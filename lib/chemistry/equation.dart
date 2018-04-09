/// Chemical equations: representation of chemical reactions

import 'package:unhexennium/maths/linalg.dart';
import 'package:unhexennium/maths/rational.dart';
import 'package:unhexennium/chemistry/element.dart';
import 'package:unhexennium/chemistry/formula.dart';

/// A chemical equation is the symbolic representation of
/// a chemical reaction in the form of symbols and formulae,
/// wherein the reactant entities are given on the left-hand side
/// and the product entities on the right-hand side.
class Equation {
  final List<Formula> reactants, products;

  /// Stoichiometric coefficients of the reactants and products.
  final List<int> coefficients;

  /// Get the stoichiometric coefficients of this equation when balanced.
  /// This is achieved through determining the null space of a matrix where
  /// columns correspond to the chemical formulae involved in the equation,
  /// rows correspond to the elements in the formulae,
  /// and cells correspond to the subscript of that element in that formula
  /// (0 if not present; opposite if the formula represents a product).
  static List<int> getBalancedCoefficients(
      List<Formula> reactants, List<Formula> products) {
    var elementsRows = <ElementSymbol, int>{};
    int equationLength = reactants.length + products.length;
    int i = 0;
    for (Formula formula in reactants + products) {
      for (ElementSymbol element in formula.elements.keys) {
        if (!elementsRows.containsKey(element)) {
          elementsRows[element] = i;
          ++i;
        }
      }
    }
    var matrixItems = create2dArray(elementsRows.length, equationLength,
        filled: new Rational.fromInt(0));
    int j = 0;
    int sign = 1;
    for (Formula formula in reactants + products) {
      if (sign == 1 && products.contains(formula)) sign = -1;
      formula.elements.forEach((ElementSymbol element, int subscript) {
        matrixItems[elementsRows[element]][j] =
            new Rational.fromInt(sign * subscript);
      });
      ++j;
    }
    var coefficientVectors = new RationalMatrix(matrixItems).nullSpace;
    var balancedCoefficients =
        new List<Rational>.filled(equationLength, new Rational.fromInt(0));
    for (List<Rational> vector in coefficientVectors) {
      for (int j = 0; j < equationLength; ++j) {
        balancedCoefficients[j] += vector[j];
      }
    }
    int multiple =
        lcmMultiple(balancedCoefficients.map((Rational q) => q.denominator));
    return balancedCoefficients
        .map((Rational q) => multiple * q.numerator ~/ q.denominator)
        .toList();
  }

  Equation(this.reactants, this.products)
      : coefficients = getBalancedCoefficients(reactants, products);
}
