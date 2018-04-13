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

    test("electronegativity", () {
      ElementSymbol leastElectronegativeElement, mostElectronegativeElement;
      num lowestElectronegativity = double.infinity,
          highestElectronegativity = double.negativeInfinity;

      for (ElementSymbol element in ElementSymbol.values) {
        num electronegativity = new ChemicalElement(element).electronegativity;
        if (electronegativity == null) continue;
        if (electronegativity < lowestElectronegativity) {
          lowestElectronegativity = electronegativity;
          leastElectronegativeElement = element;
        } else if (electronegativity > highestElectronegativity) {
          highestElectronegativity = electronegativity;
          mostElectronegativeElement = element;
        }
      }

      expect(leastElectronegativeElement, ElementSymbol.Fr);
      expect(lowestElectronegativity, 0.7);

      expect(mostElectronegativeElement, ElementSymbol.F);
      expect(highestElectronegativity, 4.0);
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

    test("abbreviated electron configuration", () {
      AbbreviatedElectronConfiguration ironElectronConfigShorthand =
          new AbbreviatedElectronConfiguration.of(
              new ChemicalElement(ElementSymbol.H).electronConfiguration);
      expect(ironElectronConfigShorthand.core, null);
      expect(ironElectronConfigShorthand.valence, [
        new Orbital("1s", 1),
      ]);
      AbbreviatedElectronConfiguration chromiumElectronConfigShorthand =
          new AbbreviatedElectronConfiguration.of(
              new ChemicalElement(ElementSymbol.Cr).electronConfiguration);
      expect(chromiumElectronConfigShorthand.core, ElementSymbol.Ar);
      expect(chromiumElectronConfigShorthand.valence, [
        new Orbital("3d", 5),
        new Orbital("4s", 1),
      ]);
    });

    test("abbreviated electron configuration - toString", () {
      expect(
          new AbbreviatedElectronConfiguration.of(
                  new ChemicalElement(ElementSymbol.O).electronConfiguration)
              .toString(),
          "[He] 2s^2 2p^4");
    });

    test("ions electron configurations", () {
      expect(
        new ChemicalElement(ElementSymbol.H).ionsElectronConfigurations,
        {
          -1: [new Orbital("1s", 2)],
          1: [],
        },
      );
      expect(
        new ChemicalElement(ElementSymbol.Cu).ionsElectronConfigurations,
        {
          1: [
            new Orbital("1s", 2),
            new Orbital("2s", 2),
            new Orbital("2p", 6),
            new Orbital("3s", 2),
            new Orbital("3p", 6),
            new Orbital("3d", 10),
          ],
          2: [
            new Orbital("1s", 2),
            new Orbital("2s", 2),
            new Orbital("2p", 6),
            new Orbital("3s", 2),
            new Orbital("3p", 6),
            new Orbital("3d", 9),
          ],
        },
      );
      expect(
        new ChemicalElement(ElementSymbol.Mn).ionsElectronConfigurations,
        {
          2: [
            new Orbital("1s", 2),
            new Orbital("2s", 2),
            new Orbital("2p", 6),
            new Orbital("3s", 2),
            new Orbital("3p", 6),
            new Orbital("3d", 5),
          ],
          3: [
            new Orbital("1s", 2),
            new Orbital("2s", 2),
            new Orbital("2p", 6),
            new Orbital("3s", 2),
            new Orbital("3p", 6),
            new Orbital("3d", 4),
          ],
          4: [
            new Orbital("1s", 2),
            new Orbital("2s", 2),
            new Orbital("2p", 6),
            new Orbital("3s", 2),
            new Orbital("3p", 6),
            new Orbital("3d", 3),
          ],
          6: [
            new Orbital("1s", 2),
            new Orbital("2s", 2),
            new Orbital("2p", 6),
            new Orbital("3s", 2),
            new Orbital("3p", 6),
            new Orbital("3d", 1),
          ],
          7: [
            new Orbital("1s", 2),
            new Orbital("2s", 2),
            new Orbital("2p", 6),
            new Orbital("3s", 2),
            new Orbital("3p", 6),
          ],
        },
      );
    });
  });
}
