import 'dart:async';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:mywb_flutter/models/autoline.dart';
import 'package:mywb_flutter/screens/scouting/sandstorm_page.dart';
import 'package:mywb_flutter/screens/scouting/teleop_page.dart';
import 'package:mywb_flutter/theme/colors.dart';
import 'package:mywb_flutter/user_info.dart';
import 'package:flutter/cupertino.dart';

class ScoutingController extends StatefulWidget {
  @override
  _ScoutingControllerState createState() => _ScoutingControllerState();
}

class _ScoutingControllerState extends State<ScoutingController> {

  final _pageController = new PageController();
  final databaseRef = FirebaseDatabase.instance.reference();

  String title = "Match $currMatch - ";
  int state = 0;

  double _progress = 0.0;

  Color sandstormColor = mainColor;
  Color teleopColor = currCardColor;
  Color gameOver = currCardColor;

  Widget doneButton = null;

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
    stopwatch.reset();
    stopwatch.start();
    new Timer.periodic(new Duration(milliseconds: 100), getTimer);
    auto = new AutoLine(habLevel, 0.0, false);
  }

  void getTimer(Timer timer) {
    if (stopwatch.isRunning) {
      if (stopwatch.elapsedMilliseconds >= 15000 && stopwatch.elapsedMilliseconds <= 15300) {
        print("SANDSTORM OVER!");
        sandstormColor = currCardColor;
        teleopColor = mainColor;
        _pageController.animateToPage(1, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      }
      if (stopwatch.elapsedMilliseconds >= 150000 && stopwatch.elapsedMilliseconds <= 150300) {
        print("MATCH OVER!");
        setState(() {
          teleopColor = currCardColor;
          gameOver = mainColor;
          doneButton = new FloatingActionButton.extended(
            icon: new Text(""),
            label: new Text("Review ", style: TextStyle(color: Colors.white),),
            onPressed: () {
              print("${matchEventList.length + 1} EVENTS DETECTED");
              router.navigateTo(context, '/breakdown', transition: TransitionType.native);
            },
          );
        });
        stopwatch.stop();
      }
      setState(() {
        // Un-Comment Line Below for Debug Timer Values
//        print(stopwatch.elapsedMilliseconds / 1000);
        _progress = stopwatch.elapsedMilliseconds / 150000;
        title = "Match $currMatch - ${((150000 - stopwatch.elapsedMilliseconds)/1000).round()} sec";
      });
    }
  }

  void exitScoutingBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (builder){
          return Container(
            color: currBackgroundColor,
            child: SafeArea(
              child: Container(
                color: currBackgroundColor,
                child: new Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    new ListTile(
                      title: new Text("Are you sure you want to exit this match?", style: TextStyle(fontFamily: "Product Sans", color: currTextColor)),
                    ),
                    new ListTile(
                      leading: new Icon(Icons.check, color: currDividerColor,),
                      title: new Text('Yes, get me outta here!', style: TextStyle(fontFamily: "Product Sans", color: currTextColor)),
                      onTap: () {
                        autoLine = false;
                        auto = new AutoLine(habLevel, 0.0, false);
                        dcList.clear();
                        hatchList.clear();
                        cargoList.clear();
                        foulList.clear();
                        stopwatch.stop();
                        stopwatch.reset();
                        dcStopwatch.stop();
                        dcStopwatch.reset();
                        hatchStopwatch.stop();
                        hatchStopwatch.reset();
                        cargoStopwatch.stop();
                        cargoStopwatch.reset();
                        databaseRef.child("regionals").child(currRegional.key).child("currMatches").child(currMatchKey).remove();
                        router.navigateTo(context, '/logged', clearStack: true, transition: TransitionType.inFromLeft);
                      },
                    ),
                    new ListTile(
                      leading: new Icon(Icons.clear, color: currDividerColor,),
                      title: new Text('Cancel', style: TextStyle(fontFamily: "Product Sans", color: currTextColor)),
                      onTap: () {
                        router.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text(title),
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
                      new Text("Sandstorm", style: TextStyle(color: sandstormColor)),
                      new Text("TeleOp + Endgame", style: TextStyle(color: teleopColor),),
                      new Text("Game Over!", style: TextStyle(color: gameOver),),
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
                  new SandstormPage(),
                  new TeleopPage(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
