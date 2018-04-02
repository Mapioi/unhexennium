// Packages
import 'package:flutter/material.dart';
import 'package:unhexennium/tabs/equation.dart';
import 'package:unhexennium/tabs/element.dart';
import 'package:unhexennium/tabs/formula.dart';
import 'package:unhexennium/chemistry/element.dart';
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
  ChemicalElement storedElement = new ChemicalElement(ElementSymbol.He);


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
        body: new TabBarView(
          children: [
            new ElementParent(selectedElement: storedElement),
            new FormulaParent(),
            new EquationParent()
          ]
        ),
      ),
    );
  }
}
