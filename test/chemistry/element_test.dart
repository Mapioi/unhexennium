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

    test("electron configuration", () {
      expect(
        new ChemicalElement(ElementSymbol.H).electronConfiguration,
        [new Orbital("1s", 1)],
      );
      expect(
        new ChemicalElement(ElementSymbol.Cr).electronConfiguration,
        [
          new Orbital("1s", 2),
          new Orbital("2s", 2),
          new Orbital("2p", 6),
          new Orbital("3s", 2),
          new Orbital("3p", 6),
          new Orbital("3d", 5),
          new Orbital("4s", 1),
        ],
      );
      expect(
        new ChemicalElement(ElementSymbol.Cu).electronConfiguration,
        [
          new Orbital("1s", 2),
          new Orbital("2s", 2),
          new Orbital("2p", 6),
          new Orbital("3s", 2),
          new Orbital("3p", 6),
          new Orbital("3d", 10),
          new Orbital("4s", 1),
        ],
      );
    });
  });
}
