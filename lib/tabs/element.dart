import 'dart:async';
import 'package:flutter/material.dart';
import 'package:unhexennium/utils.dart';
import 'package:unhexennium/tabs/table.dart';
import 'package:unhexennium/chemistry/element.dart';

// Options for the popup input dialog
enum ElementInputOptions { enter, cancel }

typedef void _Callback();
typedef void Callback(_Callback callback);

class ElementState {
  static Callback setState;
  static ElementSymbol _selectedElement = ElementSymbol.Xe;
  static int _oxidationState = 0;

  static ElementSymbol get selectedElement => _selectedElement;

  static set selectedElement(ElementSymbol element) {
    setState(() {
      _selectedElement = element;
    });
  }

  static int get oxidationState => _oxidationState;

  static set oxidationState(int oxidationState) {
    setState(() {
      _oxidationState = oxidationState;
    });
  }
}

class ElementParent extends StatelessWidget {
  // no element selected => null

  Widget renderElementCell() {
    ChemicalElement element = new ChemicalElement(ElementState.selectedElement);
    return new Container(
      height: 128.0,
      width: 128.0,
      alignment: Alignment.center,
      decoration: new BoxDecoration(
        border: new Border.all(
          color: Colors.grey[400],
        ),
      ),
      child: new Column(
        children: <Widget>[
          // TODO align left (OR NOT?)
          new Text(
            element.atomicNumber.toString(),
          ),
          new Text(
            enumToString(element.symbol),
            style: new TextStyle(
              fontSize: 56.0,
              fontFamily: 'Rock Salt',
              color: Colors.grey[600],
            ),
          ),
          new Text(
            element.relativeAtomicMass.toString(),
          ),
        ],
      ),
    );
  }

  Widget renderStaticData() {
    ChemicalElement element = new ChemicalElement(ElementState.selectedElement);
    List<List<String>> data = [
      ["Name", element.name]
    ];
    return new StaticTable(data);
  }

  Widget renderSelectionButton(BuildContext context) {
    return new RaisedButton(
      child: new Text(
        "Change to Mn",
        style: new TextStyle(color: Colors.white),
      ),
      onPressed: () => _elementPrompt(context),
      color: Colors.blueAccent,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: new EdgeInsets.all(16.0),
      child: new Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          renderElementCell(),
          renderStaticData(),
          renderSelectionButton(context),
        ],
      ),
    );
  }

  Future<Null> _elementPrompt(BuildContext context) async {
    ElementState.selectedElement = ElementSymbol.Mn;
    /*await showModalBottomSheet<ElementSymbol>(
        context: context,
        builder: (context) => new Container(
            height: 300.0,
            child: new ListView(
              scrollDirection: Axis.horizontal,
              children: <Widget>[],
            )));*/
  }
}
