import 'package:flutter/material.dart';
import 'package:unhexennium/chemistry/element.dart';
import 'package:unhexennium/utils.dart';


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
      widgetToReturn = new Text("Add an element to see its info");
    } else {
      widgetToReturn = new Column(
        children: [
          new Card(
            child: new Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                // Symbol
                new Container(
                  child: new Text(
                    enumToString(this.selectedElement.symbol)
                  ),
                  padding: new EdgeInsets.all(8.0),
                  height: 128.0,
                  width: 128.0,
                ),
                // Data table
                new Table(children: [
                  new TableRow(children: [
                    new Text("Name"),
                    new Text(this.selectedElement.name)
                  ]),
                  new TableRow(children: [
                    new Text("Molar mass"),
                    new Text(this.selectedElement.relativeAtomicMass.toString())
                  ])
                ])
              ],
            )
          )
        ]
      );
    }

    return new Padding(
      padding: new EdgeInsets.all(8.0),
      child: widgetToReturn
    );
  }
}