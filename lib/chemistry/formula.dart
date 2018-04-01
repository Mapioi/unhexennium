/// Chemical formulae
import 'package:unhexennium/utils.dart';
import 'package:unhexennium/chemistry/element.dart';

/// A chemical formula is a way of information about the chemical proportions
/// of atoms that constitute a particular chemical compound or molecule, using
/// chemical element symbols, numbers, and sometimes also other symbols, such
/// as parentheses, brackets, and plus (+) and minus (−) signs.
///
/// To construct a chemical formula,
/// use [new Formula] with a map of element symbols and integer subscripts,
/// or see [FormulaFactory] for how formulae are built within the app.
class Formula {
  final Map<ElementSymbol, int> elements;
  final int charge;

  Formula(this.elements, [this.charge = 0]);

  /// Calculate the relative formula mass of this chemical formula.
  num rfm() {
    num formulaMass = 0;
    elements.forEach((element, subscript) {
      formulaMass +=
          subscript * new ChemicalElement(element).relativeAtomicMass;
    });
    return formulaMass;
  }

  /// Calculate the mass in grams from the number of moles.
  num mass(num mole) => mole * rfm();

  /// Calculate the number of moles from mass in grams.
  num mole(num mass) => mass / rfm();
}

/// Utility structure to represent an element-subscript tuple.
class _ElementSubscriptPair {
  ElementSymbol elementSymbol;
  int subscript;

  _ElementSubscriptPair(this.elementSymbol, this.subscript);
}

/// Used to construct chemical formulae within the app.
///
/// Use [new FormulaFactory] to initialise a new factory,
/// and use the methods below to add elements, parentheses, brackets,
/// and set the subscript and charge of the chemical formula.
class FormulaFactory {
  List<_ElementSubscriptPair> elementsList = [];
  int charge = 0;

  /// Add a '(' to the formula.
  void addOpeningParenthesis() {
    elementsList.add(new _ElementSubscriptPair(null, -1));
  }

  /// Add a '[' to the formula.
  /// Used only for complex ions.
  void addOpeningBracket() {
    elementsList.add(new _ElementSubscriptPair(null, -2));
  }

  /// Add a ')' and the associated subscript to the formula.
  void addClosingParenthesis(int subscript) {
    elementsList.add(new _ElementSubscriptPair(null, subscript));
  }

  /// Add a ']' to the formula.
  /// Used only for complex ions; thus the subscript is set to 1.
  void addClosingBracket() {
    elementsList.add(new _ElementSubscriptPair(null, 1));
  }

  /// Add an element to the formula.
  void addElement(ElementSymbol elementSymbol) {
    elementsList.add(new _ElementSubscriptPair(elementSymbol, 1));
  }

  /// Set the subscript of the last added element / parenthesis.
  void setLastSubscript(int newSubscript) {
    elementsList[elementsList.length - 1].subscript = newSubscript;
  }

  /// Set the overall ionic charge of the chemical formula.
  void setCharge(int newCharge) {
    charge = newCharge;
  }

  /// Remove the last entry in [elementsList].
  void removeEntry() {
    elementsList.removeLast();
  }

  @override
  String toString() {
    String formulaString = "";
    List<String> closingParentheses = [];
    for (_ElementSubscriptPair pair in elementsList) {
      if (pair.elementSymbol == null) {
        if (pair.subscript < 0) {
          switch (pair.subscript) {
            case -1:
              closingParentheses.add(')');
              formulaString += '(';
              break;
            case -2:
              closingParentheses.add(']');
              formulaString += '[';
          }
        } else {
          formulaString += closingParentheses.removeLast();
          if (pair.subscript != 1) {
            formulaString += pair.subscript.toString();
          }
        }
      } else {
        String elementSymbol = enumToString(pair.elementSymbol);
        // TODO make subscript
        String subscript = pair.subscript == 1 ? "" : pair.subscript.toString();
        formulaString += "$elementSymbol$subscript";
      }
    }
    if (charge != 0) {
      String sign = charge > 0 ? "+" : "-";
      String chargeNumber =
          charge == 1 ? "" : (charge ~/ charge.sign).toString();
      formulaString += "^$chargeNumber$sign";
    }
    return formulaString;
  }

  /// Build a [Formula] from this factory's stored [elementsList].
  Formula build() {
    Map<ElementSymbol, int> elements = {};
    int nestedSubscripts = 1;
    List<int> subscripts = [];

    for (_ElementSubscriptPair pair in elementsList.reversed) {
      if (pair.elementSymbol == null) {
        if (pair.subscript > 0) {
          subscripts.add(pair.subscript);
          nestedSubscripts *= pair.subscript;
        } else {
          nestedSubscripts ~/= subscripts.removeLast();
        }
      } else {
        if (!elements.containsKey(pair.elementSymbol)) {
          elements[pair.elementSymbol] = 0;
        }
        elements[pair.elementSymbol] += pair.subscript * nestedSubscripts;
      }
    }
    return new Formula(elements, charge);
  }
}
