/// Periodic table UI

import 'package:flutter/material.dart';
import 'package:unhexennium/utils.dart';
import 'package:unhexennium/chemistry/element.dart';

typedef void Callback(ElementSymbol symbol);

class _ElementRange {
  int startCol, endCol;
  ElementSymbol startSymbol;

  _ElementRange(this.startSymbol, this.startCol, this.endCol);
}

class PeriodicTable extends StatelessWidget {
  final Callback onClickCallback;
  static const num cellSize = 40.0;

  PeriodicTable(this.onClickCallback);

  Widget _buildEmptyCell() {
    return new SizedBox(
      width: cellSize,
      height: cellSize,
      child: new Text(""),
    );
  }

  Widget _buildCell(ElementSymbol symbol) {
    return new SizedBox(
      width: cellSize,
      height: cellSize,
      child: new RaisedButton(
        padding: new EdgeInsets.all(0.0),
        child: new Text(
          enumToString(symbol),
          softWrap: false,
          style: new TextStyle(fontSize: 14.0),
        ),
        onPressed: () => onClickCallback(symbol)),
    );
  }

  Widget _buildRow(List<_ElementRange> elementRanges) {
    List<Widget> contents = new List<Widget>(18);
    for (_ElementRange range in elementRanges) {
      for (int col = range.startCol; col <= range.endCol; col++) {
        contents[col - 1] = _buildCell(ElementSymbol
          .values[range.startSymbol.index + (col - range.startCol)]);
      }
    }
    for (int col = 0; col < 18; col++) {
      if (contents[col] == null) {
        contents[col] = _buildEmptyCell();
      }
    }
    return new Row(children: contents);
  }

  @override
  Widget build(BuildContext context) {
    return new ListView(
      scrollDirection: Axis.vertical,
      children: <Widget>[
        Container(
          height: 500.0,
          child: new ListView(
            scrollDirection: Axis.horizontal,
            children: <Widget>[
              new Column(
                children: <Widget>[
                  _buildRow([
                    new _ElementRange(ElementSymbol.H, 1, 1),
                    new _ElementRange(ElementSymbol.He, 18, 18)
                  ]),
                  _buildRow([
                    new _ElementRange(ElementSymbol.Li, 1, 2),
                    new _ElementRange(ElementSymbol.B, 13, 18)
                  ]),
                  _buildRow([
                    new _ElementRange(ElementSymbol.Na, 1, 2),
                    new _ElementRange(ElementSymbol.Al, 13, 18)
                  ]),
                  _buildRow([new _ElementRange(ElementSymbol.K, 1, 18)]),
                  _buildRow([new _ElementRange(ElementSymbol.Rb, 1, 18)]),
                  _buildRow([
                    new _ElementRange(ElementSymbol.Cs, 1, 3),
                    new _ElementRange(ElementSymbol.Hf, 4, 18)
                  ]),
                  _buildRow([
                    new _ElementRange(ElementSymbol.Fr, 1, 3),
                    new _ElementRange(ElementSymbol.Rf, 4, 18)
                  ]),
                  _buildRow([]),
                  _buildRow([new _ElementRange(ElementSymbol.Ce, 4, 17)]),
                  _buildRow([new _ElementRange(ElementSymbol.Th, 4, 17)])
                ],
              )
            ],
          )
        )
      ]
    );
  }
}
