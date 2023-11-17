// ignore_for_file: constant_identifier_names, prefer_null_aware_operators, duplicate_ignore, slash_for_doc_comments

import 'dart:collection';

import 'dart:math';

const List<String> _ESCAPE_CHARS = <String>[
  "%",
  " ",
  "{",
  "}",
  ";",
  "/",
  "?",
  ":",
  "@",
  "&",
  "=",
  "+",
  "\$",
  ",",
  "[",
  "]",
  "#",
  "!",
  "'",
  "(",
  ")",
  "*",
  "\"",
  "<",
  ">",
  "\n",
  "\r",
  "\t",
  "~",
  " ",
  "`",
  "",
  "‚",
  "ƒ",
  "„",
  "…",
  "†",
  "‡",
  "ˆ",
  "‰",
  "Š",
  "‹",
  "Œ",
  "",
  "Ž",
  "",
  "",
  "‘",
  "’",
  "“",
  "”",
  "•",
  "–",
  "—",
  "˜",
  "™",
  "š",
  "›",
  "œ",
  "",
  "ž",
  "Ÿ",
  " ",
  "¡",
  "¢",
  "£",
  "¤",
  "¥",
  "¦",
  "§",
  "¨",
  "©",
  "ª",
  "«",
  "¬",
  "\u00AD",
  "®",
  "¯",
  "°",
  "±",
  "²",
  "³",
  "´",
  "µ",
  "¶",
  "·",
  "¸",
  "¹",
  "º",
  "»",
  "¼",
  "½",
  "¾",
  "¿",
  "À",
  "Á",
  "Â",
  "Ã",
  "Ä",
  "Å",
  "Æ",
  "Ç",
  "È",
  "É",
  "Ê",
  "Ë",
  "Ì",
  "Í",
  "Î",
  "Ï",
  "Ð",
  "Ñ",
  "Ò",
  "Ó",
  "Ô",
  "Õ",
  "Ö",
  "×",
  "Ø",
  "Ù",
  "Ú",
  "Û",
  "Ü",
  "Ý",
  "Þ",
  "ß",
  "à",
  "á",
  "â",
  "ã",
  "ä",
  "å",
  "æ",
  "ç",
  "è",
  "é",
  "ê",
  "ë",
  "ì",
  "í",
  "î",
  "ï",
  "ð",
  "ñ",
  "ò",
  "ó",
  "ô",
  "õ",
  "ö",
  "÷",
  "ø",
  "ù",
  "ú",
  "û",
  "ü",
  "ý",
  "þ",
  "ÿ"
];

const List<String> _REPLACE_CHARS = <String>[
  "%25",
  "%20",
  "%7B",
  "%7D",
  "%3B",
  "%2F",
  "%3F",
  "%3A",
  "%40",
  "%26",
  "%3D",
  "%2B",
  "%24",
  "%2C",
  "%5B",
  "%5D",
  "%23",
  "%21",
  "%27",
  "%28",
  "%29",
  "%2A",
  "%22",
  "%3C",
  "%3E",
  "%0A",
  "%0D",
  "%09",
  "%7E",
  "%7F",
  "%E2%82%AC",
  "%81",
  "%E2%80%9A",
  "%C6%92",
  "%E2%80%9E",
  "%E2%80%A6",
  "%E2%80%A0",
  "%E2%80%A1",
  "%CB%86",
  "%E2%80%B0",
  "%C5%A0",
  "%E2%80%B9",
  "%C5%92",
  "%C5%8D",
  "%C5%BD",
  "%8F",
  "%C2%90",
  "%E2%80%98",
  "%E2%80%99",
  "%E2%80%9C",
  "%E2%80%9D",
  "%E2%80%A2",
  "%E2%80%93",
  "%E2%80%94",
  "%CB%9C",
  "%E2%84",
  "%C5%A1",
  "%E2%80",
  "%C5%93",
  "%9D",
  "%C5%BE",
  "%C5%B8",
  "%C2%A0",
  "%C2%A1",
  "%C2%A2",
  "%C2%A3",
  "%C2%A4",
  "%C2%A5",
  "%C2%A6",
  "%C2%A7",
  "%C2%A8",
  "%C2%A9",
  "%C2%AA",
  "%C2%AB",
  "%C2%AC",
  "%C2%AC",
  "%C2%AE",
  "%C2%AF",
  "%C2%B0",
  "%C2%B1",
  "%C2%B2",
  "%C2%B3",
  "%C2%B4",
  "%C2%B5",
  "%C2%B6",
  "%C2%B7",
  "%C2%B8",
  "%C2%B9",
  "%C2%BA",
  "%C2%BB",
  "%C2%BC",
  "%C2%BD",
  "%C2%BE",
  "%C2%BF",
  "%C3%80",
  "%C3%81",
  "%C3%82",
  "%C3%83",
  "%C3%84",
  "%C3%85",
  "%C3%86",
  "%C3%87",
  "%C3%88",
  "%C3%89",
  "%C3%8A",
  "%C3%8B",
  "%C3%8C",
  "%C3%8D",
  "%C3%8E",
  "%C3%8F",
  "%C3%90",
  "%C3%91",
  "%C3%92",
  "%C3%93",
  "%C3%94",
  "%C3%95",
  "%C3%96",
  "%C3%97",
  "%C3%98",
  "%C3%99",
  "%C3%9A",
  "%C3%9B",
  "%C3%9C",
  "%C3%9D",
  "%C3%9E",
  "%C3%9F",
  "%C3%A0",
  "%C3%A1",
  "%C3%A2",
  "%C3%A3",
  "%C3%A4",
  "%C3%A5",
  "%C3%A6",
  "%C3%A7",
  "%C3%A8",
  "%C3%A9",
  "%C3%AA",
  "%C3%AB",
  "%C3%AC",
  "%C3%AD",
  "%C3%AE",
  "%C3%AF",
  "%C3%B0",
  "%C3%B1",
  "%C3%B2",
  "%C3%B3",
  "%C3%B4",
  "%C3%B5",
  "%C3%B6",
  "%C3%B7",
  "%C3%B8",
  "%C3%B9",
  "%C3%BA",
  "%C3%BB",
  "%C3%BC",
  "%C3%BD",
  "%C3%BE",
  "%C3%BF"
];

