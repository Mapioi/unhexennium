import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:unhexennium/utils.dart';
import 'package:unhexennium/chemistry/formula.dart';

// TODO Improve alignment.
class FormulaChild extends StatelessWidget {
  final String symbolString;
  final int subscript;
  final bool selected;

  /// Highlight pairing parentheses / brackets.
  final bool highlighted;
  static const Color selectedColor = Colors.blueAccent;
  static const Color highlightedColor = Colors.lightBlueAccent;

  FormulaChild(
      {@required this.symbolString,
      this.subscript = 1,
      this.selected = false,
      this.highlighted = false});

  @override
  Widget build(BuildContext context) {
    return new Card(
      child: new Column(
        children: <Widget>[
          new Text(
            symbolString,
            textAlign: TextAlign.center,
          ),
          new Text(
            subscript != 1 ? subscript.toString() : '',
            textAlign: TextAlign.right,
          )
        ],
      ),
      color: selected ? selectedColor : highlighted ? highlightedColor : null,
    );
  }
}

typedef void Callback();

class FormulaParent extends StatelessWidget {
  final FormulaFactory formulaFactory;
  final int cursorIndex;
  final Callback onGoLeft, onGoRight, onDelete, onEdit, onAdd;

  FormulaParent(
      {@required this.formulaFactory,
      @required this.cursorIndex,
      @required this.onGoLeft,
      @required this.onGoRight,
      @required this.onDelete,
      @required this.onEdit,
      @required this.onAdd});

  List<Widget> render() {
    var renderedFormula = <FormulaChild>[];
    var openingIndices = formulaFactory.getOpeningIndices(),
        closingIndices = formulaFactory.getClosingIndices();
    int i = 0;
    for (ElementSubscriptPair pair in formulaFactory.elementsList) {
      if (pair.elementSymbol == null) {
        if (pair.subscript < 0) {
          renderedFormula.add(new FormulaChild(
            symbolString: pair.subscript == -1 ? '(' : '[',
            selected: i == cursorIndex,
            highlighted: i == openingIndices[cursorIndex],
          ));
        } else {
          renderedFormula.add(new FormulaChild(
              symbolString:
                  renderedFormula[openingIndices[i]].symbolString == '('
                      ? ')'
                      : ']',
              subscript: pair.subscript,
              selected: i == cursorIndex,
              highlighted: i == closingIndices[cursorIndex]));
        }
      } else {
        renderedFormula.add(new FormulaChild(
          symbolString: enumToString(pair.elementSymbol),
          subscript: pair.subscript,
          selected: i == cursorIndex,
        ));
      }
      ++i;
    }
    if (formulaFactory.charge != 0) {
      String sign = formulaFactory.charge > 0 ? "+" : "-";
      String chargeNumber = formulaFactory.charge == 1
          ? ""
          : (formulaFactory.charge ~/ formulaFactory.charge.sign).toString();
      renderedFormula.add(new FormulaChild(
        symbolString: "$chargeNumber$sign",
        selected: i == cursorIndex,
      ));
    }
    return renderedFormula;
  }

  @override
  Widget build(BuildContext context) {
    // TODO fix sizing issues (instead on relying on fixed pixels)
    return new Column(children: [
      new Container(
        child: new Row(children: render()),
        padding: new EdgeInsets.all(8.0),
        height: 100.0,
      ),
      new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new IconButton(
            icon: new Icon(Icons.arrow_left),
            onPressed: onGoLeft,
            tooltip: '',
          ),
          new IconButton(
            icon: new Icon(Icons.arrow_right),
            onPressed: onGoRight,
            tooltip: '',
          )
        ],
      ),
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
