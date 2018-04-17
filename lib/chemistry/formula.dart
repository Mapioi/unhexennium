/// Chemical formulae: representation of chemical compounds and molecules

import 'package:meta/meta.dart';
import 'package:unhexennium/utils.dart';
import 'package:unhexennium/maths/rational.dart';
import 'package:unhexennium/chemistry/element.dart';

enum BondType { Covalent, Ionic, Metallic, PolarCovalent }

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

  /// Determine the type of bonding in this molecule using Table 29,
  /// triangular bonding diagram (van Arkel-Ketelaar triangle of bonding).
  /// Therefore, the type of bonding can only be determined for molecules with
  /// only 2 species of atoms; `null` is returned otherwise.
  BondType get bondType {
    // The symbol of electronegativity is χ, the greek letter chi.
    num chi1, chi2;
    var symbols = elements.keys.toList();
    if (symbols.length == 1) {
      chi1 = chi2 = new ChemicalElement(symbols[0]).electronegativity;
    } else if (symbols.length == 2) {
      chi1 = new ChemicalElement(symbols[0]).electronegativity;
      chi2 = new ChemicalElement(symbols[1]).electronegativity;
    } else
      return null;

    num chiAv = (chi1 + chi2) / 2;
    num chiDiff = (chi1 - chi2).abs();

    // Metal / non-metal boundary: χ_av = -0.5 Δχ + 2.28
    if (chiAv <= -0.5 * chiDiff + 2.28) return BondType.Metallic;

    // Covalent / ionic boundary:  χ_av =  0.5 Δχ + 1.60
    if (chiAv <= 0.5 * chiDiff + 1.60) return BondType.Ionic;

    // Typically,
    if (chiDiff <= 0.4) return BondType.Covalent;
    return BondType.PolarCovalent;
  }

  /// Calculate the number of moles from mass in grams.
  num mole(num mass) => mass / rfm;

  /// Calculate the mass in grams from the number of moles.
  num mass(num mole) => mole * rfm;
}

/// Utility structure to represent an element-subscript tuple.
class ElementSubscriptPair {
  ElementSymbol elementSymbol;
  int subscript;

  ElementSubscriptPair(this.elementSymbol, this.subscript);

  @override
  String toString() {
    if (elementSymbol != null) {
      return "(${enumToString(elementSymbol)}, ${subscript.toString()})";
    } else {
      // using brackets to avoid confusion
      return subscript < 0 ? "([)" : "(], $subscript)";
    }
  }
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

  /// Insert a ')' to the formula at [index].
  void insertClosingParenthesisAt(int index) {
    elementsList.insert(index, new ElementSubscriptPair(null, 1));
  }

  /// Insert an element to the formula at [index].
  void insertElementAt(int index, {@required ElementSymbol elementSymbol}) {
    elementsList.insert(index, new ElementSubscriptPair(elementSymbol, 1));
  }

  /// Set the subscript of the element / parenthesis at [index].
  void setSubscriptAt(int index, {@required int subscript}) {
    elementsList[index].subscript = subscript;
  }

  /// Set the element at [index].
  void setElementAt(int index, {@required ElementSymbol elementSymbol}) {
    elementsList[index].elementSymbol = elementSymbol;
  }

  /// Remove the entry at [index] in [elementsList].
  void removeAt(int index) {
    elementsList.removeAt(index);
  }

  @override
  String toString() {
    var closingIndices = getClosingIndices();
    String formula = elementsList.asMap().keys.map((int i) {
      ElementSubscriptPair pair = elementsList[i];
      // Element
      if (pair.elementSymbol != null) {
        String element = enumToString(pair.elementSymbol);
        if (pair.subscript == 1) {
          return "$element";
        } else {
          String subscript = asSubscript(
            pair.subscript.toString(),
          );
          return "$element$subscript";
        }
        // Parenthesis
      } else {
        if (pair.subscript < 0) {
          return elementsList[closingIndices[i]].subscript != 1 ? "(" : "[";
        } else {
          String parenthesis = pair.subscript == 1 ? "]" : ")";
          String subscript = asSubscript(pair.subscript.toString());
          return "$parenthesis${pair.subscript == 1 ? "" : subscript}";
        }
      }
    }).join();
    String charge = asSuperscript(toStringAsCharge(this.charge, omitOne: true));
    return "$formula$charge";
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

  /// Maps the indices of the closing parentheses to the indices of the
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
