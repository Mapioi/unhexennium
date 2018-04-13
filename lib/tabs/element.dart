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
    TextStyle boldStyle = new TextStyle(fontWeight: FontWeight.bold);
    return new StaticTable([
      [
        new Text(
          "Name",
          textAlign: TextAlign.center,
          style: boldStyle,
        ),
        new Text(
          element.name,
          textAlign: TextAlign.center,
        ),
      ],
      [
        new Text(
          "Electronegativity",
          textAlign: TextAlign.center,
          style: boldStyle,
        ),
        new Text(
          element.electronegativity.toStringAsFixed(1),
          textAlign: TextAlign.center,
        ),
      ],
      [
        new Text(
          "Electron configuration",
          textAlign: TextAlign.center,
          style: boldStyle,
        ),
        new Text(
          element.electronConfiguration.join(" "),
          textAlign: TextAlign.center,
        ),
      ],
      [
        new Text(
          "Abbreviated electron configuration",
          textAlign: TextAlign.center,
          style: boldStyle,
        ),
        new Text(
          element.abbreviatedElectronConfiguration.toString(),
          textAlign: TextAlign.center,
        ),
      ],
      [
        new Text(
          "Ions",
          textAlign: TextAlign.center,
          style: boldStyle,
        ),
        new Text(
          element.ionsElectronConfigurations.toString(),
          textAlign: TextAlign.center,
        ),
      ],
    ]);
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
