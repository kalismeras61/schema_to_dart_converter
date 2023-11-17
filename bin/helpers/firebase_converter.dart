import 'dart:convert';
import 'dart:io';

class FirebaseConverter {
  static void generateFirebaseClassesFromJson(String jsonFilePath) {
    var file = File(jsonFilePath);
    var jsonString = file.readAsStringSync();

    var jsonMap = json.decode(jsonString);
    var collections = jsonMap['__collections__'] as Map<String, dynamic>;

    for (var collectionName in collections.keys) {
      var documents = collections[collectionName] as Map<String, dynamic>;
      for (var docId in documents.keys) {
        var document = documents[docId];
        generateFirebaseClass(collectionName, document);
      }
    }
  }

  static void generateFirebaseClass(
      String className, Map<String, dynamic> document) {
    StringBuffer classBuffer = StringBuffer();

    String fileName = convertToSnakeCase(className);
    String classPascalCaseName = convertToPascalCase(className);

    classBuffer.writeln('// $fileName.dart');
    classBuffer.writeln('//');
    classBuffer
        .writeln('// Created by Yasin ilhan on ${DateTime.now().toLocal()}.');
    classBuffer
        .writeln('// Copyright © ${DateTime.now().year}. All rights reserved.');
    classBuffer.writeln('');
    classBuffer
        .writeln('import \'package:json_annotation/json_annotation.dart\';\n');

    // Import statements for related classes
    Set<String> importedTypes = {};
    document.forEach((key, value) {
      String fieldType = getFirebaseFieldType(value);
      if (![
        'String',
        'int',
        'double',
        'bool',
        'DateTime',
        'List<dynamic>',
        'Map<String, dynamic>',
        '_Map<String, dynamic>'
      ].contains(fieldType)) {
        importedTypes.add(fieldType);
      }
    });

    for (var type in importedTypes) {
      classBuffer.writeln('import \'$type.dart\';');
    }
    classBuffer.writeln('part \'$fileName.g.dart\';\n');
    classBuffer.writeln('@JsonSerializable()');
    classBuffer.writeln('class $classPascalCaseName {');

    document.forEach((key, value) {
      if (key == '__collections__') return;

      String fieldCamelCase = convertToCamelCase(key);
      String dartType = getFirebaseFieldType(value);
      if (key != fieldCamelCase) {
        classBuffer.writeln('  @JsonKey(name: "$key")');
      }
      classBuffer.writeln('  final $dartType? $fieldCamelCase;');
    });

    // Constructor
    classBuffer.writeln('\n  $classPascalCaseName({');
    document.keys.where((k) => k != '__collections__').forEach((key) {
      String fieldCamelCase = convertToCamelCase(key);
      classBuffer.writeln('    this.$fieldCamelCase,');
    });
    classBuffer.writeln('  });\n');

    // fromJson and toJson
    classBuffer.writeln(
        '  factory $classPascalCaseName.fromJson(Map<String, dynamic> json) => _\$${classPascalCaseName}FromJson(json);');
    classBuffer.writeln(
        '  Map<String, dynamic> toJson() => _\$${classPascalCaseName}ToJson(this);\n');

    classBuffer.writeln('  @override');
    classBuffer.writeln('  String toString() => toJson().toString();');
    classBuffer.writeln('}\n');

    // Save to a file
    var outputDirectory = Directory('lib/firebase_output');
    if (!outputDirectory.existsSync()) {
      outputDirectory.createSync();
    }

    var classFile = File('${outputDirectory.path}/$fileName.dart');
    classFile.writeAsStringSync(classBuffer.toString());
  }

  static String getFirebaseFieldType(dynamic value) {
    if (value is Map &&
        value.containsKey('__datatype__') &&
        value['__datatype__'] == 'timestamp') {
      return 'DateTime';
    }
    return value.runtimeType.toString();
  }

  static String convertToSnakeCase(String text) {
    return text
        .replaceAllMapped(
            RegExp(r'(?<!^)(?=[A-Z])'), (Match m) => '_${m.group(0)}')
        .toLowerCase();
  }

  static String convertToPascalCase(String text) {
    return text.split('_').map((word) {
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join('');
  }

  static String convertToCamelCase(String text) {
    List<String> words =
        text.split('_').map((word) => word.toLowerCase()).toList();
    String camelCase = words.first;
    for (int i = 1; i < words.length; i++) {
      camelCase += words[i][0].toUpperCase() + words[i].substring(1);
    }
    return camelCase;
  }
}
