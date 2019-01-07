import 'package:flutter/material.dart';
import 'package:mywb_flutter/user_info.dart';
import 'package:mywb_flutter/user_drawer.dart';
import 'package:mywb_flutter/theme.dart';

class ScoutPage extends StatefulWidget {
  @override
  _ScoutPageState createState() => _ScoutPageState();
}

class _ScoutPageState extends State<ScoutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Scouting"),
        backgroundColor: mainColor,
      ),
      drawer: new UserDrawer(),
      body: new Container(
        color: Colors.white,
        child: new Center(
          child: new Text("Scouting"),
        ),
      ),
    );
  }
}
