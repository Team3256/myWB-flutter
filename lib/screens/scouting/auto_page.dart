import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mywb_flutter/models/climb.dart';
import 'package:mywb_flutter/models/disconnect.dart';
import 'package:mywb_flutter/models/power_cell.dart';
import 'package:mywb_flutter/user_info.dart';
import 'package:mywb_flutter/utils/theme.dart';

class AutoPage extends StatefulWidget {
  @override
  _AutoPageState createState() => _AutoPageState();
}

class _AutoPageState extends State<AutoPage> {

  // Power Cell
  bool powercellState = false;
  int currPowercell = 0;
  Timer _powercellTimer;
  List<PowerCell> powercellSessionList = new List();

  // Climb
  Timer _climbTimer;
  Climb climb = new Climb();
  bool climbState = false;

  // DC
  Timer _dcTimer;
  Disconnect disconnect = new Disconnect();
  bool dcState = false;

  void checkPreload() {
    if (currMatch.matchData.preload > 0) {
      setState(() {
        powercellState = true;
        for (int i = 0; i < currMatch.matchData.preload; i++) {
          PowerCell pcell = new PowerCell();
          pcell.matchID = currMatch.id;
          pcell.teamID = currMatch.matchData.teamID;
          pcell.pickupTime = 0.0;
          powercellSessionList.add(pcell);
        }
      });
      powercellStopwatch.reset();
      powercellStopwatch.start();
      _powercellTimer = new Timer.periodic(new Duration(milliseconds: 100), (Timer timer) {
        if (powercellStopwatch.isRunning) {
          setState(() {});
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    checkPreload();
  }

  @override
  void dispose() {
    super.dispose();
    _powercellTimer.cancel();
    _climbTimer.cancel();
    _dcTimer.cancel();
    powercellStopwatch.stop();
    climbStopwatch.stop();
    dcStopwatch.stop();
    powercellStopwatch.reset();
    climbStopwatch.reset();
    dcStopwatch.reset();
  }

  @override
  Widget build(BuildContext context) {
    return new SingleChildScrollView(
      child: new Column(
        children: <Widget>[
          new Visibility(
            visible: stopwatch.elapsedMilliseconds <= 18000,
            child: new ListTile(
              title: new Text("Crossed Initiation-Line?", style: TextStyle(color: currTextColor),),
              trailing: Container(
                child: new Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    new IconButton(
                      icon: new Image.asset('images/no.png', color: currMatch.matchData.auto.crossed ? currDividerColor : mainColor,),
                      onPressed: () {
                        setState(() {
                          currMatch.matchData.auto.crossed = false;
                          currMatch.matchData.auto.crossTime = 0.0;
                        });
                        print(currMatch.matchData.auto);
                      },
                    ),
                    new IconButton(
                      icon: new Image.asset('images/yes.png', color: currMatch.matchData.auto.crossed ? mainColor : currDividerColor,),
                      onPressed: () {
                        setState(() {
                          if (!currMatch.matchData.auto.crossed) {
                            currMatch.matchData.auto.crossed = true;
                            currMatch.matchData.auto.crossTime = stopwatch.elapsedMilliseconds / 1000;
                          }
                        });
                        print(currMatch.matchData.auto);
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
          new Visibility(
            visible: stopwatch.elapsedMilliseconds <= 18000,
            child: new AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: currMatch.matchData.auto.crossed ? 60 : 0,
              child: new ListTile(
                title: new Text("Trench Auto?", style: TextStyle(color: currTextColor),),
                trailing: Container(
                  child: new Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      new IconButton(
                        icon: new Image.asset('images/no.png', color: currMatch.matchData.auto.trench ? currDividerColor : mainColor,),
                        onPressed: () {
                          setState(() {
                            currMatch.matchData.auto.trench = false;
                          });
                          print(currMatch.matchData.auto);
                        },
                      ),
                      new IconButton(
                        icon: new Image.asset('images/yes.png', color: currMatch.matchData.auto.trench ? mainColor : currDividerColor,),
                        onPressed: () {
                          setState(() {
                            currMatch.matchData.auto.trench = true;
                          });
                          print(currMatch.matchData.auto);
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          new ListTile(
            title: new Text("Power Cells", style: TextStyle(color: powercellSessionList.isNotEmpty ? mainColor : currTextColor)),
            trailing: Container(
              child: new Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  new IconButton(
                    icon: new Image.asset("images/subtract.png", color: powercellSessionList.isNotEmpty ? mainColor : currDividerColor,),
                    onPressed: () {
                      setState(() {
                        if (powercellSessionList.isNotEmpty) {
                          if (powercellSessionList.length == currPowercell + 1) {
                            powercellSessionList.clear();
                            _powercellTimer.cancel();
                            powercellStopwatch.stop();
                            powercellStopwatch.reset();
                            currPowercell = 0;
                          }
                          else {
                            powercellSessionList.removeLast();
                          }
                        }
                      });
                    },
                  ),
                  new Padding(padding: EdgeInsets.all(4)),
                  new Text(
                    (currMatch.matchData.powercells.length).toString(),
                    style: TextStyle(fontSize: 20.0, color: currTextColor),
                  ),
                  new Padding(padding: EdgeInsets.all(4)),
                  new IconButton(
                    icon: new Image.asset("images/add.png", color: powercellSessionList.isNotEmpty ? mainColor : currDividerColor,),
                    onPressed: () {
                      if (powercellSessionList.isEmpty) {
                        powercellStopwatch.reset();
                        powercellStopwatch.start();
                        _powercellTimer = new Timer.periodic(new Duration(milliseconds: 100), (Timer timer) {
                          if (powercellStopwatch.isRunning) {
                            setState(() {
                            });
                          }
                        });
                      }
                      setState(() {
                        powercellSessionList.add(new PowerCell());
                        powercellSessionList.last.matchID = currMatch.id;
                        powercellSessionList.last.teamID = currMatch.matchData.teamID;
                        powercellSessionList.last.pickupTime = stopwatch.elapsedMilliseconds / 1000;
                      });
                    },
                  )
                ],
              ),
            ),
          ),
          new AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: EdgeInsets.all(8.0),
            height: powercellSessionList.isEmpty ? 0 : 231,
            child: new Column(
              children: <Widget>[
                new Text("Shot Location (${currPowercell + 1} of ${powercellSessionList.length}):", style: TextStyle(fontWeight: FontWeight.bold, color: currTextColor),),
                new Padding(padding: EdgeInsets.all(4)),
                new Row(
                  children: <Widget>[
                    new Expanded(
                      child: new Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
                        color: currCardColor,
                        elevation: 6.0,
                        child: new InkWell(
                          borderRadius: BorderRadius.all(Radius.circular(16.0)),
                          onTap: () {
                            setState(() {
                              powercellSessionList[currPowercell].cycleTime = (stopwatch.elapsedMilliseconds / 1000) - powercellSessionList[currPowercell].pickupTime;
                              powercellSessionList[currPowercell].dropLocation = "Bottom";
                              currMatch.matchData.powercells.add(powercellSessionList[currPowercell]);
                              print(powercellSessionList[currPowercell]);
                              if (currPowercell + 1 == powercellSessionList.length) {
                                // Last ball was just shot out
                                currPowercell = 0;
                                _powercellTimer.cancel();
                                powercellStopwatch.stop();
                                powercellSessionList.clear();
                              }
                              else {
                                currPowercell++;
                              }
                            });
                          },
                          child: new Container(
                            padding: EdgeInsets.all(16),
                            child: new Text("Bottom", style: TextStyle(color: currTextColor, fontSize: 15.0), textAlign: TextAlign.center,),
                          ),
                        ),
                      ),
                    ),
                    new Padding(padding: EdgeInsets.all(4)),
                    new Expanded(
                      child: new Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
                        color: currCardColor,
                        elevation: 6.0,
                        child: new InkWell(
                          borderRadius: BorderRadius.all(Radius.circular(16.0)),
                          onTap: () {
                            setState(() {
                              powercellSessionList[currPowercell].cycleTime = (stopwatch.elapsedMilliseconds / 1000) - powercellSessionList[currPowercell].pickupTime;
                              powercellSessionList[currPowercell].dropLocation = "Outer";
                              currMatch.matchData.powercells.add(powercellSessionList[currPowercell]);
                              print(powercellSessionList[currPowercell]);
                              if (currPowercell + 1 == powercellSessionList.length) {
                                // Last ball was just shot out
                                currPowercell = 0;
                                _powercellTimer.cancel();
                                powercellStopwatch.stop();
                                powercellSessionList.clear();
                              }
                              else {
                                currPowercell++;
                              }
                            });
                          },
                          child: new Container(
                            padding: EdgeInsets.all(16),
                            child: new Text("Outer", style: TextStyle(color: currTextColor, fontSize: 15.0), textAlign: TextAlign.center,),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                new Padding(padding: EdgeInsets.all(4.0)),
                new Row(
                  children: <Widget>[
                    new Expanded(
                      child: new Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
                        color: currCardColor,
                        elevation: 6.0,
                        child: new InkWell(
                          borderRadius: BorderRadius.all(Radius.circular(16.0)),
                          onTap: () {
                            setState(() {
                              powercellSessionList[currPowercell].cycleTime = (stopwatch.elapsedMilliseconds / 1000) - powercellSessionList[currPowercell].pickupTime;
                              powercellSessionList[currPowercell].dropLocation = "Inner";
                              currMatch.matchData.powercells.add(powercellSessionList[currPowercell]);
                              print(powercellSessionList[currPowercell]);
                              if (currPowercell + 1 == powercellSessionList.length) {
                                // Last ball was just shot out
                                currPowercell = 0;
                                _powercellTimer.cancel();
                                powercellStopwatch.stop();
                                powercellSessionList.clear();
                              }
                              else {
                                currPowercell++;
                              }
                            });
                          },
                          child: new Container(
                            padding: EdgeInsets.all(16),
                            child: new Text("Inner", style: TextStyle(color: currTextColor, fontSize: 15.0), textAlign: TextAlign.center,),
                          ),
                        ),
                      ),
                    ),
                    new Padding(padding: EdgeInsets.all(4)),
                    new Expanded(
                      child: new Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
                        color: Colors.red,
                        elevation: 6.0,
                        child: new InkWell(
                          borderRadius: BorderRadius.all(Radius.circular(16.0)),
                          onTap: () {
                            setState(() {
                              powercellSessionList[currPowercell].cycleTime = (stopwatch.elapsedMilliseconds / 1000) - powercellSessionList[currPowercell].pickupTime;
                              powercellSessionList[currPowercell].dropLocation = "Dropped";
                              currMatch.matchData.powercells.add(powercellSessionList[currPowercell]);
                              print(powercellSessionList[currPowercell]);
                              if (currPowercell + 1 == powercellSessionList.length) {
                                // Last ball was just shot out
                                currPowercell = 0;
                                _powercellTimer.cancel();
                                powercellStopwatch.stop();
                                powercellSessionList.clear();
                              }
                              else {
                                currPowercell++;
                              }
                            });
                          },
                          child: new Container(
                            padding: EdgeInsets.all(16),
                            child: new Text("Dropped", style: TextStyle(color: Colors.white, fontSize: 15.0), textAlign: TextAlign.center,),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                new Padding(padding: EdgeInsets.all(4)),
                new Row(
                  children: <Widget>[
                    new Expanded(
                      child: new Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
                        color: currCardColor,
                        elevation: 6.0,
                        child: new InkWell(
                          borderRadius: BorderRadius.all(Radius.circular(16.0)),
                          child: new Container(
                            padding: EdgeInsets.all(16),
                            child: new Text("${(powercellStopwatch.elapsedMilliseconds / 1000).round()} sec", style: TextStyle(color: currTextColor, fontSize: 15.0), textAlign: TextAlign.center,),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          new Visibility(
            visible: stopwatch.elapsedMilliseconds >= 15000,
            child: new ListTile(
              title: new Text("CW Rotation", style: TextStyle(color: currTextColor),),
              trailing: Container(
                child: new Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    new IconButton(
                      icon: new Image.asset('images/no.png', color: currMatch.matchData.spin.rotation ? currDividerColor : mainColor,),
                      onPressed: () {
                        setState(() {
                          currMatch.matchData.spin.rotation = false;
                        });
                      },
                    ),
                    new IconButton(
                      icon: new Image.asset('images/yes.png', color: !currMatch.matchData.spin.rotation ? currDividerColor : mainColor,),
                      onPressed: () {
                        setState(() {
                          currMatch.matchData.spin.rotation = true;
                        });
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
          new Visibility(
            visible: stopwatch.elapsedMilliseconds >= 15000,
            child: new ListTile(
              title: new Text("CW Position", style: TextStyle(color: currTextColor),),
              trailing: Container(
                child: new Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    new IconButton(
                      icon: new Image.asset('images/no.png', color: currMatch.matchData.spin.position ? currDividerColor : mainColor,),
                      onPressed: () {
                        setState(() {
                          currMatch.matchData.spin.position = false;
                        });
                      },
                    ),
                    new IconButton(
                      icon: new Image.asset('images/yes.png', color: !currMatch.matchData.spin.position ? currDividerColor : mainColor,),
                      onPressed: () {
                        setState(() {
                          currMatch.matchData.spin.position = true;
                        });
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
          new Visibility(
            visible: stopwatch.elapsedMilliseconds >= 15000,
            child: new ListTile(
              title: new Text("Parked?", style: TextStyle(color: currTextColor),),
              trailing: Container(
                child: new Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    new IconButton(
                      icon: new Image.asset('images/no.png', color: currMatch.matchData.park ? currDividerColor : mainColor,),
                      onPressed: () {
                        setState(() {
                          currMatch.matchData.park = false;
                        });
                      },
                    ),
                    new IconButton(
                      icon: new Image.asset('images/yes.png', color: !currMatch.matchData.park ? currDividerColor : mainColor,),
                      onPressed: () {
                        setState(() {
                          currMatch.matchData.park = true;
                        });
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
          new AnimatedContainer(
            height: currMatch.matchData.park ? 50 : 0,
            duration: const Duration(milliseconds: 300),
            child: new ListTile(
              title: new Text("Climbed?", style: TextStyle(color: climbState ? mainColor : currTextColor),),
              trailing: Container(
                child: new Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    new Text(
                      (currMatch.matchData.climbs.length).toString(),
                      style: TextStyle(fontSize: 20.0, color: currTextColor),
                    ),
                    new Padding(padding: EdgeInsets.all(4)),
                    new IconButton(
                      icon: new Image.asset(climbState ? "images/subtract.png" : "images/add.png", color: climbState ? mainColor : currDividerColor),
                      onPressed: () {
                        if (climbState) {
                          // delete current climb
                          setState(() {
                            climbState = false;
                            climbStopwatch.stop();
                            climbStopwatch.reset();
                            _climbTimer.cancel();
                          });
                        }
                        else {
                          setState(() {
                            climbState = true;
                            climbStopwatch.reset();
                            climbStopwatch.start();
                            climb.matchID = currMatch.id;
                            climb.teamID = currMatch.matchData.teamID;
                            climb.startTime = stopwatch.elapsedMilliseconds / 1000;
                          });
                          _climbTimer = new Timer.periodic(new Duration(milliseconds: 100), (Timer timer) {
                            if (climbStopwatch.isRunning) {
                              setState(() {});
                            }
                          });
                        }
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
          new AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: climbState ? 140 : 0,
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                new Row(
                  children: <Widget>[
                    new Expanded(
                      child: new Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
                        color: currCardColor,
                        elevation: 6.0,
                        child: new InkWell(
                          borderRadius: BorderRadius.all(Radius.circular(16.0)),
                          onTap: () {
                            setState(() {
                              climb.climbTime = climbStopwatch.elapsedMilliseconds / 1000;
                              currMatch.matchData.climbs.add(climb);
                              _climbTimer.cancel();
                              climbState = false;
                              climbStopwatch.stop();
                              climbStopwatch.reset();
                            });
                            print(currMatch.matchData.climbs.last);
                          },
                          child: new Container(
                            padding: EdgeInsets.all(16),
                            child: new Text("Climbed", style: TextStyle(color: currTextColor, fontSize: 15.0), textAlign: TextAlign.center,),
                          ),
                        ),
                      ),
                    ),
                    new Padding(padding: EdgeInsets.all(4)),
                    new Expanded(
                      child: new Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
                        color: Colors.red,
                        elevation: 6.0,
                        child: new InkWell(
                          borderRadius: BorderRadius.all(Radius.circular(16.0)),
                          onTap: () {
                            setState(() {
                              climb.dropped = true;
                              climb.climbTime = climbStopwatch.elapsedMilliseconds / 1000;
                              currMatch.matchData.climbs.add(climb);
                              _climbTimer.cancel();
                              climbState = false;
                              climbStopwatch.stop();
                              climbStopwatch.reset();
                            });
                            print(currMatch.matchData.climbs.last);
                          },
                          child: new Container(
                            padding: EdgeInsets.all(16),
                            child: new Text("Dropped", style: TextStyle(color: Colors.white, fontSize: 15.0), textAlign: TextAlign.center,),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                new Padding(padding: EdgeInsets.all(4)),
                new Row(
                  children: <Widget>[
                    new Expanded(
                      child: new Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
                        color: currCardColor,
                        elevation: 6.0,
                        child: new Container(
                          padding: EdgeInsets.all(16),
                          child: new Text("${(climbStopwatch.elapsedMilliseconds / 1000).round()} sec", style: TextStyle(color: currTextColor, fontSize: 15.0), textAlign: TextAlign.center,),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          new Divider(indent: 8, endIndent: 8, color: currDividerColor,),
          new ListTile(
            title: new Text("Robot Disconnect", style: TextStyle(color: dcState ? mainColor : currTextColor),),
            trailing: Container(
              child: new Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  new Text(
                    (currMatch.matchData.disconnects.length).toString(),
                    style: TextStyle(fontSize: 20.0, color: currTextColor),
                  ),
                  new Padding(padding: EdgeInsets.all(4)),
                  new IconButton(
                    icon: new Image.asset(dcState ? "images/subtract.png" : "images/add.png", color: dcState ? mainColor : currDividerColor),
                    onPressed: () {
                      if (dcState) {
                        // delete current climb
                        setState(() {
                          dcState = false;
                          dcStopwatch.stop();
                          dcStopwatch.reset();
                          _dcTimer.cancel();
                        });
                      }
                      else {
                        setState(() {
                          dcState = true;
                          dcStopwatch.reset();
                          dcStopwatch.start();
                          disconnect.matchID = currMatch.id;
                          disconnect.teamID = currMatch.matchData.teamID;
                          disconnect.startTime = stopwatch.elapsedMilliseconds / 1000;
                        });
                        _dcTimer = new Timer.periodic(new Duration(milliseconds: 100), (Timer timer) {
                          if (dcStopwatch.isRunning) {
                            setState(() {});
                          }
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
            height: dcState ? 74 : 0,
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                new Row(
                  children: <Widget>[
                    new Expanded(
                      child: new Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
                        color: currCardColor,
                        elevation: 6.0,
                        child: new InkWell(
                          borderRadius: BorderRadius.all(Radius.circular(16.0)),
                          child: new Container(
                            padding: EdgeInsets.all(16),
                            child: new Text("${(dcStopwatch.elapsedMilliseconds / 1000).round()} sec", style: TextStyle(color: currTextColor, fontSize: 15.0), textAlign: TextAlign.center,),
                          ),
                        ),
                      ),
                    ),
                    new Padding(padding: EdgeInsets.all(4)),
                    new Expanded(
                      child: new Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
                        color: Colors.red,
                        elevation: 6.0,
                        child: new InkWell(
                          borderRadius: BorderRadius.all(Radius.circular(16.0)),
                          onTap: () {
                            setState(() {
                              disconnect.duration = dcStopwatch.elapsedMilliseconds / 1000;
                              dcState = false;
                              dcStopwatch.stop();
                              dcStopwatch.reset();
                              _dcTimer.cancel();
                              currMatch.matchData.disconnects.add(disconnect);
                            });
                          },
                          child: new Container(
                            padding: EdgeInsets.all(16),
                            child: new Text("Reconnected", style: TextStyle(color: Colors.white, fontSize: 15.0), textAlign: TextAlign.center,),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }
}
