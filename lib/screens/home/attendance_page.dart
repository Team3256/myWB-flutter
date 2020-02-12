import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import 'package:mywb_flutter/models/event.dart';
import 'package:mywb_flutter/utils/config.dart';
import 'package:mywb_flutter/utils/theme.dart';
import 'package:http/http.dart' as http;

import '../../user_info.dart';

class AttendancePage extends StatefulWidget {
  @override
  _AttendancePageState createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {

  bool practiceBool = true;
  bool outreachBool = false;

  int practiceProgress = 0;
  double practiceHours = 0.0;
  double requiredHours = 0.0;

  final GlobalKey<AnimatedCircularChartState> _chartKey = new GlobalKey<AnimatedCircularChartState>();

  Future<void> getPractice() async {
    await http.get("$dbHost/events", headers: {"Authentication": "Bearer $apiKey"}).then((response) async {
      print(response.body);
      print(DateTime.now());
      double requiredPractice = 0;
      var eventsJson = jsonDecode(response.body);
      await http.get("$dbHost/users/${currUser.id}/attendance/excused", headers: {"Authentication": "Bearer $apiKey"}).then((response) async {
        print(response.body);
        var excusedJson = jsonDecode(response.body);
        for (int i = 0; i < eventsJson.length; i++) {
          Event event = new Event(eventsJson[i]);
          print(event.date);
          if (event.date.month == DateTime.now().month && event.date.day >= DateTime.now().day && event.date.day - DateTime.now().day <= 2) {
            print("Added ${event.id} to list");
          }
          if (event.startTime.compareTo(DateTime.now()) < 0 && event.type == "practice") {
            print(event.endTime.difference(event.startTime).inMilliseconds / 3600000);
            requiredPractice += event.endTime.difference(event.startTime).inMilliseconds / 3600000;
            for (int i = 0; i < excusedJson.length; i++) {
              if (excusedJson[i]["eventID"] == event.id && excusedJson[i]["status"] == "verified") {
                print("EXCUSED");
                requiredPractice -= event.endTime.difference(event.startTime).inMilliseconds / 3600000;
//                requiredPractice = requiredPractice;
              }
            }
          }
        }
        print("REQUIRED HOURS FOR USER: " + requiredPractice.toString());
        requiredHours = requiredPractice;
        await http.get("$dbHost/users/${currUser.id}/attendance", headers: {"Authentication": "Bearer $apiKey"}).then((response) async {
          print(response.body);
          double outreachHours = 0;
          double practiceHours = 0;
          var responseJson = jsonDecode(response.body);
          for (int i = 0; i < responseJson.length; i++) {
            if (responseJson[i]["type"] == "outreach") {
              outreachHours += responseJson[i]["hours"];
            }
            else if (responseJson[i]["type"] == "practice") {
              practiceHours += responseJson[i]["hours"];
            }
          }
          print("ATTENDANCE: ${practiceHours / requiredPractice * 100}%");
          this.practiceHours = practiceHours;
          setState(() {
            practiceProgress = (practiceHours / requiredPractice * 100).round();
            print(practiceProgress.toString());
            Color practiceColor = Colors.blueGrey[600];
            if (practiceProgress < 75) {
              practiceColor = Colors.red;
            }
            else if (practiceProgress < 90) {
              practiceColor = Colors.orange;
            }
            else {
              practiceColor = Colors.lightGreen;
            }
            _chartKey.currentState.updateData(<CircularStackEntry>[
              new CircularStackEntry(
                <CircularSegmentEntry>[
                  new CircularSegmentEntry(practiceProgress.toDouble(), practiceColor, rankKey: 'done'),
                  new CircularSegmentEntry(100 - practiceProgress.toDouble(), Colors.blueGrey[600], rankKey: 'remaining'),
                ],
              ),
            ]);
          });
        });
      });
    });
  }

  Future<void> getOutreach() async {
    await http.get("$dbHost/users/${currUser.id}/attendance", headers: {"Authentication": "Bearer $apiKey"}).then((response) async {
      print(response.body);
      double outreachHours = 0;
      var responseJson = jsonDecode(response.body);
      for (int i = 0; i < responseJson.length; i++) {
        if (responseJson[i]["type"] == "outreach") {
          outreachHours += responseJson[i]["hours"];
        }
      }
      print("OUTREACH PROGRESS: ${outreachHours / 50.0 * 100}%");
      practiceHours = outreachHours;
      setState(() {
        practiceProgress = (outreachHours / 50.0 * 100).round();
        print(practiceProgress.toString());
        Color practiceColor = Colors.blueGrey[600];
        if (practiceProgress < 75) {
          practiceColor = Colors.red;
        }
        else if (practiceProgress < 90) {
          practiceColor = Colors.orange;
        }
        else {
          practiceColor = Colors.lightGreen;
        }
        _chartKey.currentState.updateData(<CircularStackEntry>[
          new CircularStackEntry(
            <CircularSegmentEntry>[
              new CircularSegmentEntry(practiceProgress.toDouble(), practiceColor, rankKey: 'done'),
              new CircularSegmentEntry(100 - practiceProgress.toDouble(), Colors.blueGrey[600], rankKey: 'remaining'),
            ],
          ),
        ]);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getPractice();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new CupertinoNavigationBar(
        middle: new Text("Attendance", style: TextStyle(color: Colors.white)),
        previousPageTitle: "Home",
        actionsForegroundColor: Colors.white,
        backgroundColor: mainColor,
      ),
      backgroundColor: currBackgroundColor,
      body: new Container(
        padding: EdgeInsets.only(top: 8.0, right: 8.0, left: 8.0),
        child: new Column(
          children: <Widget>[
            new Row(
              children: <Widget>[
                new Expanded(
                  child: new Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
                    color: practiceBool ? mainColor : currBackgroundColor,
                    elevation: practiceBool ? 6.0 : 0.0,
                    child: new FlatButton(
                        child: new Text("Practice", style: TextStyle(color: practiceBool ? Colors.white : currTextColor)),
                        onPressed: () {
                          setState(() {
                            practiceBool = true;
                            outreachBool = false;
                            getPractice();
                          });
                        }
                    ),
                  ),
                ),
                new Expanded(
                  child: new Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
                    color: outreachBool ? mainColor : currBackgroundColor,
                    elevation: outreachBool ? 6.0 : 0.0,
                    child: new FlatButton(
                        child: new Text("Outreach", style: TextStyle(color: outreachBool ? Colors.white : currTextColor)),
                        onPressed: () {
                          outreachBool = true;
                          practiceBool = false;
                          getOutreach();
                        }
                    ),
                  ),
                ),
              ],
            ),
            new Padding(padding: EdgeInsets.all(4.0)),
            new Container(
              height: 250.0,
              child: new AnimatedCircularChart(
                key: _chartKey,
                size: const Size(250, 250),
                initialChartData: <CircularStackEntry>[
                  new CircularStackEntry(
                    <CircularSegmentEntry>[
                      new CircularSegmentEntry(
                        0.0,
                        Colors.blue[400],
                        rankKey: 'completed',
                      ),
                      new CircularSegmentEntry(
                        100.0,
                        Colors.blueGrey[600],
                        rankKey: 'remaining',
                      ),
                    ],
                    rankKey: 'progress',
                  ),
                ],
                chartType: CircularChartType.Radial,
                percentageValues: true,
                holeLabel: '$practiceProgress%',
                labelStyle: new TextStyle(
                  color: Colors.blueGrey[600],
                  fontWeight: FontWeight.bold,
                  fontSize: 24.0,
                ),
              )
            ),
            new Padding(padding: EdgeInsets.all(4.0)),
            new Visibility(visible: practiceBool, child: new Text("${practiceHours.toStringAsFixed(2)} / $requiredHours hours", style: TextStyle(color: currTextColor),)),
            new Visibility(visible: outreachBool, child: new Text("${practiceHours.toStringAsFixed(2)} / 50 hours", style: TextStyle(color: currTextColor),)),
          ],
        ),
      ),
    );
  }
}
