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
      expect(water.rfm(), 1.01 * 2 + 16.00);
    });
  });

  group("FormulaFactory", () {
    test("sulfuric acid", () {
      int i = 0;
      FormulaFactory factory = new FormulaFactory();
      factory.insertElement(i, ElementSymbol.H);
      factory.setSubscript(i, 2);
      ++i;
      factory.insertElement(i, ElementSymbol.S);
      ++i;
      factory.insertElement(i, ElementSymbol.O);
      factory.setSubscript(i, 4);
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
      factory.insertOpeningBracket(i);
      ++i;
      factory.insertElement(i, ElementSymbol.Cu);
      ++i;
      factory.insertOpeningParenthesis(i);
      ++i;
      factory.insertElement(i, ElementSymbol.H);
      factory.setSubscript(i, 2);
      ++i;
      factory.insertElement(i, ElementSymbol.O);
      ++i;
      factory.insertClosingParenthesis(i, 6);
      ++i;
      factory.insertClosingBracket(i);
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
