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
      FormulaFactory factory = new FormulaFactory();
      factory.addElement(ElementSymbol.H);
      factory.setLastSubscript(2);
      factory.addElement(ElementSymbol.S);
      factory.addElement(ElementSymbol.O);
      factory.setLastSubscript(4);
      expect(factory.toString(), "H2SO4");
      expect(factory.build().elements, {
        ElementSymbol.S: 1,
        ElementSymbol.O: 4,
        ElementSymbol.H: 2,
      });
    });

    test("hexaaquacopper(II) ion", () {
      FormulaFactory factory = new FormulaFactory();
      factory.addOpeningBracket();
      factory.addElement(ElementSymbol.Cu);
      factory.addOpeningParenthesis();
      factory.addElement(ElementSymbol.H);
      factory.setLastSubscript(2);
      factory.addElement(ElementSymbol.O);
      factory.addClosingParenthesis(6);
      factory.addClosingBracket();
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