const String _UPPER = "ABCDEFGHIJKLMNOPQRSTUVWXYZ",
    _LOWER = "abcdefghijklmnopqrstuvwxyz";

const String _ALLOWED_CHARS = "abcdefghijklmnopqrstuvwxyz0123456789";

const String _NUMBERS = "0123456789";

const String _CAMEL_PASCAL_ALLOWED = _UPPER + _LOWER + _NUMBERS;

abstract class StringUtils {
  StringUtils._();

  static String? sanitise(String? value) {
    return value;
  }

  static String? stripslashes(String? value) {
    // ignore: prefer_null_aware_operators
    return value == null
        ? null
        : value
            .replaceAll("\\'", "'")
            .replaceAll("\\\"", "\"")
            .replaceAll("\\\\", "\\");
  }

  static String? addslashes(String? value) {
    return value == null
        ? null
        : value
            .replaceAll("\\", "\\\\")
            .replaceAll("\"", "\\\"")
            .replaceAll("'", "\\'");
  }

  static String urldecode(String value) {
    StringBuffer replaced = StringBuffer(value);

    int i, start = 0;
    for (i = 0; i < _REPLACE_CHARS.length; i++) {
      while ((start = replaced.toString().indexOf(_REPLACE_CHARS[i], start)) >=
          0) {
        replaced.toString().replaceRange(
            start, start + _REPLACE_CHARS[i].length, _ESCAPE_CHARS[i]);
        start += _ESCAPE_CHARS[i].length;
      }
    }

    return replaced.toString();
  }

  static String urlencode(String value) {
    StringBuffer replaced = StringBuffer(value);

    int i, start = 0;
    for (i = 0; i < _ESCAPE_CHARS.length; i++) {
      while (
          (start = replaced.toString().indexOf(_ESCAPE_CHARS[i], start)) >= 0) {
        replaced.toString().replaceRange(
            start, start + _ESCAPE_CHARS[i].length, _REPLACE_CHARS[i]);
        start += _REPLACE_CHARS[i].length;
      }
    }

    return replaced.toString();
  }

  static String rot13(String value) {
    StringBuffer buffer = StringBuffer();

    int count = value.length;
    int index;
    String c;
    for (int i = 0; i < count; i++) {
      c = value[i];

      if ((index = _LOWER.indexOf(c)) >= 0) {
        buffer.write(_LOWER[(index + 13) % 26]);
      } else if ((index = _UPPER.indexOf(c)) >= 0) {
        buffer.write(_UPPER[(index + 13) % 26]);
      } else {
        buffer.write(c);
      }
    }

    return buffer.toString();
  }

  /// Make the first character of the string upper-case
  /// @param value string to process
  /// @return string with upper-case first letter
  static String? upperCaseFirstLetter(String? value) {
    String? upperCaseFirstLetter = value;

    if (isNotEmpty(value)) {
      String firstLetter = value!.substring(0, 1);
      upperCaseFirstLetter =
          value.replaceFirst(firstLetter, firstLetter.toUpperCase());
    }

    return upperCaseFirstLetter;
  }

