import 'package:test/test.dart';
import 'package:unhexennium/chemistry/element.dart';

void main() {
  group("Element", () {
    test("constructor", () {
      ChemicalElement H = new ChemicalElement(ElementSymbol.H);
      ChemicalElement anotherH = new ChemicalElement(ElementSymbol.H);
      expect(H == anotherH, true);
    });

    test("name", () {
      expect(new ChemicalElement(ElementSymbol.H).name, "Hydrogen");
      expect(new ChemicalElement(ElementSymbol.Uuo).name,
          "Oganesson (Ununoctium)");
    });

    test("atomic number", () {
      expect(new ChemicalElement(ElementSymbol.H).atomicNumber, 1);
      expect(new ChemicalElement(ElementSymbol.Uuo).atomicNumber, 118);
    });

    test("relative atomic mass", () {
      expect(new ChemicalElement(ElementSymbol.H).relativeAtomicMass, 1.01);
      expect(new ChemicalElement(ElementSymbol.Uuo).relativeAtomicMass, 294);
    });
  });
}
