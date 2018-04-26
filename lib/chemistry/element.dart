import 'dart:collection';
import 'package:unhexennium/utils.dart';

/// Chemical elements: building blocks of chemistry

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

const List<ElementSymbol> alkaliMetals = const [
  ElementSymbol.Li,
  ElementSymbol.Na,
  ElementSymbol.K,
  ElementSymbol.Rb,
  ElementSymbol.Cs,
  ElementSymbol.F
];

const List<ElementSymbol> alkalineEarthMetals = const [
  ElementSymbol.Be,
  ElementSymbol.Mg,
  ElementSymbol.Ca,
  ElementSymbol.Sr,
  ElementSymbol.Ba,
  ElementSymbol.Ra
];

const List<ElementSymbol> halogens = const [
  ElementSymbol.F,
  ElementSymbol.Cl,
  ElementSymbol.Br,
  ElementSymbol.I,
  ElementSymbol.At,
];

const List<ElementSymbol> nobleGases = const [
  ElementSymbol.He,
  ElementSymbol.Ne,
  ElementSymbol.Ar,
  ElementSymbol.Kr,
  ElementSymbol.Xe,
  ElementSymbol.Rn,
];

const List<ElementSymbol> metalloids = const [
  ElementSymbol.B,
  ElementSymbol.Si,
  ElementSymbol.Ge,
  ElementSymbol.As,
  ElementSymbol.Sb,
  ElementSymbol.Te,
];

const List<ElementSymbol> nonMetals = const [
  ElementSymbol.H,
  ElementSymbol.C,
  ElementSymbol.N,
  ElementSymbol.P,
  ElementSymbol.O,
  ElementSymbol.S,
  ElementSymbol.Se,
  ElementSymbol.F,
  ElementSymbol.Cl,
  ElementSymbol.Br,
  ElementSymbol.I,
  ElementSymbol.At,
  ElementSymbol.He,
  ElementSymbol.Ne,
  ElementSymbol.Ar,
  ElementSymbol.Kr,
  ElementSymbol.Xe,
  ElementSymbol.Rn,
];

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
  "6s",
  "6p",
  "6d",
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
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 0, 2, 6, 0, 0, 1],
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 0, 2, 6, 0, 0, 2],
  // Lathinides
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 0, 2, 6, 1, 0, 2],
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 1, 2, 6, 1, 0, 2],
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 3, 2, 6, 0, 0, 2],
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 4, 2, 6, 0, 0, 2],
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 5, 2, 6, 0, 0, 2],
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 6, 2, 6, 0, 0, 2],
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 7, 2, 6, 0, 0, 2],
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 7, 2, 6, 1, 0, 2],
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 9, 2, 6, 0, 0, 2],
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 10, 2, 6, 0, 0, 2],
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 11, 2, 6, 0, 0, 2],
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 12, 2, 6, 0, 0, 2],
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 13, 2, 6, 0, 0, 2],
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 14, 2, 6, 0, 0, 2],
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 14, 2, 6, 1, 0, 2],
  //
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 14, 2, 6, 2, 0, 2],
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 14, 2, 6, 3, 0, 2],
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 14, 2, 6, 4, 0, 2],
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 14, 2, 6, 5, 0, 2],
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 14, 2, 6, 6, 0, 2],
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 14, 2, 6, 7, 0, 2],
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 14, 2, 6, 9, 0, 1],
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 14, 2, 6, 10, 0, 1],
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 14, 2, 6, 10, 0, 2],
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 14, 2, 6, 10, 0, 2, 1],
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 14, 2, 6, 10, 0, 2, 2],
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 14, 2, 6, 10, 0, 2, 3],
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 14, 2, 6, 10, 0, 2, 4],
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 14, 2, 6, 10, 0, 2, 5],
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 14, 2, 6, 10, 0, 2, 6],

  // Period 7
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 14, 2, 6, 10, 0, 2, 6, 0, 1],
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 14, 2, 6, 10, 0, 2, 6, 0, 2],
  // Actinides
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 14, 2, 6, 10, 0, 2, 6, 1, 2],
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 14, 2, 6, 10, 0, 2, 6, 2, 2],
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 14, 2, 6, 10, 2, 2, 6, 1, 2],
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 14, 2, 6, 10, 3, 2, 6, 1, 2],
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 14, 2, 6, 10, 4, 2, 6, 1, 2],
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 14, 2, 6, 10, 6, 2, 6, 0, 2],
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 14, 2, 6, 10, 7, 2, 6, 0, 2],
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 14, 2, 6, 10, 7, 2, 6, 1, 2],
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 14, 2, 6, 10, 9, 2, 6, 0, 2],
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 14, 2, 6, 10, 10, 2, 6, 0, 2],
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 14, 2, 6, 10, 11, 2, 6, 0, 2],
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 14, 2, 6, 10, 12, 2, 6, 0, 2],
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 14, 2, 6, 10, 13, 2, 6, 0, 2],
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 14, 2, 6, 10, 14, 2, 6, 0, 2],
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 14, 2, 6, 10, 14, 2, 6, 0, 2, 1],
  //
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 14, 2, 6, 10, 14, 2, 6, 2, 2],
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 14, 2, 6, 10, 14, 2, 6, 3, 2],
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 14, 2, 6, 10, 14, 2, 6, 4, 2],
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 14, 2, 6, 10, 14, 2, 6, 5, 2],
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 14, 2, 6, 10, 14, 2, 6, 6, 2],
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 14, 2, 6, 10, 14, 2, 6, 7, 2],
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 14, 2, 6, 10, 14, 2, 6, 8, 2],
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 14, 2, 6, 10, 14, 2, 6, 9, 2],
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 14, 2, 6, 10, 14, 2, 6, 10, 2],
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 14, 2, 6, 10, 14, 2, 6, 10, 2, 1],
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 14, 2, 6, 10, 14, 2, 6, 10, 2, 2],
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 14, 2, 6, 10, 14, 2, 6, 10, 2, 3],
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 14, 2, 6, 10, 14, 2, 6, 10, 2, 4],
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 14, 2, 6, 10, 14, 2, 6, 10, 2, 5],
  [2, 2, 6, 2, 6, 10, 2, 6, 10, 14, 2, 6, 10, 14, 2, 6, 10, 2, 6],
];

