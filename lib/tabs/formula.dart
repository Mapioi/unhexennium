import 'package:meta/meta.dart';
import 'package:flutter/material.dart';
import 'package:unhexennium/chemistry/formula.dart';
import 'package:unhexennium/utils.dart';


// Type declarations
typedef void Callback();
typedef void SingleArgCallback(x);


/// [InputBox] renders the top for whatever the top is
///   - Can be an element Text or a Row of more elements
/// And renders the subscript on the bottom
class InputBox extends StatelessWidget {
  final Widget widgetToDisplay;
  final int subscript;
  final bool selected;
  final Callback onInputBoxTap;

  /// Highlight pairing parentheses / brackets.
  static const Color defaultColor = Colors.grey;
  static const Color selectedColor = Colors.blueAccent;

  InputBox(
    {@required this.widgetToDisplay,
      this.onInputBoxTap,
      this.subscript = 1,
      this.selected = false});

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onTap: onInputBoxTap,
      child: new Container(
        // Structure
        child: new Column(
          children: <Widget>[
            widgetToDisplay,
            new Container(
              child: new Text(this.subscript.toString()),
            )
          ],
        ),
        // Style
        decoration: new BoxDecoration(
          border: new Border.all(color: selected ? selectedColor : defaultColor)
        ),
        padding: new EdgeInsets.all(3.0),
        margin: new EdgeInsets.all(3.0),
        alignment: Alignment(0.0, 0.0),
      )
    );
  }
}


/// Formula Parent handles the top level
class FormulaParent extends StatelessWidget {
  final FormulaFactory formulaFactory;
  final Formula formula;
  final Callback onDelete, onEdit, onAdd;
  final SingleArgCallback onBoxTap;
  final int selectedBlockIndex;

  FormulaParent({
    @required this.formulaFactory,
    @required this.selectedBlockIndex,
    @required this.onDelete,
    @required this.onEdit,
    @required this.onAdd,
    @required this.onBoxTap,
  }) : formula = formulaFactory.build();

  /// Used to build the recursive input structure
  Row recursiveInputBuilder(int startIndex, int endIndex) {
    List<Widget> renderedFormula = [];
    Map<int, int> openingIndices = formulaFactory.getOpeningIndices();
    Map<int, int> closingIndices = formulaFactory.getClosingIndices();

    for (var i = startIndex; i < endIndex; i++) {
      ElementSubscriptPair pair = formulaFactory.elementsList[i];

      if (pair.elementSymbol == null) {
        // parentheses
        if (pair.subscript < 0) {
          // opening parentheses
          int closingParenthesis = closingIndices[i];
          renderedFormula.add(
            new InputBox(
              widgetToDisplay: this.recursiveInputBuilder(
                i + 1, closingParenthesis
              ),
              subscript: formulaFactory.elementsList[
                closingParenthesis
              ].subscript,
              selected: (i == selectedBlockIndex)
                || (i == closingIndices[selectedBlockIndex]),
              onInputBoxTap: () => onBoxTap(i),
            )
          );
          i = closingParenthesis;
        } else {
          continue;
        }
      } else {
        print(pair.elementSymbol);
        print(startIndex);
        renderedFormula.add(
          new InputBox(
            widgetToDisplay: new Text(enumToString(pair.elementSymbol)),
            subscript: pair.subscript,
            selected: i == selectedBlockIndex,
            onInputBoxTap: () => onBoxTap(i)
          )
        );
      }
    }

    return new Row(children: renderedFormula);
  }

  /// Used to initiate the recursion
  InputBox render() {
    print(formulaFactory.elementsList.toString());
    Row inputBoxesRow = recursiveInputBuilder(
      0, formulaFactory.elementsList.length
    );

    InputBox parentInputBox = new InputBox(
      widgetToDisplay: inputBoxesRow,
      subscript: formulaFactory.charge,
      selected: selectedBlockIndex == -1,
      onInputBoxTap: () => onBoxTap(-1)
    );

    return parentInputBox;
  }

  @override
  Widget build(BuildContext context) {
    // TODO fix sizing issues (instead on relying on fixed pixels)
    return new Column(children: [
      // Rendered formula
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
            onPressed: onDelete,
            tooltip: 'Delete current',
          ),
          new IconButton(
            icon: new Icon(Icons.edit),
            onPressed: onEdit,
            tooltip: 'Edit',
          ),
          new IconButton(
            icon: new Icon(Icons.add),
            onPressed: onAdd,
            tooltip: 'Add after current',
          ),
        ],
      ),
    ]);
  }
}
