/// Chemical elements: building blocks of chemistry

import 'package:unhexennium/utils.dart';

/// Identifiers for elements
///
/// The IUPAC names Uut, Uuq, Uup, Uuh, Uus, Uuo are used instead of
/// Nh, Fl, Mc, Ts, Og so that this app is compliant with table 6 of
/// the IB chemistry data booklet.
enum ElementSymbol {
  // Period 1
  H,
  He,

  // Period 2
  Li,
  Be,
  B,
  C,
  N,
  O,
  F,
  Ne,

  // Period 3
  Na,
  Mg,
  Al,
  Si,
  P,
  S,
  Cl,
  Ar,

  // Period 4
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

  // Period 5
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

  // Period 6
  Cs,
  Ba,
  // Lathinides
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
  //
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

  // Period 7
  Fr,
  Ra,
  // Actinides
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
  //
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
  // Period 1
  1.01,
  4.00,

  // Period 2
  6.94,
  9.01,
  10.81,
  12.01,
  14.01,
  16.00,
  19.00,
  20.18,

  // Period 3
  22.99,
  24.31,
  26.98,
  28.09,
  30.97,
  32.07,
  35.45,
  39.95,

  // Period 4
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

  // Period 5
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

  // Period 6
  132.91,
  137.33,
  // Lathinides
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
  //
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

