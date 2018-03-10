import 'package:flutter/material.dart';

enum Mode { Default, Element, Formula, Equation }

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Mode _mode = Mode.Default;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Unhexennium"),
        ),
        body: new Center(
          child: new Text(_mode.toString()),
        ));
  }
}
