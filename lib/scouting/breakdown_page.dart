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
    print(jsonEncode(auto));
    setState(() {
      jsonSummary += "${jsonEncode(auto).toString()}";
    });
    for (int i = 0; i < matchEventList.length; i++) {
      print(jsonEncode(matchEventList[i]));
      setState(() {
        jsonSummary += "/n${jsonEncode(matchEventList[i]).toString()}";
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
              child: Center(
                child: new Text(jsonSummary)
              ),
            )
          ],
        ),
      ),
    );
  }
}