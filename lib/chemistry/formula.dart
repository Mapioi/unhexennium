/// Chemical formulae: representation of chemical compounds and molecules

import 'package:meta/meta.dart';
import 'package:unhexennium/utils.dart';
import 'package:unhexennium/maths/rational.dart';
import 'package:unhexennium/chemistry/element.dart';

/// Gas constant (J k^-1 mol^-1)
const num R = 8.31;
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

  Formula(this.elements, {this.charge = 0});

  static final Formula e = new Formula({}, charge: -1);

  @override
  String toString() {
    if (elements.isEmpty && charge == -1) return "e${asSuperscript('-')}";
    return elements.entries
            .map((MapEntry<ElementSymbol, int> entry) {
              String symbol = enumToString(entry.key);
              String subscript =
                  entry.value != 1 ? asSubscript(entry.value.toString()) : "";
              return "$symbol$subscript";
            })
            .toList()
            .join() +
        asSuperscript(toStringAsCharge(charge, omitOne: true));
  }

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
    if (elements.isEmpty) return null;
    int divisor = gcdMultiple(elements.values);
    return new Formula(
      new Map.fromIterable(elements.keys,
          key: (symbol) => symbol,
          value: (symbol) => elements[symbol] ~/ divisor),
    );
  }

  /// Calculate the percentages by mass of constituent elements.
  Map<ElementSymbol, num> get percentages => elements.isNotEmpty
      ? new Map.fromIterable(
          elements.keys,
          key: (symbol) => symbol,
          value: (symbol) =>
              new ChemicalElement(symbol).relativeAtomicMass *
              elements[symbol] /
              rfm *
              100,
        )
      : null;

  /// The oxidation state, sometimes referred to as oxidation number, describes
  /// degree of oxidation (loss of electrons) of an atom in a chemical compound.
  /// Conceptually, the oxidation state, which may be positive, negative or
  /// zero, is the hypothetical charge that an atom would have if all bonds to
  /// atoms of different elements were 100% ionic, with no covalent component.
  ///
  /// The oxidation states are determined via an algorithm based on postulates:
  /// 1. An element in a free form has OS = 0.
  /// 2. In a compound or ion, the oxidation-state sum equals the total charge
  ///    of the compound or ion.
  /// 3. Fluorine in compounds has OS = −1;
  ///    which extends to Cl and Br only when not bonded to a lighter halogen,
  ///    oxygen or nitrogen.
  /// 4. Group 1 and 2 metals in compounds have OS = +1 and +2, respectively.
  /// 5. Hydrogen has OS = +1, but adopts −1 when bonded to metals or
  ///    metalloids.
  /// 6. Oxygen in compounds has OS = −2.
  /// The algorithm is expected to cover most compounds in a textbook's scope.
  /// Returns null if it fails to determine the OS for all elements.
  Map<ElementSymbol, Rational> get oxidationStates {
    // Handle e^-
    if (elements.isEmpty) return null;

    var symbols = elements.keys.toList();
    int chargeLeft = charge;
    Map<ElementSymbol, Rational> os = {};
    // Condition in postulate 5
    bool bondedToMetalsOrMetalloids = false;

    while (symbols.length > 1) {
      // Postulate 3: fluorine always has OS of -1
      if (symbols.contains(ElementSymbol.F)) {
        os[ElementSymbol.F] = new Rational.fromInt(-1);
        chargeLeft -= (-1) * elements[ElementSymbol.F];
        symbols.remove(ElementSymbol.F);
        continue;
        // And so does chlorine when not bonded to fluorine, oxygen or nitrogen
      } else if (!symbols.contains(ElementSymbol.O) &&
          !symbols.contains(ElementSymbol.N)) {
        if (symbols.contains(ElementSymbol.Cl)) {
          os[ElementSymbol.Cl] = new Rational.fromInt(-1);
          chargeLeft -= (-1) * elements[ElementSymbol.Cl];
          symbols.remove(ElementSymbol.Cl);
          continue;

          // For bromine the 'lighter halogen' also includes chlorine
        } else if (symbols.contains(ElementSymbol.Br)) {
          os[ElementSymbol.Br] = new Rational.fromInt(-1);
          chargeLeft -= (-1) * elements[ElementSymbol.Br];
          symbols.remove(ElementSymbol.Br);
          continue;
        }
      }

      bool postulate4Used = false;

      for (int i = 0; i < symbols.length; ++i) {
        ElementSymbol symbol = symbols[i];
        if (!metalloids.contains(symbol) && !nonMetals.contains(symbol)) {
          bondedToMetalsOrMetalloids = true;

          // Postulate 4
          if (alkaliMetals.contains(symbol)) {
            os[symbol] = new Rational.fromInt(1);
            chargeLeft -= 1 * elements[symbol];
            symbols.remove(symbol);
            postulate4Used = true;
            break;
          } else if (alkalineEarthMetals.contains(symbol)) {
            os[symbol] = new Rational.fromInt(2);
            chargeLeft -= 2 * elements[symbol];
            symbols.remove(symbol);
            postulate4Used = true;
            break;
          }
        }
      }

      if (postulate4Used) continue;

      // Postulate 5
      if (symbols.contains(ElementSymbol.H)) {
        int osHydrogen = bondedToMetalsOrMetalloids ? -1 : 1;
        os[ElementSymbol.H] = new Rational.fromInt(osHydrogen);
        chargeLeft -= osHydrogen * elements[ElementSymbol.H];
        symbols.remove(ElementSymbol.H);
        continue;
      }

      // Postulate 6
      if (symbols.contains(ElementSymbol.O)) {
        os[ElementSymbol.O] = new Rational.fromInt(-2);
        chargeLeft -= (-2) * elements[ElementSymbol.O];
        symbols.remove(ElementSymbol.O);
        continue;
      }

      if (symbols.length > 1) return null;
    }

    // Postulate 1 & 2
    ElementSymbol symbol = symbols[0];
    int numberOfAtoms = elements[symbol];
    os[symbol] = new Rational(chargeLeft, numberOfAtoms);
    symbols.remove(symbol);

    return os;
  }

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

  /// Calculate the pressure of this ideal gas.
  ///
  /// * p is in pascals;
  /// * V is in cubic meters;
  /// * n is in moles;
  /// * R = 8.31 J K^-1 mol^-1;
  /// * T is in kelvins.
  num p({@required num V, @required num n, @required num T}) => (n * R * T) / V;

  /// Calculate the volume of this ideal gas.
  ///
  /// * p is in pascals;
  /// * V is in cubic meters;
  /// * n is in moles;
  /// * R = 8.31 J K^-1 mol^-1;
  /// * T is in kelvins.
  num V({@required num p, @required num n, @required num T}) => (n * R * T) / p;

  /// Calculate the number of moles of this ideal gas.
  ///
  /// * p is in pascals;
  /// * V is in cubic meters;
  /// * n is in moles;
  /// * R = 8.31 J K^-1 mol^-1;
  /// * T is in kelvins.
  num n({@required num p, @required num V, @required num T}) => p * V / (R * T);

  /// Calculate the temperature of this ideal gas.
  ///
  /// * p is in pascals;
  /// * V is in cubic meters;
  /// * n is in moles;
  /// * R = 8.31 J K^-1 mol^-1;
  /// * T is in kelvins.
  num T({@required num p, @required num V, @required num n}) => p * V / (n * R);
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
    return new Formula(elements, charge: charge);
  }
}
