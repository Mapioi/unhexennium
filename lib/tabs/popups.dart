import 'dart:async';
import 'package:flutter/material.dart';
import 'package:unhexennium/chemistry/element.dart';
import 'package:unhexennium/chemistry/formula.dart';
import "package:unhexennium/tabs/element.dart" show ElementState;
import "package:unhexennium/tabs/formula.dart";
import "package:unhexennium/tabs/equation.dart" show EquationState;
import 'package:unhexennium/tabs/periodic_table.dart';
import "package:unhexennium/utils.dart";

typedef void ElementCallback(ElementSymbol x);
typedef void SubscriptCallback(int subscript);
typedef void ElementAndSubscriptCallback(ElementSymbol x, int subscript);

/// Number of decimal places (used for RFM)
const dp = 2;

/// Number of significant figures (used for user inputs)
const sf = 5;

class ElementPrompt extends StatefulWidget {
  final BuildContext parentContext;
  final ElementSymbol currentElementSymbol;

  ElementPrompt({Key key, this.parentContext, this.currentElementSymbol})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _ElementPrompt();
}

class _ElementPrompt extends State<ElementPrompt> {
  SearchMode currentMode = SearchMode.PeriodicTable;

  @override
  Widget build(BuildContext context) {
    Widget searchWidget = <SearchMode, Widget>{
      SearchMode.PeriodicTable: new PeriodicTableSearch(
        currentElementSymbol: widget.currentElementSymbol,
      ),
      SearchMode.AtomicNumber: new AtomicNumberSearch(
        currentElementSymbol: widget.currentElementSymbol,
      ),
      SearchMode.Name: new NameSearch(
        currentElementSymbol: widget.currentElementSymbol,
      ),
    }[currentMode];

    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Element selection"),
      ),
      body: new Column(
        children: <Widget>[
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: SearchMode.values
                .map(
                  (SearchMode mode) => new FlatButton(
                        onPressed: mode == currentMode
                            ? null
                            : () => setState(() {
                                  currentMode = mode;
                                }),
                        child: new Text(enumToReadableString(mode)),
                      ),
                )
                .toList(),
          ),
          new Expanded(child: searchWidget),
        ],
      ),
    );
  }
}

Future<Null> elementFormulaPrompt({
  BuildContext context,
  ElementAndSubscriptCallback callback,
  ElementSymbol currentElementSymbol,
  int currentSubscript,
  bool isAdding = true,
}) async {
  await showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return new ElementAndSubscriptSelector(
        currentElementSymbol: currentElementSymbol,
        currentSubscript: currentSubscript,
        onFinish: (a, b) {
          callback(a, b);
          Navigator.pop(context); // exit the modal
        },
        isAdding: isAdding,
      );
    },
  );
}

Future<Null> parenSubscriptPrompt({
  BuildContext context,
  SubscriptCallback callback,
  int currentSubscript,
  bool isCharge = false,
}) async {
  await showModalBottomSheet(
    context: context,
    builder: (context) => new Padding(
          padding: new EdgeInsets.all(16.0),
          child: new ParenSubscriptSelector(
            currentSubscript: currentSubscript,
            onFinish: (a) {
              callback(a);
              Navigator.pop(context);
            },
            isCharge: isCharge,
          ),
        ),
  );
}

enum SearchMode { PeriodicTable, AtomicNumber, Name }

class PeriodicTableSearch extends StatelessWidget {
  final currentElementSymbol;

  PeriodicTableSearch({Key key, this.currentElementSymbol}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Container(
      padding: new EdgeInsets.all(16.0),
      child: new PeriodicTable(
        currentElementSymbol,
        (x) {
          ElementState.selectedElement = x;
          Navigator.pop(context); // exit the modal
        },
      ),
    );
  }
}

class AtomicNumberSearch extends StatefulWidget {
  final currentElementSymbol;

  AtomicNumberSearch({Key key, this.currentElementSymbol}) : super(key: key);

  @override
  State<StatefulWidget> createState() => new _AtomicNumberSearch();
}

class _AtomicNumberSearch extends State<AtomicNumberSearch> {
  int typedNumber;

