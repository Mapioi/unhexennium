import 'package:test/test.dart';
import 'package:unhexennium/chemistry/element.dart';
import 'package:unhexennium/chemistry/formula.dart';
import 'package:unhexennium/chemistry/equation.dart';

void main() {
  group("Balancing equations", () {
    test("2 H2 + O2 -> 2 H2O", () {
      Equation eq = new Equation(
        [
          new Formula({ElementSymbol.H: 2}),
          new Formula({ElementSymbol.O: 2}),
        ],
        [
          new Formula({ElementSymbol.H: 2, ElementSymbol.O: 1}),
        ],
      );
      expect(eq.coefficients, [2, 1, 2]);
    });

    // Here the null space consists of 2 vectors.
    test("C7H6O3 + C4H6O3 -> C9H8O4 + C2H4O2", () {
      Equation eq = new Equation(
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
      expect(eq.coefficients, [1, 1, 1, 1]);
    });

    test("Cl2 + 2 e^- -> 2 Cl^-", () {
      Equation eq = new Equation(
        [
          new Formula(
            {ElementSymbol.Cl: 2},
          ),
          Formula.e,
        ],
        [
          new Formula(
            {ElementSymbol.Cl: 1},
            charge: -1,
          ),
        ],
      );
      expect(eq.coefficients, [1, 2, 2]);
    });

    test("Cl2 + 2 Fe^2+ -> 2 Cl^- + 2 Fe^3+", () {
      Equation eq = new Equation(
        [
          new Formula(
            {ElementSymbol.Cl: 2},
          ),
          new Formula(
            {ElementSymbol.Fe: 1},
            charge: 2,
          ),
        ],
        [
          new Formula(
            {ElementSymbol.Cl: 1},
            charge: -1,
          ),
          new Formula(
            {ElementSymbol.Fe: 1},
            charge: 3
          ),
        ],
      );

      expect(eq.coefficients, [1, 2, 2, 2]);
    });
  });
}
