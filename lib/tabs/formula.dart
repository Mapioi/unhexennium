import 'package:meta/meta.dart';
import 'package:flutter/material.dart';
import 'package:unhexennium/utils.dart';
import 'package:unhexennium/chemistry/element.dart';
import 'package:unhexennium/chemistry/formula.dart';

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
              border: new Border.all(
                  color: currentBorderColor = currentBorderColor)),
//        padding: new EdgeInsets.all(3.0),
          margin: new EdgeInsets.all(6.0),
          alignment: Alignment(0.0, 0.0),
        ));
  }
}

class FormulaState {
  static SetStateCallback setState;
  static final FormulaFactory formulaFactory = new FormulaFactory()
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
    ..charge = 2;
  static Formula formula = formulaFactory.build();
  static int selectedBlockIndex = 0;

  static void removeAtCursor() {
    setState(() {
      var closingIndices = FormulaState.formulaFactory.getClosingIndices();
      if (closingIndices.containsKey(selectedBlockIndex))
        FormulaState.formulaFactory
            .removeAt(closingIndices[selectedBlockIndex]);
      FormulaState.formulaFactory.removeAt(selectedBlockIndex);
      selectedBlockIndex--;
    });
  }

  static void onEdit() {}

  static void onAdd() {}

  static void onBoxTap(int index) {
    setState(() {
      selectedBlockIndex = index;
    });
  }
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

    return new Row(children: renderedFormula);
  }

  /// Used to initiate the recursion
  InputBox render() {
    /*print(FormulaState.formulaFactory.elementsList.toString());*/
    Row inputBoxesRow =
        recursiveInputBuilder(0, FormulaState.formulaFactory.length);

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
    return new Column(children: [
      // Input space
      new Padding(
        child: new Row(
          children: [render()], // TODO use a container instead
          mainAxisAlignment: MainAxisAlignment.center,
        ),
        padding: EdgeInsets.all(8.0),
      ),
      // Formula Editor
      new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new IconButton(
            icon: new Icon(Icons.delete),
            onPressed: FormulaState.selectedBlockIndex >= 0
                ? FormulaState.removeAtCursor
                : null,
            tooltip: 'Delete current',
          ),
          new IconButton(
            icon: new Icon(Icons.edit),
            onPressed: FormulaState.onEdit,
            tooltip: 'Edit',
          ),
          new IconButton(
            icon: new Icon(Icons.add),
            onPressed: FormulaState.onAdd,
            tooltip: 'Add after current',
          ),
        ],
      ),
      new Container(height: 20.0),
      // Render
      new Text(
        FormulaState.formulaFactory.toString(),
        style: new TextStyle(
          fontFamily: 'Stix2Math',
          fontSize: 18.0,
          fontStyle: FontStyle.normal,
        ),
      )
    ]);
  }
}