  @override
  Widget build(BuildContext context) {
    List<SearchRow> searchResults = findElementByAtomicNumber(typedNumber)
        .map(
          (ChemicalElement e) => new SearchRow(
                elementToDisplay: e,
                searchedNumber: typedNumber,
                selected: e.symbol == widget.currentElementSymbol,
              ),
        )
        .toList();

    return new Column(
      children: <Widget>[
        new Center(
          child: new FractionallySizedBox(
            child: new Row(
              children: <Widget>[
                new Text("Number to search for:"),
                new SizedBox(width: 10.0),
                new SizedBox(
                  width: 80.0,
                  child: new TextField(
                    keyboardType: TextInputType.number,
                    onChanged: (String s) => setState(() {
                          typedNumber = int.parse(s);
                        }),
                  ),
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            ),
            widthFactor: 0.6,
          ),
        ),
        new Expanded(
          child: new Padding(
            padding: new EdgeInsets.all(8.0),
            child: new ListView(children: searchResults),
          ),
        )
      ],
    );
  }
}

class NameSearch extends StatefulWidget {
  final ElementSymbol currentElementSymbol;

  NameSearch({Key key, this.currentElementSymbol}) : super(key: key);

  @override
  State<StatefulWidget> createState() => new _NameSearch();
}

class _NameSearch extends State<NameSearch> {
  String typedText;

  @override
  Widget build(BuildContext context) {
    List<SearchRow> searchResults = findElementByName(typedText)
        .map(
          (ChemicalElement e) => new SearchRow(
                elementToDisplay: e,
                searchedName: typedText,
                selected: e.symbol == widget.currentElementSymbol,
              ),
        )
        .toList();

    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Column(
        children: <Widget>[
          new Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 8.0),
            child: new Row(
              children: <Widget>[
                new Icon(Icons.search),
                new SizedBox(width: 20.0),
                new Expanded(
                  child: new TextField(
                    onChanged: (String s) => setState(() => typedText = s),
                  ),
                )
              ],
            ),
          ),
          new Expanded(
            child: ListView(children: searchResults),
          )
        ],
      ),
    );
  }
}

class SearchRow extends StatelessWidget {
  final ChemicalElement elementToDisplay;
  final int searchedNumber;
  final String searchedName;
  final bool selected;

  SearchRow({
    Key key,
    this.elementToDisplay,
    this.searchedNumber,
    this.searchedName,
    this.selected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onTap: () {
        ElementState.selectedElement = elementToDisplay.symbol;
        Navigator.pop(context);
      },
      child: new Container(
        padding: const EdgeInsets.all(8.0),
        color: Color(0xFAFAFA),
        child: new Row(
          children: <Widget>[
            // Atomic number
            new Container(
              width: 50.0,
              padding: new EdgeInsets.all(8.0),
              child: searchedNumber == null
                  ? new Text(elementToDisplay.atomicNumber.toString())
                  : new Row(
                      children: <Widget>[
                        new Text(
                          searchedNumber.toString(),
                          style: new TextStyle(fontWeight: FontWeight.bold),
                        ),
                        new Text(
                          elementToDisplay.atomicNumber.toString().substring(
                                searchedNumber.toString().length,
                              ),
                        )
                      ],
                    ),
            ),
            // Element Symbol
            new Container(
              decoration: new BoxDecoration(
                border: new Border.all(
                  color: selected ? Colors.green : Colors.grey,
                ),
              ),
              height: 40.0,
              width: 40.0,
              child: new Center(
                child: new Text(
                  enumToString(elementToDisplay.symbol),
                  style: new TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                    fontSize: 16.0,
                  ),
                ),
              ),
            ),
            new SizedBox(width: 10.0),
            searchedName == null
                ? new Text(elementToDisplay.name)
                : new Row(
                    children: <Widget>[
                      new Text(
                        searchedName,
                        style: new TextStyle(fontWeight: FontWeight.bold),
                      ),
                      new Text(
                          elementToDisplay.name.substring(searchedName.length))
                    ],
                  ),
            new Expanded(child: Container())
          ],
        ),
      ),
    );
  }
}

Future<Null> massMolePrompt(BuildContext context) async {
  await showDialog(
    context: context,
    builder: (context) {
      return new Dialog(
        child: new MassMoleCalculator(),
      );
    },
  );
}

class MassMoleCalculator extends StatelessWidget {
  final TextEditingController massController = new TextEditingController(
      text: FormulaState.mass == null
          ? ""
          : FormulaState.mass.toStringAsPrecision(sf));
  final TextEditingController moleController = new TextEditingController(
      text: FormulaState.mole == null
          ? ""
          : FormulaState.mole.toStringAsPrecision(sf));

