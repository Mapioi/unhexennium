import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:unhexennium/chemistry/element.dart';
import 'package:unhexennium/chemistry/formula.dart';
import 'package:unhexennium/maths/rational.dart';
import 'package:unhexennium/tabs/element.dart';
import 'package:unhexennium/tabs/popups.dart';
import 'package:unhexennium/tabs/table.dart';
import 'package:unhexennium/utils.dart';

/// [InputBox] renders the top for whatever the top is
///   - Can be an element Text or a Row of more elements
/// And renders the subscript on the bottom
class InputBox extends StatelessWidget {
  final Widget widgetToDisplay;
  final int subscript;
  final bool selected;
  final Callback onInputBoxTap;
  final bool isCharge;

  /// Highlight pairing parentheses / brackets.
  static const Color defaultColor = Colors.grey;
  static const Color selectedColor = Colors.blueAccent;
  static const Color chargeSelectedColor = Colors.green;

  InputBox({
    @required this.widgetToDisplay,
    this.onInputBoxTap,
    this.subscript = 1,
    this.selected = false,
    this.isCharge = false,
  });

  @override
  Widget build(BuildContext context) {
    String numberToDisplay;
    if (isCharge) {
      numberToDisplay = toStringAsCharge(subscript);
    } else {
      numberToDisplay = subscript.toString();
    }

    Color currentBorderColor = selected
        ? (isCharge ? chargeSelectedColor : selectedColor)
        : defaultColor;

    return new GestureDetector(
        onTap: onInputBoxTap,
        child: new Container(
          // Structure
          child: new Column(
            children: <Widget>[
              // Top part
              new Container(
                child: widgetToDisplay,
                decoration: new BoxDecoration(
                  border: new Border(
                    bottom: new BorderSide(color: currentBorderColor),
                  ),
                ),
              ),
              // Subscript
              new Container(
                child: new Padding(
                  child: new Text(numberToDisplay),
                  padding: new EdgeInsets.fromLTRB(0.0, 2.0, 0.0, 2.0),
                ),
              ),
            ],
          ),
          // Style
          decoration: new BoxDecoration(
            border:
                new Border.all(color: currentBorderColor = currentBorderColor),
          ),
          margin: new EdgeInsets.all(4.0),
          alignment: Alignment(0.0, 0.0),
        ));
  }
}

enum IdealGasComputed { P, V, n, T }

class FormulaState {
  static SetStateCallback setState;
  static Callback switchToElementTab;
  static FormulaFactory formulaFactory = new FormulaFactory()
    ..insertOpeningParenthesisAt(0)
    ..insertElementAt(1, elementSymbol: ElementSymbol.Fe)
    ..insertOpeningParenthesisAt(2)
    ..insertElementAt(3, elementSymbol: ElementSymbol.O)
    ..insertElementAt(4, elementSymbol: ElementSymbol.H)
    ..insertClosingParenthesisAt(5)
    ..setSubscriptAt(5, subscript: 2)
    ..insertOpeningParenthesisAt(6)
    ..insertElementAt(7, elementSymbol: ElementSymbol.H)
    ..setSubscriptAt(7, subscript: 2)
    ..insertElementAt(8, elementSymbol: ElementSymbol.O)
    ..insertClosingParenthesisAt(9)
    ..setSubscriptAt(9, subscript: 4)
    ..insertClosingParenthesisAt(10)
    ..charge = 1;
  static Formula formula = formulaFactory.build();
  static int _selectedBlockIndex = 0;

  static int get selectedBlockIndex => _selectedBlockIndex;

  static set selectedBlockIndex(int i) {
    _selectedBlockIndex = i;
    try {
      _underCursor =
          formulaFactory.elementsList[selectedBlockIndex].elementSymbol;
    } catch (e) {
      _underCursor = null;
    }
  }

  static ElementSymbol _underCursor =
      formulaFactory.elementsList[selectedBlockIndex].elementSymbol;

  static ElementSymbol get underCursor => _underCursor;

  static num _mass, _mole;

  static num get mass => _mass;

  static set mass(num m) {
    _mass = m;
    _mole = m != null ? formula.mole(m) : null;
  }

  static get mole => _mole;

  static set mole(num n) {
    _mole = n;
    _mass = n != null ? formula.mass(n) : null;
  }

  static IdealGasComputed idealGasComputed = IdealGasComputed.n;
  static num pressure, volume, temperature;

  static resetProperties() {
    _mass = _mole = pressure = volume = temperature = null;
  }

  static List<bool> expansionPanelStates = [false, false];

