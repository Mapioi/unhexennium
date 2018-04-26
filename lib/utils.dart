import 'dart:collection';

typedef void Callback();
typedef void SetStateCallback(Callback callback);

String enumToString(someEnum) => someEnum.toString().split(".")[1];

String enumToReadableString(someEnum) {
  String result = "";
  bool isStart = true;
  enumToString(someEnum).runes.forEach((int rune) {
    var character = new String.fromCharCode(rune);
    if (character == character.toUpperCase() && !isStart) {
      result += " ${character.toLowerCase()}";
    } else {
      result += "$character";
    }
    isStart = false;
  });
  return result;
}

const Map<String, String> _subscriptMap = const {
  "0": "₀",
  "1": "₁",
  "2": "₂",
  "3": "₃",
  "4": "₄",
  "5": "₅",
  "6": "₆",
  "7": "₇",
  "8": "₈",
  "9": "₉",
  "+": "₊",
  "-": "₋",
};

const Map<String, String> _superscriptMap = const {
  "0": "⁰",
  "1": "¹",
  "2": "²",
  "3": "³",
  "4": "⁴",
  "5": "⁵",
  "6": "⁶",
  "7": "⁷",
  "8": "⁸",
  "9": "⁹",
  "+": "⁺",
  "-": "⁻",
};

final Map<String, String> _inverseSubscriptMap =
    Map.fromIterables(_subscriptMap.values, _subscriptMap.keys);

final Map<String, String> _inverseSuperscriptMap =
    Map.fromIterables(_superscriptMap.values, _superscriptMap.keys);

String asSubscript(String s) {
  return s
      .split("")
      .map((String char) =>
          _subscriptMap.containsKey(char) ? _subscriptMap[char] : char)
      .join();
}

String asSuperscript(String s) {
  return s
      .split("")
      .map((String char) =>
          _superscriptMap.containsKey(char) ? _superscriptMap[char] : char)
      .join();
}

bool isSubscriptChar(String s) => _inverseSubscriptMap.containsKey(s);

bool isSuperscriptChar(String s) => _inverseSuperscriptMap.containsKey(s);

String fromSubscript(String s) {
  return s
      .split("")
      .map((String char) =>
          isSubscriptChar(char) ? _inverseSubscriptMap[char] : char)
      .join();
}

String fromSuperscript(String s) {
  return s
      .split("")
      .map((String char) =>
          isSuperscriptChar(char) ? _inverseSuperscriptMap[char] : char)
      .join();
}

/// Convert -2 to '2-' and 2 to '2+'.
/// If [omitOne] is true, convert -1 to '-' and 1 to '+'.
/// 0 is converted to ''.
String toStringAsCharge(int charge, {bool omitOne = false}) {
  if (charge == 0) return "";
  String sign = charge > 0 ? "+" : "-";
  String value = charge.abs() == 1 && omitOne ? "" : charge.abs().toString();
  return "$value$sign";
}

/// Replace the french virgules by points.
String unFrench(String s) => s.replaceAll(",", ".");

/// Sort a map by its keys
LinkedHashMap<int, String> sortMapByValues(Map<int, String> mapToSort) {
  List sortedKeys = mapToSort.keys.toList(growable: false)..sort(
    (a, b) => mapToSort[a].compareTo(mapToSort[b])
  );
  return new LinkedHashMap.fromIterable(
    sortedKeys,
    key: (k) => k,
    value: (k) => mapToSort[k],
  );
}
