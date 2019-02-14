import 'package:flutter/material.dart';
import 'package:mywb_flutter/theme.dart';
import 'package:mywb_flutter/user_info.dart';
import 'dart:convert';
import 'package:timeline/timeline.dart';
import 'package:timeline/model/timeline_model.dart';
import 'package:fluro/fluro.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class BreakdownPage extends StatefulWidget {
  @override
  _BreakdownPageState createState() => _BreakdownPageState();
}

class _BreakdownPageState extends State<BreakdownPage> {
  
  Match myMatch = new Match();
  MatchData myMatchData = new MatchData();

  Color getAllianceColor() {
    if (currAlliance == "Blue") {
      return Colors.lightBlue;
    }
    else {
      return Colors.red;
    }
  }

  List<TimelineModel> breakdownList = new List();

  @override
  void initState() {
    super.initState();
    // Initialize Match Object
    myMatch.matchNumber = int.parse(currMatch);
    myMatch.regionalKey = currRegional;
    myMatch.teamKey = int.parse(currTeam);
    myMatch.alliance = currAlliance;
    // Calculate Match Stats
    hatchList.forEach((hatch) {
      if (hatch.dropOff != "Dropped") {
        myMatchData.hatchCount++;
        // Update Averages
        myMatchData.avgHatch = (myMatchData.avgHatch * (myMatchData.hatchCount - 1) + hatch.cycleTime) / myMatchData.hatchCount;
      }
    });
    cargoList.forEach((cargo) {
      if (cargo.dropOff != "Dropped") {
        myMatchData.cargoCount++;
        // Update Averages
        myMatchData.avgCargo = (myMatchData.avgCargo * (myMatchData.cargoCount - 1) + cargo.cycleTime) / myMatchData.cargoCount;
      }
    });
    // Add MatchData to object
    myMatch.matchData = myMatchData;
    print(jsonEncode(myMatch));
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
        onPressed: () async {
          // TODO: handle database upload here
          var postMatchUrl = "${dbHost}api/scouting/match/";
          try {
            http.post(postMatchUrl, body: jsonEncode(myMatch), headers: {HttpHeaders.authorizationHeader: "Bearer $authToken", HttpHeaders.contentTypeHeader: "application/json"}).then((response) {
              print(response.body);
              var uploadResponse = jsonDecode(response.body);
              if (uploadResponse["error"] != null) {
                // Whoops, an error occurred!

              }
            });
          }
          catch (error) {
            print(error);
          }
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
              child: new TimelineComponent(
                timelineList: breakdownList,
              ),
            )
          ],
        ),
      ),
    );
  }
}