import 'package:flutter/material.dart';
import 'package:mywb_flutter/theme.dart';
import 'package:mywb_flutter/user_info.dart';
import 'dart:convert';
import 'package:timeline/timeline.dart';
import 'package:timeline/model/timeline_model.dart';
import 'package:fluro/fluro.dart';

class BreakdownPage extends StatefulWidget {
  @override
  _BreakdownPageState createState() => _BreakdownPageState();
}

class _BreakdownPageState extends State<BreakdownPage> {
  
  Match myMatch = new Match();

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
    print(jsonEncode(auto));
    for (int i = 0; i < matchEventList.length; i++) {
      print("${matchEventList[i].runtimeType}: ${jsonEncode(matchEventList[i])}");
      if (matchEventList[i].runtimeType == Disconnect) {
        // Add disconnect stuff to timeline
        setState(() {
          breakdownList.add(new TimelineModel(id: i.toString(), title: "${matchEventList[i].startTime} - Robot Disconnected", description: "Team $currTeam's robot disconnected for ${matchEventList[i].duration} seconds."));
        });
      }
      else if (matchEventList[i].runtimeType == Hatch || matchEventList[i].runtimeType == Cargo) {
        // Add hatch stuff to timeline
        setState(() {
          breakdownList.add(new TimelineModel(id: i.toString(), title: "${matchEventList[i].pickupTime} - Picked up ${matchEventList[i].runtimeType} from ${matchEventList[i].pickup}", description: ""));
          if (matchEventList[i].dropOff != "Dropped") {
            breakdownList.add(new TimelineModel(id: i.toString(), title: "${matchEventList[i].pickupTime + matchEventList[i].cycleTime} - Dropped off ${matchEventList[i].runtimeType} at ${matchEventList[i].dropOff}", description: ""));
          }
          else {
            breakdownList.add(new TimelineModel(id: i.toString(), title: "${matchEventList[i].pickupTime + matchEventList[i].cycleTime} - Dropped ${matchEventList[i].runtimeType}", description: ""));
          }
        });
      }
      else if (matchEventList[i].runtimeType == Foul) {
        setState(() {
          breakdownList.add(new TimelineModel(id: i.toString(), title: "${matchEventList[i].time} - Foul", description: "Reason for foul: ${matchEventList[i].reason}"));
        });
      }
      else if (matchEventList[i].runtimeType == Climb) {
        setState(() {
          breakdownList.add(new TimelineModel(id: i.toString(), title: "${matchEventList[i].time} - ", description: ""));
        });
      }
    }
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