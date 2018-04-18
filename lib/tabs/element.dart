import 'package:flutter/material.dart';
import 'package:unhexennium/utils.dart';
import 'package:unhexennium/tabs/table.dart';
import 'package:unhexennium/tabs/popups.dart';
import 'package:unhexennium/chemistry/element.dart';

// Options for the popup input dialog
enum ElementInputOptions { enter, cancel }

class ElementState {
  static SetStateCallback setState;
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

  Widget renderElementCell(BuildContext context) {
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
      child: new GestureDetector(
        onTap: () => elementSymbolPrompt(context),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: new Column(
            children: <Widget>[
              new Text(element.atomicNumber.toString()),
              new Expanded(
                child: new Center(
                  child: Text(
                    enumToString(element.symbol),
                    style: new TextStyle(
                      fontSize: 56.0,
                      fontFamily: 'Rock Salt',
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ),
              new Text(
                element.relativeAtomicMass.toString(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget renderStaticData() {
    ChemicalElement element = new ChemicalElement(ElementState.selectedElement);
    Map<Widget, Widget> data = {};
    data[new Text("Name", style: StaticTable.head)] = new Text(element.name);
    if (element.electronegativity != null)
      data[new Text("Electronegativity", style: StaticTable.head)] =
          new Text(element.electronegativity.toString());
    data[new Text("Electron configuration", style: StaticTable.head)] =
        new Text(new AbbreviatedElectronConfiguration.of(
                element.electronConfiguration)
            .toString());

    if (element.ionsElectronConfigurations.length != 0)
      data[new Text("Ions", style: StaticTable.head)] = new Column(
        children: element.ionsElectronConfigurations.entries
            .map((MapEntry<int, List<Orbital>> ion) => new Text(
                  toStringAsCharge(ion.key) +
                      ": " +
                      new AbbreviatedElectronConfiguration.of(ion.value)
                          .toString(),
                  style: ion.key == ElementState.oxidationState
                      ? new TextStyle(fontWeight: FontWeight.w500)
                      : null,
                ))
            .toList(),
        crossAxisAlignment: CrossAxisAlignment.start,
      );

    return new Expanded(
      child: new ListView(
        children: [StaticTable(data)],
        scrollDirection: Axis.vertical,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: new EdgeInsets.all(16.0),
      child: new Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          renderElementCell(context),
          renderStaticData(),
        ],
      ),
    );
  }
}
