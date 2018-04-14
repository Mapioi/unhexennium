import 'dart:async';
import 'package:flutter/material.dart';
import 'package:unhexennium/chemistry/element.dart';
import 'package:unhexennium/utils.dart';


typedef void ElementChooserCallback(ElementSymbol x, int subscript);


class ElementSelector extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _ElementSelector();
}

class _ElementSelector extends State<ElementSelector> {
  ElementSymbol selectedElementSymbol;
  int selectedSubscript = 1;

  @override
  Widget build(BuildContext context) {
    return new SimpleDialog(
      title: const Text('Select element & stuff'),
      children: <Widget>[
        new Container(
          width: 100.0,
          height: 100.0,
          padding: new EdgeInsets.all(4.0),
          child: new ListView(
            padding: const EdgeInsets.all(16.0),
            children: ElementSymbol.values.map((e) => new FlatButton(
              onPressed: () {
                setState(() {
                  selectedElementSymbol = e;
                });
              },
              // Navigator.pop(context, [e, 1])
              color: selectedElementSymbol == e ? Colors.blueGrey : null,
              child: new Text(enumToString(e))
            )).toList()
          )
        ),
        new SimpleDialogOption(
          onPressed: () { Navigator.pop(
            context, [selectedElementSymbol, selectedSubscript]
          ); },
          child: const Text('CONTINUE'),
        )
      ]
    );
  }
}


Future<Null> askForElementSymbol(
  BuildContext context, ElementChooserCallback f
  ) async {

  List result = await showDialog<List>(
    context: context,
    builder: (BuildContext context) {
      return new ElementSelector();
    }
  );

  f(result[0], result[1]);
}
