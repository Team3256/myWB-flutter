import 'package:flutter/material.dart';
import 'package:mywb_flutter/theme.dart';

class TeamsPage extends StatefulWidget {
  @override
  _TeamsPageState createState() => _TeamsPageState();
}

class Team {

}

class _TeamsPageState extends State<TeamsPage> {

  List<Team> teamsList = new List();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Teams"),
        backgroundColor: mainColor,
      ),
      body: new Container(
        padding: EdgeInsets.all(8.0),
        child: new ListView.builder(
          itemCount: ,
        ),
      ),
    );
  }
}