final Map<ElementSymbol, List<Sublevel>> _nobleGasesSublevels = {
  ElementSymbol.He: [Sublevel("1s", 2)],
  ElementSymbol.Ne: [Sublevel("2s", 2), Sublevel("2p", 6)],
  ElementSymbol.Ar: [Sublevel("3s", 2), Sublevel("3p", 6)],
  ElementSymbol.Kr: [Sublevel("4s", 2), Sublevel("3d", 10), Sublevel("4p", 6)],
  ElementSymbol.Xe: [Sublevel("5s", 2), Sublevel("4d", 10), Sublevel("5p", 6)],
  ElementSymbol.Rn: [
    Sublevel("6s", 2),
    Sublevel("4f", 14),
    Sublevel("5d", 10),
    Sublevel("6p", 6)
  ],
  ElementSymbol.Uuo: [
    Sublevel("7s", 2),
    Sublevel("5f", 14),
    Sublevel("6d", 10),
    Sublevel("7p", 6)
  ],
};

/// Oxidation states of elements
const List<List<int>> _oxidationStates = const [
  [-1, 1],
  [],
  [1],
  [2],
  [3],
  [-4, -3, -2, -1, 1, 2, 3, 4],
  [-3, 3, 5],
  [-2],
  [-1],
  [],
  [1],
  [2],
  [3],
  [-4, 4],
  [-3, 3, 5],
  [-2, 2, 4, 6],
  [-1, 1, 3, 5, 7],
  [],
  [1],
  [2],
  [3],
  [4],
  [5],
  [3, 6],
  [2, 4, 7],
  [2, 3, 6],
  [2, 3],
  [2],
  [2],
  [2],
  [3],
  [-4, 2, 4],
  [-3, 3, 5],
  [-2, 2, 4, 6],
  [-1, 1, 3, 5],
  [2],
  [1],
  [2],
  [3],
  [4],
  [5],
  [4, 6],
  [4, 7],
  [3, 4],
  [3],
  [2, 4],
  [1],
  [2],
  [3],
  [-4, 2, 4],
  [-3, 3, 5],
  [-2, 2, 4, 6],
  [-1, 1, 3, 5, 7],
  [2, 4, 6],
  [1],
  [2],
  [3],
  [3, 4],
  [3],
  [3],
  [3],
  [3],
  [2, 3],
  [3],
  [3],
  [3],
  [3],
  [3],
  [3],
  [3],
  [3],
  [4],
  [5],
  [4, 6],
  [4],
  [4],
  [3, 4],
  [2, 4],
  [3],
  [1, 2],
  [1, 3],
  [2, 4],
  [3],
  [-2, 2, 4],
  [-1, 1],
  [2],
  [1],
  [2],
  [3],
  [4],
  [5],
  [6],
  [5],
  [4],
  [3],
  [3],
  [3],
  [3],
  [3],
  [3],
  [3],
  [2],
  [3],
  [4],
  [5],
  [6],
  [7],
  [8],
  [],
  [],
  [],
  [2],
  [],
  [],
  [],
  [],
  [],
  [],
];

