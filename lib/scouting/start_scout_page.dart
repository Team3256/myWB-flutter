import 'dart:async';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:mywb_flutter/scouting/sandstorm.dart';
import 'package:mywb_flutter/scouting/teleop.dart';
import 'package:mywb_flutter/theme.dart';
import 'package:mywb_flutter/user_info.dart';
import 'package:flutter/cupertino.dart';

class ScoutPageOne extends StatefulWidget {
  @override
  _ScoutPageOneState createState() => _ScoutPageOneState();
}

class _ScoutPageOneState extends State<ScoutPageOne> {

  final _pageController = new PageController();

  String title = "Match $currMatch - ";
  int state = 0;

  double _progress = 0.0;

  Color sandstormColor = mainColor;
  Color teleopColor = greyAccent;
  Color gameOver = greyAccent;

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
  }

  void getTimer(Timer timer) {
    if (stopwatch.isRunning) {
      if (stopwatch.elapsedMilliseconds >= 15000 && stopwatch.elapsedMilliseconds <= 15300) {
        print("SANDSTORM OVER!");
        sandstormColor = greyAccent;
        teleopColor = mainColor;
        _pageController.animateToPage(1, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      }
      if (stopwatch.elapsedMilliseconds >= 150000 && stopwatch.elapsedMilliseconds <= 150300) {
        print("MATCH OVER!");

      }
      setState(() {
//        print(stopwatch.elapsedMilliseconds / 1000);
        _progress = stopwatch.elapsedMilliseconds / 150000;
        title = "Match $currMatch - ${((150000 - stopwatch.elapsedMilliseconds)/1000).round()} sec";
      });
    }
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
            autoLine = false;
            dcList.clear();
            hatchList.clear();
            cargoList.clear();
            fowlList.clear();
            stopwatch.stop();
            stopwatch.reset();
            dcStopwatch.stop();
            dcStopwatch.reset();
            hatchStopwatch.stop();
            hatchStopwatch.reset();
            cargoStopwatch.stop();
            cargoStopwatch.reset();
            router.navigateTo(context, '/scout', clearStack: true, transition: TransitionType.inFromLeft);
          },
        ),
      ),
      backgroundColor: Colors.white,
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
                        backgroundColor: greyAccent,
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
                  new SandStorm(),
                  new TeleOp(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
