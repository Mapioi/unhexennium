import 'package:test/test.dart';
import 'package:unhexennium/maths/rational.dart';
import 'package:unhexennium/chemistry/element.dart';
import 'package:unhexennium/chemistry/formula.dart';
import 'package:unhexennium/chemistry/equation.dart';

void main() {
  group("Balancing equations", () {
    test("H₂ + O₂ ⟶ H₂O", () {
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
    test("C₇H₆O₃ + C₄H₆O₃ ⟶ C₉H₈O₄ + C₂H₄O₂", () {
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
        strictBalancing: false,
      );
      expect(eq.coefficients, [1, 1, 1, 1]);
      try {
        new Equation(
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
          strictBalancing: true,
        );
      } catch (e) {
        expect(e.kernel, [
          [Rational(11, 9), Rational(1, 9), Rational(1, 1), Rational(0, 1)],
          [Rational(-2, 9), Rational(8, 9), Rational(0, 1), Rational(1, 1)]
        ]);
      }
    });

    test("Cl₂ + e⁻ ⟶ Cl⁻", () {
      Equation eq = new Equation(
        [
          new Formula(
            {ElementSymbol.Cl: 2},
          ),
          Formula.eMinus,
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

    test("Cl₂ + Fe²⁺ ⟶ Cl⁻ + Fe³⁺", () {
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
          new Formula({ElementSymbol.Fe: 1}, charge: 3),
        ],
      );
      expect(eq.coefficients, [1, 2, 2, 2]);
    });
  });
}
