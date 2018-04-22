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
  final ElementSymbol selectedElement;
  static const num cellSize = 40.0;

  static const String singleDagger = "†";
  static const String doubleDagger = "‡";

  PeriodicTable(this.selectedElement, this.onClickCallback);

  Widget _buildEmptyCell([String text = ""]) {
    return new SizedBox(
      width: cellSize,
      height: cellSize,
      child: new Text(
        text,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildCell(ElementSymbol symbol) {
    return new SizedBox(
      width: cellSize,
      height: cellSize,
      child: new RaisedButton(
        padding: new EdgeInsets.all(0.0),
//          color: symbol == selectedElement ? Colors.green : Colors.grey[400],
        child: new Text(
          enumToString(symbol) +
              (symbol == ElementSymbol.La
                  ? singleDagger
                  : symbol == ElementSymbol.Ac ? doubleDagger : ""),
          softWrap: false,
          style: new TextStyle(fontSize: 14.0),
        ),
        onPressed:
            symbol == selectedElement ? null : () => onClickCallback(symbol),
      ),
    );
  }

  Widget _buildGroupNumbersRow() {
    return new Row(
      children: new List<Widget>.generate(
        19,
        (int i) => _buildEmptyCell(i != 0 ? i.toString() : ""),
      ),
    );
  }

  Widget _buildRow(
    List<_ElementRange> elementRanges, {
    int row,
    bool lathinides: false,
    bool actinides: false,
  }) {
    List<Widget> contents = new List<Widget>(19);
    for (_ElementRange range in elementRanges) {
      for (int col = range.startCol; col <= range.endCol; col++) {
        contents[col] = _buildCell(ElementSymbol
            .values[range.startSymbol.index + (col - range.startCol)]);
      }
    }
    if (lathinides || actinides) {
      contents[3] = _buildEmptyCell(lathinides ? singleDagger : doubleDagger);
    } else if (row != null) {
      contents[0] = _buildEmptyCell(row.toString());
    }
    for (int col = 0; col < 19; col++) {
      if (contents[col] == null) {
        contents[col] = _buildEmptyCell();
      }
    }
    return new Row(children: contents);
  }

  @override
  Widget build(BuildContext context) {
    return new ListView(scrollDirection: Axis.vertical, children: <Widget>[
      Container(
          height: 11.25 * cellSize,
          child: new ListView(
            scrollDirection: Axis.horizontal,
            children: <Widget>[
              new Column(
                children: <Widget>[
                  _buildGroupNumbersRow(),
                  _buildRow(
                    [
                      new _ElementRange(ElementSymbol.H, 1, 1),
                      new _ElementRange(ElementSymbol.He, 18, 18)
                    ],
                    row: 1,
                  ),
                  _buildRow([
                    new _ElementRange(ElementSymbol.Li, 1, 2),
                    new _ElementRange(ElementSymbol.B, 13, 18)
                  ], row: 2),
                  _buildRow([
                    new _ElementRange(ElementSymbol.Na, 1, 2),
                    new _ElementRange(ElementSymbol.Al, 13, 18)
                  ], row: 3),
                  _buildRow([new _ElementRange(ElementSymbol.K, 1, 18)],
                      row: 4),
                  _buildRow([new _ElementRange(ElementSymbol.Rb, 1, 18)],
                      row: 5),
                  _buildRow([
                    new _ElementRange(ElementSymbol.Cs, 1, 3),
                    new _ElementRange(ElementSymbol.Hf, 4, 18)
                  ], row: 6),
                  _buildRow([
                    new _ElementRange(ElementSymbol.Fr, 1, 3),
                    new _ElementRange(ElementSymbol.Rf, 4, 18)
                  ], row: 7),
                  _buildRow([]),
                  _buildRow([new _ElementRange(ElementSymbol.Ce, 4, 17)],
                      lathinides: true),
                  _buildRow([new _ElementRange(ElementSymbol.Th, 4, 17)],
                      actinides: true)
                ],
              )
            ],
          ))
    ]);
  }
}