  /// Make the first character of the string lower-case
  /// @param value string to process
  /// @return string with lower-case first letter
  static String? lowerCaseFirstLetter(String? value) {
    String? lowerCaseFirstLetter = value;

    if (isNotEmpty(value)) {
      String firstLetter = value!.substring(0, 1);
      lowerCaseFirstLetter =
          value.replaceFirst(firstLetter, firstLetter.toLowerCase());
    }

    return lowerCaseFirstLetter;
  }

  static String restrict(String? value,
      [String allowed = _ALLOWED_CHARS,
      String replacement = "-",
      int maxLength = 100]) {
    StringBuffer restricted = StringBuffer();

    if (isNotEmpty(value)) {
      value = value!.toLowerCase();

      int size = min(value.length, maxLength);
      String c;
      bool replacedOne = false;
      for (int i = 0; i < size; i++) {
        c = value[i];

        if (allowed.contains(c)) {
          restricted.write(c);
          replacedOne = false;
        } else if (!replacedOne) {
          restricted.write(replacement);
          replacedOne = true;
        }
      }
    }

    return restricted.toString();
  }

  static String camelCase(String? value) {
    StringBuffer restricted = StringBuffer();

    if (isNotEmpty(value)) {
      int size = value!.length;
      bool replacedOne = false;
      bool foundOne = false;
      String characterAsString;
      for (int i = 0; i < size; i++) {
        characterAsString = value[i];

        if (_CAMEL_PASCAL_ALLOWED.contains(characterAsString)) {
          if (_LOWER.contains(characterAsString)) {
            if (foundOne) {
              if (replacedOne) {
                restricted.write(characterAsString.toUpperCase());
              } else {
                restricted.write(characterAsString);
              }
            } else {
              restricted.write(characterAsString);
            }

            replacedOne = false;
            foundOne = true;
          } else if (_UPPER.contains(characterAsString)) {
            if (foundOne) {
              restricted.write(characterAsString);
            } else {
              restricted.write(characterAsString.toLowerCase());
            }

            replacedOne = false;
            foundOne = true;
          } else if (foundOne) {
            // must be a number
            restricted.write(characterAsString);
            replacedOne = false;
          }
        } else if (foundOne && !replacedOne) {
          replacedOne = true;
        }
      }
    }

    return restricted.toString();
  }

  static String pascalCase(String? value) {
    StringBuffer restricted = StringBuffer();

    if (isNotEmpty(value)) {
      int size = value!.length;
      bool replacedOne = false;
      bool foundOne = false;
      String characterAsString;
      for (int i = 0; i < size; i++) {
        characterAsString = value[i];

        if (_CAMEL_PASCAL_ALLOWED.contains(characterAsString)) {
          if (_LOWER.contains(characterAsString)) {
            if (foundOne) {
              if (replacedOne) {
                restricted.write(characterAsString.toUpperCase());
              } else {
                restricted.write(characterAsString);
              }
            } else {
              restricted.write(characterAsString.toUpperCase());
            }

            replacedOne = false;
            foundOne = true;
          } else if (_UPPER.contains(characterAsString)) {
            restricted.write(characterAsString);

            replacedOne = false;
            foundOne = true;
          } else if (foundOne) {
            // must be a number
            restricted.write(characterAsString);
            replacedOne = false;
          }
        } else if (foundOne && !replacedOne) {
          replacedOne = true;
        }
      }
    }

    return restricted.toString();
  }

  static String snakeCase(String? value) =>
      expandByCase(value, false, false, "_");

  static String expandByCase(
      String? value, bool capitalFirst, bool capitalAfterSpace, String space,
      [String? append = ""]) {
    StringBuffer expanded = StringBuffer();
    if (isNotEmpty(value)) {
      int size = value!.length;
      bool inNumbers = false, isNumber = false, addSpace = false;
      String characterAsString;
      for (int i = 0; i < size; i++) {
        characterAsString = value[i];
        addSpace = false;
        isNumber = _NUMBERS.contains(characterAsString);

        if (inNumbers) {
          if (!isNumber) {
            addSpace = true;
            inNumbers = false;
          }
        } else {
          if (isNumber) {
            addSpace = true;
            inNumbers = true;
          }
        }

        if (i == 0) {
          if (capitalFirst) {
            expanded.write(characterAsString.toUpperCase());
          } else {
            expanded.write(characterAsString.toLowerCase());
          }
        } else {
          if (!addSpace && _UPPER.contains(characterAsString)) {
            addSpace = true;
          }

          if (addSpace) {
            expanded.write(space);
          }

          if (addSpace && capitalAfterSpace) {
            expanded.write(characterAsString.toUpperCase());
          } else {
            if (!isNumber) {
              expanded.write(characterAsString.toLowerCase());
            } else {
              expanded.write(characterAsString);
            }
          }
        }
      }

      expanded.write(append);
    }

    return expanded.toString();
  }

