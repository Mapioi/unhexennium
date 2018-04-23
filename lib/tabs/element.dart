import 'package:flutter/material.dart';
import 'package:unhexennium/chemistry/element.dart';
import 'package:unhexennium/tabs/popups.dart';
import 'package:unhexennium/tabs/table.dart';
import 'package:unhexennium/utils.dart';

// Options for the popup input dialog
enum ElementInputOptions { enter, cancel }

class ElementState {
  static SetStateCallback setState;
  static ElementSymbol _selectedElement = ElementSymbol.Xe;
  static int _oxidationState = 0;
  static List<bool> expansionPanelStates = [false, false];

  // only because Xe
  static List<bool> ionExpansionPanelStates = [];

  static void collapseExpansionPanels() {
    expansionPanelStates = [false, false];
    ionExpansionPanelStates =
        new List.filled(ionExpansionPanelStates.length, false);
  }

  static ElementSymbol get selectedElement => _selectedElement;

  static set selectedElement(ElementSymbol element) {
    ChemicalElement e = new ChemicalElement(element);
    setState(() {
      ElementState.ionExpansionPanelStates =
          List.filled(e.ionsElectronConfigurations.length, false);
      _selectedElement = element;
    });
    collapseExpansionPanels();
  }

  static int get oxidationState => _oxidationState;

  static set oxidationState(int oxidationState) {
    setState(() {
      _oxidationState = oxidationState;
    });
    collapseExpansionPanels();
  }

  static void toggleExpansionPanel(int index) => setState(
      () => expansionPanelStates[index] = !expansionPanelStates[index]);

  static void toggleIonExpansionPanel(int index) => setState(
      () => ionExpansionPanelStates[index] = !ionExpansionPanelStates[index]);
}

typedef bool GetExpansionState();

class ElementParent extends StatelessWidget {
  /// Renders the top square
  Widget renderElementCell(BuildContext context) {
    ChemicalElement element = new ChemicalElement(ElementState.selectedElement);
    return Center(
      child: new GestureDetector(
        onTap: () => elementSymbolPrompt(
              context: context,
              currentElementSymbol: ElementState.selectedElement,
            ),
        child: new Container(
          height: 128.0,
          width: 128.0,
          alignment: Alignment.center,
          decoration: new BoxDecoration(
            border: new Border.all(
              color: Colors.grey[400],
            ),
          ),
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
                  element.relativeAtomicMass.toStringAsFixed(2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Renders table + ExpansionPanel
  Widget renderStaticData() {
    ChemicalElement element = new ChemicalElement(ElementState.selectedElement);
    Map<Widget, Widget> data = {};

    // Render text data in the table
    data[new Text("Name", style: StaticTable.head)] = new Text(element.name);
    if (element.electronegativity != null) {
      data[new Text(
        "Electronegativity",
        style: StaticTable.head,
      )] = new Text(element.electronegativity.toString());
    }
    return StaticTable(data);
  }

  /// Template for expansion panels to display electron config
  ExpansionPanel electronConfigExpansionPanel(
    List<Sublevel> sublevels,
    int index,
    int oxidationState,
    ElementSymbol symbol,
  ) {
    return new ExpansionPanel(
      isExpanded: oxidationState != 0
          ? ElementState.ionExpansionPanelStates[index]
          : ElementState.expansionPanelStates[index],
      headerBuilder: (BuildContext context, bool isOpen) {
        return new Padding(
          padding: new EdgeInsets.all(16.0),
          child: ListView(
            children: <Widget>[
              new Text(
                oxidationState == 0
                    ? "Electron configuration:"
                    : enumToString(symbol) +
                        asSuperscript(
                            toStringAsCharge(oxidationState, omitOne: true)),
                style: new TextStyle(fontWeight: FontWeight.bold),
              ),
              new SizedBox(width: 10.0),
              new Text(
                new AbbreviatedElectronConfiguration.of(sublevels).toString(),
              ),
            ],
            scrollDirection: Axis.horizontal,
          ),
        );
      },
      body: new Container(
        padding: new EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
        height: 70.0,
        child: new ListView(
          children: <Widget>[
            new Row(
              children:
                  sublevels.map((Sublevel s) => new SublevelBox(s)).toList(),
            ),
          ],
          scrollDirection: Axis.horizontal,
        ),
      ),
    );
  }

  /// Build the whole elements page
  @override
  Widget build(BuildContext context) {
    List<ExpansionPanel> expansionPanels = [];
    ChemicalElement element = new ChemicalElement(ElementState.selectedElement);

    // Electronic configuration
    expansionPanels.add(electronConfigExpansionPanel(
      element.electronConfiguration,
      0,
      0,
      ElementState.selectedElement,
    ));

    // Ions
    Map<int, List<Sublevel>> ionsElectronConfig =
        element.ionsElectronConfigurations;
    if (ionsElectronConfig.length != 0) {
      List<ExpansionPanel> ionExpansionPanels = [];
      int i = 0;
      for (MapEntry<int, List<Sublevel>> entry in ionsElectronConfig.entries) {
        ionExpansionPanels.add(
          electronConfigExpansionPanel(
            entry.value,
            i++,
            entry.key,
            ElementState.selectedElement,
          ),
        );
      }

      expansionPanels.add(
        new ExpansionPanel(
          isExpanded: ElementState.expansionPanelStates[1],
          headerBuilder: (BuildContext context, bool isOpen) {
            return new Padding(
              padding: new EdgeInsets.all(16.0),
              child: new Text(
                "Ions",
                style: new TextStyle(fontWeight: FontWeight.bold),
              ),
            );
          },
          body: new Padding(
            padding: new EdgeInsets.all(16.0),
            child: new ExpansionPanelList(
              expansionCallback: (int index, bool currentState) {
                ElementState.toggleIonExpansionPanel(index);
              },
              children: ionExpansionPanels,
            ),
          ),
        ),
      );
    }

    return new Padding(
      padding: new EdgeInsets.all(16.0),
      child: new ListView(
        children: <Widget>[
          renderElementCell(context),
          renderStaticData(),
          new ExpansionPanelList(
            expansionCallback: (int index, bool newState) {
              ElementState.toggleExpansionPanel(index);
            },
            children: expansionPanels,
          )
        ],
      ),
    );
  }
}

class OrbitalBox extends StatelessWidget {
  final int numberOfElectrons;

  OrbitalBox(this.numberOfElectrons);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: new BoxDecoration(border: Border.all(color: Colors.grey)),
      width: 25.0,
      height: 25.0,
      child: new Center(
        child: new Text(
          numberOfElectrons == 2 ? "⥮" : numberOfElectrons == 1 ? "↿" : "",
          style: new TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class SublevelBox extends StatelessWidget {
  final Sublevel sublevel;

  SublevelBox(this.sublevel);

  List<int> calculateOrbitals() {
    int numberOrbitals = sublevel.size ~/ 2;
    int numberElectrons = 0;
    List<int> orbitals = new List.filled(numberOrbitals, 0);
    for (int t = 0; t < 2; t++) {
      // Satisfies Hund's rule of maximum multiplicity
      for (int i = 0; i < numberOrbitals; i++) {
        if (numberElectrons == sublevel.numberElectrons) {
          break;
        }
        orbitals[i]++;
        numberElectrons++;
      }
    }
    return orbitals;
  }

  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: const EdgeInsets.all(4.0),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new Row(
            children:
                calculateOrbitals().map((int n) => new OrbitalBox(n)).toList(),
          ),
          new Text(sublevel.toString()),
        ],
      ),
    );
  }
}
