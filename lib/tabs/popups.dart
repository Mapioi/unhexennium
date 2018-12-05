import 'dart:async';
import 'package:flutter/material.dart';
import 'package:unhexennium/chemistry/element.dart';
import 'package:unhexennium/chemistry/formula.dart';
import "package:unhexennium/tabs/formula.dart";
import "package:unhexennium/chemistry/data/formulae.dart";
import "package:unhexennium/tabs/equation.dart";
import 'package:unhexennium/tabs/periodic_table.dart';
import "package:unhexennium/utils.dart";

typedef void ElementAndSubscriptCallback(ElementSymbol x, int subscript);

/// Number of decimal places (used for RFM)
const dp = 2;

/// Number of significant figures (used for user inputs)
const sf = 5;

class ElementPrompt extends StatefulWidget {
  final ArgCallback<ElementSymbol> onClickedCallback;
  final ElementSymbol currentElementSymbol;

  ElementPrompt({
    Key key,
    this.currentElementSymbol,
    this.onClickedCallback,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ElementPrompt();
}

class _ElementPrompt extends State<ElementPrompt> {
  SearchMode currentMode = SearchMode.PeriodicTable;
  ElementSymbol selectedElement;

  @override
  Widget build(BuildContext context) {
    // TODO More DRY using Map if possible
//    Map<Symbol, dynamic> commonArguments = {
//      const Symbol('currentElementSymbol'):
//          selectedElement ?? widget.currentElementSymbol,
//      const Symbol('onClickedCallback'): (x) => setState(() {
//            selectedElement = x;
//            widget.onClickedCallback(x);
//          }),
//    };

    Widget searchWidget = <SearchMode, Widget>{
      SearchMode.PeriodicTable: new PeriodicTableSearch(
        currentElementSymbol: selectedElement ?? widget.currentElementSymbol,
        onClickedCallback: (x) => setState(() {
              selectedElement = x;
              widget.onClickedCallback(x);
            }),
      ),
      SearchMode.AtomicNumber: new AtomicNumberSearch(
        currentElementSymbol: selectedElement ?? widget.currentElementSymbol,
        onClickedCallback: (x) => setState(() {
              selectedElement = x;
              widget.onClickedCallback(x);
            }),
      ),
      SearchMode.Name: new NameSearch(
        currentElementSymbol: selectedElement ?? widget.currentElementSymbol,
        onClickedCallback: (x) => setState(() {
              selectedElement = x;
              widget.onClickedCallback(x);
            }),
      ),
    }[currentMode];

    return new Column(
      children: <Widget>[
        new BottomAppBar(
          elevation: 4.0,
          child: Row(
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
        ),
        new Expanded(child: searchWidget),
      ],
    );
  }
}

enum SearchMode { PeriodicTable, AtomicNumber, Name }

class PeriodicTableSearch extends StatelessWidget {
  final ArgCallback<ElementSymbol> onClickedCallback;
  final ElementSymbol currentElementSymbol;

  PeriodicTableSearch({
    Key key,
    this.currentElementSymbol,
    this.onClickedCallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Container(
      padding: new EdgeInsets.all(16.0),
      child: new PeriodicTable(
        currentElementSymbol,
        onClickedCallback,
      ),
    );
  }
}

class AtomicNumberSearch extends StatefulWidget {
  final ArgCallback<ElementSymbol> onClickedCallback;
  final ElementSymbol currentElementSymbol;

  AtomicNumberSearch({
    Key key,
    this.currentElementSymbol,
    this.onClickedCallback,
  }) : super(key: key);

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
                onClickedCallback: widget.onClickedCallback,
              ),
        )
        .toList();

    return new Column(
      children: <Widget>[
        new Center(
          child: new Padding(
            padding: const EdgeInsets.only(left: 32.0, right: 32.0),
            child: new TextField(
              keyboardType: TextInputType.numberWithOptions(
                signed: false,
                decimal: true,
              ),
              onChanged: (String s) => setState(() {
                    typedNumber = int.parse(s);
                  }),
              decoration: new InputDecoration(
                icon: new Icon(Icons.search),
                hintText: widget.currentElementSymbol != null
                    ? ChemicalElement(widget.currentElementSymbol)
                        .atomicNumber
                        .toString()
                    : "29",
              ),
            ),
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
  final ArgCallback<ElementSymbol> onClickedCallback;
  final ElementSymbol currentElementSymbol;

  NameSearch({
    Key key,
    this.currentElementSymbol,
    this.onClickedCallback,
  }) : super(key: key);

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
                onClickedCallback: widget.onClickedCallback,
              ),
        )
        .toList();

    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Column(
        children: <Widget>[
          new Center(
            child: new Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 8.0),
              child: new TextField(
                autocorrect: false,
                onChanged: (String s) => setState(() => typedText = s),
                decoration: new InputDecoration(
                  icon: const Icon(Icons.search),
                  hintText: widget.currentElementSymbol != null
                      ? ChemicalElement(widget.currentElementSymbol).name
                      : "Francium",
                ),
              ),
            ),
          ),
          new Expanded(
            child: ListView(children: searchResults),
          ),
        ],
      ),
    );
  }
}

