/// Chemical elements: building blocks of chemistry

/// Identifiers for elements
///
/// The IUPAC names Uut, Uuq, Uup, Uuh, Uus, Uuo are used instead of
/// Nh, Fl, Mc, Ts, Og so that this app is compliant with table 6 of
/// the IB chemistry data booklet.
enum ElementSymbol {
  H,
  He,
  Li,
  Be,
  B,
  C,
  N,
  O,
  F,
  Ne,
  Na,
  Mg,
  Al,
  Si,
  P,
  S,
  Cl,
  Ar,
  K,
  Ca,
  Sc,
  Ti,
  V,
  Cr,
  Mn,
  Fe,
  Co,
  Ni,
  Cu,
  Zn,
  Ga,
  Ge,
  As,
  Se,
  Br,
  Kr,
  Rb,
  Sr,
  Y,
  Zr,
  Nb,
  Mo,
  Tc,
  Ru,
  Rh,
  Pd,
  Ag,
  Cd,
  In,
  Sn,
  Sb,
  Te,
  I,
  Xe,
  Cs,
  Ba,
  La,
  Ce,
  Pr,
  Nd,
  Pm,
  Sm,
  Eu,
  Gd,
  Tb,
  Dy,
  Ho,
  Er,
  Tm,
  Yb,
  Lu,
  Hf,
  Ta,
  W,
  Re,
  Os,
  Ir,
  Pt,
  Au,
  Hg,
  Tl,
  Pb,
  Bi,
  Po,
  At,
  Rn,
  Fr,
  Ra,
  Ac,
  Th,
  Pa,
  U,
  Np,
  Pu,
  Am,
  Cm,
  Bk,
  Cf,
  Es,
  Fm,
  Md,
  No,
  Lr,
  Rf,
  Db,
  Sg,
  Bh,
  Hs,
  Mt,
  Ds,
  Rg,
  Cn,
  Uut,
  Uuq,
  Uup,
  Uuh,
  Uus,
  Uuo,
}

/// Relative atomic masses
/// from table 6 - The periodic table
/// of the IB chemistry data booklet (version 2, 2014)
///
/// For elements with no stable isotopes,
/// the mass number of the isotope with the longest half-life is given.
const List<num> _relativeAtomicMasses = const [
  1.01,
  4.00,
  6.94,
  9.01,
  10.81,
  12.01,
  14.01,
  16.00,
  19.00,
  20.18,
  22.99,
  24.31,
  26.98,
  28.09,
  30.97,
  32.07,
  35.45,
  39.95,
  39.10,
  40.08,
  44.96,
  47.87,
  50.94,
  52.00,
  54.94,
  55.85,
  58.93,
  58.69,
  63.55,
  65.38,
  69.72,
  72.63,
  74.92,
  78.96,
  79.90,
  83.90,
  85.47,
  87.62,
  88.91,
  91.22,
  92.91,
  95.96,
  98,
  101.07,
  102.91,
  106.42,
  107.87,
  112.41,
  114.82,
  118.71,
  121.76,
  127.60,
  126.90,
  131.29,
  132.91,
  137.33,
  138.91,
  140.12,
  140.91,
  144.24,
  145,
  150.36,
  151.96,
  157.25,
  158.93,
  162.50,
  164.93,
  167.26,
  168.93,
  173.05,
  174.97,
  178.49,
  180.95,
  183.84,
  186.21,
  190.23,
  192.22,
  195.08,
  196.97,
  200.59,
  204.38,
  207.20,
  208.98,
  209,
  210,
  222,
  223,
  226,
  227,
  232.04,
  231.04,
  238.03,
  237,
  244,
  243,
  247,
  247,
  251,
  252,
  257,
  258,
  259,
  262,
  267,
  268,
  269,
  270,
  269,
  278,
  281,
  281,
  285,
  286,
  289,
  288,
  293,
  294,
  294,
];

