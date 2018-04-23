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
  static List<bool> ionExpansionPanelStates = [];  // only because Xe

  static ElementSymbol get selectedElement => _selectedElement;

  static set selectedElement(ElementSymbol element) {
    ChemicalElement e = new ChemicalElement(element);
    setState(() {
      ElementState.ionExpansionPanelStates =
          List.filled(e.ionsElectronConfigurations.length, false);
      _selectedElement = element;
    });
  }

  static int get oxidationState => _oxidationState;

  static set oxidationState(int oxidationState) {
    setState(() {
      _oxidationState = oxidationState;
    });
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

  /// Construct a list of lists for the decoration arrow boxes
  List<List<int>> constructSubshellBoxesStructure(List<Orbital> orbitals) {
    List<List<int>> toReturn = [];
    for (Orbital orbital in orbitals) {
      int electronsLeft = orbital.numberElectrons;
      int numberOfBoxes = orbital.size ~/ 2;
      List<int> boxes;
      if (electronsLeft > numberOfBoxes) {
        boxes = List.filled(numberOfBoxes, 1);
        electronsLeft -= numberOfBoxes;
      } else {
        boxes = List.filled(numberOfBoxes, 0);
      }
      for (int i = 0; i < electronsLeft; i++) {
        boxes[i] += 1;
      }
      toReturn.add(boxes);
    }
    return toReturn;
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

    if (element.ionsElectronConfigurations.length != 0) {
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
    }

    return StaticTable(data);
  }

  /// Template for expansion panels to display electron config
  ExpansionPanel electronConfigExpansionPanel(
    List<Orbital> orbitals,
    int index,
    bool isIon,
  ) {
    List<List<int>> boxData = constructSubshellBoxesStructure(orbitals);
    return new ExpansionPanel(
      isExpanded: isIon
          ? ElementState.ionExpansionPanelStates[index]
          : ElementState.expansionPanelStates[index],
      headerBuilder: (BuildContext context, bool isOpen) {
        return new Padding(
          padding: new EdgeInsets.all(16.0),
          child: Row(
            children: <Widget>[
              new Text(
                "Electron configuration:",
                style: new TextStyle(fontWeight: FontWeight.bold),
              ),
              new SizedBox(width: 10.0),
              new Text(
                new AbbreviatedElectronConfiguration.of(orbitals).toString(),
              )
            ],
          ),
        );
      },
      body: new Container(
        padding: new EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
        height: 50.0,
        child: new ListView(
          children: <Widget>[
            new Row(
              children: boxData
                  .map(
                    (List<int> boxes) => Row(
                          children: boxes
                              .map(
                                (int boxArrowsNum) => new ElectronSublevelBox(
                                      numberOfArrows: boxArrowsNum,
                                    ),
                              )
                              .toList(),
                        ),
                  )
                  .toList(),
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
    expansionPanels.add(
        electronConfigExpansionPanel(element.electronConfiguration, 0, false));

    // Ions
    Map<int, List<Orbital>> ionsElectronConfig =
        element.ionsElectronConfigurations;
    if (ionsElectronConfig.length != 0) {
      List<ExpansionPanel> ionExpansionPanels = [];
      for (int i = 0; i < ionsElectronConfig.length; i++) {
        ionExpansionPanels.add(
          electronConfigExpansionPanel(
            ionsElectronConfig[ionsElectronConfig.keys.toList()[i]],
            i,
            true,
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
                print(index);
                print(ElementState.ionExpansionPanelStates);
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

class ElectronSublevelBox extends StatelessWidget {
  final int numberOfArrows;
  static final Map<int, String> arrowImage = {
    0: "imgs/arrows/spinempty.gif",
    1: "imgs/arrows/spinsingle.gif",
    2: "imgs/arrows/spinpair.gif"
  };

  ElectronSublevelBox({Key key, this.numberOfArrows}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: new BoxDecoration(border: Border.all(color: Colors.grey)),
      child: new Image.asset(arrowImage[numberOfArrows]),
    );
  }
}
