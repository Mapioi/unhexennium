import 'dart:async';
import 'package:flutter/material.dart';
import 'package:unhexennium/chemistry/element.dart';
import 'package:unhexennium/tabs/periodic_table.dart';
import "package:unhexennium/tabs/element.dart" show ElementState;

typedef void ElementCallback(ElementSymbol x);
typedef void ElementAndSubscriptCallback(ElementSymbol x, int subscript);

Future<Null> elementFormulaPrompt(
    BuildContext context,
    ElementAndSubscriptCallback callback,
    ElementSymbol currentElementSymbol,
    int currentSubscript) async {
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
      );
    },
  );
}

Future<Null> elementSymbolPrompt(BuildContext context) async {
  await showModalBottomSheet(
    context: context,
    builder: (context) => new Container(
          padding: new EdgeInsets.all(16.0),
          child: new PeriodicTable(
            ElementState.selectedElement,
            (x) {
              ElementState.selectedElement = x;
              Navigator.pop(context); // exit the modal
            },
          ),
        ),
  );
}

class ElementAndSubscriptSelector extends StatefulWidget {
  ElementAndSubscriptSelector({
    Key key,
    this.currentSubscript,
    this.currentElementSymbol,
    this.onFinish,
  }) : super(key: key);

  final int currentSubscript;
  final ElementSymbol currentElementSymbol;
  final ElementAndSubscriptCallback onFinish;

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
        new Row(children: <Widget>[
          new Text(selectedSubscript.toString()),
          new FlatButton(
            onPressed: selectedSubscript == 1
                ? null
                : () => setState(() => --selectedSubscript),
            child: new Icon(Icons.arrow_left),
          ),
          new FlatButton(
            onPressed: () => setState(() => ++selectedSubscript),
            child: new Icon(Icons.arrow_right),
          ),
        ]),
        new Container(
          height: 300.0,
          child: new PeriodicTable(
            selectedElementSymbol,
            (element) => widget.onFinish(element, selectedSubscript),
          ),
        )
      ],
    );
  }
}
