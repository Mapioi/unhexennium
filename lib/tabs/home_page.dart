import 'package:flutter/material.dart';

// constants
enum Mode { Element, Formula, Equation }

const default_mode = Mode.Element;

// utils
String enumToString(enumElement) => enumElement.toString().split(".")[1];

// ui
class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Mode _mode = default_mode;

  @override
  Widget build(BuildContext context) {
    return new DefaultTabController(
      length: Mode.values.length,
      child: new Scaffold(
        appBar: new AppBar(
          title: new Text("Unhexennium"),
          bottom: new TabBar(
            isScrollable: true,
            tabs: Mode.values.map((Mode tabTitle) {
              return new Tab(
                  text: enumToString(tabTitle)
              );
            }).toList(),
          ),
        ),
        // content
        body: new TabBarView(
          children: Mode.values.map((Mode tabTitle) {
            return new Padding(
              padding: const EdgeInsets.all(16.0),
              child: new Text(enumToString(tabTitle)),
            );
          }).toList(),
        ),
      ),
    );
  }
}