  static void removeAtCursor() {
    setState(() {
      var closingIndices = FormulaState.formulaFactory.getClosingIndices();
      formulaFactory.removeAt(selectedBlockIndex);
      if (closingIndices.containsKey(selectedBlockIndex)) {
        // Upon removal of the opening parenthesis,
        // which is guaranteed to be situated to the left of its closing counterpart,
        // everything is shifted to the left by 1, and hence the -1.
        formulaFactory.removeAt(closingIndices[selectedBlockIndex] - 1);
        selectedBlockIndex = closingIndices[selectedBlockIndex] - 1;
      }

      selectedBlockIndex--;
      // Select box, whose index is the opening parenthesis.
      Map<int, int> openingIndices = formulaFactory.getOpeningIndices();
      if (openingIndices.containsKey(selectedBlockIndex))
        selectedBlockIndex = openingIndices[selectedBlockIndex];

      formula = formulaFactory.build();
      resetProperties();
    });
  }

  static void onEdit(ElementSymbol element, int subscript) {
    setState(() {
      if (selectedBlockIndex == -1) {
        formulaFactory.charge = subscript;
      } else if (element != null) {
        formulaFactory.setElementAt(
          selectedBlockIndex,
          elementSymbol: element,
        );
        formulaFactory.setSubscriptAt(
          selectedBlockIndex,
          subscript: subscript,
        );
      } else {
        int closingParenIndex =
            formulaFactory.getClosingIndices()[selectedBlockIndex];
        formulaFactory.setSubscriptAt(closingParenIndex, subscript: subscript);
      }

      formula = formulaFactory.build();
      resetProperties();
    });
  }

  static void onAdd(ElementSymbol element, int subscript) {
    Map<int, int> closingParentheses = formulaFactory.getClosingIndices();

    int position;
    if (selectedBlockIndex == -1) {
      position = formulaFactory.length;
    } else if (closingParentheses.keys.contains(selectedBlockIndex)) {
      position = closingParentheses[selectedBlockIndex];
    } else {
      position = selectedBlockIndex + 1;
    }

    setState(() {
      if (element != null) {
        // Add element
        formulaFactory.insertElementAt(
          position,
          elementSymbol: element,
        );

        if (subscript != 1) {
          formulaFactory.setSubscriptAt(
            position,
            subscript: subscript,
          );
        }
      } else {
        // Add parentheses
        formulaFactory.insertOpeningParenthesisAt(position);
        formulaFactory.insertClosingParenthesisAt(position + 1);
        if (subscript != 1) {
          formulaFactory.setSubscriptAt(
            position + 1,
            subscript: subscript,
          );
        }
      }

      selectedBlockIndex = position;
      formula = formulaFactory.build();
      resetProperties();
    });
  }

  static void onBoxTap(int index) {
    setState(() {
      selectedBlockIndex = index;
    });
  }

  static void onView() {
    ElementState.selectedElement = underCursor;
    var oxidationStates = FormulaState.formula.oxidationStates;
    if (oxidationStates != null) {
      /// Oxidation state
      Rational os = oxidationStates[underCursor];
      if (os != null && os.denominator.abs() == 1)
        ElementState.oxidationState = os.numerator ~/ os.denominator;
    }
    switchToElementTab();
  }

  static void onReset() {
    setState(() {
      formulaFactory.elementsList.clear();
      formulaFactory.charge = 0;
      selectedBlockIndex = -1;

      formula = formulaFactory.build();
      resetProperties();
    });
  }

  static void toggleExpansionPanel(int index) => setState(
      () => expansionPanelStates[index] = !expansionPanelStates[index]);
}

/// Formula Parent handles the top level
class FormulaParent extends StatelessWidget {
  /// Used to build the recursive input structure
  Row recursiveInputBuilder(int startIndex, int endIndex) {
    List<Widget> renderedFormula = [];
    Map<int, int> openingIndices =
        FormulaState.formulaFactory.getOpeningIndices();
    Map<int, int> closingIndices =
        FormulaState.formulaFactory.getClosingIndices();

    for (var i = startIndex; i < endIndex; i++) {
      ElementSubscriptPair pair = FormulaState.formulaFactory.elementsList[i];

      if (pair.elementSymbol == null) {
        // parentheses
        if (pair.subscript < 0) {
          // opening parentheses
          int closingParenthesis = closingIndices[i];
          renderedFormula.add(
            new InputBox(
              widgetToDisplay: recursiveInputBuilder(i + 1, closingParenthesis),
              subscript: FormulaState
                  .formulaFactory.elementsList[closingParenthesis].subscript,
              selected: i == FormulaState.selectedBlockIndex,
              onInputBoxTap: () => FormulaState.onBoxTap(openingIndices[i]),
            ),
          );
          i = closingParenthesis;
        } else {
          continue;
        }
      } else {
        renderedFormula.add(
          new InputBox(
            widgetToDisplay: new Padding(
              padding: new EdgeInsets.all(6.0),
              child: new Text(
                enumToString(pair.elementSymbol),
              ),
            ),
            subscript: pair.subscript,
            selected: i == FormulaState.selectedBlockIndex,
            onInputBoxTap: () => FormulaState.onBoxTap(i),
          ),
        );
      }
    }

    if (startIndex == endIndex) {
      return new Row(children: [SizedBox(height: 20.0, width: 10.0)]);
    } else {
      return new Row(children: renderedFormula);
    }
  }

