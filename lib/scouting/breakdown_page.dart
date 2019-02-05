import 'package:flutter/material.dart';
import 'package:mywb_flutter/theme.dart';
import 'package:mywb_flutter/user_info.dart';
import 'package:timeline_list/timeline.dart';
import 'dart:convert';
import 'package:fluro/fluro.dart';

class BreakdownPage extends StatefulWidget {
  @override
  _BreakdownPageState createState() => _BreakdownPageState();
}

class _BreakdownPageState extends State<BreakdownPage> {
  
  String jsonSummary = "";
  Match myMatch = new Match();

  Color getAllianceColor() {
    if (currAlliance == "Blue") {
      return Colors.lightBlue;
    }
    else {
      return Colors.red;
    }
  }

  @override
  void initState() {
    super.initState();
    // Initialize Match Object
    myMatch.matchNumber = int.parse(currMatch);
    myMatch.regionalKey = currRegional;
    myMatch.teamKey = int.parse(currTeam);
    myMatch.alliance = currAlliance;
    print(jsonEncode(auto));
    setState(() {
      jsonSummary += "Event 1:\n${jsonEncode(auto).toString()}";
    });
    for (int i = 0; i < matchEventList.length; i++) {
      print("${matchEventList[i].runtimeType}: ${jsonEncode(matchEventList[i])}");
      setState(() {
        jsonSummary += "Event ${i + 2}:\n${jsonEncode(matchEventList[i]).toString()}\n";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Match $currMatch"),
        backgroundColor: getAllianceColor(),
        elevation: 0.0,
      ),
      floatingActionButton: new FloatingActionButton.extended(
        icon: new Icon(Icons.save),
        label: new Text("Save"),
        onPressed: () {
          // TODO: handle database upload here
        },
      ),
      body: new Container(
        child: new Column(
          children: <Widget>[
            new Container(
              padding: EdgeInsets.all(16.0),
              color: getAllianceColor(),
              height: 75.0,
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  new Text(
                    currTeam,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 35.0
                    ),
                  ),
                  new Text(
                    "$currAlliance Alliance",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w100,
                        fontSize: 35.0
                    ),
                  )
                ],
              ),
            ),
            new Expanded(
              child: SingleChildScrollView(
                child: new Text(jsonSummary)
              ),
            )
          ],
        ),
      ),
    );
  }
}