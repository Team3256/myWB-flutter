import 'dart:async';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
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
            stopwatch.stop();
            stopwatch.reset();
            dcStopwatch.stop();
            dcStopwatch.reset();
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
  Color noColor = mainColor;
  Color yesColor = greyAccent;

  //DC
  Color dcAdd = greyAccent;
  int dcTimer = 0;
  String dcImagePath = "images/add.png";
  bool reconnectVisible = false;

  //Hatch
  Color hatchAdd = greyAccent;
  Color hatchTitle = Colors.black;
  String hatchImagePath = "images/add.png";
  int hatchTimer = 0;
  bool intakeVisible = true;
  bool dropVisible = false;
  double hatchContainerHeight = 0.0;
  String intakeLocation = "";
  String dropLocation = "";

  @override
  Widget build(BuildContext context) {
    return new SingleChildScrollView(
      child: new Column(
        children: <Widget>[
          new ListTile(
            title: new Text("Crossed Base-Line?"),
            trailing: Container(
              width: 100.0,
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                        yesColor = greyAccent;
                        noColor = mainColor;
                        autoTime = 0;
                        print("Points: $points - $autoTime");
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
                        noColor = greyAccent;
                        autoTime = stopwatch.elapsedMilliseconds/1000;
                        print("Points: $points - ${stopwatch.elapsedMilliseconds/1000}");
                      });
                    },
                  )
                ],
              ),
            ),
          ),
          new ListTile(
            title: new Text("Hatch Panels", style: TextStyle(color: hatchTitle),),
            trailing: Container(
              width: 100.0,
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  new Text(
                    (hatchList.length).toString(),
                    style: TextStyle(fontSize: 20.0),
                  ),
                  new IconButton(
                    icon: new Image.asset(hatchImagePath, color: hatchAdd,),
                    onPressed: () {
                      if (hatchImagePath == "images/add.png") {
                        hatchStopwatch.reset();
                        hatchStopwatch.start();
                        new Timer.periodic(new Duration(milliseconds: 500), (Timer timer) {
                          if (hatchStopwatch.isRunning) {
                            setState(() {
                              hatchTimer = (hatchStopwatch.elapsedMilliseconds / 1000).round();
                            });
                          }
                        });
                        setState(() {
                          hatchAdd = mainColor;
                          hatchTitle = mainColor;
                          intakeVisible = true;
                          dropVisible = false;
                          hatchImagePath = "images/subtract.png";
                          hatchContainerHeight = 155.0;
                        });
                      }
                      else {
                        hatchStopwatch.stop();
                        hatchStopwatch.reset();
                        dropLocation = "";
                        intakeLocation = "";
                        setState(() {
                          hatchTitle = Colors.black;
                          hatchAdd = greyAccent;
                          hatchImagePath = "images/add.png";
                          hatchContainerHeight = 0.0;
                          intakeVisible = true;
                          dropVisible = false;
                        });
                      }
                    },
                  )
                ],
              ),
            ),
          ),
          new AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            height: hatchContainerHeight,
            padding: EdgeInsets.all(8.0),
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                new Text("Intake Location: $intakeLocation", style: TextStyle(fontWeight: FontWeight.bold),),
                new Visibility(visible: intakeVisible, child: new Padding(padding: EdgeInsets.all(4.0))),
                new Visibility(
                  visible: intakeVisible,
                  child: new Row(
                    children: <Widget>[
                      new Expanded(
                        child: new ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          child: new Container(
                            color: greyAccent,
                            child: new FlatButton(
                              child: new Text("Human Player Station"),
                              onPressed: () {
                                setState(() {
                                  intakeLocation = "Human Player Station";
                                  dropVisible = true;
                                  intakeVisible = false;
                                  hatchContainerHeight = 290.0;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                      new Padding(padding: EdgeInsets.all(4.0)),
                      new Expanded(
                        child: new ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          child: new Container(
                            color: greyAccent,
                            child: new FlatButton(
                              child: new Text("Ground"),
                              onPressed: () {

                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                new Padding(padding: EdgeInsets.all(4.0)),
                new Visibility(visible: dropVisible, child: new Text("Drop Location: $dropLocation", style: TextStyle(fontWeight: FontWeight.bold),)),
                new Visibility(visible: dropVisible, child: new Padding(padding: EdgeInsets.all(4.0))),
                new Visibility(
                  visible: dropVisible,
                  child: new Row(
                    children: <Widget>[
                      new Expanded(
                        child: new ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          child: new Container(
                            color: greyAccent,
                            child: new FlatButton(
                              child: new Text("Cargo Ship"),
                              onPressed: () {
                                hatchStopwatch.stop();
                                hatchStopwatch.reset();
                                setState(() {
                                  dropLocation = "Cargo Ship";
                                  dropVisible = false;
                                  intakeVisible = false;
                                  hatchContainerHeight = 0.0;
                                  hatchAdd = greyAccent;
                                  hatchTitle = Colors.black;
                                  hatchImagePath = "images/add.png";
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                      new Padding(padding: EdgeInsets.all(4.0)),
                      new Expanded(
                        child: new ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          child: new Container(
                            color: greyAccent,
                            child: new FlatButton(
                              child: new Text("Rocket Lvl 1"),
                              onPressed: () {

                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                new Visibility(visible: dropVisible, child: new Padding(padding: EdgeInsets.all(4.0))),
                new Visibility(
                  visible: dropVisible,
                  child: new Row(
                    children: <Widget>[
                      new Expanded(
                        child: new ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          child: new Container(
                            color: greyAccent,
                            child: new FlatButton(
                              child: new Text("Rocket Lvl 2"),
                              onPressed: () {

                              },
                            ),
                          ),
                        ),
                      ),
                      new Padding(padding: EdgeInsets.all(4.0)),
                      new Expanded(
                        child: new ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          child: new Container(
                            color: greyAccent,
                            child: new FlatButton(
                              child: new Text("Rocket Lvl 3"),
                              onPressed: () {

                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                new Visibility(visible: dropVisible, child: new Padding(padding: EdgeInsets.all(4.0))),
                new Visibility(
                  visible: dropVisible,
                  child: new Row(
                    children: <Widget>[
                      new Expanded(
                        child: new ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          child: new Container(
                            color: Colors.red,
                            child: new FlatButton(
                              child: new Text("Droppped"),
                              textColor: Colors.white,
                              onPressed: () {

                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                new Visibility(visible: dropVisible, child: new Padding(padding: EdgeInsets.all(4.0))),
                new ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  child: new Container(
                    color: greyAccent,
                    child: new ListTile(
                      title: new Text("$hatchTimer sec"),
                    ),
                  ),
                )
              ],
            ),
          ),
          new ExpansionTile(
            title: new Text("Robot Disconnected?"),
            trailing: Container(
              width: 100.0,
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  new Text(
                    (dcList.length ~/ 2).toString(),
                    style: TextStyle(fontSize: 20.0),
                  ),
                  new IconButton(
                    icon: new Image.asset(dcImagePath, color: dcAdd,),
                    onPressed: null,
                  )
                ],
              ),
            ),
            onExpansionChanged: (isExpanded) {
              if (isExpanded) {
                setState(() {
                  dcImagePath = "images/subtract.png";
                  dcAdd = mainColor;
                  reconnectVisible = true;
                });
                dcStopwatch.reset();
                dcStopwatch.start();
                new Timer.periodic(new Duration(milliseconds: 500), (Timer timer) {
                  if (dcStopwatch.isRunning) {
                    setState(() {
                      dcTimer = (dcStopwatch.elapsedMilliseconds / 1000).round();
                    });
                  }
                });
              }
              else {
                setState(() {
                  dcTimer = 0;
                  dcAdd = greyAccent;
                  dcImagePath = "images/add.png";
                  reconnectVisible = false;
                });
                dcStopwatch.stop();
                dcStopwatch.reset();
              }
            },
            children: <Widget>[
              new Container(
                padding: EdgeInsets.all(8.0),
                child: new ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  child: new Container(
                    color: greyAccent,
                    child: new ListTile(
                      title: new Text("$dcTimer sec"),
                      trailing: new Visibility(
                        visible: reconnectVisible,
                        child: new FlatButton(
                            child: new Text("RECONNECTED"),
                            textColor: Colors.white,
                            color: Colors.red,
                            onPressed: () {
                              dcStopwatch.stop();
                              setState(() {
                                dcList.add(stopwatch.elapsedMilliseconds/1000);
                                dcList.add(dcStopwatch.elapsedMilliseconds/1000);
                                print("Robot Disconnect @ ${dcList.elementAt(dcList.length - 2)} for ${dcList.elementAt(dcList.length - 1)} seconds!");
                                reconnectVisible = false;
                              });
                        }),
                      ),
                    ),
                  ),
                ),
              )
            ],
          )
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