class SearchRow extends StatelessWidget {
  final ArgCallback<ElementSymbol> onClickedCallback;
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
    this.onClickedCallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onTap: () {
        onClickedCallback(elementToDisplay.symbol);
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
                  : new RichText(
                      text: TextSpan(
                        style: DefaultTextStyle.of(context).style,
                        children: [
                          new TextSpan(
                            text: elementToDisplay.atomicNumber
                                .toString()
                                .substring(
                                  0,
                                  searchedNumber.toString().length,
                                ),
                            style: new TextStyle(fontWeight: FontWeight.bold),
                          ),
                          new TextSpan(
                            text: elementToDisplay.atomicNumber
                                .toString()
                                .substring(
                                  searchedNumber.toString().length,
                                ),
                          )
                        ],
                      ),
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
                : new RichText(
                    text: new TextSpan(
                      style: DefaultTextStyle.of(context).style,
                      children: [
                        new TextSpan(
                          text: elementToDisplay.name.substring(
                            0,
                            elementToDisplay.name
                                .toLowerCase()
                                .indexOf(searchedName.toLowerCase()),
                          ),
                        ),
                        new TextSpan(
                          text: elementToDisplay.name
                                      .toLowerCase()
                                      .indexOf(searchedName.toLowerCase()) ==
                                  0
                              ? searchedName
                              : searchedName.toLowerCase(),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        new TextSpan(
                          text: elementToDisplay.name.substring(
                            elementToDisplay.name
                                    .toLowerCase()
                                    .indexOf(searchedName.toLowerCase()) +
                                searchedName.length,
                          ),
                        ),
                      ],
                    ),
                  ),
            new Expanded(child: Container())
          ],
        ),
      ),
    );
  }
}

Future<Null> parenSubscriptPrompt({
  BuildContext context,
  ArgCallback<int> callback,
  int currentSubscript,
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
          ),
        ),
  );
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

    return new Scaffold(
      appBar: new AppBar(
        title: new Text(
          "Element ${widget.isAdding ? "insertion" : "modification"}",
        ),
      ),
      body: new Column(
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
          new Expanded(
            child: new ElementPrompt(
              currentElementSymbol: widget.currentElementSymbol,
              onClickedCallback: (x) =>
                  setState(() => selectedElementSymbol = x),
            ),
          ),
        ],
      ),
    );
  }
}

class ParenSubscriptSelector extends StatefulWidget {
  final int currentSubscript;
  final ArgCallback<int> onFinish;

  ParenSubscriptSelector({Key key, this.currentSubscript, this.onFinish})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => new _ParenSubscriptSelector();
}

class _ParenSubscriptSelector extends State<ParenSubscriptSelector> {
  int selectedSubscript;

  @override
  Widget build(BuildContext context) {
    selectedSubscript ??= widget.currentSubscript;
    return new Row(children: <Widget>[
      new Text(
        "Set subscript",
        style: new TextStyle(fontWeight: FontWeight.bold),
      ),
      new Expanded(child: SizedBox(height: 0.0)),
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
          "SUBMIT",
          style: new TextStyle(color: Colors.white),
        ),
        onPressed: () => widget.onFinish(selectedSubscript),
        color: Colors.blueAccent,
      )
    ]);
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

class MassMoleCalculator extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _MassMoleCalculatorState();
}

