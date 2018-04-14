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
  final bool isCharge;

  /// Highlight pairing parentheses / brackets.
  static const Color defaultColor = Colors.grey;
  static const Color selectedColor = Colors.blueAccent;
  static const Color chargeSelectedColor = Colors.green;

  InputBox(
    {@required this.widgetToDisplay,
      this.onInputBoxTap,
      this.subscript = 1,
      this.selected = false,
      this.isCharge = false});

  @override
  Widget build(BuildContext context) {
    String numberToDisplay;
    if (isCharge) {
      if (subscript > 0) {
        numberToDisplay = "$subscript+";
      } else if (subscript < 0) {
        numberToDisplay = "$subscript-";
      }
    } else {
      numberToDisplay = subscript.toString();
    }

    Color currentBorderColor = selected ? (
      isCharge ? chargeSelectedColor : selectedColor
    ) : defaultColor;

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
                  bottom: new BorderSide(color: currentBorderColor)
                )
              ),
            ),
            // Subscript
            new Container(
              child: new Padding(
                child: new Text(numberToDisplay),
                padding: new EdgeInsets.fromLTRB(0.0, 2.0, 0.0, 2.0))
            )
          ],
        ),
        // Style
        decoration: new BoxDecoration(
          border: new Border.all(
            color: currentBorderColor = currentBorderColor
          )
        ),
//        padding: new EdgeInsets.all(3.0),
        margin: new EdgeInsets.all(6.0),
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
              selected: i == selectedBlockIndex,
              onInputBoxTap: () => onBoxTap(openingIndices[i]),
            )
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
              child: new Text(enumToString(pair.elementSymbol))
            ),
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
      onInputBoxTap: () => onBoxTap(-1),
      isCharge: true,
    );

    return parentInputBox;
  }

  @override
  Widget build(BuildContext context) {
    // TODO fix sizing issues (instead on relying on fixed pixels)
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
        new Container(height: 20.0),
      // Render
      new Text(
        formulaFactory.toString(),
        style: new TextStyle(
          fontFamily: 'Stix2Math',
          fontSize: 18.0,
          fontStyle: FontStyle.normal
        ),
      )
    ]);
  }
}
