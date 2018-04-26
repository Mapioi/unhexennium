import 'package:flutter/material.dart';

class StaticTable extends StatelessWidget {
  final Map<Widget, Widget> data;
  static final TextStyle head = new TextStyle(fontWeight: FontWeight.bold);
  static final TextStyle formula = new TextStyle(
    fontFamily: 'Stix2Math',
    /*fontSize: 18.0,
    fontStyle: FontStyle.normal,*/
  );

  StaticTable(this.data);

  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: new EdgeInsets.all(16.0),
      child: DataTable(
        columns: [
          new DataColumn(
            label: new Text("Property"),
            onSort: (i, b) => null,
          ),
          new DataColumn(
            label: new Text("Value"),
            onSort: (i, b) => null,
          )
        ],
        rows: data.entries
            .map((var entry) => new DataRow(cells: [
                  new DataCell(
                    entry.key,
                    onTap: () => null,
                  ),
                  new DataCell(
                    entry.value,
                    onTap: () => null,
                  ),
                ]))
            .toList(),
      ),
    );
  }
}