class Sublevel {
  /// This orbital's name
  final String name;

  /// The number of electrons occupying this orbital
  final int numberElectrons;

  static final Map<String, Sublevel> _cache = {};
  static final Map<String, int> _maxSizes = {
    "s": 2,
    "p": 6,
    "d": 10,
    "f": 14,
  };

  Sublevel._internal(this.name, this.numberElectrons);

  factory Sublevel(String name, int numberElectrons) {
    assert(_orbitalNames.contains(name));
    String identifier = "$name^$numberElectrons";
    if (_cache.containsKey(identifier)) {
      return _cache[identifier];
    } else {
      Sublevel orbital = new Sublevel._internal(name, numberElectrons);
      _cache[identifier] = orbital;
      return orbital;
    }
  }

  bool get isEmpty => numberElectrons == 0;

  bool get isFull => numberElectrons == _maxSizes[name[1]];

  int get size => _maxSizes[name[1]];

  @override
  String toString() {
    return "$name${asSuperscript(numberElectrons.toString())}";
  }
}

class AbbreviatedElectronConfiguration {
  /// The symbol of the noble gas representing the core electron configuration
  final ElementSymbol core;

  /// The list of orbitals representing the configuration of valence electrons
  final List<Sublevel> valence;

  AbbreviatedElectronConfiguration(this.core, this.valence) {
    assert(core == null || _nobleGasesSublevels.containsKey(core));
  }

