import 'package:flutter/material.dart';

class StaticTable extends StatelessWidget {
  final List<List<Widget>> data;

  StaticTable(this.data);

  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: new EdgeInsets.all(16.0),
        child: Table(
      border: new TableBorder.all(color: Colors.grey[300]),
      children: data
          .map((List<Widget> row) => new TableRow(
                children: row
                    .map((Widget cell) => new Padding(
                          padding: new EdgeInsets.all(8.0),
                          child: cell,
                        ))
                    .toList(growable: false),
              ))
          .toList(growable: false),
    ),);
  }
}