  /// Used to initiate the recursion
  Widget buildEditorMain() {
    Row inputBoxesRow =
        recursiveInputBuilder(0, FormulaState.formulaFactory.length);

    // TODO make scrollable _(:_」∠)_ (　ﾟдﾟ) (￣Д￣)ﾉ
    InputBox parentInputBox = new InputBox(
      widgetToDisplay: inputBoxesRow,
      subscript: FormulaState.formulaFactory.charge,
      selected: FormulaState.selectedBlockIndex == -1,
      onInputBoxTap: () => FormulaState.onBoxTap(-1),
      isCharge: true,
    );

    return parentInputBox;
  }

  @override
  Widget build(BuildContext context) {
    ElementSubscriptPair currentPair = FormulaState.selectedBlockIndex == -1
        ? null
        : FormulaState
            .formulaFactory.elementsList[FormulaState.selectedBlockIndex];

    int currentSubscript;
    if (currentPair == null) {
      currentSubscript = FormulaState.formulaFactory.charge;
    } else if (currentPair.subscript < 0) {
      int closingParenIndex = FormulaState.formulaFactory
          .getClosingIndices()[FormulaState.selectedBlockIndex];
      currentSubscript =
          FormulaState.formulaFactory.elementsList[closingParenIndex].subscript;
    } else {
      currentSubscript = currentPair.subscript;
    }

    List<ExpansionPanel> expansions = [];

    if (FormulaState.formula.percentages != null) {
      expansions.add(
        new ExpansionPanel(
          headerBuilder: (BuildContext context, bool isOpen) {
            return new Padding(
              padding: new EdgeInsets.all(16.0),
              child: new Text(
                "Percentage by mass",
                style: new TextStyle(fontWeight: FontWeight.bold),
              ),
            );
          },
          body: new Container(
            padding: new EdgeInsets.all(8.0),
            height: 80.0,
            child: new MassPercentageCards(
              percentages: FormulaState.formula.percentages,
            ),
          ),
          isExpanded: FormulaState.expansionPanelStates[0],
        ),
      );
    }

    Map<ElementSymbol, Rational> os = FormulaState.formula.oxidationStates;
    if (os != null) {
      expansions.add(
        new ExpansionPanel(
          headerBuilder: (BuildContext context, bool isOpen) {
            return new Padding(
              padding: new EdgeInsets.all(16.0),
              child: new Text(
                "Oxidation",
                style: new TextStyle(fontWeight: FontWeight.bold),
              ),
            );
          },
          body: new Container(
            padding: new EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 10.0),
            height: 80.0, // required for ListView
            child: new OxidationCards(os: os),
          ),
          isExpanded: FormulaState.expansionPanelStates[1],
        ),
      );
    }

