import 'package:flutter/material.dart';
import 'package:unhexennium/chemistry/element.dart';
import 'package:unhexennium/utils.dart';
import 'dart:async';


// Options for the popup input dialog
enum ElementInputOptions {
  enter,
  cancel
}


class ElementParent extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _ElementParentState();
}


class _ElementParentState extends State<ElementParent> {

  // no element selected => null
  ChemicalElement selectedElement = new ChemicalElement(ElementSymbol.H);

  @override
  Widget build(BuildContext context) {
    Widget widgetToReturn;
    print(this.selectedElement);
    if (this.selectedElement == null) {
      // fallback if user hasn't inputted an element
      widgetToReturn = new Text(
        "Add an element to see its info",
        style: new TextStyle(color: Colors.grey)
      );
    } else {
      widgetToReturn = new Column(
        children: [
          new Card(
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
                    // TODO resize that so that its not stretched
                    children: [
                      new TableRow(children: [
                        new Text("Name"),
                        new Text(this.selectedElement.name)
                      ]),
                      new TableRow(children: [
                        new Text("Molar mass"),
                        new Text(
                          this.selectedElement.relativeAtomicMass.toString()
                        )
                      ])
                    ]
                  )
                )
              ],
            )
          ),
          new RaisedButton(
            child: new Text(
              "ADD ELEMENT",
              style: new TextStyle(color: Colors.white),
            ),
            onPressed: _elementPrompt,
            color: Colors.blueAccent,
          )
        ]
      );
    }

    return new Padding(
      padding: new EdgeInsets.all(8.0),
      child: widgetToReturn
    );
  }

  Future<Null> _elementPrompt() async {
    await showDialog<ElementSymbol>(
      context: context,
      child: new SimpleDialog(
        title: const Text('Select assignment'),
        children: <Widget>[
          new Text("HEY THERE")
        ],
      ),
    );
  }
}

