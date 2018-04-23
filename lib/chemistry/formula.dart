/// Chemical formulae: representation of chemical compounds and molecules

import 'package:meta/meta.dart';
import 'package:unhexennium/utils.dart';
import 'package:unhexennium/maths/rational.dart';
import 'package:unhexennium/chemistry/element.dart';
import 'package:unhexennium/chemistry/data/formulae.dart';

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

  // TODO hill's
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
    bool isMetalHydride = false;

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
        // Due to technical difficulties,
        // only binary metal hydrides are considered.
        if (elements.length <= 2) {
          if (!metalloids.contains(symbol) && !nonMetals.contains(symbol)) {
            isMetalHydride = true;
          }

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
        int osHydrogen = isMetalHydride ? -1 : 1;
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

    // Metal / non-metal boundary
    if (chiDiff <= -1.86 * chiAv + 3.57) return BondType.Metallic;

    // Covalent / ionic boundary
    if (chiDiff >= 1.86 * chiAv - 2.79) return BondType.Ionic;

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
  num P({@required num V, @required num n, @required num T}) => (n * R * T) / V;

  /// Calculate the volume of this ideal gas.
  ///
  /// * p is in pascals;
  /// * V is in cubic meters;
  /// * n is in moles;
  /// * R = 8.31 J K^-1 mol^-1;
  /// * T is in kelvins.
  num V({@required num P, @required num n, @required num T}) => (n * R * T) / P;

  /// Calculate the number of moles of this ideal gas.
  ///
  /// * p is in pascals;
  /// * V is in cubic meters;
  /// * n is in moles;
  /// * R = 8.31 J K^-1 mol^-1;
  /// * T is in kelvins.
  num n({@required num P, @required num V, @required num T}) => P * V / (R * T);

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

  String get name => toString();

  /// Instantiate a [FormulaFactory] with an empty [elementsList].
  FormulaFactory();

  /// Instantiate a [FormulaFactory] filling [elementsList] from formula string.
  FormulaFactory.fromString(String formula) {
    int factoryIndex = -1;
    int stringIndex = 0;
    String subscript = "";
    String element = "";
    String charge = "";
    for (stringIndex; stringIndex < formula.length; stringIndex++) {
      String char = formula[stringIndex];
      // char can either be:
      // - an opening parenthesis / bracket
      // - a closing parenthesis / bracket
      // - a subscript
      // - a superscript
      // - a letter, upper or lower case
      // - '·': the notation for water of crystallization
      //
      // An element symbol starts with an upper case letter,
      // and continues with lower case letters.
      //
      // A subscript follows an element or a closing parenthesis / bracket.
      //
      // The superscript can be empty in the case where the charge is 0,
      // and otherwise ends with '+' or '-' and may contain numbers in superscript.

      // Formula
      if (char == '·') {
        // End of formula, start of water of crystallization
        break;
      }
      if (isSuperscriptChar(char)) {
        // End of formula, start of charge
        break;
      } else if (isSubscriptChar(char)) {
        if (element.isNotEmpty) {
          insertElementAt(factoryIndex,
              elementSymbol: new ChemicalElement.fromString(element).symbol);
          element = "";
          // To set its subscript, formulaIndex is not incremented
        }
        subscript += char;
      } else {
        if (['(', '[', ']', ')'].contains(char) || char.toUpperCase() == char) {
          if (element.isNotEmpty) {
            insertElementAt(factoryIndex,
                elementSymbol: new ChemicalElement.fromString(element).symbol);
            element = "";
          } else if (subscript.isNotEmpty) {
            setSubscriptAt(factoryIndex,
                subscript: int.parse(fromSubscript(subscript)));
            subscript = "";
          }
          factoryIndex++;

          if (char == '(' || char == '[') {
            insertOpeningParenthesisAt(factoryIndex);
          } else if (char == ')' || char == ']') {
            insertClosingParenthesisAt(factoryIndex);
          } else {
            element = "";
            element += char;
          }
        } else {
          element += char;
        }
      }
    }
    if (element.isNotEmpty) {
      insertElementAt(factoryIndex,
          elementSymbol: new ChemicalElement.fromString(element).symbol);
      element = "";
    } else if (subscript.isNotEmpty) {
      setSubscriptAt(factoryIndex,
          subscript: int.parse(fromSubscript(subscript)));
      subscript = "";
    }
    factoryIndex++;

    if (stringIndex >= formula.length) return;
    if (formula[stringIndex] == '·') {
      // Water of crystallization
      String n = "";
      for (++stringIndex; stringIndex < formula.length; stringIndex++) {
        String char = formula[stringIndex];
        if (char == 'H') {
          break;
        }
        n += char;
      }

      int subscript = n.isEmpty ? 1 : num.parse(n);
      insertOpeningParenthesisAt(factoryIndex++);
      insertElementAt(factoryIndex, elementSymbol: ElementSymbol.H);
      setSubscriptAt(factoryIndex++, subscript: 2);
      insertElementAt(factoryIndex++, elementSymbol: ElementSymbol.O);
      insertClosingParenthesisAt(factoryIndex);
      setSubscriptAt(factoryIndex++, subscript: subscript);
    } else {
      // Charge
      for (stringIndex; stringIndex < formula.length; stringIndex++) {
        String char = String.fromCharCode(formula.runes.elementAt(stringIndex));
        assert(isSuperscriptChar(char));
        charge += char;
      }
      if (charge.isNotEmpty) {
        charge = fromSuperscript(charge);
        // this.charge defaults to 0
        String signChar = String.fromCharCode(charge.runes.last);
        assert(signChar == '-' || signChar == '+');
        int sign = {'-': -1, '+': 1}[signChar];
        int value = charge.length == 1
            ? 1
            : int.parse(charge.substring(0, charge.length - 1));
        this.charge = sign * value;
      }
    }
  }

  List<String> get names => formulaeNames[toString()];

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
    if (elementsList.isEmpty) return null;
    List<String> formulaList = elementsList.asMap().keys.map((int i) {
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
          return "(";
        } else {
          String subscript = asSubscript(pair.subscript.toString());
          return ")${pair.subscript == 1 ? "" : subscript}";
        }
      }
    }).toList();
    // Change the first pair parentheses into brackets if needed
    if (elementsList[0].elementSymbol == null &&
        elementsList[0].subscript < 0) {
      int closingIndex = getClosingIndices()[0];
      if (elementsList[closingIndex].subscript == 1) {
        assert(formulaList[0] == '(');
        formulaList[0] = '[';
        assert(formulaList[closingIndex] == ')');
        formulaList[closingIndex] = ']';
      }
    }
    String formula = formulaList.join();
    // Water of crystallization
    String n = "";
    int i = formula.length - 1;
    while (i >= 0 && isSubscriptChar(formula[i])) {
      // Get the subscript of the last cell
      n = formula[i] + n;
      i--;
    }
    if (i > 4) {
      // ...(H₂O)
      if (formula.substring(i - 4, i + 1) == "(H₂O)") {
        formula = "${formula.substring(0, i - 4)}·${fromSubscript(n)}H₂O";
      }
    }

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