  void clear() {
    massController.clear();
    moleController.clear();
    FormulaState.mass = null;
    FormulaState.mole = null;
  }

  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: const EdgeInsets.all(16.0),
      child: new Container(
        height: 150.0,
        child: new Column(
          children: <Widget>[
            new Text("RFM: " + FormulaState.formula.rfm.toStringAsFixed(dp)),
            new Expanded(
              child: new GridView.count(
                crossAxisCount: 2,
                children: <Widget>[
                  new TextField(
                    decoration: new InputDecoration(
                      helperText: "Mass / g",
                    ),
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    controller: massController,
                    onChanged: (String s) {
                      s = unFrench(s);
                      num mass = num.parse(s, (v) => null);
                      FormulaState.mass = mass;
                      moleController.text =
                          FormulaState.mole.toStringAsPrecision(sf);
                    },
                  ),
                  new TextField(
                    decoration: new InputDecoration(
                      helperText: "Mole / mol",
                    ),
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    controller: moleController,
                    onChanged: (String s) {
                      s = unFrench(s);
                      num mole = num.parse(s, (v) => null);
                      FormulaState.mole = mole;
                      massController.text =
                          FormulaState.mass.toStringAsPrecision(sf);
                    },
                  ),
                ],
              ),
            ),
            new IconButton(
              icon: new Icon(Icons.clear),
              onPressed: clear,
              tooltip: "Clear",
            ),
          ],
        ),
      ),
    );
  }
}

Future<Null> idealGasPrompt(BuildContext context) async {
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        child: IdealGasCalculator(),
      );
    },
  );
}

class IdealGasCalculator extends StatefulWidget {
  @override
  State<IdealGasCalculator> createState() => new _IdealGasCalculatorState();
}

class _IdealGasCalculatorState extends State<IdealGasCalculator> {
  _IdealGasCalculatorState() {
    if (FormulaState.properties.mole != null &&
        FormulaState.properties.idealGasComputed == IdealGasComputed.n) {
      FormulaState.properties.idealGasComputed = IdealGasComputed.V;
    }
    updateValue();
  }

  Map<IdealGasComputed, TextEditingController> controllers = {
    IdealGasComputed.P: new TextEditingController(
        text: FormulaState.properties.P != null
            ? FormulaState.properties.P.toStringAsPrecision(sf)
            : ""),
    IdealGasComputed.V: new TextEditingController(
        text: FormulaState.properties.V != null
            ? FormulaState.properties.V.toStringAsPrecision(sf)
            : ""),
    IdealGasComputed.n: new TextEditingController(
        text: FormulaState.properties.mole != null
            ? FormulaState.properties.mole.toStringAsPrecision(sf)
            : ""),
    IdealGasComputed.T: new TextEditingController(
        text: FormulaState.properties.T != null
            ? FormulaState.properties.T.toStringAsPrecision(sf)
            : ""),
  };
  Map<IdealGasComputed, FocusNode> focusNodes = {
    IdealGasComputed.P: new FocusNode(),
    IdealGasComputed.V: new FocusNode(),
    IdealGasComputed.n: new FocusNode(),
    IdealGasComputed.T: new FocusNode(),
  };

