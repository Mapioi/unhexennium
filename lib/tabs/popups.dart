import 'dart:async';

import 'package:flutter/material.dart';
import 'package:unhexennium/chemistry/element.dart';
import "package:unhexennium/tabs/element.dart" show ElementState;
import "package:unhexennium/tabs/formula.dart" show FormulaState;
import 'package:unhexennium/tabs/periodic_table.dart';

typedef void ElementCallback(ElementSymbol x);
typedef void SubscriptCallback(int subscript);
typedef void ElementAndSubscriptCallback(ElementSymbol x, int subscript);

// TODO more DRY
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
    // TODO give user the option: () or []
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

Future<Null> elementSymbolPrompt({
  BuildContext context,
  ElementSymbol currentElementSymbol,
}) async {
  await showModalBottomSheet(
    context: context,
    builder: (context) => new Container(
          padding: new EdgeInsets.all(16.0),
          child: new PeriodicTable(
            currentElementSymbol,
            (x) {
              ElementState.selectedElement = x;
              Navigator.pop(context); // exit the modal
            },
          ),
        ),
  );
}

Future<Null> massMolePrompt(BuildContext context) async {
  await showDialog(
      context: context,
      builder: (context) {
        return new Dialog(
          child: new MassMoleCalculator(),
        );
      });
}

class MassMoleCalculator extends StatelessWidget {
  final TextEditingController massController = new TextEditingController(
      text: FormulaState.mass == null
          ? ""
          : FormulaState.mass.toStringAsPrecision(5));
  final TextEditingController moleController = new TextEditingController(
      text: FormulaState.mole == null
          ? ""
          : FormulaState.mole.toStringAsPrecision(5));

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
        height: 135.0,
        child: new Column(
          children: <Widget>[
            new Text("RFM: " + FormulaState.formula.rfm.toStringAsFixed(2)),
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
                      num mass = num.parse(s);
                      FormulaState.mass = mass;
                      moleController.text =
                          FormulaState.mole.toStringAsPrecision(5);
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
                      num mole = num.parse(s);
                      FormulaState.mole = mole;
                      massController.text =
                          FormulaState.mass.toStringAsPrecision(5);
                    },
                  ),
                ],
              ),
            ),
            new IconButton(
              icon: new Icon(Icons.clear),
              onPressed: clear,
            ),
          ],
        ),
      ),
    );
  }
}

Future<Null> idealGasPrompt(BuildContext context) async {
  await showDialog(context: null);
}

class IdeaGasCalculator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return null;
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
        onPressed: (selectedSubscript == 1 && !widget.isCharge)
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
          "GO!",
          style: new TextStyle(color: Colors.white),
        ),
        onPressed: () => widget.onFinish(selectedSubscript),
        color: Colors.blueAccent,
      )
    ]);
  }
}
