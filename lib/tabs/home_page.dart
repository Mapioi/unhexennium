// Packages
import 'package:flutter/material.dart';
import 'package:unhexennium/tabs/equation.dart';
import 'package:unhexennium/tabs/element.dart';
import 'package:unhexennium/tabs/formula.dart';
import 'package:unhexennium/utils.dart';

// ui
enum Mode { Element, Formula, Equation }

const default_mode = Mode.Element;

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  _HomePageState() {
    ElementState.setState = setState;
    FormulaState.setState = setState;
    FormulaState.switchToElementTab =
        () => _tabController.animateTo(Mode.Element.index);
  }

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: Mode.values.length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      // title
      appBar: new AppBar(
        title: new Text("Unhexennium"),
        bottom: new TabBar(
          controller: _tabController,
          tabs: Mode.values.map((Mode tabTitle) {
            return new Tab(
              text: enumToString(tabTitle),
            );
          }).toList(),
        ),
      ),
      // content
      body: new TabBarView(
        controller: _tabController,
        children: [
          new ElementParent(),
          new FormulaParent(),
          new EquationParent(),
        ],
      ),
    );
  }
}
