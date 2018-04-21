import 'package:test/test.dart';
import 'package:unhexennium/utils.dart';
import 'package:unhexennium/maths/rational.dart';
import 'package:unhexennium/chemistry/element.dart';
import 'package:unhexennium/chemistry/formula.dart';

void main() {
  group("Formula", () {
    test("constructor", () {
      Formula water = new Formula({
        ElementSymbol.H: 2,
        ElementSymbol.O: 1,
      });
      expect(water.rfm, 1.01 * 2 + 16.00);
    });

    test("fromString", () {
      String hydrogenPeroxide = asSubscript("H2O2");
      String ammoniumIon = asSubscript("NH4") + asSuperscript("+");
      String blueVitriol = asSubscript("[Cu(H2O)4]SO4·H2O");
      String iron3BromideHexahydrate =
          asSubscript("FeBr3") + "·6" + asSubscript("H2O");
      expect(
        FormulaFactory.fromString(hydrogenPeroxide).toString(),
        hydrogenPeroxide,
      );
      expect(
        FormulaFactory.fromString(ammoniumIon).toString(),
        ammoniumIon,
      );
      expect(
        FormulaFactory.fromString(blueVitriol).toString(),
        blueVitriol,
      );
      expect(
        FormulaFactory.fromString(iron3BromideHexahydrate).toString(),
        iron3BromideHexahydrate,
      );
    });

    test("empirical", () {
      Formula ethane = new Formula({
        ElementSymbol.C: 2,
        ElementSymbol.H: 6,
      });
      Formula empiricalFormula = ethane.empiricalFormula;
      expect(empiricalFormula.elements.length, 2);
      expect(empiricalFormula.elements[ElementSymbol.C], 1);
      expect(empiricalFormula.elements[ElementSymbol.H], 3);
      expect(empiricalFormula.charge, 0);
    });

    test("toString", () {
      expect(Formula.e.toString(), "e⁻");
      expect(
          new Formula({
            ElementSymbol.C: 2,
            ElementSymbol.H: 6,
          }).empiricalFormula.toString(),
          "CH₃");
    });

    test("percentages by mass", () {
      Formula hydrogenCyanide = new Formula({
        ElementSymbol.H: 1,
        ElementSymbol.C: 1,
        ElementSymbol.N: 1,
      });
      Map<ElementSymbol, num> percentages = hydrogenCyanide.percentages;
      expect(percentages[ElementSymbol.H].toStringAsPrecision(3), '3.74');
      expect(percentages[ElementSymbol.C].toStringAsPrecision(3), '44.4');
      expect(percentages[ElementSymbol.N].toStringAsPrecision(3), '51.8');
    });

    test("type of bonding", () {
      // Metallic ---
      // Cs
      expect(
        new Formula({
          ElementSymbol.Cs: 1,
        }).bondType,
        BondType.Metallic,
      );
      // SrMg
      expect(
        new Formula({
          ElementSymbol.Sr: 1,
          ElementSymbol.Mg: 1,
        }).bondType,
        BondType.Metallic,
      );

      // Ionic ---
      // NaCl
      expect(
        new Formula({
          ElementSymbol.Na: 1,
          ElementSymbol.Cl: 1,
        }).bondType,
        BondType.Ionic,
      );
      // LiO2
      expect(
        new Formula({
          ElementSymbol.Li: 2,
          ElementSymbol.O: 1,
        }).bondType,
        BondType.Ionic,
      );

      // Polar covalent ---
      // BF3
      expect(
        new Formula({
          ElementSymbol.B: 1,
          ElementSymbol.F: 3,
        }).bondType,
        BondType.PolarCovalent,
      );
      // HF
      expect(
        new Formula({
          ElementSymbol.H: 1,
          ElementSymbol.F: 1,
        }).bondType,
        BondType.PolarCovalent,
      );

      // (non-polar) Covalent ---
      // C
      expect(
        new Formula({
          ElementSymbol.C: 1,
        }).bondType,
        BondType.Covalent,
      );
      // CH4
      expect(
        new Formula({
          ElementSymbol.C: 1,
          ElementSymbol.H: 4,
        }).bondType,
        BondType.Covalent,
      );

      // Cannot be determined ---
      // [Cu(H2O)6]2+
      expect(
        new Formula(
          {
            ElementSymbol.Cu: 1,
            ElementSymbol.H: 12,
            ElementSymbol.O: 6,
          },
          charge: 2,
        ).bondType,
        null,
      );
    });

    group("oxidation state", () {
      test("Postulate 1: F2", () {
        expect(
          new Formula(
            {
              ElementSymbol.F: 2,
            },
          ).oxidationStates,
          {
            ElementSymbol.F: new Rational.fromInt(0),
          },
        );
      });

      test("Postulate 2: O2^-", () {
        expect(
          new Formula(
            {
              ElementSymbol.O: 2,
            },
            charge: -1,
          ).oxidationStates,
          {
            ElementSymbol.O: new Rational(-1, 2),
          },
        );
      });

      test("Postulate 3: ClF3", () {
        expect(
          new Formula(
            {
              ElementSymbol.Cl: 1,
              ElementSymbol.F: 3,
            },
          ).oxidationStates,
          {
            ElementSymbol.F: new Rational.fromInt(-1),
            ElementSymbol.Cl: new Rational.fromInt(3),
          },
        );
      });

      test("Postulate 4: Na2O2", () {
        expect(
          new Formula(
            {
              ElementSymbol.Na: 2,
              ElementSymbol.O: 2,
            },
          ).oxidationStates,
          {
            ElementSymbol.Na: new Rational.fromInt(1),
            ElementSymbol.O: new Rational.fromInt(-1),
          },
        );
      });

      test("Postulate 5: CH4", () {
        expect(
          new Formula(
            {
              ElementSymbol.C: 1,
              ElementSymbol.H: 4,
            },
          ).oxidationStates,
          {
            ElementSymbol.C: new Rational.fromInt(-4),
            ElementSymbol.H: new Rational.fromInt(1),
          },
        );
      });

      test("Postulate 5: LiH", () {
        expect(
          new Formula(
            {
              ElementSymbol.Li: 1,
              ElementSymbol.H: 1,
            },
          ).oxidationStates,
          {
            ElementSymbol.Li: new Rational.fromInt(1),
            ElementSymbol.H: new Rational.fromInt(-1),
          },
        );
      });

      test("Postulate 6: Fe3O4", () {
        expect(
          new Formula(
            {
              ElementSymbol.Fe: 3,
              ElementSymbol.O: 4,
            },
          ).oxidationStates,
          {
            ElementSymbol.Fe: new Rational(8, 3),
            ElementSymbol.O: new Rational.fromInt(-2),
          },
        );
      });
    });
  });

  group("FormulaFactory", () {
    test("sulfuric acid", () {
      int i = 0;
      FormulaFactory factory = new FormulaFactory();
      factory.insertElementAt(i, elementSymbol: ElementSymbol.H);
      factory.setSubscriptAt(i, subscript: 2);
      ++i;
      factory.insertElementAt(i, elementSymbol: ElementSymbol.S);
      ++i;
      factory.insertElementAt(i, elementSymbol: ElementSymbol.O);
      factory.setSubscriptAt(i, subscript: 4);
      ++i;
      expect(factory.toString(), "H₂SO₄");
      expect(factory.build().elements, {
        ElementSymbol.S: 1,
        ElementSymbol.O: 4,
        ElementSymbol.H: 2,
      });
    });

    test("hexaaquacopper(II) ion", () {
      FormulaFactory factory = new FormulaFactory();
      int i = 0;
      factory.insertOpeningParenthesisAt(i);
      ++i;
      factory.insertElementAt(i, elementSymbol: ElementSymbol.Cu);
      ++i;
      factory.insertOpeningParenthesisAt(i);
      ++i;
      factory.insertElementAt(i, elementSymbol: ElementSymbol.H);
      factory.setSubscriptAt(i, subscript: 2);
      ++i;
      factory.insertElementAt(i, elementSymbol: ElementSymbol.O);
      ++i;
      factory.insertClosingParenthesisAt(i);
      factory.setSubscriptAt(i, subscript: 6);
      ++i;
      factory.insertClosingParenthesisAt(i);
      factory.charge = 2;
      expect(factory.toString(), "[Cu(H₂O)₆]²⁺");
      expect(factory.build().elements, {
        ElementSymbol.Cu: 1,
        ElementSymbol.H: 12,
        ElementSymbol.O: 6,
      });
    });
  });
}
