import 'package:flutter/material.dart';
import 'package:mywb_flutter/user_info.dart';
import 'package:mywb_flutter/user_drawer.dart';
import 'package:mywb_flutter/theme.dart';

class ScoutPage extends StatefulWidget {
  @override
  _ScoutPageState createState() => _ScoutPageState();
}

class Scoutable {
  int teamNumber;
  String alliance;
  int match;
}

class _ScoutPageState extends State<ScoutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Scouting"),
        backgroundColor: mainColor,
      ),
      floatingActionButton: new FloatingActionButton(
        child: new Icon(Icons.add),
        backgroundColor: mainColor,
        onPressed: () {},
      ),
      drawer: new UserDrawer(),
      body: new Container(
        padding: EdgeInsets.all(16.0),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Text("Current", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),),
            new Padding(padding: EdgeInsets.all(8.0)),
            new ListView.builder(

            )
            new Padding(padding: EdgeInsets.all(8.0)),
            new Divider(color: mainColor,)
          ],
        ),
      ),
    );
  }
}