  factory AbbreviatedElectronConfiguration.of(List<Sublevel> orbitals) {
    // Avoid side effects
    orbitals = new List<Sublevel>.from(orbitals);
    ElementSymbol core;
    for (var entry in _nobleGasesSublevels.entries) {
      ElementSymbol nobleGas = entry.key;
      List<Sublevel> fullSublevels = entry.value;
      bool isMatched = true;
      for (Sublevel fullSublevel in fullSublevels) {
        if (!orbitals.contains(fullSublevel)) {
          isMatched = false;
          break;
        }
      }
      if (!isMatched) {
        break;
      }
      core = nobleGas;
      for (Sublevel fullSublevel in fullSublevels) {
        orbitals.remove(fullSublevel);
      }
    }
    return new AbbreviatedElectronConfiguration(
      core,
      orbitals,
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

  factory ChemicalElement.fromString(String symbolString) {
    for (ElementSymbol symbol in ElementSymbol.values) {
      if (enumToString(symbol) == symbolString) {
        return ChemicalElement(symbol);
      }
    }
    throw Exception("Unknown element symbol '$symbolString'");
  }

  String get name => _names[symbol.index];

  int get atomicNumber => symbol.index + 1;

  num get relativeAtomicMass => _relativeAtomicMasses[symbol.index];

  num get electronegativity => _electronegativities[symbol];

  @override
  String toString() => this.name;

  List<Sublevel> get electronConfiguration {
    List<Sublevel> orbitals = [];
    _electronConfigurations[symbol.index]
        .asMap()
        .forEach((int i, int numberElectrons) {
      if (numberElectrons != 0) {
        orbitals.add(new Sublevel(_orbitalNames[i], numberElectrons));
      }
    });
    return orbitals;
  }

  List<Sublevel> _getIonElectronConfiguration(int oxidationState) {
    List<Sublevel> sublevels = electronConfiguration;
    if (oxidationState < 0) {
      // Anion
      Sublevel valenceSublevel = sublevels.removeLast();
      sublevels.add(new Sublevel(
        valenceSublevel.name,
        // The oxidation state for anions are negative.
        valenceSublevel.numberElectrons + oxidationState.abs(),
      ));
      // Note: this method does not work if a new orbital is occupied.
      // This is because the order in which the orbitals are filled up
      // is not very predictable.
      // Hence, without the assertion below,
      // the electrons in the last sublevel might surpass its maximum size.
      assert(sublevels.last.numberElectrons <= sublevels.last.size);
    } else {
      // Cation
      while (oxidationState > 0) {
        Sublevel valenceSublevel = sublevels.removeLast();
        if (oxidationState < valenceSublevel.numberElectrons) {
          sublevels.add(new Sublevel(
            valenceSublevel.name,
            valenceSublevel.numberElectrons - oxidationState,
          ));
          break;
        }
        oxidationState -= valenceSublevel.numberElectrons;
      }
    }
    return sublevels;
  }

  Map<int, List<Sublevel>> get oxidisedElectronConfigurations {
    List<int> os = _oxidationStates[symbol.index] + [0];
    os.sort();
    return new Map.fromIterable(
      os,
      key: (oxidationState) => oxidationState,
      value: (oxidationState) => _getIonElectronConfiguration(oxidationState),
    );
  }
}

/// Element searching functions

List<ChemicalElement> findElementByAtomicNumber(int queryNumber) {
  if (queryNumber == null) {
    return ElementSymbol.values.map((e) => new ChemicalElement(e)).toList();
  }

  String queryNumberString = queryNumber.toString();
  queryNumber -= 1; // 0 indexing

  if (queryNumber > ElementSymbol.values.length || queryNumber < 0) {
    return [];
  } else {
    List<ChemicalElement> result = [
      new ChemicalElement(ElementSymbol.values[queryNumber])
    ];
    for (int i = queryNumber + 1; i < ElementSymbol.values.length; i++) {
      if (queryNumberString ==
          (i + 1).toString().substring(0, queryNumberString.length)) {
        result.add(new ChemicalElement(ElementSymbol.values[i]));
      }
    }
    return result;
  }
}

List<ChemicalElement> findElementByName(String queryName) {
  LinkedHashMap<int, String> sortedNamesMap = sortMapByValues(
    new Map.from(List.from(_names).asMap()),
  );

  if (queryName == null) {
    return sortedNamesMap.keys
        .map(
          (atomicNumber) =>
              new ChemicalElement(ElementSymbol.values[atomicNumber]),
        )
        .toList();
  } else {
    queryName = queryName.toLowerCase();
    List<ChemicalElement> result = [];
    for (int i = 0; i < _names.length; i++) {
      int currentAtomicNumber = sortedNamesMap.keys.toList()[i];
      String currentName = sortedNamesMap.values.toList()[i].toLowerCase();
      if (currentName == queryName) {
        result.add(
          new ChemicalElement(ElementSymbol.values[currentAtomicNumber]),
        );
      } else if (queryName.length < currentName.length &&
          queryName == currentName.substring(0, queryName.length)) {
        result.add(
          new ChemicalElement(ElementSymbol.values[currentAtomicNumber]),
        );
      }
    }
    return result;
  }
}