/// Names of the elements
const List<String> _names = const [
  "Hydrogen",
  "Helium",
  "Lithium",
  "Beryllium",
  "Boron",
  "Carbon",
  "Nitrogen",
  "Oxygen",
  "Fluorine",
  "Neon",
  "Sodium",
  "Magnesium",
  "Aluminium",
  "Silicon",
  "Phosphorus",
  "Sulfur",
  "Chlorine",
  "Argon",
  "Potassium",
  "Calcium",
  "Scandium",
  "Titanium",
  "Vanadium",
  "Chromium",
  "Manganese",
  "Iron",
  "Cobalt",
  "Nickel",
  "Copper",
  "Zinc",
  "Gallium",
  "Germanium",
  "Arsenic",
  "Selenium",
  "Bromine",
  "Krypton",
  "Rubidium",
  "Strontium",
  "Yttrium",
  "Zirconium",
  "Niobium",
  "Molybdenum",
  "Technetium",
  "Ruthenium",
  "Rhodium",
  "Palladium",
  "Silver",
  "Cadmium",
  "Indium",
  "Tin",
  "Antimony",
  "Tellurium",
  "Iodine",
  "Xenon",
  "Cesium",
  "Barium",
  "Lanthanum",
  "Cerium",
  "Praseodymium",
  "Neodymium",
  "Promethium",
  "Samarium",
  "Europium",
  "Gadolinium",
  "Terbium",
  "Dysprosium",
  "Holmium",
  "Erbium",
  "Thulium",
  "Ytterbium",
  "Lutetium",
  "Hafnium",
  "Tantalum",
  "Tungsten",
  "Rhenium",
  "Osmium",
  "Iridium",
  "Platinum",
  "Gold",
  "Mercury",
  "Thallium",
  "Lead",
  "Bismuth",
  "Polonium",
  "Astatine",
  "Radon",
  "Francium",
  "Radium",
  "Actinium",
  "Thorium",
  "Protactinium",
  "Uranium",
  "Neptunium",
  "Plutonium",
  "Americium",
  "Curium",
  "Berkelium",
  "Californium",
  "Einsteinium",
  "Fermium",
  "Mendelevium",
  "Nobelium",
  "Lawrencium",
  "Rutherfordium",
  "Dubnium",
  "Seaborgium",
  "Bohrium",
  "Hassium",
  "Meitnerium",
  "Darmstadtium",
  "Roentgenium",
  "Copernicium",
  "Nihonium (Ununtrium)",
  "Flerovium (Ununquadium)",
  "Moscovium (Ununpentium)",
  "Livermorium (Ununhexium)",
  "Tennessine (Ununseptium)",
  "Oganesson (Ununoctium)",
];

const List<String> _orbitalNames = const [
  "1s",
  "2s",
  "2p",
  "3s",
  "3p",
  "3d",
  "4s",
  "4p",
  "4d",
  "4f",
  "5s",
  "5p",
  "5d",
  "5f",
  "5g",
  "6s",
  "6p",
  "6d",
  "6f",
  "7s",
  "7p",
];

