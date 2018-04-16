import 'dart:async';
import 'package:flutter/material.dart';
import 'package:unhexennium/chemistry/element.dart';
import 'package:unhexennium/tabs/periodic_table.dart';
import "package:unhexennium/tabs/element.dart" show ElementState;

typedef void ElementChooserCallback(ElementSymbol x, int subscript);

class ElementSelector extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _ElementSelector();
}

class _ElementSelector extends State<ElementSelector> {
  ElementSymbol selectedElementSymbol;
  int selectedSubscript = 1;

  @override
  Widget build(BuildContext context) {
    return null;
  }
}

Future<Null> askForElementSymbol(
    BuildContext context, ElementChooserCallback f) async {
  List result = await showDialog<List>(
      context: context,
      builder: (BuildContext context) {
        return new ElementSelector();
      });

  f(result[0], result[1]);
}

Future<Null> elementPrompt(BuildContext context) async {
  await showModalBottomSheet<ElementSymbol>(
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
