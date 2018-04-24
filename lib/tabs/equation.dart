import 'package:flutter/material.dart';
import 'package:unhexennium/utils.dart';
import 'package:unhexennium/maths/rational.dart';
import 'package:unhexennium/chemistry/element.dart';
import 'package:unhexennium/chemistry/formula.dart';
import 'package:unhexennium/chemistry/equation.dart';
import 'package:unhexennium/tabs/formula.dart';

// Constants
enum EquationSide { Reactant, Product }

class EquationState {
  // Callbacks set in homepage.
  static SetStateCallback setState;
  static Callback switchToFormulaTab;

  // State management
  static EquationSide _selectedSide = EquationSide.Reactant;
  static int _selectedIndex = -1;
  static FormulaFactory _selectedFormula;

  static EquationSide get selectedSide => _selectedSide;

  static int get selectedIndex => _selectedIndex;

  static FormulaFactory get selectedFormula => _selectedFormula;

  static List<FormulaFactory> reactants = [
    new FormulaFactory()
      ..insertElementAt(0, elementSymbol: ElementSymbol.H)
      ..setSubscriptAt(0, subscript: 2),
    new FormulaFactory()
      ..insertElementAt(0, elementSymbol: ElementSymbol.O)
      ..setSubscriptAt(0, subscript: 2),
  ];
  static List<FormulaFactory> products = [
    new FormulaFactory()
      ..insertElementAt(0, elementSymbol: ElementSymbol.H)
      ..setSubscriptAt(0, subscript: 2)
      ..insertElementAt(1, elementSymbol: ElementSymbol.O),
  ];
  static Equation equation = new Equation(
    reactants.map((f) => f.build()).toList(),
    products.map((f) => f.build()).toList(),
  );

  // To display in error message
  static List<List<Rational>> candidateCoefficients;

  static rebuildEquation() {
    var r = reactants
        .where((f) => f.elementsList.isNotEmpty || f.charge == -1)
        .map((f) => f.build())
        .toList();
    var p = products
        .where((f) => f.elementsList.isNotEmpty || f.charge == -1)
        .map((f) => f.build())
        .toList();
    setState(() {
      try {
        equation = new Equation(r, p, strictBalancing: true);
        candidateCoefficients = null;
      } on InfiniteWaysOfBalancingException catch (e) {
        equation = new Equation(r, p, strictBalancing: false);
        candidateCoefficients = e.kernel;
      }
    });
  }

  static select(EquationSide side, int index) {
    assert(-1 <= index &&
        index <
            (side == EquationSide.Reactant
                ? reactants.length
                : products.length));
    setState(() {
      _selectedSide = side;
      _selectedIndex = index;
      try {
        _selectedFormula = {
          EquationSide.Reactant: reactants,
          EquationSide.Product: products
        }[side][index];
      } on RangeError {
        _selectedFormula = null;
      }
    });
  }

  static onDeleteSelected() {
    assert(selectedIndex >= 0);
    setState(() {
      if (selectedSide == EquationSide.Reactant) {
        reactants.removeAt(selectedIndex);
      }
      if (selectedSide == EquationSide.Product) {
        products.removeAt(selectedIndex);
      }
      select(selectedSide, selectedIndex - 1);
    });
    rebuildEquation();
  }

  static onInsertAfterSelected() {
    setState(() {
      <EquationSide, List<FormulaFactory>>{
        EquationSide.Reactant: reactants,
        EquationSide.Product: products
      }[selectedSide]
          .insert(selectedIndex + 1, new FormulaFactory());
    });
    select(EquationState.selectedSide, EquationState.selectedIndex + 1);
    rebuildEquation();
  }

  static onEditSelected() {
    FormulaState.formulaFactory = selectedFormula;
    switchToFormulaTab();
  }
}