  void updateValue() {
    num result;
    try {
      switch (FormulaState.properties.idealGasComputed) {
        case IdealGasComputed.P:
          result = FormulaState.properties.P = FormulaState.formula.P(
            V: FormulaState.properties.V,
            n: FormulaState.properties.mole,
            T: FormulaState.properties.T,
          );
          break;
        case IdealGasComputed.V:
          result = FormulaState.properties.V = FormulaState.formula.V(
            P: FormulaState.properties.P,
            n: FormulaState.properties.mole,
            T: FormulaState.properties.T,
          );
          break;
        case IdealGasComputed.n:
          result = FormulaState.mole = FormulaState.formula.n(
            P: FormulaState.properties.P,
            V: FormulaState.properties.V,
            T: FormulaState.properties.T,
          );
          break;
        case IdealGasComputed.T:
          result = FormulaState.properties.T = FormulaState.formula.T(
            p: FormulaState.properties.P,
            V: FormulaState.properties.V,
            n: FormulaState.properties.mole,
          );
          break;
      }
      assert(result.isFinite && !result.isNegative);
      controllers[FormulaState.properties.idealGasComputed].text =
          result.toStringAsPrecision(sf);
    } catch (e) {
      /*print(e);*/
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: const EdgeInsets.all(16.0),
      child: new Container(
        height: 400.0,
        child: new Column(
          children: <Widget>[
            new Text("PV = nRT (R = 8.31 ${asSuperscript('J mol-1')})"),
            new Expanded(
              child: new GridView.count(
                crossAxisCount: 2,
                children: <Widget>[
                  new TextField(
                    decoration: new InputDecoration(
                      helperText: "Pressure / Pa",
                    ),
                    controller: controllers[IdealGasComputed.P],
                    focusNode: focusNodes[IdealGasComputed.P],
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    enabled: FormulaState.properties.idealGasComputed !=
                        IdealGasComputed.P,
                    onChanged: (String s) {
                      s = unFrench(s);
                      FormulaState.properties.P = num.parse(s, (v) => null);
                      updateValue();
                    },
                  ),
                  new TextField(
                    decoration: new InputDecoration(
                      helperText: asSuperscript("Volume / m3"),
                    ),
                    controller: controllers[IdealGasComputed.V],
                    focusNode: focusNodes[IdealGasComputed.V],
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    enabled: FormulaState.properties.idealGasComputed !=
                        IdealGasComputed.V,
                    onChanged: (String s) {
                      s = unFrench(s);
                      FormulaState.properties.V = num.parse(s, (v) => null);
                      updateValue();
                    },
                  ),
                ],
              ),
            ),
            new Expanded(
              child: new GridView.count(
                crossAxisCount: 2,
                children: <Widget>[
                  new TextField(
                    decoration: new InputDecoration(
                      helperText: "Number / mol",
                    ),
                    controller: controllers[IdealGasComputed.n],
                    focusNode: focusNodes[IdealGasComputed.n],
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    enabled: FormulaState.properties.idealGasComputed !=
                        IdealGasComputed.n,
                    onChanged: (String s) {
                      s = unFrench(s);
                      FormulaState.mole = num.parse(s, (v) => null);
                      updateValue();
                    },
                  ),
                  new TextField(
                    decoration: new InputDecoration(
                      helperText: asSuperscript("Temperature / K"),
                    ),
                    controller: controllers[IdealGasComputed.T],
                    focusNode: focusNodes[IdealGasComputed.T],
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    enabled: FormulaState.properties.idealGasComputed !=
                        IdealGasComputed.T,
                    onChanged: (String s) {
                      s = unFrench(s);
                      FormulaState.properties.T = num.parse(s, (v) => null);
                      updateValue();
                    },
                  ),
                ],
              ),
            ),
            new Text("Computed value:"),
            new Expanded(
                child: new GridView.count(
              crossAxisCount: 2,
              children: <Widget>[
                new Column(
                  children: [IdealGasComputed.P, IdealGasComputed.n]
                      .map((IdealGasComputed x) {
                    return new RadioListTile(
                      value: x,
                      groupValue: FormulaState.properties.idealGasComputed,
                      onChanged: (y) => setState(() {
                            FormulaState.properties.idealGasComputed = y;
                            if (focusNodes[y].hasFocus) {
                              focusNodes[y].unfocus();
                            }
                          }),
                      title: new Text(enumToString(x)),
                      subtitle:
                          new Text(x == IdealGasComputed.P ? "Pa" : "mol"),
                      dense: true,
                    );
                  }).toList(),
                ),
                new Column(
                  children: [IdealGasComputed.V, IdealGasComputed.T]
                      .map((IdealGasComputed x) {
                    return new RadioListTile(
                      value: x,
                      groupValue: FormulaState.properties.idealGasComputed,
                      onChanged: (y) => setState(() {
                            FormulaState.properties.idealGasComputed = y;
                            if (focusNodes[y].hasFocus) {
                              focusNodes[y].unfocus();
                            }
                          }),
                      title: new Text(enumToString(x)),
                      subtitle: new Text(
                          x == IdealGasComputed.V ? asSuperscript("m3") : "K"),
                      dense: true,
                    );
                  }).toList(),
                ),
              ],
            )),
          ],
        ),
      ),
    );
  }
}

class ElementAndSubscriptSelector extends StatefulWidget {
  final int currentSubscript;
  final ElementSymbol currentElementSymbol;
  final ElementAndSubscriptCallback onFinish;
  final bool isAdding;