/// Electron configurations of neutral gaseous atoms in their ground states
///
/// Each list at index i corresponds to the electron configuration of the
/// atom of element of atomic number (i + 1).
/// The j-th entry of the list corresponds to the number of electrons in the
/// j-th orbital (see [_orbitalNames]).
///
/// source:
/// en.wikipedia.org/wiki/Electron_configurations_of_the_elements_(data_page)
const List<List<int>> _electronConfigurations = const [
  [1],
  [2],
  [2, 1],
  [2, 2],
  [2, 2, 1],
  [2, 2, 2],
  [2, 2, 3],
  [2, 2, 4],
  [2, 2, 5],
  [2, 2, 6],
  [2, 2, 6, 1],
  [2, 2, 6, 2],
  [2, 2, 6, 2, 1],
  [2, 2, 6, 2, 2],
  [2, 2, 6, 2, 3],
  [2, 2, 6, 2, 4],
  [2, 2, 6, 2, 5],
  [2, 2, 6, 2, 6],
  [2, 2, 6, 2, 6, 0, 1],
  [2, 2, 6, 2, 6, 0, 2],
  [2, 2, 6, 2, 6, 1, 2],
  [2, 2, 6, 2, 6, 2, 2],
  [2, 2, 6, 2, 6, 3, 2],
  [2, 2, 6, 2, 6, 5, 1],
  [2, 2, 6, 2, 6, 5, 2],
  [2, 2, 6, 2, 6, 6, 2],
  [2, 2, 6, 2, 6, 7, 2],
  [2, 2, 6, 2, 6, 8, 2],
  [2, 2, 6, 2, 6, 10, 1],
  [2, 2, 6, 2, 6, 10, 2],
  [2, 2, 6, 2, 6, 10, 2, 1],
  [2, 2, 6, 2, 6, 10, 2, 2],
  [2, 2, 6, 2, 6, 10, 2, 3],
  [2, 2, 6, 2, 6, 10, 2, 4],
  [2, 2, 6, 2, 6, 10, 2, 5],
  [2, 2, 6, 2, 6, 10, 2, 6],
  [2, 2, 6, 2, 6, 10, 2, 6, 0, 0, 1],
  [2, 2, 6, 2, 6, 10, 2, 6, 0, 0, 2],
  [2, 2, 6, 2, 6, 10, 2, 6, 1, 0, 2],
  [2, 2, 6, 2, 6, 10, 2, 6, 2, 0, 2],
  [2, 2, 6, 2, 6, 10, 2, 6, 4, 0, 1],
  [2, 2, 6, 2, 6, 10, 2, 6, 5, 0, 1],
  [2, 2, 6, 2, 6, 10, 2, 6, 5, 0, 2],
  [2, 2, 6, 2, 6, 10, 2, 6, 7, 0, 1],
  [2, 2, 6, 2, 6, 10, 2, 6, 8, 0, 1],
  [2, 2, 6, 2, 6, 10, 2, 6, 10],
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 0, 1],
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 0, 2],
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 0, 2, 1],
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 0, 2, 2],
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 0, 2, 3],
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 0, 2, 4],
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 0, 2, 5],
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 0, 2, 6],
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 0, 2, 6, 0, 0, 0, 1],
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 0, 2, 6, 0, 0, 0, 2],
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 0, 2, 6, 1, 0, 0, 2],
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 1, 2, 6, 1, 0, 0, 2],
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 3, 2, 6, 0, 0, 0, 2],
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 4, 2, 6, 0, 0, 0, 2],
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 5, 2, 6, 0, 0, 0, 2],
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 6, 2, 6, 0, 0, 0, 2],
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 7, 2, 6, 0, 0, 0, 2],
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 7, 2, 6, 1, 0, 0, 2],
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 9, 2, 6, 0, 0, 0, 2],
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 10, 2, 6, 0, 0, 0, 2],
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 11, 2, 6, 0, 0, 0, 2],
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 12, 2, 6, 0, 0, 0, 2],
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 13, 2, 6, 0, 0, 0, 2],
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 14, 2, 6, 0, 0, 0, 2],
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 14, 2, 6, 1, 0, 0, 2],
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 14, 2, 6, 2, 0, 0, 2],
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 14, 2, 6, 3, 0, 0, 2],
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 14, 2, 6, 4, 0, 0, 2],
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 14, 2, 6, 5, 0, 0, 2],
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 14, 2, 6, 6, 0, 0, 2],
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 14, 2, 6, 7, 0, 0, 2],
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 14, 2, 6, 9, 0, 0, 1],
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 14, 2, 6, 10, 0, 0, 1],
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 14, 2, 6, 10, 0, 0, 2],
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 14, 2, 6, 10, 0, 0, 2, 1],
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 14, 2, 6, 10, 0, 0, 2, 2],
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 14, 2, 6, 10, 0, 0, 2, 3],
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 14, 2, 6, 10, 0, 0, 2, 4],
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 14, 2, 6, 10, 0, 0, 2, 5],
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 14, 2, 6, 10, 0, 0, 2, 6],
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 14, 2, 6, 10, 0, 0, 2, 6, 0, 0, 1],
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 14, 2, 6, 10, 0, 0, 2, 6, 0, 0, 2],
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 14, 2, 6, 10, 0, 0, 2, 6, 1, 0, 2],
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 14, 2, 6, 10, 0, 0, 2, 6, 2, 0, 2],
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 14, 2, 6, 10, 2, 0, 2, 6, 1, 0, 2],
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 14, 2, 6, 10, 3, 0, 2, 6, 1, 0, 2],
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 14, 2, 6, 10, 4, 0, 2, 6, 1, 0, 2],
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 14, 2, 6, 10, 6, 0, 2, 6, 0, 0, 2],
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 14, 2, 6, 10, 7, 0, 2, 6, 0, 0, 2],
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 14, 2, 6, 10, 7, 0, 2, 6, 1, 0, 2],
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 14, 2, 6, 10, 9, 0, 2, 6, 0, 0, 2],
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 14, 2, 6, 10, 10, 0, 2, 6, 0, 0, 2],
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 14, 2, 6, 10, 11, 0, 2, 6, 0, 0, 2],
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 14, 2, 6, 10, 12, 0, 2, 6, 0, 0, 2],
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 14, 2, 6, 10, 13, 0, 2, 6, 0, 0, 2],
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 14, 2, 6, 10, 14, 0, 2, 6, 0, 0, 2],
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 14, 2, 6, 10, 14, 0, 2, 6, 0, 0, 2, 1],
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 14, 2, 6, 10, 14, 0, 2, 6, 2, 0, 2],
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 14, 2, 6, 10, 14, 0, 2, 6, 3, 0, 2],
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 14, 2, 6, 10, 14, 0, 2, 6, 4, 0, 2],
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 14, 2, 6, 10, 14, 0, 2, 6, 5, 0, 2],
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 14, 2, 6, 10, 14, 0, 2, 6, 6, 0, 2],
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 14, 2, 6, 10, 14, 0, 2, 6, 7, 0, 2],
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 14, 2, 6, 10, 14, 0, 2, 6, 8, 0, 2],
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 14, 2, 6, 10, 14, 0, 2, 6, 9, 0, 2],
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 14, 2, 6, 10, 14, 0, 2, 6, 10, 0, 2],
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 14, 2, 6, 10, 14, 0, 2, 6, 10, 0, 2, 1],
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 14, 2, 6, 10, 14, 0, 2, 6, 10, 0, 2, 2],
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 14, 2, 6, 10, 14, 0, 2, 6, 10, 0, 2, 3],
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 14, 2, 6, 10, 14, 0, 2, 6, 10, 0, 2, 4],
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 14, 2, 6, 10, 14, 0, 2, 6, 10, 0, 2, 5],
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 14, 2, 6, 10, 14, 0, 2, 6, 10, 0, 2, 6],
];

