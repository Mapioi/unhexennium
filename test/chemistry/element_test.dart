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
        [new Sublevel("1s", 1)],
      );
      expect(
        new ChemicalElement(ElementSymbol.Cr).electronConfiguration,
        [
          new Sublevel("1s", 2),
          new Sublevel("2s", 2),
          new Sublevel("2p", 6),
          new Sublevel("3s", 2),
          new Sublevel("3p", 6),
          new Sublevel("3d", 5),
          new Sublevel("4s", 1),
        ],
      );
      expect(
        new ChemicalElement(ElementSymbol.Cu).electronConfiguration,
        [
          new Sublevel("1s", 2),
          new Sublevel("2s", 2),
          new Sublevel("2p", 6),
          new Sublevel("3s", 2),
          new Sublevel("3p", 6),
          new Sublevel("3d", 10),
          new Sublevel("4s", 1),
        ],
      );
    });

    test("abbreviated electron configuration", () {
      AbbreviatedElectronConfiguration ironElectronConfigShorthand =
          new AbbreviatedElectronConfiguration.of(
              new ChemicalElement(ElementSymbol.H).electronConfiguration);
      expect(ironElectronConfigShorthand.core, null);
      expect(ironElectronConfigShorthand.valence, [
        new Sublevel("1s", 1),
      ]);
      AbbreviatedElectronConfiguration chromiumElectronConfigShorthand =
          new AbbreviatedElectronConfiguration.of(
              new ChemicalElement(ElementSymbol.Cr).electronConfiguration);
      expect(chromiumElectronConfigShorthand.core, ElementSymbol.Ar);
      expect(chromiumElectronConfigShorthand.valence, [
        new Sublevel("3d", 5),
        new Sublevel("4s", 1),
      ]);

      AbbreviatedElectronConfiguration bohriumElectronConfigShorthand =
          new AbbreviatedElectronConfiguration.of(
              new ChemicalElement(ElementSymbol.Bh).electronConfiguration);
      expect(bohriumElectronConfigShorthand.core, ElementSymbol.Rn);
      expect(
        bohriumElectronConfigShorthand.valence,
        [
          Sublevel("5f", 14),
          Sublevel("6d", 5),
          Sublevel("7s", 2),
        ],
      );
    });

    test("abbreviated electron configuration - toString", () {
      expect(
          new AbbreviatedElectronConfiguration.of(
                  new ChemicalElement(ElementSymbol.O).electronConfiguration)
              .toString(),
          "[He]2s²2p⁴");
    });

    test("ions electron configurations", () {
      expect(
        new ChemicalElement(ElementSymbol.H).oxidisedElectronConfigurations,
        {
          -1: [new Sublevel("1s", 2)],
          0: [new Sublevel("1s", 1)],
          1: [],
        },
      );
      for (ElementSymbol symbol in ElementSymbol.values) {
        expect(
          new ChemicalElement(symbol)
              .oxidisedElectronConfigurations
              .containsKey(0),
          true,
        );
      }
    });

    test(
        "finds elements with the atomic number specified, "
        "or whose atomic number starts by it", () {
      expect(findElementByAtomicNumber(0).length, 0);
      expect(findElementByAtomicNumber(2).length, 11);
      expect(findElementByAtomicNumber(2).length, 11);
      expect(findElementByAtomicNumber(92).length, 1);
    });
  });
}