  // Period 7
  223,
  226,
  // Actinides
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
  //
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

/// A measure of the tendency of an atom to attract a bonding pair of electrons
///
/// Table 8 - First ionization energy, electron affinity and electronegativity
/// of the elements
const Map<ElementSymbol, num> _electronegativities = const {
  // Period 1
  ElementSymbol.H: 2.2,

  // Period 2
  ElementSymbol.Li: 1.0,
  ElementSymbol.Be: 1.6,
  ElementSymbol.B: 2.0,
  ElementSymbol.C: 2.6,
  ElementSymbol.N: 3.0,
  ElementSymbol.O: 3.4,
  ElementSymbol.F: 4.0,

  // Period 3
  ElementSymbol.Na: 0.9,
  ElementSymbol.Mg: 1.3,
  ElementSymbol.Al: 1.6,
  ElementSymbol.Si: 1.9,
  ElementSymbol.P: 2.2,
  ElementSymbol.S: 2.6,
  ElementSymbol.Cl: 3.2,

  // Period 4
  ElementSymbol.K: 0.8,
  ElementSymbol.Ca: 1.0,
  ElementSymbol.Sc: 1.4,
  ElementSymbol.Ti: 1.5,
  ElementSymbol.V: 1.6,
  ElementSymbol.Cr: 1.7,
  ElementSymbol.Mn: 1.6,
  ElementSymbol.Fe: 1.8,
  ElementSymbol.Co: 1.9,
  ElementSymbol.Ni: 1.9,
  ElementSymbol.Cu: 1.9,
  ElementSymbol.Zn: 1.6,
  ElementSymbol.Ga: 1.8,
  ElementSymbol.Ge: 2.0,
  ElementSymbol.As: 2.2,
  ElementSymbol.Se: 2.6,
  ElementSymbol.Br: 3.0,

  // Period 5
  ElementSymbol.Rb: 0.8,
  ElementSymbol.Sr: 1.0,
  ElementSymbol.Y: 1.2,
  ElementSymbol.Zr: 1.3,
  ElementSymbol.Nb: 1.6,
  ElementSymbol.Mo: 2.2,
  ElementSymbol.Tc: 2.1,
  ElementSymbol.Ru: 2.2,
  ElementSymbol.Rh: 2.3,
  ElementSymbol.Pd: 2.2,
  ElementSymbol.Ag: 1.9,
  ElementSymbol.Cd: 1.7,
  ElementSymbol.In: 1.8,
  ElementSymbol.Sn: 2.0,
  ElementSymbol.Sb: 2.0,
  ElementSymbol.Te: 2.1,
  ElementSymbol.I: 2.7,
  ElementSymbol.Xe: 2.6,

  // Period 6
  ElementSymbol.Cs: 0.8,
  ElementSymbol.Ba: 0.9,
  ElementSymbol.La: 1.1,
  ElementSymbol.Hf: 1.3,
  ElementSymbol.Ta: 1.5,
  ElementSymbol.W: 1.7,
  ElementSymbol.Re: 1.9,
  ElementSymbol.Os: 2.2,
  ElementSymbol.Ir: 2.2,
  ElementSymbol.Pt: 2.2,
  ElementSymbol.Au: 2.4,
  ElementSymbol.Hg: 1.9,
  ElementSymbol.Tl: 1.8,
  ElementSymbol.Pb: 1.8,
  ElementSymbol.Bi: 1.9,
  ElementSymbol.Po: 2.0,
  ElementSymbol.At: 2.2,

  // Period 7
  ElementSymbol.Fr: 0.7,
  ElementSymbol.Ra: 0.9,
  ElementSymbol.Ac: 1.1,
};

/// Names of the elements
const List<String> _names = const [
  // Period 1
  "Hydrogen",
  "Helium",

  // Period 2
  "Lithium",
  "Beryllium",
  "Boron",
  "Carbon",
  "Nitrogen",
  "Oxygen",
  "Fluorine",
  "Neon",

  // Period 3
  "Sodium",
  "Magnesium",
  "Aluminium",
  "Silicon",
  "Phosphorus",
  "Sulfur",
  "Chlorine",
  "Argon",

  // Period 4
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

  // Period 5
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

  // Period 6
  "Cesium",
  "Barium",
  // Lathinides
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
  //
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

  // Period 7
  "Francium",
  "Radium",
  // Actinides
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
  //
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
  // Period 1
  [1],
  [2],

  // Period 2
  [2, 1],
  [2, 2],
  [2, 2, 1],
  [2, 2, 2],
  [2, 2, 3],
  [2, 2, 4],
  [2, 2, 5],
  [2, 2, 6],

  // Period 3
  [2, 2, 6, 1],
  [2, 2, 6, 2],
  [2, 2, 6, 2, 1],
  [2, 2, 6, 2, 2],
  [2, 2, 6, 2, 3],
  [2, 2, 6, 2, 4],
  [2, 2, 6, 2, 5],
  [2, 2, 6, 2, 6],

  // Period 4
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

  // Period 5
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

  // Period 6
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 0, 2, 6, 0, 0, 0, 1],
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 0, 2, 6, 0, 0, 0, 2],
  // Lathinides
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
  //
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

  // Period 7
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 14, 2, 6, 10, 0, 0, 2, 6, 0, 0, 1],
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 14, 2, 6, 10, 0, 0, 2, 6, 0, 0, 2],
  // Actinides
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
  //
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

const Map<int, ElementSymbol> _nobleGasesNumberOrbitals = const {
  1: ElementSymbol.He,
  3: ElementSymbol.Ne,
  5: ElementSymbol.Ar,
  8: ElementSymbol.Kr,
  11: ElementSymbol.Xe,
  15: ElementSymbol.Rn,
  19: ElementSymbol.Uuo,
};

/// Monatomic ions of each element
const Map<ElementSymbol, List<int>> _monatomicIons = const {
  // Group 1
  ElementSymbol.H: [-1, 1],
  ElementSymbol.Li: [1],
  ElementSymbol.Na: [1],
  ElementSymbol.K: [1],
  ElementSymbol.Rb: [1],
  ElementSymbol.Cs: [1],

  // Group 2
  ElementSymbol.Be: [2],
  ElementSymbol.Mg: [2],
  ElementSymbol.Ca: [2],
  ElementSymbol.Sr: [2],
  ElementSymbol.Ba: [2],

  // Table 14 Common oxidation states of the 3d ions
  ElementSymbol.Sc: [3],
  ElementSymbol.Ti: [2, 3, 4],
  ElementSymbol.V: [2, 3, 4, 5],
  ElementSymbol.Cr: [2, 3, 6],
  ElementSymbol.Mn: [2, 3, 4, 6, 7],
  ElementSymbol.Fe: [2, 3],
  ElementSymbol.Co: [2, 3],
  ElementSymbol.Ni: [2],
  ElementSymbol.Cu: [1, 2],
  ElementSymbol.Zn: [2],

  ElementSymbol.Ag: [1],
  ElementSymbol.Pb: [2],
  ElementSymbol.Cd: [2],
  ElementSymbol.Hg: [1, 2],

  // Group 15
  ElementSymbol.N: [-3],
  ElementSymbol.P: [-3],

  // Group 16
  ElementSymbol.O: [-2],
  ElementSymbol.S: [-2],

  // Group 17
  ElementSymbol.F: [-1],
  ElementSymbol.Cl: [-1],
  ElementSymbol.Br: [-1],
  ElementSymbol.I: [-1],
};

