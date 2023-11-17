//
// Created by Yasin ilhan on November 17, 2023.
// Copyright © 2023. All rights reserved.
//

import 'dart:convert';
import 'dart:io';
import 'helpers/firebase_converter.dart';
import 'helpers/appsync_schema.dart';

void main(List<String> arguments) async {
  if (arguments.isNotEmpty && arguments[0] == '--g') {
    if (arguments.length >= 2 && arguments[1] == 'class') {
     
      if (arguments.contains('--firebase')) {
        await checkAndInstallNpm();
        await installFirestoreExport();
        await convertFirestoreJson();
        await generateFirebaseClasses();
        runBuildRunner();
      } else {
        String jsonFilePath = 'lib/input/appsync.json';
        String input = await File("lib/input/schema.json").readAsString();
        String output = Converter().convert(input);
        // Save to file
        File(jsonFilePath).writeAsStringSync(output);
        generateClassesFromJson(jsonFilePath);
        runBuildRunner();
      }
    } else {
      print(
          'Invalid command. Use: dart run [SCRIPT_NAME].dart --g class [--firebase]');
    }
  } else {
    print('No arguments provided.');
  }
}

// firebse checks
Future<void> checkAndInstallNpm() async {
  // Check if npm is installed
  var npmCheckResult = await Process.run('npm', ['-v']);
  if (npmCheckResult.exitCode != 0) {
    print('npm is not installed. Please install Node.js and npm first.');
    exit(1);
  }
  print('npm is installed: ${npmCheckResult.stdout}');
}

Future<void> installFirestoreExport() async {

  print('Installing node-firestore-import-export...');
  var npmInstallResult = await Process.run(
      'npm', ['install', '-g', 'node-firestore-import-export']);
  if (npmInstallResult.exitCode != 0) {
    print(
        'Error installing node-firestore-import-export: ${npmInstallResult.stderr}');
    exit(npmInstallResult.exitCode);
  }
  print('node-firestore-import-export installed successfully.');
}

Future<void> convertFirestoreJson() async {
  print('Converting Firestore data to JSON...');
  var result = await Process.run('npx', [
    '-p',
    'node-firestore-import-export',
    'firestore-export',
    '-a',
    'lib/input/exportedDB.json', // Path to your exportedDB.json
    '-b',
    'lib/input/firebase.json' // Desired output path for firebase.json
  ]);

  if (result.exitCode != 0) {
    print('Error in firestore export: ${result.stderr}');
    exit(result.exitCode);
  }
  print('Firestore data converted to JSON successfully.');
}

Future<void> generateFirebaseClasses() async {
  var jsonFilePath = 'lib/input/firebase.json'; // Correct path to firebase.json

  FirebaseConverter.generateFirebaseClassesFromJson(jsonFilePath);
}

void generateClassesFromJson(String jsonFilePath) {
  var file = File(jsonFilePath);
  var jsonString = file.readAsStringSync();

  var jsonMap = json.decode(jsonString);
  var types = jsonMap['types'] as List<dynamic>;

  List<String> allClassNames = [];
  List<String> allEnumNames = [];

  for (var type in types) {
    if (type['type'] == 'class') {
      allClassNames.add(type['name']);
    } else if (type['type'] == 'enumeration') {
      allEnumNames.add(type['name']);
    }
  }

  for (var type in types) {
    if (type['type'] == 'class') {
      generateDartClass(
          type['name'], type['variables'], allClassNames, allEnumNames);
    } else if (type['type'] == 'enumeration') {
      generateDartEnum(type['name'], type['variables']);
    }
  }
}

void runBuildRunner() async {
  var result = await Process.run(
      'dart', ['run', 'build_runner', 'build', '--delete-conflicting-outputs']);
  print(result);
  print(result.stdout);
  print(result.stderr);
}