  ElementAndSubscriptSelector({
    Key key,
    this.currentSubscript,
    this.currentElementSymbol,
    this.onFinish,
    this.isAdding = true,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => new _ElementAndSubscriptSelector();
}

class _ElementAndSubscriptSelector extends State<ElementAndSubscriptSelector> {
  ElementSymbol selectedElementSymbol;
  int selectedSubscript;

  @override
  Widget build(BuildContext context) {
    selectedElementSymbol ??= widget.currentElementSymbol;
    selectedSubscript ??= widget.currentSubscript;

    return new Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: new Row(children: <Widget>[
            new Text(
              "Select subscript",
              style: new TextStyle(fontWeight: FontWeight.bold),
            ),
            new Expanded(child: SizedBox(height: 0.0)), // weird
            new Text(selectedSubscript.toString()),
            new Expanded(child: SizedBox(height: 0.0)),
            new IconButton(
              onPressed: selectedSubscript == 1
                  ? null
                  : () => setState(() => --selectedSubscript),
              icon: new Icon(Icons.arrow_left),
            ),
            new IconButton(
              onPressed: () => setState(() => ++selectedSubscript),
              icon: new Icon(Icons.arrow_right),
            ),
            new Expanded(child: SizedBox(height: 0.0)),
            new RaisedButton(
              child: new Text(
                widget.isAdding ? "INSERT" : "MODIFY",
                style: new TextStyle(color: Colors.white),
              ),
              onPressed: () => selectedElementSymbol == null
                  ? null
                  : widget.onFinish(
                      selectedElementSymbol,
                      selectedSubscript,
                    ),
              color: Colors.blueAccent,
            )
          ]),
        ),
        Expanded(
          child: new PeriodicTable(
            selectedElementSymbol,
            (element) => setState(() {
                  selectedElementSymbol = element;
                }),
          ),
        ),
      ],
    );
  }
}

class ParenSubscriptSelector extends StatefulWidget {
  final int currentSubscript;
  final SubscriptCallback onFinish;
  final bool isCharge;

  ParenSubscriptSelector(
      {Key key, this.currentSubscript, this.onFinish, this.isCharge})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => new _ParenSubscriptSelector();
}

class _ParenSubscriptSelector extends State<ParenSubscriptSelector> {
  int selectedSubscript;

  @override
  Widget build(BuildContext context) {
    selectedSubscript ??= widget.currentSubscript;

    String numberText = selectedSubscript.toString();
    if (widget.isCharge && selectedSubscript > 0) {
      numberText = "+$selectedSubscript";
    }

    String leftText = "Set ${widget.isCharge ? "charge" : "subscript"}";

    return new Row(children: <Widget>[
      new Text(
        leftText,
        style: new TextStyle(fontWeight: FontWeight.bold),
      ),
      new Expanded(child: SizedBox(height: 0.0)),
      new Text(numberText),
      new Expanded(child: SizedBox(height: 0.0)),
      new IconButton(
        onPressed: (widget.isCharge
                ? (FormulaState.formulaFactory.elementsList.isEmpty &&
                    selectedSubscript != 0)
                : selectedSubscript == 1)
            ? null
            : () => setState(() => --selectedSubscript),
        icon: new Icon(Icons.arrow_left),
      ),
      new IconButton(
        onPressed: widget.isCharge &&
                (FormulaState.formulaFactory.elementsList.isNotEmpty ||
                    selectedSubscript == -1)
            ? () => setState(() => ++selectedSubscript)
            : null,
        icon: new Icon(Icons.arrow_right),
      ),
      new Expanded(child: SizedBox(height: 0.0)),
      new RaisedButton(
        child: new Text(
          "GO!",
          style: new TextStyle(color: Colors.white),
        ),
        onPressed: () => widget.onFinish(selectedSubscript),
        color: Colors.blueAccent,
      )
    ]);
  }
}

Future<Null> equationMassesMolesPrompt(BuildContext context) async {
  await showDialog(
      context: context,
      builder: (BuildContext context) {
        return new Dialog(
          child: new EquationMassesMolesCalculator(),
        );
      });
}

class EquationMassesMolesCalculator extends StatefulWidget {
  @override
  State<EquationMassesMolesCalculator> createState() =>
      new _EquationMassesMolesCalculatorState();
}

