import 'package:flutter/material.dart';
import 'package:unhexennium/utils.dart';

// Constants
enum EquationSide { Reactant, Product }

class EquationParent extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _EquationParentState();
}

class _EquationParentState extends State<EquationParent> {
  List<String> inputtedReactants = [];
  List<String> inputtedProducts = [];

  @override
  Widget build(BuildContext context) {
    return new Center(
        child: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
          _buildEquationInputColumn(
              EquationSide.Reactant, this.inputtedReactants),
          _buildEquationInputColumn(EquationSide.Product, this.inputtedProducts)
        ]));
  }

  /// Builds a column for the reactant or product input
  Widget _buildEquationInputColumn(
      EquationSide colName, List<String> alreadyInputted) {
    // Top Title
    List<Widget> textBoxes = [new Text(enumToString(colName))];
    // Already generated elements
    textBoxes
        .addAll(alreadyInputted.map((String element) => new Text(element)));

    textBoxes.add(new FlatButton(
        onPressed: () => this.addElement(colName, "TEST"),
        child: new Text("ADD ELEMENT")));

    return new Column(children: textBoxes);
  }

  void addElement(EquationSide colName, String elementToAdd) {
    setState(() {
      if (colName == EquationSide.Reactant) {
        this.inputtedReactants.add(elementToAdd);
      } else if (colName == EquationSide.Product) {
        this.inputtedProducts.add(elementToAdd);
      }
    });
  }
}