class _MassMoleCalculatorState extends State<MassMoleCalculator> {
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
                    keyboardType: TextInputType.numberWithOptions(
                      signed: false,
                      decimal: true,
                    ),
                    textAlign: TextAlign.center,
                    controller: massController,
                    onChanged: (String s) {
                      s = unFrench(s);
                      num mass = num.parse(s);
                      FormulaState.mass = mass;
                      moleController.text =
                          FormulaState.mole.toStringAsPrecision(sf);
                    },
                    autofocus: true,
                  ),
                  new TextField(
                    decoration: new InputDecoration(
                      helperText: "Mole / mol",
                    ),
                    keyboardType: TextInputType.numberWithOptions(
                      signed: false,
                      decimal: true,
                    ),
                    textAlign: TextAlign.center,
                    controller: moleController,
                    onChanged: (String s) {
                      s = unFrench(s);
                      num mole = num.parse(s);
                      FormulaState.mole = mole;
                      massController.text =
                          FormulaState.mass.toStringAsPrecision(sf);
                    },
                  ),
                ],
              ),
            ),
            new RaisedButton.icon(
              icon: new Icon(Icons.exposure_zero),
              onPressed: clear,
              label: Text("Clear"),
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
                    keyboardType: TextInputType.numberWithOptions(
                      signed: false,
                      decimal: true,
                    ),
                    textAlign: TextAlign.center,
                    enabled: FormulaState.properties.idealGasComputed !=
                        IdealGasComputed.P,
                    onChanged: (String s) {
                      s = unFrench(s);
                      FormulaState.properties.P = num.parse(s);
                      updateValue();
                    },
                  ),
                  new TextField(
                    decoration: new InputDecoration(
                      helperText: asSuperscript("Volume / m3"),
                    ),
                    controller: controllers[IdealGasComputed.V],
                    focusNode: focusNodes[IdealGasComputed.V],
                    keyboardType: TextInputType.numberWithOptions(
                      signed: false,
                      decimal: true,
                    ),
                    textAlign: TextAlign.center,
                    enabled: FormulaState.properties.idealGasComputed !=
                        IdealGasComputed.V,
                    onChanged: (String s) {
                      s = unFrench(s);
                      FormulaState.properties.V = num.parse(s);
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
                    keyboardType: TextInputType.numberWithOptions(
                      signed: false,
                      decimal: true,
                    ),
                    textAlign: TextAlign.center,
                    enabled: FormulaState.properties.idealGasComputed !=
                        IdealGasComputed.n,
                    onChanged: (String s) {
                      s = unFrench(s);
                      FormulaState.mole = num.parse(s);
                      updateValue();
                    },
                  ),
                  new TextField(
                    decoration: new InputDecoration(
                      helperText: asSuperscript("Temperature / K"),
                    ),
                    controller: controllers[IdealGasComputed.T],
                    focusNode: focusNodes[IdealGasComputed.T],
                    keyboardType: TextInputType.numberWithOptions(
                      signed: false,
                      decimal: true,
                    ),
                    textAlign: TextAlign.center,
                    enabled: FormulaState.properties.idealGasComputed !=
                        IdealGasComputed.T,
                    onChanged: (String s) {
                      s = unFrench(s);
                      FormulaState.properties.T = num.parse(s);
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
                        ? Icon(
                            Icons.invert_colors_off,
                            color: Colors.red,
                          )
                        : null,
                  ),
                  textAlign: TextAlign.center,
                  controller: massControllers[i],
                  onChanged: (String s) =>
                      onMassUpdateAt(i, num.parse(unFrench(s))),
                  keyboardType: TextInputType.numberWithOptions(
                    signed: false,
                    decimal: true,
                  ),
                  enabled: formulae[i].rfm != 0,
                ),
                new TextField(
                  decoration: new InputDecoration(
                    helperText: "n(${factories[i]}) / mol",
                    suffixIcon: i == lrIndex
                        ? Icon(
                            Icons.invert_colors_off,
                            color: Colors.red,
                          )
                        : null,
                  ),
                  textAlign: TextAlign.center,
                  controller: moleControllers[i],
                  onChanged: (String s) =>
                      onMoleUpdateAt(i, num.parse(unFrench(s))),
                  keyboardType: TextInputType.numberWithOptions(
                    signed: false,
                    decimal: true,
                  ),
                ),
              ]);
              return content;
            }).expand((x) => x).toList() +
            <Widget>[
              Divider(),
              Divider(),
              new RaisedButton.icon(
                icon: Icon(Icons.save),
                onPressed: () {
                  for (int i = 0; i < formulae.length; i++) {
                    EquationState.properties[i]
                      ..mass = massControllers[i].text == ''
                          ? null
                          : double.parse(massControllers[i].text)
                      ..mole = moleControllers[i].text == ''
                          ? null
                          : double.parse(moleControllers[i].text);
                  }
                },
                label: Text("Apply changes"),
              ),
              new RaisedButton.icon(
                icon: Icon(Icons.exposure_zero),
                onPressed: clearText,
                label: Text("Clear"),
              ),
            ],
      ),
    );
  }
}

