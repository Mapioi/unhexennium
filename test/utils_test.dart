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

  test("asSubscript", () {
    expect(asSuperscript("-42"), "⁻⁴²");
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
