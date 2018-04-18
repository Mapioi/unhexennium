import 'package:flutter/material.dart';

class StaticTable extends StatelessWidget {
  final Map<Widget, Widget> data;
  static final TextStyle head = new TextStyle(fontWeight: FontWeight.bold);

  StaticTable(this.data);

  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: new EdgeInsets.all(16.0),
      child: Table(
          border: new TableBorder.all(color: Colors.grey[300]),
          children: data.entries
              .map((MapEntry<Widget, Widget> row) => new TableRow(
                    children: <Widget>[
                      new Padding(
                        padding: new EdgeInsets.all(8.0),
                        child: row.key,
                      ),
                      new Padding(
                        padding: new EdgeInsets.all(8.0),
                        child: row.value,
                      )
                    ],
                  ))
              .toList()
          ),
    );
  }
}
