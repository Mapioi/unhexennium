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
  static List<bool> expansionPanelStates = [false];

  static List<bool> osExpansionPanelStates = new List<bool>.filled(
    new ChemicalElement(_selectedElement).oxidisedElectronConfigurations.length,
    false,
  );

  static void collapseExpansionPanels() {
    expansionPanelStates = [false];
    osExpansionPanelStates =
        new List.filled(osExpansionPanelStates.length, false);
  }

  static ElementSymbol get selectedElement => _selectedElement;

  static set selectedElement(ElementSymbol element) {
    ChemicalElement e = new ChemicalElement(element);
    setState(() {
      ElementState.osExpansionPanelStates =
          List.filled(e.oxidisedElectronConfigurations.length, false);
      _selectedElement = element;
      _oxidationState = 0;
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
      () => osExpansionPanelStates[index] = !osExpansionPanelStates[index]);
}

typedef bool GetExpansionState();

class ElementParent extends StatelessWidget {
  /// Renders the top square
  Widget renderElementCell(BuildContext context) {
    ChemicalElement element = new ChemicalElement(ElementState.selectedElement);
    return new Padding(
      padding: new EdgeInsets.only(top: 16.0),
      child: Center(
        child: new GestureDetector(
          onTap: () => Navigator.push(
                context,
                new MaterialPageRoute(
                  builder: (context) => new Scaffold(
                        appBar: new AppBar(
                          title: new Text("Select element"),
                        ),
                        body: new ElementPrompt(
                            currentElementSymbol: ElementState.selectedElement,
                            onClickedCallback: (x) {
                              ElementState.selectedElement = x;
                              Navigator.pop(context);
                            }),
                      ),
                ),
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
                          fontSize: 49.0,
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
      isExpanded: ElementState.osExpansionPanelStates[index],
      headerBuilder: (BuildContext context, bool isOpen) {
        return new Padding(
          padding: new EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              new Text(
                enumToString(symbol) +
                    asSuperscript(
                        toStringAsCharge(oxidationState, omitOne: true)),
                style: new TextStyle(
                  fontWeight: FontWeight.bold,
                  color: oxidationState == ElementState.oxidationState
                      ? Colors.black54
                      : Colors.black,
                ),
              ),
              new SizedBox(width: 10.0),
              new Text(
                new AbbreviatedElectronConfiguration.of(sublevels).toString(),
              ),
            ],
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

    // Oxidation states + electron configurations
    Map<int, List<Sublevel>> osElectronConfigs =
        element.oxidisedElectronConfigurations;
    List<ExpansionPanel> osExpansionPanels = [];
    int i = 0;
    for (MapEntry<int, List<Sublevel>> entry in osElectronConfigs.entries) {
      osExpansionPanels.add(
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
        isExpanded: ElementState.expansionPanelStates[0],
        headerBuilder: (BuildContext context, bool isOpen) {
          return new Padding(
            padding: new EdgeInsets.all(16.0),
            child: new Text(
              "Oxidation states",
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
            children: osExpansionPanels,
          ),
        ),
      ),
    );

    return new ListView(
      children: <Widget>[
        renderElementCell(context),
        renderStaticData(),
        new Container(
          padding: new EdgeInsets.all(16.0),
          child: new ExpansionPanelList(
            expansionCallback: (int index, bool newState) {
              ElementState.toggleExpansionPanel(index);
            },
            children: expansionPanels,
          ),
        ),
      ],
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
          style: new TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: "Stix2Math",
          ),
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
