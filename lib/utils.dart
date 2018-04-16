// Utils. These should be self explanatory.

String enumToString(enumElement) => enumElement.toString().split(".")[1];

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

String asSubscript(String s, {omitOne = false}) {
  if (s == '1') return "";
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

/// Convert -2 to '2-' and 2 to '2+'.
/// If [omitOne] is true, convert -1 to '-' and 1 to '+'.
/// 0 is converted to ''.
String toStringAsCharge(int charge, {omitOne = false}) {
  // TODO refactor formula to make use of this
  if (charge == 0) return "";
  String sign = charge > 0 ? "+" : "-";
  String value = charge.abs() == 1 && omitOne ? "" : charge.abs().toString();
  return "$value$sign";
}