enum FormulaEditMode { SetCharge, NameSearch, FormulaInput }

class FormulaEditor extends StatefulWidget {
  final Callback onFinish;

  const FormulaEditor({Key key, this.onFinish}) : super(key: key);

  @override
  State<StatefulWidget> createState() => new _FormulaEditPromptState();
}

class _FormulaEditPromptState extends State<FormulaEditor> {
  FormulaEditMode currentMode = FormulaEditMode.FormulaInput;

  @override
  Widget build(BuildContext context) {
    Widget buttonBar = new BottomAppBar(
      elevation: 4.0,
      child: new ButtonBar(
        alignment: MainAxisAlignment.center,
        children: FormulaEditMode.values
            .map((var mode) => new FlatButton(
                  onPressed: mode == currentMode
                      ? null
                      : () => setState(() {
                            currentMode = mode;
                          }),
                  child: new Text(enumToReadableString(mode)),
                  padding: const EdgeInsets.all(0.0),
                ))
            .toList(),
      ),
    );
    ChargeEditor chargeEditor = new ChargeEditor(
      currentCharge: FormulaState.formulaFactory.charge,
      onFinish: (c) {
        FormulaState.formulaFactory.charge = c;
        widget.onFinish();
      },
    );
    FormulaNameSearch nameSearch = new FormulaNameSearch(
      currentFormulaName: FormulaState.formulaFactory.names?.join(", ") ?? "",
      onClickedCallback: (String formula) {
        FormulaFactory f = new FormulaFactory.fromString(formula);
        // If FormulaState.formulaFactory is updated directly,
        // its reference in the equation will be lost.
        FormulaState.formulaFactory
          ..elementsList = f.elementsList
          ..charge = f.charge;
        FormulaState.formula = f.build();
        widget.onFinish();
      },
    );
    FormulaInput formulaInput = new FormulaInput(
      currentFormula: FormulaState.formulaFactory.elementsList.isNotEmpty
          ? FormulaState.formulaFactory.toString()
          : "",
      onFinish: (String formula) {
        FormulaFactory f = new FormulaFactory.fromString(formula);
        // If FormulaState.formulaFactory is updated directly,
        // its reference in the equation will be lost.
        FormulaState.formulaFactory
          ..elementsList = f.elementsList
          ..charge = f.charge;
        FormulaState.formula = f.build();
        FormulaState.mole = null;
        widget.onFinish();
      },
    );
    Widget currentEditor = new Expanded(
      child: {
        FormulaEditMode.SetCharge: chargeEditor,
        FormulaEditMode.NameSearch: nameSearch,
        FormulaEditMode.FormulaInput: formulaInput
      }[currentMode],
    );
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Edit formula"),
      ),
      body: new Column(
        children: <Widget>[
          buttonBar,
          currentEditor,
        ],
      ),
    );
  }
}

class ChargeEditor extends StatefulWidget {
  final int currentCharge;
  final ArgCallback<int> onFinish;

  const ChargeEditor({Key key, this.currentCharge, this.onFinish})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => new _ChargeEditorState(currentCharge);
}

class _ChargeEditorState extends State<ChargeEditor> {
  int charge;

  _ChargeEditorState(this.charge);

