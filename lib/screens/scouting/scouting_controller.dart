import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mywb_flutter/screens/scouting/auto_page.dart';
import 'package:mywb_flutter/screens/scouting/teleop_page.dart';
import 'package:mywb_flutter/user_info.dart';
import 'package:mywb_flutter/utils/config.dart';
import 'package:mywb_flutter/utils/theme.dart';

class ScoutingController extends StatefulWidget {
  @override
  _ScoutingControllerState createState() => _ScoutingControllerState();
}

class _ScoutingControllerState extends State<ScoutingController> {

  final _pageController = new PageController();
  final databaseRef = FirebaseDatabase.instance.reference();

  String title = "Match ${currMatch} - ";

  Timer _timer;
  double _progress = 0.0;

  String state = "auto";

  Widget doneButton = null;

  Color getAllianceColor() {
    if (currMatch.matchData.alliance == "Blue") {
      return Colors.lightBlue;
    }
    else {
      return Colors.red;
    }
  }

  exitScoutingBottomSheet() {
    showCupertinoModalPopup(
        context: context,
        builder: (builder) {
          return CupertinoActionSheet(
            title: new Text("Are you sure you want to exit this match?"),
            actions: <Widget>[
              new CupertinoActionSheetAction(
                child: new Text("Yes"),
                isDestructiveAction: true,
                onPressed: () {
                  databaseRef.child("regionals").child(currRegional.id).child("currMatches").child(currMatch.id).remove();
                  stopwatch.stop();
                  stopwatch.reset();
                  router.pop(context);
                  router.pop(context);
                },
              ),
            ],
            cancelButton: new CupertinoActionSheetAction(
              child: new Text("Cancel"),
              isDefaultAction: true,
              onPressed: () {
                router.pop(context);
              },
            )
          );
        }
    );
  }

  @override
  void initState() {
    super.initState();
    stopwatch.reset();
//    stopwatch.start();
    _timer = new Timer.periodic(new Duration(milliseconds: 100), getTimer);
  }

  @override
  void dispose() {
    super.dispose();
    stopwatch.stop();
    stopwatch.reset();
    _timer.cancel();
  }

  void getTimer(Timer timer) {
    if (stopwatch.isRunning) {
      if (stopwatch.elapsedMilliseconds >= 15000 && stopwatch.elapsedMilliseconds <= 15300) {
        print("AUTO OVER!");
        state = "teleop";
//        _pageController.animateToPage(1, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      }
      if (stopwatch.elapsedMilliseconds >= 150000 && stopwatch.elapsedMilliseconds <= 150300) {
        print("MATCH OVER!");
        setState(() {
          state = "end";
          doneButton = new FloatingActionButton.extended(
            icon: new Text(""),
            label: new Text("Review ", style: TextStyle(color: Colors.white),),
            onPressed: () {
//              print("${matchEventList.length + 1} EVENTS DETECTED");
              router.navigateTo(context, '/scouting/breakdown', transition: TransitionType.native);
            },
          );
        });
      }
      setState(() {
        // Un-Comment Line Below for Debug Timer Values
        print(stopwatch.elapsedMilliseconds / 1000);
        _progress = stopwatch.elapsedMilliseconds / 150000;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: () => exitScoutingBottomSheet(),
      child: Scaffold(
        appBar: new AppBar(
          title: new Text("${currMatch.id.contains("p")?"Practice ":""}Match ${currMatch.matchNum} - ${((150000 - stopwatch.elapsedMilliseconds)/1000).round()} sec"),
          backgroundColor: getAllianceColor(),
          elevation: 0.0,
          leading: new IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              exitScoutingBottomSheet();
            },
          ),
        ),
        floatingActionButton: doneButton,
        backgroundColor: currBackgroundColor,
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
                      currMatch.matchData.teamID,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 35.0
                      ),
                    ),
                    new Text(
                      "${currMatch.matchData.alliance} Alliance",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w100,
                          fontSize: 35.0
                      ),
                    )
                  ],
                ),
              ),
              new Container(
                padding: EdgeInsets.all(16.0),
                height: 75.0,
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(16.0)),
                      child: new Container(
                        height: 20.0,
                        child: new LinearProgressIndicator(
                          backgroundColor: currCardColor,
                          value: _progress,
                        ),
                      ),
                    ),
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        new Text("Autonomous", style: TextStyle(color: state == "auto" ? mainColor : currDividerColor)),
                        new Text("TeleOp + Endgame", style: TextStyle(color: state == "teleop" ? mainColor : currDividerColor),),
                        new Text("Game Over!", style: TextStyle(color: state == "end" ? mainColor : currDividerColor),),
                      ],
                    )
                  ],
                ),
              ),
              new Expanded(
                child: new PageView(
                  controller: _pageController,
                  physics: NeverScrollableScrollPhysics(),
                  children: <Widget>[
                  new AutoPage(),
                  new TeleopPage(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
