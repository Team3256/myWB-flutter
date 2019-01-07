import 'package:flutter/material.dart';
import 'package:mywb_flutter/user_info.dart';
import 'package:mywb_flutter/theme.dart';
import 'package:mywb_flutter/user_drawer.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Home"),
        backgroundColor: mainColor,
      ),
      drawer: new UserDrawer(),
      body: new Container(
        color: Colors.white,
        child: new Center(
          child: new Text("Home"),
        ),
      ),
    );
  }
}
