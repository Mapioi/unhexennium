import 'package:flutter/material.dart';
import 'package:unhexennium/chemistry/formula.dart';
import 'package:unhexennium/tabs/periodic_table.dart';

class FormulaParent extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _FormulaParentState();
}

class _FormulaParentState extends State<FormulaParent> {
  FormulaFactory _factory = new FormulaFactory();

  @override
  Widget build(BuildContext context) {
    // TODO fix sizing issues (instead on relying on fixed pixels)
    return new Column(children: [
      new Container(
        child: new Text(_factory.toString()),
        padding: new EdgeInsets.all(8.0),
        height: 128.0,
        width: 128.0,
      ),
      new Container(
        height: 400.0,
        child: new PeriodicTable((symbol) {
          _factory.addElement(symbol);
          setState(() {});
        }),
      )
    ]);
  }
}