    return new Column(children: [
      // Input space
      buildEditor(context, currentPair, currentSubscript),
      // Formula Editor

      // Calculations
      buildButtons(context),

      // Render
      Expanded(
        child: ListView(
          children: <Widget>[
            buildStaticData(),
            new Padding(
              padding: new EdgeInsets.all(16.0),
              child: new ExpansionPanelList(
                expansionCallback: (int index, bool isExpanded) {
                  FormulaState.toggleExpansionPanel(index);
                },
                children: expansions,
              ),
            ),
            new SizedBox(height: 60.0) // spacer
          ],
        ),
      )
    ]);
  }

  Widget buildButtons(BuildContext context) {
    return new ButtonBar(
      alignment: MainAxisAlignment.center,
      children: <Widget>[
        new RaisedButton(
          child: Text("m = nRFM"),
          onPressed: FormulaState.formula.rfm != 0
              ? () => massMolePrompt(context)
              : null,
        ),
        new RaisedButton(
          child: Text("PV = nRT"),
          onPressed: FormulaState.formula.rfm != 0
              ? () => idealGasPrompt(context)
              : null,
        ),
      ],
    );
  }

  Widget buildStaticData() {
    Map<Widget, Widget> data = <Widget, Widget>{};

    List<String> names = FormulaState.formulaFactory.names;
    if (names != null) {
      data[new Text(
        "Name(s)",
        style: StaticTable.head,
      )] = new Text(
        names.join(", "),
      );
    }

    String formula = FormulaState.formulaFactory.toString();
    if (formula != null) {
      data[new Text(
        "Formula",
        style: StaticTable.head,
      )] = new Text(
        formula,
        style: StaticTable.formula,
      );
    }

    data[new Text(
      "Relative formula mass",
      style: StaticTable.head,
    )] = new Text(FormulaState.formula.rfm.toStringAsFixed(2));

    Formula ef = FormulaState.formula.empiricalFormula;
    if (ef != null) {
      data[new Text(
        "Empirical formula",
        style: StaticTable.head,
      )] = new Text(
        ef.toString(),
        style: StaticTable.formula,
      );
    }

    BondType bondType = FormulaState.formula.bondType;
    if (bondType != null) {
      data[new Text(
        "Bond type",
        style: StaticTable.head,
      )] = new Text(enumToReadableString(FormulaState.formula.bondType));
    }
    return StaticTable(data);
  }

  Widget buildEditor(
    BuildContext context,
    ElementSubscriptPair currentPair,
    int currentSubscript,
  ) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new IconButton(
                icon: new Icon(Icons.info),
                onPressed: FormulaState.selectedBlockIndex == -1 ||
                        FormulaState.formulaFactory
                            .getClosingIndices()
                            .containsKey(FormulaState.selectedBlockIndex)
                    ? null
                    : FormulaState.onView,
                tooltip: 'View selected',
              ),
              new IconButton(
                icon: new Icon(Icons.add),
                onPressed: () => elementFormulaPrompt(
                      context: context,
                      callback: FormulaState.onAdd,
                      currentElementSymbol: null,
                      currentSubscript: 1,
                    ),
                tooltip: 'Add element after selected',
              ),
              new IconButton(
                icon: new Icon(Icons.add_circle_outline),
                onPressed: () => parenSubscriptPrompt(
                      context: context,
                      callback: (a) => FormulaState.onAdd(null, a),
                      currentSubscript: 1,
                    ),
                tooltip: 'Add box after current',
              ),
            ],
          ),
          Expanded(
            child: Row(
              children: <Widget>[
                buildEditorMain(),
              ],
              mainAxisAlignment: MainAxisAlignment.center,
            ),
          ),
          new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new IconButton(
                icon: new Icon(Icons.edit),
                onPressed: currentPair == null
                    // Charge selected
                    ? () => parenSubscriptPrompt(
                          context: context,
                          callback: (a) => FormulaState.onEdit(null, a),
                          currentSubscript: currentSubscript,
                          isCharge: true,
                        )
                    : (currentPair.elementSymbol == null
                        // Parentheses selected
                        ? () => parenSubscriptPrompt(
                              context: context,
                              callback: (a) => FormulaState.onEdit(null, a),
                              currentSubscript: currentSubscript,
                            )
                        // Element selected
                        : () => elementFormulaPrompt(
                              context: context,
                              callback: FormulaState.onEdit,
                              currentElementSymbol: currentPair.elementSymbol,
                              currentSubscript: currentSubscript,
                              isAdding: false,
                            )),
                tooltip: 'Edit selected',
              ),
              new IconButton(
                icon: new Icon(Icons.delete),
                onPressed: FormulaState.selectedBlockIndex >= 0
                    ? FormulaState.removeAtCursor
                    : FormulaState.formulaFactory.charge != 0
                        ? () {
                            FormulaState.setState(() {
                              FormulaState.formulaFactory.charge = 0;
                            });
                          }
                        : null,
                tooltip: 'Delete selected',
              ),
              new IconButton(
                icon: new Icon(Icons.clear),
                onPressed: FormulaState.onReset,
                tooltip: 'Reset',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class OxidationCards extends StatelessWidget {
  final Map<ElementSymbol, Rational> os;

  OxidationCards({Key key, this.os}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Row(
      children: os.entries
          .map(
            (MapEntry<ElementSymbol, Rational> entry) => Card(
                  child: Padding(
                    padding: new EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Text(enumToString(entry.key)),
                        new Text(
                          (entry.value.numerator < 0
                                  ? '-'
                                  : entry.value.numerator == 0 ? '' : '+') +
                              (entry.value.denominator == 1
                                  ? entry.value.numerator.abs().toString()
                                  : entry.value.abs.toString()),
                        ),
                      ],
                    ),
                  ),
                ),
          )
          .toList(),
      mainAxisAlignment: MainAxisAlignment.center,
    );
  }
}

class MassPercentageCards extends StatelessWidget {
  final Map<ElementSymbol, num> percentages;

  MassPercentageCards({Key key, this.percentages}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Row(
      children: percentages.entries
          .map(
            (MapEntry<ElementSymbol, num> entry) => Card(
                  child: Padding(
                    padding: new EdgeInsets.all(3.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Text(enumToString(entry.key)),
                        new Text(entry.value.toStringAsPrecision(3) + '%'),
                      ],
                    ),
                  ),
                ),
          )
          .toList(),
      mainAxisAlignment: MainAxisAlignment.center,
    );
  }
}
