// Packages
import 'package:flutter/material.dart';
import 'package:unhexennium/tabs/equation.dart';
import 'package:unhexennium/tabs/element.dart';
import 'package:unhexennium/tabs/formula.dart';
import 'package:unhexennium/chemistry/element.dart';
import 'package:unhexennium/chemistry/formula.dart';
import 'package:unhexennium/utils.dart';

// ui
enum Mode { Element, Formula, Equation }

const default_mode = Mode.Element;

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  /// States are stored here for the child widgets
  /// So that they don't get lost on tab switch
  ChemicalElement _storedElement;
  FormulaFactory formulaFactory;
  int formulaCursorIndex;

  _HomePageState() {
    // Element ---
    _storedElement = new ChemicalElement(ElementSymbol.Xe);

    // Formula ---
    formulaFactory = new FormulaFactory();
    formulaFactory.insertOpeningBracketAt(0);
    formulaFactory.insertElementAt(1, elementSymbol: ElementSymbol.Fe);
    formulaFactory.insertOpeningParenthesisAt(2);
    formulaFactory.insertElementAt(3, elementSymbol: ElementSymbol.O);
    formulaFactory.insertElementAt(4, elementSymbol: ElementSymbol.H);
    formulaFactory.insertClosingParenthesisAt(5, subscript: 2);
    formulaFactory.insertOpeningParenthesisAt(6);
    formulaFactory.insertElementAt(7, elementSymbol: ElementSymbol.H);
    formulaFactory.setSubscriptAt(7, subscript: 2);
    formulaFactory.insertElementAt(8, elementSymbol: ElementSymbol.O);
    formulaFactory.insertClosingParenthesisAt(9, subscript: 4);
    formulaFactory.insertClosingBracketAt(10);
    formulaFactory.setCharge(2);

    formulaCursorIndex = 0;
  }

  /// Formula tab callbacks
  void formulaShiftCursorLeft() {
    setState(() {
      --formulaCursorIndex;
    });
  }

  void formulaShiftCursorRight() {
    setState(() {
      ++formulaCursorIndex;
    });
  }

  void formulaRemoveAtCursor() {
    setState(() {
      if (formulaCursorIndex < formulaFactory.length) {
        var closingIndices = formulaFactory.getClosingIndices();
        if (closingIndices.containsKey(formulaCursorIndex)) {
          formulaFactory.removeAt(closingIndices[formulaCursorIndex]);
        }
        formulaFactory.removeAt(formulaCursorIndex);
      } else if (formulaCursorIndex == formulaFactory.length &&
          formulaFactory.charge != 0) {
        formulaFactory.setCharge(0);
      }
      --formulaCursorIndex;
    });
  }

  void formulaEditAtCursor() {}

  void formulaInsertAfterCursor() {}

  @override
  Widget build(BuildContext context) {
    return new DefaultTabController(
      length: Mode.values.length,
      child: new Scaffold(
        // title
        appBar: new AppBar(
          title: new Text("Unhexennium"),
          bottom: new TabBar(
            isScrollable: true,
            tabs: Mode.values.map((Mode tabTitle) {
              return new Tab(
                text: enumToString(tabTitle),
              );
            }).toList(),
          ),
        ),
        // content
        body: new TabBarView(children: [
          new ElementParent(selectedElement: _storedElement),
          new FormulaParent(
              formulaFactory: formulaFactory,
              cursorIndex: formulaCursorIndex,
              onGoLeft: formulaCursorIndex >= 0 ? formulaShiftCursorLeft : null,
              onGoRight: formulaCursorIndex < formulaFactory.length - 1 ||
                      (formulaCursorIndex == formulaFactory.length - 1 &&
                          formulaFactory.charge != 0)
                  ? formulaShiftCursorRight
                  : null,
              onDelete: formulaCursorIndex >= 0 ? formulaRemoveAtCursor : null,
              onEdit: formulaCursorIndex >= 0 ? formulaEditAtCursor : null,
              onAdd: formulaCursorIndex < formulaFactory.length
                  ? formulaInsertAfterCursor
                  : null),
          new EquationParent()
        ]),
      ),
    );
  }
}
