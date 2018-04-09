import 'package:test/test.dart';
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
      expect(factory.toString(), "H2SO4");
      expect(factory.build().elements, {
        ElementSymbol.S: 1,
        ElementSymbol.O: 4,
        ElementSymbol.H: 2,
      });
    });

    test("hexaaquacopper(II) ion", () {
      FormulaFactory factory = new FormulaFactory();
      int i = 0;
      factory.insertOpeningBracketAt(i);
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
      factory.insertClosingParenthesisAt(i, subscript: 6);
      ++i;
      factory.insertClosingBracketAt(i);
      ++i;
      factory.setCharge(2);
      expect(factory.toString(), "[Cu(H2O)6]^2+");
      expect(factory.build().elements, {
        ElementSymbol.Cu: 1,
        ElementSymbol.H: 12,
        ElementSymbol.O: 6,
      });
    });
  });
}
