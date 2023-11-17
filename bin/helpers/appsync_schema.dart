// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'string_utils.dart';

class Converter {
  String convert(String amplifyJson) {
    List<Map<String, dynamic>> awsTypes = jsonDecode(amplifyJson)["data"]
            ["__schema"]["types"]
        .cast<Map<String, dynamic>>();
    late List<Map<String, dynamic>> codeGenTypes;

    Map<String, dynamic> outputJson = {
      "name": "schema",
      "description":
          "Data classes were generated on ${DateTime.now()} by AppSyncSchemaConverter.",
      "author": "Yasin ilhan",
      "copyrightNotice":
          "Copyright © ${DateTime.now().year}. All rights reserved.",
      "types": codeGenTypes = [],
    };

    int count = 0;
    for (Map<String, dynamic> item in awsTypes) {
      // log.fine("item ${jsonEncode(item)}");

      if (item["name"] == "Query" ||
          item["name"] == "Mutation" ||
          item["name"] == "Subscription" ||
          item["name"] == "ModelAttributeTypes" ||
          item["name"] == "ModelSortDirection" ||
          (item["name"] as String).startsWith("__") ||
          (item["name"] as String).endsWith("Response") ||
          item["kind"] == "INPUT_OBJECT" ||
          item["kind"] == "SCALAR" ||
          isAwsType(item)) continue;

      count++;
      Map<String, dynamic> mappedItem = {};

      bool isClass = false;
      if (item["kind"] == "OBJECT") {
        mappedItem["type"] = "class";
        isClass = true;
      } else if (item["kind"] == "ENUM") {
        mappedItem["type"] = "enumeration";
      }

      mappedItem["name"] = item["name"];

      List<Map<String, dynamic>>? fields;
      if (isClass) {
        if (item["fields"] != null) {
          fields = item["fields"].cast<Map<String, dynamic>>();
        }
      } else {
        if (item["enumValues"] != null) {
          fields = item["enumValues"].cast<Map<String, dynamic>>();
        }
      }

      if (fields != null) {
        List<Map<String, dynamic>> variables =
            (mappedItem["variables"] = <Map<String, dynamic>>[]);

        for (Map<String, dynamic> field in fields) {
          Map<String, dynamic> variable = {};

          if (isClass) {
            if ((field["name"] as String).contains("_") ||
                (field["name"] as String).toUpperCase() == field["name"]) {
              variable["name"] = StringUtils.camelCase(
                  (field["name"] as String).toLowerCase().replaceAll("_", " "));
              variable["serialisedName"] = field["name"];
            } else {
              variable["name"] = field["name"];
            }

            variable["type"] = _extractType(field["type"]);
            variable["collection"] = _extractCollection(field["type"]);
            variable["enumeration"] = _extractEnumeration(field["type"]);
          } else {
            variable["name"] = field["name"];
            variable["type"] = "string";
          }

          variables.add(variable);
        }
      }

      codeGenTypes.add(mappedItem);
    }

    return jsonEncode(outputJson);
  }

  bool isAwsType(Map<String, dynamic> item) {
    return (item["name"] as String).startsWith("AWS") &&
        (item["kind"] == "SCALAR" && item["description"] != null);
  }

  String _extractType(Map<String, dynamic> field) {
    String? type;

    Map<String, dynamic> child = field;
    while (type == null) {
      if (child["ofType"] == null) {
        type = child["name"];
      } else {
        child = child["ofType"];
      }
    }

    switch (type) {
      case "String":
      case "ID":
      case "AWSJSON":
        type = "string";
        break;
      case "AWSDate":
        type = "date";
        break;
      case "AWSDateTime":
        type = "dateTime";
        break;
      case "Boolean":
        type = "boolean";
        break;
      case "Int":
        type = "integer";
        break;
      case "Float":
        type = "float";
        break;
    }

    return type;
  }

  bool _extractCollection(Map<String, dynamic> field) {
    bool isCollection = false;

    Map<String, dynamic>? child = field;

    while (child != null) {
      if (child["kind"] == "LIST") {
        isCollection = true;
        break;
      } else {
        child = child["ofType"];
      }
    }

    return isCollection;
  }

  bool _extractEnumeration(Map<String, dynamic> field) {
    bool isEnumeration = false;

    Map<String, dynamic>? child = field;

    while (child != null) {
      if (child["kind"] == "ENUM") {
        isEnumeration = true;
        break;
      } else {
        child = child["ofType"];
      }
    }

    return isEnumeration;
  }
}
