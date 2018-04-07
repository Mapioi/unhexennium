import 'package:flutter/material.dart';
import 'package:unhexennium/utils.dart';
import 'package:unhexennium/chemistry/element.dart';
import 'package:unhexennium/chemistry/formula.dart';

class FormulaChild extends StatelessWidget {
  final String symbolString;
  final int subscript;
  final bool selected;

  /// Highlight pairing parentheses / brackets.
  final bool highlighted;
  static const Color selectedColor = Colors.blueAccent;
  static const Color highlightedColor = Colors.lightBlueAccent;

  FormulaChild(
      this.symbolString, this.subscript, this.selected, this.highlighted);

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

class FormulaParent extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _FormulaParentState();
}

class _FormulaParentState extends State<FormulaParent> {
  FormulaFactory _factory = new FormulaFactory();
  int _index = 0;

  _FormulaParentState() {
    int i = 0;
    _factory.insertOpeningBracket(i);
    ++i;
    _factory.insertElement(i, ElementSymbol.Cu);
    ++i;
    _factory.insertOpeningParenthesis(i);
    ++i;
    _factory.insertElement(i, ElementSymbol.H);
    _factory.setSubscript(i, 2);
    ++i;
    _factory.insertElement(i, ElementSymbol.O);
    ++i;
    _factory.insertClosingParenthesis(i, 6);
    ++i;
    _factory.insertClosingBracket(i);
    ++i;
    _factory.setCharge(2);
  }

  List<Widget> render() {
    var formula = <Widget>[];
    var openStack = <String>[];
    var openIndexStack = <int>[];
    var pairIndex = <int, int>{};
    int index = 0;
    for (ElementSubscriptPair pair in _factory.elementsList) {
      if (pair.elementSymbol == null) {
        if (pair.subscript < 0) {
          if (pair.subscript == -1) {
            formula.add(new FormulaChild(
                '(', 1, index == _index, index == pairIndex[_index]));
            openStack.add('(');
            openIndexStack.add(index);
          } else if (pair.subscript == -2) {
            formula.add(new FormulaChild(
                '[', 1, index == _index, index == pairIndex[_index]));
            openStack.add('[');
            openIndexStack.add(index);
          }
        } else {
          String open = openStack.removeLast();
          String close = open == '(' ? ')' : ']';
          int openIndex = openIndexStack.removeLast();
          pairIndex[openIndex] = index;
          pairIndex[index] = openIndex;
          formula.add(new FormulaChild(close, pair.subscript, index == _index,
              index == pairIndex[_index]));
        }
      } else {
        formula.add(new FormulaChild(enumToString(pair.elementSymbol),
            pair.subscript, index == _index, false));
      }
      ++index;
    }
    if (_factory.charge != 0) {
      String sign = _factory.charge > 0 ? "+" : "-";
      String chargeNumber = _factory.charge == 1
          ? ""
          : (_factory.charge ~/ _factory.charge.sign).toString();
      formula.add(new FormulaChild("$chargeNumber$sign", 1, false, false));
    }
    return formula;
  }

  @override
  Widget build(BuildContext context) {
    // TODO fix sizing issues (instead on relying on fixed pixels)
    print(_index);
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
            onPressed: () {
              setState(() {
                if (_index >= 0) --_index;
              });
            },
            tooltip: '',
          ),
          new IconButton(
            icon: new Icon(Icons.arrow_right),
            onPressed: () {
              setState(() {
                if (_index < _factory.elementsList.length - 1) ++_index;
              });
            },
            tooltip: '',
          )
        ],
      ),
      new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new IconButton(
            icon: new Icon(Icons.delete),
            onPressed: null,
            tooltip: 'Delete',
          ),
          new IconButton(
            icon: new Icon(Icons.edit),
            onPressed: null,
            tooltip: 'Edit',
          ),
          new IconButton(
            icon: new Icon(Icons.add),
            onPressed: null,
            tooltip: 'Add',
          ),
        ],
      ),
    ]);
  }
}
