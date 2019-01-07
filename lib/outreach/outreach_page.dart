import 'package:flutter/material.dart';
import 'package:mywb_flutter/theme.dart';
import 'package:mywb_flutter/user_info.dart';
import 'package:mywb_flutter/user_drawer.dart';

class OutreachPage extends StatefulWidget {
  @override
  _OutreachPageState createState() => _OutreachPageState();
}

class _OutreachPageState extends State<OutreachPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Outreach"),
        backgroundColor: mainColor,
      ),
      drawer: new UserDrawer(),
      body: new Container(
        color: Colors.white,
        child: new Center(
          child: new Text("Outreach"),
        ),
      ),
    );
  }
}
