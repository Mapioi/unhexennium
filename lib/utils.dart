// Utils. These should be self explanatory.

String enumToString(enumElement) => enumElement.toString().split(".")[1];

const Map<String, String> subscriptMap = const {
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

const Map<String, String> superscriptMap = const {
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

String asSubscript(String s) {
  return s
      .split("")
      .map((String char) =>
          subscriptMap.containsKey(char) ? subscriptMap[char] : char)
      .join();
}

String asSuperscript(String s) {
  return s
      .split("")
      .map((String char) =>
          superscriptMap.containsKey(char) ? superscriptMap[char] : char)
      .join();
}
