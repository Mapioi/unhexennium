// Packages
import 'package:flutter/material.dart';
import 'package:unhexennium/tabs/equation.dart';
import 'package:unhexennium/tabs/element.dart';
import 'package:unhexennium/tabs/formula.dart';
import 'package:unhexennium/tabs/popups.dart';
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
    formulaFactory = new FormulaFactory()
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
        formulaFactory.charge = 0;
      }
      --formulaSelectedBlockIndex;
    });
  }

  void formulaEditAtCursor() {}

  void formulaInsertAfterIndex(int indexToInsertAt, ElementSymbol toInsert) {
    askForElementSymbol(context, (e, i) => print(e));
    print(formulaSelectedBlockIndex);
  }

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
                ? () => formulaInsertAfterIndex(1, ElementSymbol.Ac)
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