class Orbital {
  /// This orbital's name
  final String name;

  /// The number of electrons occupying this orbital
  final int numberElectrons;

  static final Map<String, Orbital> _cache = {};

  Orbital._internal(this.name, this.numberElectrons);

  factory Orbital(String name, int numberElectrons) {
    String identifier = "$name^$numberElectrons";
    if (_cache.containsKey(identifier)) {
      return _cache[identifier];
    } else {
      Orbital orbital = new Orbital._internal(name, numberElectrons);
      _cache[identifier] = orbital;
      return orbital;
    }
  }

  @override
  String toString() {
    return "$name^$numberElectrons";
  }
}

class AbbreviatedElectronConfiguration {
  /// The symbol of the noble gas representing the core electron configuration
  final ElementSymbol core;

  /// The list of orbitals representing the configuration of valence electrons
  final List<Orbital> valence;

  const AbbreviatedElectronConfiguration(this.core, this.valence);

  @override
  String toString() {
    return "[$core]$valence";
  }
}

/// A species of atoms having the same number of protons in their atomic nuclei
///
/// Construct using [new ChemicalElement] with an [ElementSymbol].
/// Provides information about the name, symbol, atomic number and relative
/// atomic mass about the element.
class ChemicalElement {
  final ElementSymbol symbol;
  static final Map<ElementSymbol, ChemicalElement> _cache = {};

  ChemicalElement._internal(this.symbol);

  factory ChemicalElement(ElementSymbol symbol) {
    if (_cache.containsKey(symbol)) {
      return _cache[symbol];
    } else {
      final ChemicalElement element = new ChemicalElement._internal(symbol);
      _cache[symbol] = element;
      return element;
    }
  }

  String get name => _names[symbol.index];

  int get atomicNumber => symbol.index + 1;

  num get relativeAtomicMass => _relativeAtomicMasses[symbol.index];

  List<Orbital> get electronConfiguration {
    List<Orbital> orbitals = [];
    _electronConfigurations[symbol.index]
        .asMap()
        .forEach((int i, int numberElectrons) {
      if (numberElectrons != 0) {
        orbitals.add(new Orbital(_orbitalNames[i], numberElectrons));
      }
    });
    return orbitals;
  }

  AbbreviatedElectronConfiguration get abbreviatedElectronConfiguration {
    return null;
  }
}
