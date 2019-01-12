import 'dart:async';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:mywb_flutter/theme.dart';
import 'package:mywb_flutter/user_info.dart';

class ScoutPageOne extends StatefulWidget {
  @override
  _ScoutPageOneState createState() => _ScoutPageOneState();
}

class _ScoutPageOneState extends State<ScoutPageOne> {

  final _pageController = new PageController();

  String title = "Match $currMatch - ";
  int state = 0;

  double _progress = 0.0;

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
    // TODO: implement initState
    super.initState();
    points = 0;
    stopwatch.reset();
//    stopwatch.start();
    new Timer.periodic(new Duration(milliseconds: 100), getTimer);
  }

  void getTimer(Timer timer) {
    if (stopwatch.isRunning) {
      setState(() {
//        print(stopwatch.elapsedMilliseconds / 1000);
        _progress = stopwatch.elapsedMilliseconds / 150000;
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
            stopwatch.stop();
            stopwatch.reset();
            router.navigateTo(context, '/scout', clearStack: true, transition: TransitionType.inFromLeft);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.arrow_forward_ios),
        onPressed: () {
          setState(() {
            if (state%2 == 0) {
              state++;
              _pageController.animateToPage(1, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
              _progress = 0.5;
            }
            else {
              state++;
              _pageController.animateToPage(0, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
              _progress = 0.0;
            }
          });
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
                      fontSize: 25.0
                    ),
                  ),
                  new Text(
                    "$currAlliance Alliance",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 25.0
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
                        backgroundColor: Colors.grey,
                        value: _progress,
                      ),
                    ),
                  ),
                  new Row(
                    children: <Widget>[
                      new Text("Sandstorm"),
                      new Padding(padding: EdgeInsets.all(10.0)),
                      new Text("TeleOp + Endgame"),
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

class SandStorm extends StatefulWidget {
  @override
  _SandStormState createState() => _SandStormState();
}

class _SandStormState extends State<SandStorm> {

  //Auto-line
  Color noColor = Colors.grey;
  Color yesColor = Colors.grey;

  //DC
  Color dcYes = Colors.grey;
  Color dcNo = Colors.grey;

  @override
  Widget build(BuildContext context) {
    return new SingleChildScrollView(
      child: new Column(
        children: <Widget>[
          new ListTile(
            title: new Text("Crossed Auto-Line?"),
            trailing: Container(
              width: 100.0,
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new IconButton(
                    icon: new Image.asset('images/no.png', color: noColor,),
                    onPressed: () {
                      setState(() {
                        if (autoLine) {
                          if (habLevel == 1) {
                            points -= 3;
                          }
                          else if (habLevel == 2) {
                            points -=6;
                          }
                        }
                        autoLine = false;
                        yesColor = Colors.grey;
                        noColor = mainColor;
                        print("Points: $points - ${stopwatch.elapsedMilliseconds/1000}");
                      });
                    },
                  ),
                  new IconButton(
                    icon: new Image.asset('images/yes.png', color: yesColor,),
                    onPressed: () {
                      setState(() {
                        if (!autoLine) {
                          if (habLevel == 1) {
                            points += 3;
                          }
                          else if (habLevel == 2) {
                            points +=6;
                          }
                        }
                        autoLine = true;
                        yesColor = mainColor;
                        noColor = Colors.grey;
                        print("Points: $points - ${stopwatch.elapsedMilliseconds/1000}");
                      });
                    },
                  )
                ],
              ),
            ),
          ),
          new ExpansionTile(
            title: new Text("Hatch"),
            children: <Widget>[

            ],
          ),
          new ListTile(
            title: new Text("Robot Disconnected?"),
            trailing: Container(
              width: 100.0,
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new IconButton(
                    icon: new Image.asset('images/no.png', color: noColor,),
                    onPressed: () {
                      setState(() {
                        if (autoLine) {
                          if (habLevel == 1) {
                            points -= 3;
                          }
                          else if (habLevel == 2) {
                            points -=6;
                          }
                        }
                        autoLine = false;
                        yesColor = Colors.grey;
                        noColor = mainColor;
                        print("Points: $points - ${stopwatch.elapsedMilliseconds/1000}");
                      });
                    },
                  ),
                  new IconButton(
                    icon: new Image.asset('images/yes.png', color: yesColor,),
                    onPressed: () {
                      setState(() {
                        if (!autoLine) {
                          if (habLevel == 1) {
                            points += 3;
                          }
                          else if (habLevel == 2) {
                            points +=6;
                          }
                        }
                        autoLine = true;
                        yesColor = mainColor;
                        noColor = Colors.grey;
                        print("Points: $points - ${stopwatch.elapsedMilliseconds/1000}");
                      });
                    },
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TeleOp extends StatefulWidget {
  @override
  _TeleOpState createState() => _TeleOpState();
}

class _TeleOpState extends State<TeleOp> {
  @override
  Widget build(BuildContext context) {
    return new SingleChildScrollView(
      child: new Column(
        children: <Widget>[
          new ListTile(title: Text("Hello!"),),
          new ListTile(title: Text("Hello!"),),
          new ListTile(title: Text("Hello!"),),
          new ListTile(title: Text("Hello!"),),
          new ListTile(title: Text("Hello!"),),
          new ListTile(title: Text("Hello!"),),
          new ListTile(title: Text("Hello!"),),
          new ListTile(title: Text("Hello!"),),
          new ListTile(title: Text("Hello!"),),
          new ListTile(title: Text("Hello!"),),
          new ListTile(title: Text("Hello!"),),
          new ListTile(title: Text("Hello!"),),
          new ListTile(title: Text("Hello!"),),
        ],
      ),
    );
  }
}