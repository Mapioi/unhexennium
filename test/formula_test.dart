import 'package:test/test.dart';
import 'package:unhexennium/chemistry/element.dart';
import 'package:unhexennium/chemistry/formula.dart';

void main() {
  group("Formula", () {
    test("constructor", () {
      Formula water = new Formula(
          {new ChemicalElement(ElementSymbol.H): 2, new ChemicalElement(ElementSymbol.O): 1});
      expect(water.rfm(), 1.01 * 2 + 16.00);
    });
  });
}
