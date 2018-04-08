import 'package:test/test.dart';
import 'package:unhexennium/chemistry/element.dart';
import 'package:unhexennium/chemistry/formula.dart';
import 'package:unhexennium/chemistry/equation.dart';

void main() {
  group("Balancing equations", () {
    test("H2 + O2 -> H2O", () {
      Equation e = new Equation(
        [
          new Formula({ElementSymbol.H: 2}),
          new Formula({ElementSymbol.O: 2}),
        ],
        [
          new Formula({ElementSymbol.H: 2, ElementSymbol.O: 1}),
        ],
      );
      expect(e.coefficients, [2, 1, 2]);
    });

    // Here the null space consists of 2 vectors.
    test("C7H6O3 + C4H6O3 -> C9H8O4 + C2H4O2", () {
      Equation e = new Equation(
        [
          new Formula(
              {ElementSymbol.C: 7, ElementSymbol.H: 6, ElementSymbol.O: 3}),
          new Formula(
              {ElementSymbol.C: 4, ElementSymbol.H: 6, ElementSymbol.O: 3}),
        ],
        [
          new Formula(
              {ElementSymbol.C: 9, ElementSymbol.H: 8, ElementSymbol.O: 4}),
          new Formula(
              {ElementSymbol.C: 2, ElementSymbol.H: 4, ElementSymbol.O: 2}),
        ],
      );
      expect(e.coefficients, [1, 1, 1, 1]);
    });
  });
}
