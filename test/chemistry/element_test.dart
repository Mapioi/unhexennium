import 'package:test/test.dart';
import 'package:unhexennium/chemistry/element.dart';

void main() {
  group("Element", () {
    test("constructor", () {
      ChemicalElement H = const ChemicalElement(ElementSymbol.H);
      expect(H.symbol, ElementSymbol.H);
      expect(H.name, "Hydrogen");
      expect(H.atomicNumber, 1);
      expect(H.relativeAtomicMass, 1.01);
    });
  });
}
