import 'package:flutter_test/flutter_test.dart';
import 'package:unhexennium/maths/rational.dart';
import 'package:unhexennium/maths/linalg.dart';

void main() {
  final Rational zero = new Rational.fromInt(0);
  final Rational one = new Rational.fromInt(1);
  final Rational two = new Rational.fromInt(2);
  final Rational three = new Rational.fromInt(3);
  final Rational four = new Rational.fromInt(4);
  final Rational six = new Rational.fromInt(6);
  final Rational seven = new Rational.fromInt(7);
  final Rational eight = new Rational.fromInt(8);
  final Rational nine = new Rational.fromInt(9);
  test("identity", () {
    expect(new RationalMatrix.identity(2).items, [
      [one, zero],
      [zero, one]
    ]);
  });
  test("transpose", () {
    expect(
        new RationalMatrix([
          [one, two, three],
          [one.opposite, two.opposite, three.opposite]
        ]).transpose.items,
        [
          [one, one.opposite],
          [two, two.opposite],
          [three, three.opposite]
        ]);
  });
  group("rref", () {
    test("H2 + O2 -> H2O", () {
      var a = new RationalMatrix([
        [two, zero, two.opposite],
        [zero, two, one.opposite]
      ]);
      expect(a.nullSpace, [
        [one, one * two.reciprocal, one]
      ]);
    });
    test("C7H6O3 + C4H6O3 -> C9H8O4 + C2H4O2", () {
      var b = new RationalMatrix([
        [seven, four, nine.opposite, two.opposite],
        [six, six, eight.opposite, four.opposite],
        [three, three, four.opposite, two.opposite]
      ]);
      expect(b.nullSpace, [
        [new Rational(11, 9), new Rational(1, 9), one, zero],
        [new Rational(-2, 9), new Rational(8, 9), zero, one]
      ]);
    });
  });
}