  @override
  Widget build(BuildContext context) {
    String sign = charge < 0 ? '-' : charge == 0 ? '' : '+';
    String chargeDisplay = charge.abs().toString() + sign;
    return new Center(
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Chip(
            label: new Text("Charge: $chargeDisplay"),
            avatar: new Icon(
              charge != 0 ? Icons.flash_on : Icons.flash_off,
              color: charge == 0
                  ? Colors.grey
                  : charge < 0 ? Colors.amber[600] : Colors.yellow[600],
            ),
          ),
          new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new IconButton(
                icon: const Icon(Icons.remove_circle),
                onPressed: FormulaState.formulaFactory.elementsList.isEmpty &&
                        charge != 0
                    ? null
                    : () => setState(() => charge--),
              ),
              new IconButton(
                icon: const Icon(Icons.add_circle_outline),
                onPressed: FormulaState.formulaFactory.elementsList.isEmpty &&
                        charge != -1
                    ? null
                    : () => setState(() => charge++),
              ),
            ],
          ),
          new RaisedButton(
            onPressed: () => widget.onFinish(charge),
            child: new Text("Apply changes"),
            color: charge == FormulaState.formulaFactory.charge
                ? Colors.blue[300]
                : Colors.blue,
            textColor: Colors.white,
          ),
        ],
      ),
    );
  }
}

class FormulaNameSearchResult extends StatelessWidget {
  final String formulaName;
  final String formula;
  final String query;
  final ArgCallback<String> onClickedCallback;

