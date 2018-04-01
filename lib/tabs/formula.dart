import 'package:flutter/material.dart';
import 'package:unhexennium/utils.dart';
import 'package:unhexennium/chemistry/element.dart';
import 'package:unhexennium/chemistry/formula.dart';

class FormulaParent extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _FormulaParentState();
}

class _FormulaParentState extends State<FormulaParent> {
  FormulaFactory _factory = new FormulaFactory();
  Formula _formula;

  SizedBox _generateCell(ElementSymbol symbol) {
    if (symbol == null) {
      return new SizedBox(
        child: new Text(""),
        width: 64.0,
        height: 64.0
      );
    }
    return new SizedBox(
      width: 64.0,
      height: 64.0,
      child: new RaisedButton(
      child: new Text(enumToString(symbol)),
      onPressed: () {
        _factory.addElement(symbol);
        setState(() {});
      }
    ));
  }

  Column _generatePeriodicTable() {
    List<List<ElementSymbol>> periods = [
      [
        ElementSymbol.H,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        ElementSymbol.He,
      ],
      [
        ElementSymbol.Li,
        ElementSymbol.Be,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        ElementSymbol.B,
        ElementSymbol.C,
        ElementSymbol.N,
        ElementSymbol.O,
        ElementSymbol.F,
        ElementSymbol.Ne
      ],
      [
        ElementSymbol.Na,
        ElementSymbol.Mg,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        ElementSymbol.Al,
        ElementSymbol.Si,
        ElementSymbol.P,
        ElementSymbol.S,
        ElementSymbol.Cl,
        ElementSymbol.Ar
      ]
    ];
    return new Column(
      children: periods
        .map((period) =>
      new Row(
        children: period.map(_generateCell).toList()
      ))
        .toList(),
    );
  }

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
        child: new ListView(
          scrollDirection: Axis.horizontal,
          children: <Widget>[
            _generatePeriodicTable()
          ],
        )
      )]);
  }
}
