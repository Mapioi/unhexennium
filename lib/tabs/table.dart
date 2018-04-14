import 'package:flutter/material.dart';

class StaticTable extends StatelessWidget {
  final List<List<String>> data;
  static final TextStyle bold = new TextStyle(fontWeight: FontWeight.bold);

  StaticTable(this.data);

  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: new EdgeInsets.all(16.0),
      child: Table(
        border: new TableBorder.all(color: Colors.grey[300]),
        children: data
            .map((List<String> row) => new TableRow(
                  children: <Widget>[
                    new Padding(
                      padding: new EdgeInsets.all(8.0),
                      child: new Text(
                        row[0],
                        /*textAlign: TextAlign.center,*/
                        style: bold,
                      ),
                    ),
                    new Padding(
                      padding: new EdgeInsets.all(8.0),
                      child: new Text(
                        row[1],
                        /*textAlign: TextAlign.center,*/
                      ),
                    ),
                  ],
                ))
            .toList(),
      ),
    );
  }
}