class Orbital {
  /// This orbital's name
  final String name;

  /// The number of electrons occupying this orbital
  final int numberElectrons;

  static final Map<String, Orbital> _cache = {};

  Orbital._internal(this.name, this.numberElectrons);

  factory Orbital(String name, int numberElectrons) {
    assert(_orbitalNames.contains(name));
    String identifier = "$name^$numberElectrons";
    if (_cache.containsKey(identifier)) {
      return _cache[identifier];
    } else {
      Orbital orbital = new Orbital._internal(name, numberElectrons);
      _cache[identifier] = orbital;
      return orbital;
    }
  }

  bool get isEmpty => numberElectrons == 0;

  bool get isFull =>
      numberElectrons == {"s": 2, "p": 6, "d": 10, "f": 14, "g": 18}[name[1]];

  @override
  String toString() {
    return "$name${asSuperscript(numberElectrons.toString())}";
  }
}

class AbbreviatedElectronConfiguration {
  /// The symbol of the noble gas representing the core electron configuration
  final ElementSymbol core;

  /// The list of orbitals representing the configuration of valence electrons
  final List<Orbital> valence;

  AbbreviatedElectronConfiguration(this.core, this.valence) {
    assert(core == null || _nobleGasesNumberOrbitals.containsValue(core));
  }

  factory AbbreviatedElectronConfiguration.of(List<Orbital> orbitals) {
    int i = 0;
    while (i < orbitals.length && orbitals[i].isFull) ++i;
    while (i > 0 && !_nobleGasesNumberOrbitals.containsKey(i)) --i;
    return new AbbreviatedElectronConfiguration(
      _nobleGasesNumberOrbitals[i],
      orbitals.getRange(i, orbitals.length).toList(),
    );
  }

  @override
  String toString() {
    return "${(core == null ? "" : "[${enumToString(core)}]")}${valence
      .join()}";
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

  num get electronegativity => _electronegativities[symbol];

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

  List<Orbital> _getIonElectronConfiguration(int oxidationState) {
    List<Orbital> orbitals = electronConfiguration;
    if (oxidationState < 0) {
      // Anion
      Orbital valenceOrbital = orbitals.removeLast();
      orbitals.add(new Orbital(
        valenceOrbital.name,
        // The oxidation state for anions are negative.
        valenceOrbital.numberElectrons + oxidationState.abs(),
      ));
      // Anions' valence orbital must be full.
      assert(orbitals.last.isFull);
    } else {
      // Cation
      while (oxidationState > 0) {
        Orbital valenceOrbital = orbitals.removeLast();
        if (oxidationState < valenceOrbital.numberElectrons) {
          orbitals.add(new Orbital(
            valenceOrbital.name,
            valenceOrbital.numberElectrons - oxidationState,
          ));
          break;
        }
        oxidationState -= valenceOrbital.numberElectrons;
      }
    }
    return orbitals;
  }

  Map<int, List<Orbital>> get ionsElectronConfigurations {
    if (_monatomicIons[symbol] == null) return {};
    return new Map.fromIterable(
      _monatomicIons[symbol],
      key: (oxidationState) => oxidationState,
      value: (oxidationState) => _getIonElectronConfiguration(oxidationState),
    );
  }
}