class _EquationMassesMolesCalculatorState
    extends State<EquationMassesMolesCalculator> {
  final List<Formula> formulae =
      EquationState.equation.reactants + EquationState.equation.products;
  final List<FormulaFactory> factories =
      EquationState.reactants + EquationState.products;
  List<TextEditingController> massControllers;
  List<TextEditingController> moleControllers;

  bool updateProperties = false;
  int lrIndex;

  _EquationMassesMolesCalculatorState() {
    massControllers = new List.generate(
      formulae.length,
      (int i) => new TextEditingController(
          text:
              EquationState.properties[i].mass?.toStringAsPrecision(sf) ?? ""),
    );
    moleControllers = new List.generate(
      formulae.length,
      (int i) => new TextEditingController(
          text:
              EquationState.properties[i].mole?.toStringAsPrecision(sf) ?? ""),
    );

    // Determining the limiting reactant
    num leastMoles = double.infinity;
    for (int i = 0; i < formulae.length; i++) {
      num mole = EquationState.properties[i].mole;
      if (mole != null && mole < leastMoles) {
        lrIndex = i;
        leastMoles = mole;
      }
    }
  }

  clearText() {
    massControllers.forEach((var controller) => controller.clear());
    moleControllers.forEach((var controller) => controller.clear());
  }

  onMassUpdateAt(int index, num mass) {
    if (lrIndex != null) {
      setState(() {
        lrIndex = null;
      });
    }

    num extent = EquationState.equation.extentFromMassAt(index, mass);
    List<num> masses = EquationState.equation.massesFromExtent(extent);
    List<num> moles = EquationState.equation.molesFromExtent(extent);

    for (int i = 0; i < formulae.length; i++) {
      if (i != index) {
        massControllers[i].text = masses[i].toStringAsPrecision(sf);
      }
      moleControllers[i].text = moles[i].toStringAsPrecision(sf);
      if (updateProperties) {
        EquationState.properties[i]
          ..mass = masses[i]
          ..mole = moles[i];
      }
    }
  }

  onMoleUpdateAt(int index, num mole) {
    if (lrIndex != null) {
      setState(() {
        lrIndex = null;
      });
    }

    num extent = EquationState.equation.extentFromMoleAt(index, mole);
    List<num> masses = EquationState.equation.massesFromExtent(extent);
    List<num> moles = EquationState.equation.molesFromExtent(extent);
    setState(() {
      for (int i = 0; i < formulae.length; i++) {
        massControllers[i].text = masses[i].toStringAsPrecision(sf);
        if (i != index) {
          moleControllers[i].text = moles[i].toStringAsPrecision(sf);
        }
        if (updateProperties) {
          EquationState.properties[i]
            ..mass = masses[i]
            ..mole = moles[i];
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      width: 0.8 * MediaQuery.of(context).size.width,
      height: 0.5 * MediaQuery.of(context).size.height,
      child: new GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 2.7,
        children: new List.generate(formulae.length, (int i) {
              List<Widget> content = [];
              if (i == EquationState.reactants.length) {
                content.addAll([
                  new Divider(),
                  new Divider(),
                ]);
              }
              content.addAll([
                new TextField(
                  decoration: new InputDecoration(
                    helperText: "m(${factories[i]}) / g",
                    suffixIcon: i == lrIndex
                        ? new Icon(
                            Icons.invert_colors_off,
                            color: Colors.red,
                          )
                        : null,
                  ),
                  textAlign: TextAlign.center,
                  controller: massControllers[i],
                  onChanged: (String s) =>
                      onMassUpdateAt(i, num.parse(unFrench(s))),
                  keyboardType: TextInputType.number,
                  enabled: formulae[i].rfm != 0,
                ),
                new TextField(
                  decoration: new InputDecoration(
                    helperText: "n(${factories[i]}) / mol",
                  ),
                  textAlign: TextAlign.center,
                  controller: moleControllers[i],
                  onChanged: (String s) =>
                      onMoleUpdateAt(i, num.parse(unFrench(s))),
                  keyboardType: TextInputType.number,
                ),
              ]);
              return content;
            }).expand((x) => x).toList() +
            <Widget>[
              new CheckboxListTile(
                value: updateProperties,
                onChanged: (bool val) => setState(() {
                      updateProperties = val;
                    }),
                subtitle: new Text("Update values"),
                dense: true,
              ),
              new IconButton(
                icon: new Icon(Icons.clear),
                onPressed: clearText,
                tooltip: "Clear",
              ),
            ],
      ),
    );
  }
}
