import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mywb_flutter/models/autoline.dart';
import 'package:mywb_flutter/models/match_data.dart';
import 'package:mywb_flutter/models/match.dart';
import 'package:mywb_flutter/theme/colors.dart';
import 'package:mywb_flutter/user_info.dart';
import 'dart:convert';
import 'package:timeline/timeline.dart';
import 'package:timeline/model/timeline_model.dart';
import 'package:fluro/fluro.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart' as http;
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:convert';
import 'dart:io';

class BreakdownPage extends StatefulWidget {
  @override
  _BreakdownPageState createState() => _BreakdownPageState();
}

class _BreakdownPageState extends State<BreakdownPage> {

  Match myMatch = new Match();
  MatchData myMatchData = new MatchData();

  final databaseRef = FirebaseDatabase.instance.reference();

  Widget _breakdownWidget = new Container();

  Color breakdownBtnColor = mainColor;
  Color breakdownBtnText = Colors.white;
  Color qrBtnText = currTextColor;
  Color qrBtnColor = currBackgroundColor;

  Color getAllianceColor() {
    if (currAlliance == "Blue") {
      return Colors.lightBlue;
    }
    else {
      return Colors.red;
    }
  }

  List<TimelineModel> breakdownList = new List();

  void uploadErrorDialog(String error) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          backgroundColor: currBackgroundColor,
          title: new Text("Ruh-roh!", style: TextStyle(color: currTextColor),),
          content: new Text(
            "It looks like an error occurred trying to upload your match: $error",
            style: TextStyle(color: currTextColor),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text("DONE"),
              onPressed: () {
                router.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  void matchExistError() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          backgroundColor: currBackgroundColor,
          title: new Text("Bruh, that's a wong move", style: TextStyle(color: currTextColor),),
          content: new Text(
            "Scouting data for this match already exists. LOL, how did you screw up this badly?",
            style: TextStyle(color: currTextColor),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text("DONE"),
              onPressed: () {
                autoLine = false;
                auto = new AutoLine(habLevel, 0.0, false);
                dcList.clear();
                hatchList.clear();
                cargoList.clear();
                foulList.clear();
                climbList.clear();
                stopwatch.stop();
                stopwatch.reset();
                dcStopwatch.stop();
                dcStopwatch.reset();
                hatchStopwatch.stop();
                hatchStopwatch.reset();
                cargoStopwatch.stop();
                cargoStopwatch.reset();
                databaseRef.child("regionals").child(currRegional.key).child("currMatches").child(currMatchKey).remove();
                router.navigateTo(context, '/home', transition: TransitionType.fadeIn);
              },
            )
          ],
        );
      },
    );
  }

  void uploadSuccess(String matchRef, String name) {
    // flutter defined function
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          backgroundColor: currBackgroundColor,
          title: new Text("Match Upload Success", style: TextStyle(color: currTextColor),),
          content: new Text(
            "Match $matchRef has been successfully uploaded to the server by $name!",
            style: TextStyle(color: currTextColor),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text("DONE"),
              onPressed: () {
                autoLine = false;
                auto = new AutoLine(habLevel, 0.0, false);
                dcList.clear();
                hatchList.clear();
                cargoList.clear();
                foulList.clear();
                climbList.clear();
                stopwatch.stop();
                stopwatch.reset();
                dcStopwatch.stop();
                dcStopwatch.reset();
                hatchStopwatch.stop();
                hatchStopwatch.reset();
                cargoStopwatch.stop();
                cargoStopwatch.reset();
                router.navigateTo(context, '/home', transition: TransitionType.fadeIn);
              },
            )
          ],
        );
      },
    );
  }

  Future uploadMatch() async {
    // Stop match timer
    stopwatch.stop();
    // Handle DB Upload
    var postMatchUrl = "${dbHost}api/scouting/match/";
    try {
      http.post(postMatchUrl, body: jsonEncode(myMatch), headers: {HttpHeaders.authorizationHeader: "Bearer $authToken", HttpHeaders.contentTypeHeader: "application/json"}).then((response) {
        print(response.body);
        var uploadResponse = jsonDecode(response.body);
        if (uploadResponse["error"] != null) {
          // Whoops, an error occurred!
          if (uploadResponse["error"] == "Conflict") {
            matchExistError();
          }
          else {
            uploadErrorDialog(uploadResponse["message"]);
          }
        }
        else {
          print("Successfully uploaded match!");
          databaseRef.child("regionals").child(currRegional.key).child("currMatches").child(currMatchKey).remove();
          uploadSuccess(uploadResponse["id"], (uploadResponse["scoutedBy"]["firstName"] + " " + uploadResponse["scoutedBy"]["lastName"]));
        }
      });
    }
    catch (error) {
      print(error);
    }
  }

  @override
  void initState() {
    super.initState();
    // Initialize Match Object
    myMatch.matchNumber = int.parse(currMatch);
    myMatch.regionalKey = currRegional.key;
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
    setState(() {
      _breakdownWidget = new GestureDetector(
          onTap: () {
            Clipboard.setData(new ClipboardData(text: jsonEncode(myMatch).toString()));
            print("Copied!");
          },
          child: new Text(jsonEncode(myMatch).toString(), style: TextStyle(color: currTextColor),)
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Match $currMatch"),
        backgroundColor: getAllianceColor(),
        elevation: 0.0,
      ),
      backgroundColor: currBackgroundColor,
      floatingActionButton: new FloatingActionButton.extended(
        icon: new Icon(Icons.save),
        label: new Text("Save"),
        onPressed: uploadMatch,
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
              child: Container(
                padding: EdgeInsets.all(16.0),
                child: new Column(
                  children: <Widget>[
                    new Row(
                      children: <Widget>[
                        new Expanded(
                          child: new FlatButton(
                            child: new Text("Breakdown"),
                            color: breakdownBtnColor,
                            textColor: breakdownBtnText,
                            onPressed: () {
                              setState(() {
                                breakdownBtnColor = mainColor;
                                breakdownBtnText = Colors.white;
                                qrBtnColor = currBackgroundColor;
                                qrBtnText = currTextColor;
                                _breakdownWidget = new GestureDetector(
                                  onTap: () {
                                    Clipboard.setData(new ClipboardData(text: jsonEncode(myMatch).toString()));
                                    print("Copied!");
                                  },
                                  child: new Text(jsonEncode(myMatch).toString(), style: TextStyle(color: currTextColor),)
                                );
                              });
                            },
                          ),
                        ),
                        new Expanded(
                          child: new FlatButton(
                            child: new Text("QR Code"),
                            color: qrBtnColor,
                            textColor: qrBtnText,
                            onPressed: () {
                              setState(() {
                                breakdownBtnColor = currBackgroundColor;
                                breakdownBtnText = currTextColor;
                                qrBtnColor = mainColor;
                                qrBtnText = Colors.white;
                                _breakdownWidget = new Text("qr code here");
                              });
                            },
                          ),
                        )
                      ],
                    ),
                    new Padding(padding: EdgeInsets.all(8.0),),
                    _breakdownWidget
                  ],
                ),
              )
            )
          ],
        ),
      ),
    );
  }
}