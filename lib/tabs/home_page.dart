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
  FormulaFactory formulaFactory;
  int formulaSelectedBlockIndex;

  _HomePageState() {
    // Formula ---
    ElementState.setState = setState;
    formulaFactory = new FormulaFactory();
    formulaFactory.insertElementAt(0, elementSymbol: ElementSymbol.Fe);
    formulaFactory.insertOpeningParenthesisAt(1);
    formulaFactory.insertElementAt(2, elementSymbol: ElementSymbol.O);
    formulaFactory.insertElementAt(3, elementSymbol: ElementSymbol.H);
    formulaFactory.insertClosingParenthesisAt(4, subscript: 2);
    formulaFactory.insertOpeningParenthesisAt(5);
    formulaFactory.insertElementAt(6, elementSymbol: ElementSymbol.H);
    formulaFactory.setSubscriptAt(6, subscript: 2);
    formulaFactory.insertElementAt(7, elementSymbol: ElementSymbol.O);
    formulaFactory.insertClosingParenthesisAt(8, subscript: 4);
    formulaFactory.setCharge(2);

    formulaSelectedBlockIndex = -1;
  }

  void formulaRemoveAtCursor() {
    setState(() {
      if (formulaSelectedBlockIndex < formulaFactory.length) {
        var closingIndices = formulaFactory.getClosingIndices();
        if (closingIndices.containsKey(formulaSelectedBlockIndex)) {
          formulaFactory.removeAt(closingIndices[formulaSelectedBlockIndex]);
        }
        formulaFactory.removeAt(formulaSelectedBlockIndex);
      } else if (formulaSelectedBlockIndex == formulaFactory.length &&
          formulaFactory.charge != 0) {
        formulaFactory.setCharge(0);
      }
      --formulaSelectedBlockIndex;
    });
  }

  void formulaEditAtCursor() {}

  void formulaInsertAfterCursor() {}

  void formulaOnInputBoxTap(currentBlock) {
    setState(() {
      formulaSelectedBlockIndex = currentBlock;
    });
  }

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
          new ElementParent(),
          new FormulaParent(
            formulaFactory: formulaFactory,
            onDelete:
                formulaSelectedBlockIndex >= 0 ? formulaRemoveAtCursor : null,
            onEdit: formulaSelectedBlockIndex >= 0 ? formulaEditAtCursor : null,
            onAdd: formulaSelectedBlockIndex < formulaFactory.length
                ? formulaInsertAfterCursor
                : null,
            selectedBlockIndex: formulaSelectedBlockIndex,
            onBoxTap: formulaOnInputBoxTap,
          ),
          new EquationParent(),
        ]),
      ),
    );
  }
}
