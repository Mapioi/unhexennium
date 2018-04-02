import 'package:flutter/material.dart';
import 'package:unhexennium/chemistry/element.dart';
import 'package:unhexennium/utils.dart';
import 'dart:async';


// Options for the popup input dialog
enum ElementInputOptions {
  enter,
  cancel
}


class ElementParent extends StatelessWidget {

  ElementParent({Key key, this.selectedElement}) : super(key: key);

  // no element selected => null
  final ChemicalElement selectedElement;

  @override
  Widget build(BuildContext context) {
    // Building the widget
    Widget widgetToReturn;

    List<List<String>> tableData = [
      ["Name", this.selectedElement.name],
      ["Molar Mass", this.selectedElement.relativeAtomicMass.toString()]
    ];

    print(this.selectedElement);
    if (this.selectedElement == null) {
      // fallback if user hasn't inputted an element
      widgetToReturn = new Text(
        "Add an element to see its info",
        style: new TextStyle(color: Colors.grey)
      );
    } else {
      widgetToReturn = new Column(
        children: <Widget>[
          new Card(
            child: new Padding(
              padding: new EdgeInsets.all(16.0),
              child: new Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  // Symbol (ex: He)
                  new Container(
                    // TODO: display A and Z like a periodic table
                    child: new Text(
                      enumToString(this.selectedElement.symbol),
                      style: new TextStyle(
                        fontSize: 56.0,
                        fontFamily: 'Rock Salt',
                        color: Colors.grey[600]
                      ),
                    ),
                    decoration: new BoxDecoration(
                      border: new Border.all(color: Colors.grey[400])
                    ),
                    padding: new EdgeInsets.all(16.0),
                    height: 128.0,
                    width: 128.0,
                    alignment: Alignment.center,
                  ),
                  // Data table (name, Mr, etc)
                  new Padding(
                    padding: new EdgeInsets.all(16.0),
                    child: new Table(
                      border: new TableBorder.all(color: Colors.grey[300]),
                      // TODO resize that so that its not stretched
                      children:
                      tableData.map(
                          (List<String> row) =>
                        new TableRow(
                          children: row.map(
                              (String stringToDisplay) =>
                            new Padding(
                              padding: new EdgeInsets.all(8.0),
                              child: new Text(
                                stringToDisplay,
                                textAlign: TextAlign.center
                              )
                            )
                          ).toList()
                        )
                      ).toList()
                    )
                  )
                ],
              )
            )
          )
        ]
      );
    }

    return new Padding(
      padding: new EdgeInsets.all(16.0),
      child: new Column(
        children: <Widget>[
          // Top part
          widgetToReturn,
          // Spacing
          new SizedBox(height: 16.0),
          // Element button
          new RaisedButton(
            child: new Text(
              "SELECT AN ELEMENT",
              style: new TextStyle(color: Colors.white),
            ),
            onPressed: () => null,
            color: Colors.blueAccent,
          )
        ],
      )
    );
  }

//  Future<Null> _elementPrompt() async {
//    await showDialog<ElementSymbol>(
//      context: context,
//      child: new SimpleDialog(
//        title: const Text('Select Element'),
//        children: <Widget>[
//          new Text("<insert periodic table>")
//        ],
//      ),
//    );
//  }

}