void generateDartEnum(String enumName, dynamic variables) {
  StringBuffer enumBuffer = StringBuffer();

  // Add comments at the top of the file
  enumBuffer.writeln('// $enumName.dart');
  enumBuffer.writeln('//');
  enumBuffer
      .writeln('// Created by Yasin ilhan on ${DateTime.now().toLocal()}.');
  enumBuffer
      .writeln('// Copyright © ${DateTime.now().year}. All rights reserved.');
  enumBuffer.writeln('');

  enumBuffer
      .writeln('import \'package:json_annotation/json_annotation.dart\';\n');
  enumBuffer.writeln('enum $enumName {');

  for (var variable in variables) {
    String enumMember = convertToCamelCase(variable['name']);
    String enumMemberValue = variable['name'];
    if (enumMember == 'new') {
      enumMember += 'Value';
    }
    enumBuffer.writeln('\t@JsonValue("$enumMemberValue")');
    enumBuffer.writeln('\t$enumMember,');
  }

  enumBuffer.writeln(';\n}\n');

  // Save to a file
  var outputDirectory = Directory('lib/output');
  if (!outputDirectory.existsSync()) {
    outputDirectory.createSync();
  }

  var enumFile =
      File('${outputDirectory.path}/${convertToSnakeCase(enumName)}.dart');
  enumFile.writeAsStringSync(enumBuffer.toString());
}

String convertToCamelCase(String text) {
  List<String> words = text.split('_').map((str) => str.toLowerCase()).toList();
  String camelCase = words.first;
  for (int i = 1; i < words.length; i++) {
    camelCase += words[i][0].toUpperCase() + words[i].substring(1);
  }
  return camelCase;
}

void generateDartClass(String className, dynamic variables,
    List<String> allClassNames, List<String> allEnumNames) {
  StringBuffer classBuffer = StringBuffer();


  String fileName = convertToSnakeCase(className);


  classBuffer.writeln('// $fileName.dart');
  classBuffer.writeln('//');
  classBuffer
      .writeln('// Created by Yasin ilhan on ${DateTime.now().toLocal()}.');
  classBuffer
      .writeln('// Copyright © ${DateTime.now().year}. All rights reserved.');
  classBuffer.writeln('');

  // Import statements
  classBuffer
      .writeln('import \'package:json_annotation/json_annotation.dart\';\n');

  Set<String> dependencies =
      findDependencies(variables, allClassNames, allEnumNames);

  if (dependencies.isEmpty) {
    print('No dependencies found for $className');
  }

  for (String dep in dependencies) {
    String depFileName = convertToSnakeCase(dep);

    classBuffer.writeln('import \'$depFileName.dart\';');
  }

  classBuffer.writeln('\npart \'$fileName.g.dart\';\n');
  classBuffer.writeln('@JsonSerializable()');
  classBuffer.writeln('class $className {');

  for (var variable in variables) {
    String dartType = convertJsonTypeToDartType(variable['type']);
    String name = variable['name'];
    String? serializedName = variable['serialisedName'];

    if (serializedName != null) {
      classBuffer.writeln('  @JsonKey(name: "$serializedName")');
    }

    classBuffer.writeln('  final $dartType $name;');
  }

  classBuffer.writeln('\n  $className({');
  for (var variable in variables) {
    String name = variable['name'];
    classBuffer.writeln('    this.$name,');
  }
  classBuffer.writeln('  });\n');

  classBuffer.writeln(
      '  factory $className.fromJson(Map<String, dynamic> json) => _\$${className}FromJson(json);');
  classBuffer.writeln(
      '  Map<String, dynamic> toJson() => _\$${className}ToJson(this);\n');

  classBuffer.writeln('  @override');
  classBuffer.writeln('  String toString() => toJson().toString();');
  classBuffer.writeln('}\n');

  // Save to a file
  var outputDirectory = Directory('lib/output');
  if (!outputDirectory.existsSync()) {
    outputDirectory.createSync();
  }

  var classFile = File('${outputDirectory.path}/$fileName.dart');
  classFile.writeAsStringSync(classBuffer.toString());
}

Set<String> findDependencies(
    dynamic variables, List<String> allClassNames, List<String> allEnumNames) {
  Set<String> dependencies = {};
  for (var variable in variables) {
    String jsonType = variable['type'];
    if (allClassNames.contains(jsonType) || allEnumNames.contains(jsonType)) {
      dependencies.add(jsonType);
    }
  }
  return dependencies;
}

String convertToSnakeCase(String text) {
  return text
      .replaceAllMapped(
          RegExp(r'(?<!^)(?=[A-Z])'), (Match m) => '_${m.group(0)}')
      .toLowerCase();
}

String convertJsonTypeToDartType(String jsonType) {
  switch (jsonType) {
    case 'string':
      return 'String?';
    case 'float':
      return 'double?';
    case 'integer':
      return 'int?';
    case 'dateTime':
      return 'DateTime?';
    case 'date':
      return 'DateTime?';
    case 'boolean':
      return 'bool?';
    default:
      return "$jsonType?";
  }
}
