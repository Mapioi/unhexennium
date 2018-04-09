/// Chemical formulae: representation of chemical compounds and molecules

import 'package:meta/meta.dart';
import 'package:unhexennium/utils.dart';
import 'package:unhexennium/maths/rational.dart';
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
  num get rfm {
    num formulaMass = 0;
    elements.forEach((element, subscript) {
      formulaMass +=
          subscript * new ChemicalElement(element).relativeAtomicMass;
    });
    return formulaMass;
  }

  /// Derive the empirical formula.
  Formula get empiricalFormula {
    if (elements.length == 0) return new Formula({});
    int divisor = gcdMultiple(elements.values);
    return new Formula(
      new Map.fromIterable(elements.keys,
          key: (symbol) => symbol,
          value: (symbol) => elements[symbol] ~/ divisor),
    );
  }

  /// Calculate the percentages by mass of constituent elements.
  Map<ElementSymbol, num> get percentages => new Map.fromIterable(
        elements.keys,
        key: (symbol) => symbol,
        value: (symbol) =>
            new ChemicalElement(symbol).relativeAtomicMass *
            elements[symbol] /
            rfm *
            100,
      );

  /// Calculate the mass in grams from the number of moles.
  num mass(num mole) => mole * rfm;

  /// Calculate the number of moles from mass in grams.
  num mole(num mass) => mass / rfm;
}

/// Utility structure to represent an element-subscript tuple.
class ElementSubscriptPair {
  ElementSymbol elementSymbol;
  int subscript;

  ElementSubscriptPair(this.elementSymbol, this.subscript);
}

/// Used to construct chemical formulae within the app.
///
/// Use [new FormulaFactory] to initialise a new factory,
/// and use the methods below to add elements, parentheses, brackets,
/// and set the subscript and charge of the chemical formula.
class FormulaFactory {
  List<ElementSubscriptPair> elementsList = [];
  int charge = 0;

  int get length => elementsList.length;

  /// Insert a '(' to the formula at [index].
  void insertOpeningParenthesisAt(int index) {
    elementsList.insert(index, new ElementSubscriptPair(null, -1));
  }

  /// Insert a '[' to the formula at [index].
  /// Only used for complex ions.
  void insertOpeningBracketAt(int index) {
    elementsList.insert(index, new ElementSubscriptPair(null, -2));
  }

  /// Insert a ')' and the associated subscript to the formula at [index].
  void insertClosingParenthesisAt(int index, {int subscript = 1}) {
    elementsList.insert(index, new ElementSubscriptPair(null, subscript));
  }

  /// Insert a ']' to the formula at [index].
  /// Used only for complex ions; thus the subscript is set to 1.
  void insertClosingBracketAt(int index) {
    elementsList.insert(index, new ElementSubscriptPair(null, 1));
  }

  /// Insert an element to the formula at [index].
  void insertElementAt(int index, {@required ElementSymbol elementSymbol}) {
    elementsList.add(new ElementSubscriptPair(elementSymbol, 1));
  }

  /// Set the subscript of the element / parenthesis at [index].
  void setSubscriptAt(int index, {@required int subscript}) {
    elementsList[index].subscript = subscript;
  }

  /// Set the element at [index].
  void setElementAt(int index, {@required ElementSymbol elementSymbol}) {
    elementsList[index].elementSymbol = elementSymbol;
  }

  /// Set the overall ionic charge of the chemical formula.
  void setCharge(int newCharge) {
    charge = newCharge;
  }

  /// Remove the entry at [index] in [elementsList].
  void removeAt(int index) {
    elementsList.removeAt(index);
  }

  @override
  String toString() {
    String formulaString = "";
    List<String> closingParentheses = [];
    for (ElementSubscriptPair pair in elementsList) {
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

  /// Maps the indices of opening parentheses to the indices of the
  /// corresponding closing parentheses.
  Map<int, int> getClosingIndices() {
    var closingIndices = <int, int>{};
    var openingIndicesStack = <int>[];
    int i = 0;
    for (ElementSubscriptPair pair in elementsList) {
      if (pair.elementSymbol == null) {
        if (pair.subscript < 0) {
          openingIndicesStack.add(i);
        } else {
          closingIndices[openingIndicesStack.removeLast()] = i;
        }
      }
      ++i;
    }
    return closingIndices;
  }

  /// Maps the indices of the closing parenthese to the indices of the
  /// corresponding opening parentheses.
  Map<int, int> getOpeningIndices() {
    var closingIndices = getClosingIndices();
    return new Map.fromIterables(closingIndices.values, closingIndices.keys);
  }

  /// Build a [Formula] from this factory's stored [elementsList].
  Formula build() {
    Map<ElementSymbol, int> elements = {};
    int nestedSubscripts = 1;
    List<int> subscripts = [];

    for (ElementSubscriptPair pair in elementsList.reversed) {
      if (pair.elementSymbol == null) {
        if (pair.subscript > 0) {
          subscripts.add(pair.subscript);
          nestedSubscripts *= pair.subscript;
        } else {
          /// If the list of subscripts is empty,
          /// this factory contains an unpaired opening parenthesis / bracket.
          /// In this case, the opening parenthesis / bracket is ignored.
          if (subscripts.length > 1)
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