  static String constantName(String? value, String? prefix, String suffix) {
    StringBuffer constant = StringBuffer();

    constant.write(prefix);

    bool addedPrefixSeparator = isEmpty(prefix);

    if (isNotEmpty(value)) {
      int size = value!.length;
      bool replacedOne = false;
      bool foundOne = false;
      String characterAsString;
      for (int i = 0; i < size; i++) {
        characterAsString = value[i];

        if (_CAMEL_PASCAL_ALLOWED.contains(characterAsString)) {
          if (!_NUMBERS.contains(characterAsString)) {
            if (!addedPrefixSeparator) {
              constant.write("_");
              addedPrefixSeparator = true;
            }

            constant.write(characterAsString.toUpperCase());

            replacedOne = false;
            foundOne = true;
          } else if (foundOne) {
            if (!addedPrefixSeparator) {
              constant.write("_");
              addedPrefixSeparator = true;
            }

            constant.write(characterAsString);
            replacedOne = false;
          }
        } else if (foundOne && !replacedOne) {
          constant.write("_");
          replacedOne = true;
        }
      }
    }

    if (constant.isNotEmpty &&
        constant.toString()[constant.length - 1] != '_' &&
        suffix.isNotEmpty) {
      constant.write("_");
    }

    constant.write(suffix);

    return constant.toString();
  }

  /// Returns a string of string repeated count times
  /// @param string String to repeat.
  /// If a negative value is used the result will always be an empty string.
  /// @param count The number of times to repeat the string
  /// @return
  static String repeat(String string, int count) {
    StringBuffer buffer = StringBuffer();

    for (int i = 0; i < count; i++) {
      buffer.write(string);
    }

    return buffer.toString();
  }

  static Iterable<String> longestCommonParts(String lhs, String rhs) {
    List<List<int?>> table = List<List<int?>>.generate(
        lhs.length,
        (int i) => List<int?>.filled(
              rhs.length,
              null,
              growable: true,
            ));
    int longest = 0;
    Set<String> result = HashSet<String>();

    for (int i = 0; i < lhs.length; i++) {
      for (int j = 0; j < rhs.length; j++) {
        if (lhs[i] == rhs[j]) {
          table[i][j] = (i == 0 || j == 0) ? 1 : 1 + (table[i - 1][j - 1] ?? 0);
          if ((table[i][j] ?? 0) > longest) {
            longest = (table[i][j] ?? 0);
            result.clear();
          }

          if (table[i][j] == longest) {
            result.add(lhs.substring(i - longest + 1, i + 1));
          }
        }
      }
    }

    return result;
  }

  static String commonPrefix(String lhs, String rhs) {
    final int count = min(lhs.length, rhs.length);
    int index = 0;
    for (int i = 0; i < count; i++) {
      if (lhs[i] != rhs[i]) {
        break;
      }

      index = i;
    }

    return index == 0 ? "" : lhs.substring(0, index + 1);
  }

  static String trim(String string, String c) {
    String trimmed = string;

    if (isNotEmpty(string)) {
      int start = 0;
      for (int i = start; i < string.length; i++) {
        start = i;
        if (string[i] != c) {
          break;
        }
      }

      int end = string.length;
      if (start < (end - 1)) {
        for (int i = end; i > 0; i--) {
          end = i;
          if (string[i - 1] != c) {
            break;
          }
        }
      } else {
        end = start;
      }

      trimmed = string.substring(start, end);
    }

    return trimmed;
  }

  static Iterable<String> matchParts(Iterable<String?>? strings) {
    Set<String> matchParts = HashSet<String>();

    if (strings != null) {
      List<String> split;
      String modified;
      StringBuffer buffer = StringBuffer();

      for (String? string in strings) {
        modified = restrict(string, _ALLOWED_CHARS, " ", 2147483647);
        split = modified.split(" ");
        for (String part in split) {
          if (isNotEmpty(part)) {
            buffer.clear();

            for (int i = 0; i < part.length - 1; i++) {
              buffer.write(part[i]);
              matchParts.add(buffer.toString());
            }
          }
        }
      }
    }

    return matchParts;
  }

  static bool isEmpty(String? value) {
    return value == null || value.isEmpty;
  }

  static bool isNotEmpty(String? value) {
    return !isEmpty(value);
  }

  static bool equalsIgnoreCase(String? s1, String? s2) =>
      s1?.toLowerCase() == s2?.toLowerCase();

  static bool isAllCaps(String? value) =>
      value != null && value == value.toUpperCase();
}
