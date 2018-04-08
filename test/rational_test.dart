import 'package:test/test.dart';
import 'package:unhexennium/maths/rational.dart';

void main() {
  group("gcd", () {
    test("positive", () {
      expect(gcd(2, 4), 2);
      expect(gcd(10, 15), 5);
      expect(gcd(3, 37), 1);
    });

    test("zero", () {
      expect(gcd(0, 5), 5);
      expect(gcd(3, 0), 3);
    });

    test("negative", () {
      expect(gcd(8, -8), 8);
      expect(gcd(-3, -2), 1);
    });
  });

  group("Rational", () {
    test("initiator + canonical form", () {
      var f = new Rational(6, 10);
      expect(f.numerator, 3);
      expect(f.denominator, 5);

      try {
        // An attempt to create inf.
        f = new Rational(1, 0);
      } catch (e) {
        expect(e is AssertionError, true);
      }
    });

    test(".fromInt", () {
      var f = new Rational.fromInt(-5);
      expect(f.numerator, -5);
      expect(f.denominator, 1);

      f = new Rational.fromInt(7);
      expect(f.numerator, 7);
      expect(f.denominator, 1);
    });

    test("opposite", () {
      var f = new Rational.fromInt(1);
      expect(f.opposite, new Rational.fromInt(-1));
      expect(f.opposite.opposite, f);
      expect(new Rational.fromInt(0).opposite, new Rational.fromInt(0));
    });

    test("reciprocal", () {
      var f = new Rational(101, 1001);
      expect(f.reciprocal, new Rational(1001, 101));
      expect(f.reciprocal.reciprocal, f);
      expect(new Rational.fromInt(-1), new Rational.fromInt(-1));
    });

    test("+", () {
      var f1 = new Rational(1, 2);
      var f2 = new Rational(-1, 3);
      var diff = f1 + f2;
      expect(diff.numerator, 1);
      expect(diff.denominator, 6);
    });

    test("*", () {
      var f = new Rational(5, 7) * new Rational(7, 5);
      expect(f == new Rational.fromInt(1), true);
    });
  });
}
