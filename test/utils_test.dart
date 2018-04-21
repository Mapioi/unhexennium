import 'package:test/test.dart';
import 'package:unhexennium/utils.dart';

enum Foo { bar, spam, UnreadableEnum, SomewhatReadableEnum, Boo }

void main() {
  test("enumToString shows the right hand side of an enum toString()", () {
    expect(enumToString(Foo.bar), "bar");
    expect(enumToString(Foo.spam), "spam");
  });

  test("asSubscript", () {
    expect(asSubscript("-42"), "₋₄₂");
  });

  test("asSuperscript", () {
    expect(asSuperscript("-42"), "⁻⁴²");
  });

  List<String> characters = [
    '0',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '+',
    '-'
  ];
  test("isSubscriptChar", () {
    for (String char in characters) {
      expect(isSubscriptChar(char), false);
      expect(isSubscriptChar(asSubscript(char)), true);
      expect(isSubscriptChar(asSuperscript(char)), false);
    }
  });

  test("isSuperscriptChar", () {
    for (String char in characters) {
      expect(isSuperscriptChar(char), false);
      expect(isSuperscriptChar(asSubscript(char)), false);
      expect(isSuperscriptChar(asSuperscript(char)), true);
    }
  });

  test("fromSubscript", () {
    expect(fromSubscript("₋₄₂"), "-42");
  });

  test("fromSuperscript", () {
    expect(fromSuperscript("⁻⁴²"), "-42");
  });

  test("toStringAsCharge", () {
    expect(toStringAsCharge(1, omitOne: false), "1+");
    expect(toStringAsCharge(1, omitOne: true), "+");
    expect(toStringAsCharge(-1, omitOne: false), "1-");
    expect(toStringAsCharge(-1, omitOne: true), "-");
    expect(toStringAsCharge(0), "");
  });

  test("enumToReadableString", () {
    expect(enumToReadableString(Foo.UnreadableEnum), "Unreadable enum");
    expect(
      enumToReadableString(Foo.SomewhatReadableEnum),
      "Somewhat readable enum",
    );
    expect(enumToReadableString(Foo.Boo), "Boo");
    expect(enumToReadableString(Foo.bar), "bar");
  });
}