  const FormulaNameSearchResult(
      {Key key,
      this.formulaName,
      this.formula,
      this.query,
      this.onClickedCallback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    int startIndex = formulaName.toLowerCase().indexOf(query.toLowerCase());
    int endIndex = startIndex + query.length;
    return new GestureDetector(
      onTap: () => onClickedCallback(formula),
      child: new SizedBox(
        height: 40.0,
        child: new Row(
          children: <Widget>[
            new SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: new ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  new RichText(
                    text: new TextSpan(
                      style: DefaultTextStyle.of(context).style,
                      children: [
                        new TextSpan(
                          text: formulaName.substring(0, startIndex),
                        ),
                        new TextSpan(
                          text: formulaName.substring(startIndex, endIndex),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        new TextSpan(
                          text: formulaName.substring(endIndex),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            new Expanded(child: new SizedBox()),
            new SizedBox(
              width: 150.0,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: new ListView(
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    new Chip(
                      label: new Text(
                        formula,
                      ),
                      backgroundColor: FormulaState.formulaFactory.names
                                  ?.contains(formulaName) ??
                              false
                          ? Colors.greenAccent[100]
                          : null,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FormulaNameSearch extends StatefulWidget {
  final String currentFormulaName;
  final ArgCallback<String> onClickedCallback;

  const FormulaNameSearch(
      {Key key, this.currentFormulaName, this.onClickedCallback})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => new _FormulaNameSearchState();
}

class _FormulaNameSearchState extends State<FormulaNameSearch> {
  String query = "";

  @override
  Widget build(BuildContext context) {
    Map<String, String> queryResults = FormulaLookup.searchByName(query);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Column(
        children: <Widget>[
          // Search bar
          new Padding(
            padding: const EdgeInsets.only(bottom: 32.0),
            child: new TextField(
              autocorrect: false,
              decoration: new InputDecoration(
                hintText: widget.currentFormulaName,
                icon: const Icon(Icons.search),
              ),
              onChanged: (String s) => setState(() => query = s),
            ),
          ),

          // Results
          new Expanded(
            child: new ListView(
              children: queryResults.entries
                  .map(
                    (var entry) => new FormulaNameSearchResult(
                          onClickedCallback: widget.onClickedCallback,
                          formulaName: entry.key,
                          formula: entry.value,
                          query: query,
                        ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class FormulaInput extends StatefulWidget {
  final String currentFormula;
  final ArgCallback<String> onFinish;

  const FormulaInput({Key key, this.currentFormula, this.onFinish})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => new _FormulaInputState(currentFormula);
}

class FormulaSearchResult extends StatelessWidget {
  final String formula;
  final String queryFormula;
  final List<String> formulaNames;
  final ArgCallback<String> onTap;

  const FormulaSearchResult(
      {Key key, this.formula, this.formulaNames, this.onTap, this.queryFormula})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    int startIndex = formula.indexOf(queryFormula);
    int endIndex = startIndex + queryFormula.length;
    return new GestureDetector(
      onTap: () => onTap(formula),
      child: new SizedBox(
        height: 40.0,
        child: new Row(
          children: <Widget>[
            new SizedBox(
              width: MediaQuery.of(context).size.width * 0.4,
              child: new ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  new RichText(
                    text: new TextSpan(
                      style: DefaultTextStyle.of(context).style,
                      children: [
                        new TextSpan(
                          text: formula.substring(0, startIndex),
                        ),
                        new TextSpan(
                          text: formula.substring(startIndex, endIndex),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        new TextSpan(
                          text: formula.substring(endIndex),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            new SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: new ListView(
                  scrollDirection: Axis.horizontal,
                  children: formulaNames
                      .map((String name) => new Chip(label: new Text(name)))
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FormulaInputState extends State<FormulaInput> {
  String currentFormula;
  TextEditingController controller;
  String errorText;

  _FormulaInputState(this.currentFormula) {
    controller = new TextEditingController(text: currentFormula);
  }

  void onFormulaChanged(String s) {
    setState(() {
      TextSelection oldSelection = controller.selection;
      currentFormula = asSubscript(s
          .replaceAll("+", asSuperscript("+"))
          .replaceAll("-", asSuperscript("-")));
      try {
        var f = FormulaFactory.fromString(currentFormula);
        errorText = null;
        if (f.elementsList.isNotEmpty && f.charge != -1) {
          currentFormula = f.toString();
          int cursorPos = controller.selection.start - 1;
          if (cursorPos < s.length &&
              s[cursorPos] == '1' &&
              (cursorPos >= currentFormula.length ||
                  currentFormula[cursorPos] != asSubscript('1'))) {
            currentFormula = currentFormula.substring(0, cursorPos) +
                asSubscript('1') +
                currentFormula.substring(cursorPos);
          }
        }
      } on UnknownElementSymbolError catch (e) {
        errorText = e.toString();
      } on UnpairedParenthesisError catch (e) {
        errorText = e.toString();
      } on FormatException catch (e) {
        errorText = e.toString();
      } catch (e) {
        print(e);
      }
      // Without this if, when you delete the '2' from 'C12',
      // the '12' vanishes instead of the intended '2' only.
      if (currentFormula.length < s.length) {
        oldSelection = TextSelection.collapsed(
          offset: oldSelection.baseOffset + (currentFormula.length - s.length),
        );
      }

      controller = TextEditingController.fromValue(
        TextEditingValue(
          text: currentFormula,
          selection: oldSelection,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    Map<String, List<String>> matchedFormulae =
        FormulaLookup.searchByFormula(currentFormula);
    return new Column(
      children: <Widget>[
        new Padding(
          padding: const EdgeInsets.all(32.0),
          child: new TextField(
            autocorrect: false,
            controller: controller,
            autofocus: true,
            decoration: new InputDecoration(
              icon: const Icon(Icons.edit),
              errorText: errorText,
              helperText: "Enter the chemical formula (without the charge)",
            ),
            onChanged: onFormulaChanged,
          ),
        ),
        new Expanded(
            child: new Padding(
          padding: const EdgeInsets.all(8.0),
          child: new ListView(
            children: matchedFormulae.entries
                .map(
                  (var entry) => new FormulaSearchResult(
                        formula: entry.key,
                        formulaNames: entry.value,
                        queryFormula: currentFormula,
                        onTap: (String formula) => setState(() {
                              currentFormula = formula;
                              controller.text = formula;
                            }),
                      ),
                )
                .toList(),
          ),
        )),
        new BottomAppBar(
          child: new ButtonBar(
            alignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              new RaisedButton(
                onPressed: () => setState(() {
                      currentFormula = "";
                      controller.text = "";
                    }),
                color: Colors.blue,
                textColor: Colors.white,
                child: new Text("Clear"),
              ),
              new RaisedButton(
                onPressed: errorText != null
                    ? null
                    : () => widget.onFinish(currentFormula),
                color: FormulaState.formulaFactory.length != 0 &&
                        currentFormula == FormulaState.formulaFactory.toString()
                    ? Colors.blue[300]
                    : Colors.blue,
                textColor: Colors.white,
                child: new Text("Apply changes"),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
