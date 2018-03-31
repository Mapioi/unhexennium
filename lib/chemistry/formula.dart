import 'package:unhexennium/chemistry/element.dart';

class Formula {
  final Map<ChemicalElement, int> elements;
  final int charge;

  Formula(this.elements, [this.charge = 0]);

  num rfm() {
    num formulaMass = 0;
    elements.forEach((element, subscript) {
      formulaMass += subscript * element.relativeAtomicMass;
    });
    return formulaMass;
  }

  num mass(num mole) => mole * rfm();

  num mole(num mass) => mass / rfm();
}