class EquationParent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Center(
      child: Column(
        children: <Widget>[
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildColumn(EquationSide.Reactant, EquationState.reactants),
              buildColumn(EquationSide.Product, EquationState.products),
            ],
          ),
          new Expanded(child: new Container()),
          buildButtons(context),
        ],
      ),
    );
  }

  Widget buildButtons(BuildContext context) {
    List<Widget> buttons = <Widget>[
      new Padding(
        padding: const EdgeInsets.all(8.0),
        child: new FloatingActionButton(
          onPressed: EquationState.onInsertAfterSelected,
          child: new Icon(Icons.add),
          tooltip: "Insert after selected",
        ),
      ),
    ];

    if (0 <= EquationState.selectedIndex &&
        EquationState.selectedIndex <
            {
              EquationSide.Reactant: EquationState.reactants,
              EquationSide.Product: EquationState.products
            }[EquationState.selectedSide]
                .length) {
      buttons.add(
        new Padding(
          padding: const EdgeInsets.all(8.0),
          child: new FloatingActionButton(
            onPressed: EquationState.onEditSelected,
            child: new Icon(Icons.edit),
            tooltip: "Edit selected formula",
          ),
        ),
      );
    }

    if (0 <= EquationState.selectedIndex &&
        EquationState.selectedIndex <
            {
              EquationSide.Reactant: EquationState.reactants,
              EquationSide.Product: EquationState.products
            }[EquationState.selectedSide]
                .length) {
      buttons.add(
        new Padding(
          padding: const EdgeInsets.all(8.0),
          child: new FloatingActionButton(
            onPressed: EquationState.onDeleteSelected,
            child: new Icon(Icons.delete),
            tooltip: "Delete selected",
          ),
        ),
      );
    }

    if (EquationState.candidateCoefficients != null) {
      buttons.add(new FloatingActionButton(
        onPressed: () => showDialog(
            context: context,
            builder: (BuildContext context) {
              return new Dialog(
                child: new Container(
                  height: MediaQuery.of(context).size.height * 0.25,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: ListView(
                      children: <Widget>[
                            new Center(
                              child: Text("This is not a single equation.\n"
                                  "We tried to balance it,\n"
                                  "but if the result looks amiss,\n"
                                  "here are the coefficients:\n"),
                            ),
                          ] +
                          EquationState.candidateCoefficients
                              .map((var vector) => Center(
                                    child: Text(
                                      vector.toString(),
                                      style: new TextStyle(
                                        fontFamily: "Stix2Math",
                                      ),
                                    ),
                                  ))
                              .toList(),
                    ),
                  ),
                ),
              );
            }),
        backgroundColor: Colors.red,
        child: new Icon(
          Icons.error,
        ),
      ));
    }

    return new Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: buttons,
    );
  }

  /// Builds a column for the reactant or product input
  Widget buildColumn(EquationSide side, List<FormulaFactory> formulae) {
    int coefficientIndex = 0;
    int index = 0;
    List<Widget> items = [
      new GestureDetector(
        onTap: () => EquationState.select(side, -1),
        child: new Padding(
          padding: const EdgeInsets.all(8.0),
          child: new Container(
            decoration: new BoxDecoration(
              border: new Border(
                bottom: new BorderSide(
                    color: EquationState.selectedSide == side &&
                            EquationState.selectedIndex == -1
                        ? Colors.green
                        : Colors.white),
              ),
            ),
            child: new Text(
              enumToString(side) + 's',
            ),
          ),
        ),
      ),
    ];
    for (FormulaFactory factory in formulae) {
      // Try replacing wtf by index, you'll see. (hint: wtf)
      final int wtf = index;
      bool isEmpty = !(factory.elementsList.isNotEmpty || factory.charge == -1);
      List<Widget> contents = [
        // Formula
        new Text(factory.toString()),
      ];
      if (!isEmpty) {
        contents.insert(
          0,
          // Stoichiometric coefficient
          new Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 0.0, 8.0, 0.0),
            child: new Text(
              EquationState.equation.coefficients[coefficientIndex].toString(),
              style: new TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }
      items.add(new Padding(
        padding: const EdgeInsets.all(8.0),
        child: new FlatButton(
          padding: EdgeInsets.all(0.0),
          color: (side == EquationState.selectedSide &&
                  wtf == EquationState.selectedIndex)
              ? (isEmpty ? Colors.blueGrey[200] : Colors.blue[100])
              : (isEmpty ? Colors.grey[200] : Colors.grey[100]),
          splashColor: isEmpty ? Colors.blueGrey[400] : Colors.blue[200],
          disabledTextColor: Colors.black,
          child: new Row(
            children: contents,
          ),
          onPressed: () => EquationState.select(side, wtf),
        ),
      ));
      index++;
      if (!isEmpty) {
        coefficientIndex++;
      }
    }
    return new Column(
      children: items,
    );
  }
}
