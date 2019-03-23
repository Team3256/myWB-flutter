import 'dart:async';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:mywb_flutter/models/autoline.dart';
import 'package:mywb_flutter/models/cargo.dart';
import 'package:mywb_flutter/models/climb.dart';
import 'package:mywb_flutter/models/disconnect.dart';
import 'package:mywb_flutter/models/foul.dart';
import 'package:mywb_flutter/models/hatch.dart';
import 'package:mywb_flutter/theme/colors.dart';
import 'package:mywb_flutter/user_info.dart';
import 'package:flutter/cupertino.dart';

class TeleopPage extends StatefulWidget {
  @override
  _TeleopPageState createState() => _TeleopPageState();
}

class _TeleopPageState extends State<TeleopPage> {
  // DC
  Color dcAdd = currCardColor;
  double dcStartTime = 0.0;
  int dcTimer = 0;
  String dcImagePath = "images/add.png";
  bool reconnectVisible = false;

  // Hatch
  int hatchCounter = 0;
  double hatchPickupTime = 0.0;
  Color hatchAdd = currCardColor;
  Color hatchTitle = currTextColor;
  String hatchImagePath = "images/add.png";
  int hatchTimer = 0;
  bool intakeVisible = false;
  bool dropVisible = false;
  double hatchContainerHeight = 0.0;
  String hatchIntakeLocation = "";
  String hatchDropLocation = "";

  // Cargo
  int cargoCounter = 0;
  double cargoPickupTime = 0.0;
  Color cargoAdd = currCardColor;
  Color cargoTitle = currTextColor;
  String cargoImagePath = "images/add.png";
  int cargoTimer = 0;
  bool cargoIntakeVisible = false;
  bool cargoDropVisible = false;
  double cargoContainerHeight = 0.0;
  String cargoIntakeLocation = "";
  String cargoDropLocation = "";

  // Fouls
  String foulImagePath = "images/add.png";
  Color foulAdd = currCardColor;
  Color foulText = currTextColor;
  String foulReason = "";
  double foulTime = 0.0;
  double foulContainerHeight = 0.0;
  FocusNode _focusController = new FocusNode();
  TextEditingController _foulController = new TextEditingController();

  // Endgame
  String climbImagePath = "images/add.png";
  String climbStatus = "Not Parked";
  double climbStartTime = 0.0;
  Color climbAdd = currCardColor;
  Color climbText = currTextColor;
  int climbTimer = 0;
  int endHabLevel = 0;
  double climbContainerHeight = 0.0;
  bool canSupport = false;
  Color canSupportYes = currCardColor;
  Color canSupportNo = currCardColor;

  void getParkStatus() {
    if (climbList.last != null && climbList.last.habLevel != 0) {
      setState(() {
        climbStatus = climbList.last.habLevel.toString();
      });
    }
    else {
      setState(() {
        climbStatus = "Not Parked";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new SingleChildScrollView(
      child: new Column(
        children: <Widget>[
          new ListTile(
            title: new Text("Hatch Panels", style: TextStyle(color: hatchTitle),),
            trailing: Container(
              width: 100.0,
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  new Text(
                    (hatchCounter).toString(),
                    style: TextStyle(fontSize: 20.0, color: currTextColor),
                  ),
                  new IconButton(
                    icon: new Image.asset(hatchImagePath, color: hatchAdd,),
                    onPressed: () {
                      if (hatchImagePath == "images/add.png") {
                        hatchStopwatch.reset();
                        hatchStopwatch.start();
                        hatchPickupTime = stopwatch.elapsedMilliseconds / 1000;
                        new Timer.periodic(new Duration(milliseconds: 100), (Timer timer) {
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
                        hatchDropLocation = "";
                        hatchIntakeLocation = "";
                        setState(() {
                          hatchTitle = currTextColor;
                          hatchAdd = currCardColor;
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
                new Text("Intake Location: $hatchIntakeLocation", style: TextStyle(fontWeight: FontWeight.bold, color: currTextColor),),
                new Visibility(visible: intakeVisible, child: new Padding(padding: EdgeInsets.all(4.0))),
                new Visibility(
                  visible: intakeVisible,
                  child: new Row(
                    children: <Widget>[
                      new Expanded(
                        child: new ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          child: new Container(
                            color: currCardColor,
                            child: new FlatButton(
                              child: new Text("Loading Station", style: TextStyle(fontFamily: "Product Sans", color: currTextColor)),
                              onPressed: () {
                                setState(() {
                                  hatchIntakeLocation = "Loading Station";
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
                            color: currCardColor,
                            child: new FlatButton(
                              child: new Text("Ground", style: TextStyle(fontFamily: "Product Sans", color: currTextColor)),
                              onPressed: () {
                                setState(() {
                                  hatchIntakeLocation = "Ground";
                                  dropVisible = true;
                                  intakeVisible = false;
                                  hatchContainerHeight = 290.0;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                new Padding(padding: EdgeInsets.all(4.0)),
                new Visibility(visible: dropVisible, child: new Text("Drop Location: $hatchDropLocation", style: TextStyle(fontWeight: FontWeight.bold, color: currTextColor),)),
                new Visibility(visible: dropVisible, child: new Padding(padding: EdgeInsets.all(4.0))),
                new Visibility(
                  visible: dropVisible,
                  child: new Row(
                    children: <Widget>[
                      new Expanded(
                        child: new ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          child: new Container(
                            color: currCardColor,
                            child: new FlatButton(
                              child: new Text("Cargo Ship", style: TextStyle(fontFamily: "Product Sans", color: currTextColor)),
                              onPressed: () {
                                hatchDropLocation = "Cargo Ship";
                                hatchStopwatch.stop();
                                setState(() {
                                  hatchCounter++;
                                  hatchList.add(new Hatch(hatchIntakeLocation, hatchDropLocation, hatchPickupTime, hatchStopwatch.elapsedMilliseconds/1000, "Tele-Op"));
                                  dropVisible = false;
                                  intakeVisible = false;
                                  hatchContainerHeight = 0.0;
                                  hatchAdd = currCardColor;
                                  hatchTitle = currTextColor;
                                  hatchImagePath = "images/add.png";
                                });
                                matchEventList.add(new Hatch(hatchIntakeLocation, hatchDropLocation, hatchPickupTime, hatchStopwatch.elapsedMilliseconds/1000, "Tele-Op"));
                                hatchStopwatch.reset();
                                print("${hatchList[hatchList.length-1].pickup} to ${hatchList[hatchList.length-1].dropOff} @ ${hatchList[hatchList.length-1].pickupTime} for ${hatchList[hatchList.length-1].cycleTime}");
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
                            color: currCardColor,
                            child: new FlatButton(
                              child: new Text("Rocket Lvl 1", style: TextStyle(fontFamily: "Product Sans", color: currTextColor)),
                              onPressed: () {
                                hatchDropLocation = "Rocket Lvl 1";
                                hatchStopwatch.stop();
                                setState(() {
                                  hatchCounter++;
                                  hatchList.add(new Hatch(hatchIntakeLocation, hatchDropLocation, hatchPickupTime, hatchStopwatch.elapsedMilliseconds/1000, "Tele-Op"));
                                  dropVisible = false;
                                  intakeVisible = false;
                                  hatchContainerHeight = 0.0;
                                  hatchAdd = currCardColor;
                                  hatchTitle = currTextColor;
                                  hatchImagePath = "images/add.png";
                                });
                                matchEventList.add(new Hatch(hatchIntakeLocation, hatchDropLocation, hatchPickupTime, hatchStopwatch.elapsedMilliseconds/1000, "Tele-Op"));
                                hatchStopwatch.reset();
                                print("${hatchList[hatchList.length-1].pickup} to ${hatchList[hatchList.length-1].dropOff} @ ${hatchList[hatchList.length-1].pickupTime} for ${hatchList[hatchList.length-1].cycleTime}");
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
                            color: currCardColor,
                            child: new FlatButton(
                              child: new Text("Rocket Lvl 2", style: TextStyle(fontFamily: "Product Sans", color: currTextColor)),
                              onPressed: () {
                                hatchDropLocation = "Rocket Lvl 2";
                                hatchStopwatch.stop();
                                setState(() {
                                  hatchCounter++;
                                  hatchList.add(new Hatch(hatchIntakeLocation, hatchDropLocation, hatchPickupTime, hatchStopwatch.elapsedMilliseconds/1000, "Tele-Op"));
                                  dropVisible = false;
                                  intakeVisible = false;
                                  hatchContainerHeight = 0.0;
                                  hatchAdd = currCardColor;
                                  hatchTitle = currTextColor;
                                  hatchImagePath = "images/add.png";
                                });
                                matchEventList.add(new Hatch(hatchIntakeLocation, hatchDropLocation, hatchPickupTime, hatchStopwatch.elapsedMilliseconds/1000, "Tele-Op"));
                                hatchStopwatch.reset();
                                print("${hatchList[hatchList.length-1].pickup} to ${hatchList[hatchList.length-1].dropOff} @ ${hatchList[hatchList.length-1].pickupTime} for ${hatchList[hatchList.length-1].cycleTime}");
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
                            color: currCardColor,
                            child: new FlatButton(
                              child: new Text("Rocket Lvl 3", style: TextStyle(fontFamily: "Product Sans", color: currTextColor)),
                              onPressed: () {
                                hatchDropLocation = "Rocket Lvl 3";
                                hatchStopwatch.stop();
                                setState(() {
                                  hatchCounter++;
                                  hatchList.add(new Hatch(hatchIntakeLocation, hatchDropLocation, hatchPickupTime, hatchStopwatch.elapsedMilliseconds/1000, "Tele-Op"));
                                  dropVisible = false;
                                  intakeVisible = false;
                                  hatchContainerHeight = 0.0;
                                  hatchAdd = currCardColor;
                                  hatchTitle = currTextColor;
                                  hatchImagePath = "images/add.png";
                                });
                                matchEventList.add(new Hatch(hatchIntakeLocation, hatchDropLocation, hatchPickupTime, hatchStopwatch.elapsedMilliseconds/1000, "Tele-Op"));
                                hatchStopwatch.reset();
                                print("${hatchList[hatchList.length-1].pickup} to ${hatchList[hatchList.length-1].dropOff} @ ${hatchList[hatchList.length-1].pickupTime} for ${hatchList[hatchList.length-1].cycleTime}");
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
                              child: new Text("Droppped", style: TextStyle(fontFamily: "Product Sans", color: currTextColor)),
                              textColor: Colors.white,
                              onPressed: () {
                                hatchDropLocation = "Dropped";
                                hatchStopwatch.stop();
                                setState(() {
                                  hatchList.add(new Hatch(hatchIntakeLocation, hatchDropLocation, hatchPickupTime, hatchStopwatch.elapsedMilliseconds/1000, "Tele-Op"));
                                  dropVisible = false;
                                  intakeVisible = false;
                                  hatchContainerHeight = 0.0;
                                  hatchAdd = currCardColor;
                                  hatchTitle = currTextColor;
                                  hatchImagePath = "images/add.png";
                                });
                                matchEventList.add(new Hatch(hatchIntakeLocation, hatchDropLocation, hatchPickupTime, hatchStopwatch.elapsedMilliseconds/1000, "Tele-Op"));
                                hatchStopwatch.reset();
                                print("${hatchList[hatchList.length-1].pickup} to ${hatchList[hatchList.length-1].dropOff} @ ${hatchList[hatchList.length-1].pickupTime} for ${hatchList[hatchList.length-1].cycleTime}");
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
                    color: currCardColor,
                    child: new ListTile(
                      title: new Text("$hatchTimer sec", style: TextStyle(fontFamily: "Product Sans", color: currTextColor)),
                    ),
                  ),
                )
              ],
            ),
          ),
          new ListTile(
            title: new Text("Cargo", style: TextStyle(color: cargoTitle),),
            trailing: Container(
              width: 100.0,
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  new Text(
                    (cargoCounter).toString(),
                    style: TextStyle(fontSize: 20.0, color: currTextColor),
                  ),
                  new IconButton(
                    icon: new Image.asset(cargoImagePath, color: cargoAdd,),
                    onPressed: () {
                      if (cargoImagePath == "images/add.png") {
                        cargoStopwatch.reset();
                        cargoStopwatch.start();
                        cargoPickupTime = stopwatch.elapsedMilliseconds / 1000;
                        new Timer.periodic(new Duration(milliseconds: 100), (Timer timer) {
                          if (cargoStopwatch.isRunning) {
                            setState(() {
                              cargoTimer = (cargoStopwatch.elapsedMilliseconds / 1000).round();
                            });
                          }
                        });
                        setState(() {
                          cargoDropLocation = "";
                          cargoIntakeLocation = "";
                          cargoAdd = mainColor;
                          cargoTitle = mainColor;
                          cargoIntakeVisible = true;
                          cargoDropVisible = false;
                          cargoImagePath = "images/subtract.png";
                          cargoContainerHeight = 155.0;
                        });
                      }
                      else {
                        cargoStopwatch.stop();
                        cargoStopwatch.reset();
                        cargoDropLocation = "";
                        cargoIntakeLocation = "";
                        setState(() {
                          cargoTitle = currTextColor;
                          cargoAdd = currCardColor;
                          cargoImagePath = "images/add.png";
                          cargoContainerHeight = 0.0;
                          cargoIntakeVisible = true;
                          cargoDropVisible = false;
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
            height: cargoContainerHeight,
            padding: EdgeInsets.all(8.0),
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                new Text("Intake Location: $cargoIntakeLocation", style: TextStyle(fontWeight: FontWeight.bold, color: currTextColor),),
                new Visibility(visible: cargoIntakeVisible, child: new Padding(padding: EdgeInsets.all(4.0))),
                new Visibility(
                  visible: cargoIntakeVisible,
                  child: new Row(
                    children: <Widget>[
                      new Expanded(
                        child: new ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          child: new Container(
                            color: currCardColor,
                            child: new FlatButton(
                              child: new Text("Loading Station", style: TextStyle(fontFamily: "Product Sans", color: currTextColor), textAlign: TextAlign.center,),
                              onPressed: () {
                                setState(() {
                                  cargoIntakeLocation = "Loading Station";
                                  cargoDropVisible = true;
                                  cargoIntakeVisible = false;
                                  cargoContainerHeight = 290.0;
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
                            color: currCardColor,
                            child: new FlatButton(
                              child: new Text("Depot", style: TextStyle(fontFamily: "Product Sans", color: currTextColor)),
                              onPressed: () {
                                setState(() {
                                  cargoIntakeLocation = "Depot";
                                  cargoDropVisible = true;
                                  cargoIntakeVisible = false;
                                  cargoContainerHeight = 290.0;
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
                            color: currCardColor,
                            child: new FlatButton(
                              child: new Text("Ground", style: TextStyle(fontFamily: "Product Sans", color: currTextColor)),
                              onPressed: () {
                                setState(() {
                                  cargoIntakeLocation = "Ground";
                                  cargoDropVisible = true;
                                  cargoIntakeVisible = false;
                                  cargoContainerHeight = 290.0;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                new Padding(padding: EdgeInsets.all(4.0)),
                new Visibility(visible: cargoDropVisible, child: new Text("Drop Location: $cargoDropLocation", style: TextStyle(fontWeight: FontWeight.bold, color: currTextColor),)),
                new Visibility(visible: cargoDropVisible, child: new Padding(padding: EdgeInsets.all(4.0))),
                new Visibility(
                  visible: cargoDropVisible,
                  child: new Row(
                    children: <Widget>[
                      new Expanded(
                        child: new ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          child: new Container(
                            color: currCardColor,
                            child: new FlatButton(
                              child: new Text("Cargo Ship", style: TextStyle(fontFamily: "Product Sans", color: currTextColor)),
                              onPressed: () {
                                cargoDropLocation = "Cargo Ship";
                                cargoStopwatch.stop();
                                setState(() {
                                  cargoCounter++;
                                  cargoList.add(new Cargo(cargoIntakeLocation, cargoDropLocation, cargoPickupTime, cargoStopwatch.elapsedMilliseconds/1000, "Tele-Op"));
                                  cargoDropVisible = false;
                                  cargoIntakeVisible = false;
                                  cargoContainerHeight = 0.0;
                                  cargoAdd = currCardColor;
                                  cargoTitle = currTextColor;
                                  cargoImagePath = "images/add.png";
                                });
                                matchEventList.add(new Cargo(cargoIntakeLocation, cargoDropLocation, cargoPickupTime, cargoStopwatch.elapsedMilliseconds/1000, "Tele-Op"));
                                cargoStopwatch.reset();
                                print("${cargoList[cargoList.length-1].pickup} to ${cargoList[cargoList.length-1].dropOff} @ ${cargoList[cargoList.length-1].pickupTime} for ${cargoList[cargoList.length-1].cycleTime}");
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
                            color: currCardColor,
                            child: new FlatButton(
                              child: new Text("Rocket Lvl 1", style: TextStyle(fontFamily: "Product Sans", color: currTextColor)),
                              onPressed: () {
                                cargoDropLocation = "Rocket Lvl 1";
                                cargoStopwatch.stop();
                                setState(() {
                                  cargoCounter++;
                                  cargoList.add(new Cargo(cargoIntakeLocation, cargoDropLocation, cargoPickupTime, cargoStopwatch.elapsedMilliseconds/1000, "Tele-Op"));
                                  cargoDropVisible = false;
                                  cargoIntakeVisible = false;
                                  cargoContainerHeight = 0.0;
                                  cargoAdd = currCardColor;
                                  cargoTitle = currTextColor;
                                  cargoImagePath = "images/add.png";
                                });
                                matchEventList.add(new Cargo(cargoIntakeLocation, cargoDropLocation, cargoPickupTime, cargoStopwatch.elapsedMilliseconds/1000, "Tele-Op"));
                                cargoStopwatch.reset();
                                print("${cargoList[cargoList.length-1].pickup} to ${cargoList[cargoList.length-1].dropOff} @ ${cargoList[cargoList.length-1].pickupTime} for ${cargoList[cargoList.length-1].cycleTime}");
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                new Visibility(visible: cargoDropVisible, child: new Padding(padding: EdgeInsets.all(4.0))),
                new Visibility(
                  visible: cargoDropVisible,
                  child: new Row(
                    children: <Widget>[
                      new Expanded(
                        child: new ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          child: new Container(
                            color: currCardColor,
                            child: new FlatButton(
                              child: new Text("Rocket Lvl 2", style: TextStyle(fontFamily: "Product Sans", color: currTextColor)),
                              onPressed: () {
                                cargoDropLocation = "Rocket Lvl 2";
                                cargoStopwatch.stop();
                                setState(() {
                                  cargoCounter++;
                                  cargoList.add(new Cargo(cargoIntakeLocation, cargoDropLocation, cargoPickupTime, cargoStopwatch.elapsedMilliseconds/1000, "Tele-Op"));
                                  cargoDropVisible = false;
                                  cargoIntakeVisible = false;
                                  cargoContainerHeight = 0.0;
                                  cargoAdd = currCardColor;
                                  cargoTitle = currTextColor;
                                  cargoImagePath = "images/add.png";
                                });
                                matchEventList.add(new Cargo(cargoIntakeLocation, cargoDropLocation, cargoPickupTime, cargoStopwatch.elapsedMilliseconds/1000, "Tele-Op"));
                                cargoStopwatch.reset();
                                print("${cargoList[cargoList.length-1].pickup} to ${cargoList[cargoList.length-1].dropOff} @ ${cargoList[cargoList.length-1].pickupTime} for ${cargoList[cargoList.length-1].cycleTime}");
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
                            color: currCardColor,
                            child: new FlatButton(
                              child: new Text("Rocket Lvl 3", style: TextStyle(fontFamily: "Product Sans", color: currTextColor)),
                              onPressed: () {
                                cargoDropLocation = "Rocket Lvl 3";
                                cargoStopwatch.stop();
                                setState(() {
                                  cargoCounter++;
                                  cargoList.add(new Cargo(cargoIntakeLocation, cargoDropLocation, cargoPickupTime, cargoStopwatch.elapsedMilliseconds/1000, "Tele-Op"));
                                  cargoDropVisible = false;
                                  cargoIntakeVisible = false;
                                  cargoContainerHeight = 0.0;
                                  cargoAdd = currCardColor;
                                  cargoTitle = currTextColor;
                                  cargoImagePath = "images/add.png";
                                });
                                matchEventList.add(new Cargo(cargoIntakeLocation, cargoDropLocation, cargoPickupTime, cargoStopwatch.elapsedMilliseconds/1000, "Tele-Op"));
                                cargoStopwatch.reset();
                                print("${cargoList[cargoList.length-1].pickup} to ${cargoList[cargoList.length-1].dropOff} @ ${cargoList[cargoList.length-1].pickupTime} for ${cargoList[cargoList.length-1].cycleTime}");
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                new Visibility(visible: cargoDropVisible, child: new Padding(padding: EdgeInsets.all(4.0))),
                new Visibility(
                  visible: cargoDropVisible,
                  child: new Row(
                    children: <Widget>[
                      new Expanded(
                        child: new ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          child: new Container(
                            color: Colors.red,
                            child: new FlatButton(
                              child: new Text("Droppped", style: TextStyle(fontFamily: "Product Sans", color: currTextColor)),
                              textColor: Colors.white,
                              onPressed: () {
                                cargoDropLocation = "Dropped";
                                cargoStopwatch.stop();
                                setState(() {
                                  cargoList.add(new Cargo(cargoIntakeLocation, cargoDropLocation, cargoPickupTime, cargoStopwatch.elapsedMilliseconds/1000, "Tele-Op"));
                                  cargoDropVisible = false;
                                  cargoIntakeVisible = false;
                                  cargoContainerHeight = 0.0;
                                  cargoAdd = currCardColor;
                                  cargoTitle = currTextColor;
                                  cargoImagePath = "images/add.png";
                                });
                                matchEventList.add(new Cargo(cargoIntakeLocation, cargoDropLocation, cargoPickupTime, cargoStopwatch.elapsedMilliseconds/1000, "Tele-Op"));
                                cargoStopwatch.reset();
                                print("${cargoList[cargoList.length-1].pickup} to ${cargoList[cargoList.length-1].dropOff} @ ${cargoList[cargoList.length-1].pickupTime} for ${cargoList[cargoList.length-1].cycleTime}");
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                new Visibility(visible: cargoDropVisible, child: new Padding(padding: EdgeInsets.all(4.0))),
                new ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  child: new Container(
                    color: currCardColor,
                    child: new ListTile(
                      title: new Text("$cargoTimer sec", style: TextStyle(fontFamily: "Product Sans", color: currTextColor)),
                    ),
                  ),
                )
              ],
            ),
          ),
          new ExpansionTile(
            title: new Text("Robot Disconnected?", style: TextStyle(color: currTextColor),),
            trailing: Container(
              width: 100.0,
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  new Text(
                    (dcList.length).toString(),
                    style: TextStyle(fontSize: 20.0, color: currTextColor),
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
                dcStartTime = stopwatch.elapsedMilliseconds / 1000;
                new Timer.periodic(new Duration(milliseconds: 100), (Timer timer) {
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
                  dcAdd = currCardColor;
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
                    color: currCardColor,
                    child: new ListTile(
                      title: new Text("$dcTimer sec", style: TextStyle(fontFamily: "Product Sans", color: currTextColor)),
                      trailing: new Visibility(
                        visible: reconnectVisible,
                        child: new FlatButton(
                            child: new Text("RECONNECTED"),
                            textColor: Colors.white,
                            color: Colors.red,
                            onPressed: () {
                              dcStopwatch.stop();
                              setState(() {
                                dcList.add(new Disconnect(dcStartTime, dcStopwatch.elapsedMilliseconds/1000));
                                print("Robot Disconnect @ ${dcList[dcList.length - 1].startTime} for ${dcList[dcList.length - 1].duration} seconds!");
                                reconnectVisible = false;
                              });
                              matchEventList.add(new Disconnect(dcStartTime, dcStopwatch.elapsedMilliseconds/1000));
                            }),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
          new ListTile(
            title: new Text("Fouls", style: TextStyle(color: foulText),),
            trailing: new Container(
              width: 100.0,
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  new Text(
                    (foulList.length).toString(),
                    style: TextStyle(fontSize: 20.0, color: currTextColor),
                  ),
                  new IconButton(
                    icon: new Image.asset(foulImagePath, color: foulAdd,),
                    onPressed: () {
                      if (foulImagePath == "images/add.png") {
                        foulTime = stopwatch.elapsedMilliseconds / 1000;
                        setState(() {
                          foulText = mainColor;
                          foulContainerHeight = 95;
                          foulImagePath = "images/subtract.png";
                          foulAdd = mainColor;
                        });
                      }
                      else {
                        foulTime = 0;
                        foulReason = "";
                        _foulController.clear();
                        FocusScope.of(context).requestFocus(new FocusNode());
                        setState(() {
                          foulText = currTextColor;
                          foulContainerHeight = 0.0;
                          foulImagePath = "images/add.png";
                          foulAdd = currCardColor;
                        });
                      }
                    },
                  )
                ],
              ),
            ),
          ),
          new AnimatedContainer(
            duration: new Duration(milliseconds: 300),
            curve: Curves.easeOut,
            padding: EdgeInsets.all(8.0),
            height: foulContainerHeight,
            child: new ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              child: Container(
                padding: EdgeInsets.all(8.0),
                color: currCardColor,
                child: new TextField(
                  focusNode: _focusController,
                  controller: _foulController,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (input) {
                    if (input == "") {
                      setState(() {
                        foulList.add(new Foul(foulTime, "Unknown Reason"));
                      });
                      matchEventList.add(new Foul(foulTime, "Unknown Reason"));
                    }
                    else {
                      setState(() {
                        foulList.add(new Foul(foulTime, input));
                      });
                      matchEventList.add(new Foul(foulTime, input));
                    }
                    print("foul @ ${foulList[foulList.length - 1].time} for ${foulList[foulList.length - 1].reason}");
                    foulTime = 0;
                    foulReason = "";
                    _foulController.clear();
                    setState(() {
                      foulContainerHeight = 0.0;
                      foulText = currTextColor;
                      foulImagePath = "images/add.png";
                      foulAdd = currCardColor;
                    });
                  },
                  decoration: InputDecoration(
                      labelText: "Foul Reason",
                      hintText: "Leave empty if you don't know"
                  ),
                ),
              ),
            ),
          ),
          new ListTile(
            title: new Text("Park Status", style: TextStyle(color: climbText),),
            subtitle: new Text(climbStatus, style: TextStyle(color: Colors.grey),),
            trailing: new Container(
                width: 100.0,
                child: new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      new Text(
                        climbList.length.toString(),
                        style: TextStyle(fontSize: 20.0, color: currTextColor),
                      ),
                      new IconButton(
                        icon: new Image.asset(climbImagePath, color: climbAdd,),
                        onPressed: () {
                          if (climbImagePath == "images/add.png") {
                            climbStartTime = stopwatch.elapsedMilliseconds / 1000;
                            setState(() {
                              canSupportYes = currCardColor;
                              canSupportNo = mainColor;
                              climbImagePath = "images/subtract.png";
                              climbText = mainColor;
                              climbAdd = mainColor;
                              climbContainerHeight = 250.0;
                            });
                          }
                          else {
                            setState(() {
                              climbImagePath = "images/add.png";
                              climbText = currTextColor;
                              climbAdd = currCardColor;
                              climbContainerHeight = 0.0;
                            });
                          }
                        },
                      ),
                    ]
                )
            )
          ),
          new AnimatedContainer(
            duration: new Duration(milliseconds: 300),
            curve: Curves.easeOut,
            padding: EdgeInsets.all(8.0),
            height: climbContainerHeight,
            color: currBackgroundColor,
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                new ListTile(
                  title: new Text("Can Support?", style: TextStyle(color: currTextColor),),
                  trailing: Container(
                    width: 100.0,
                    child: new Row(
                      children: <Widget>[
                        new IconButton(
                          icon: new Image.asset('images/yes.png', color: canSupportYes,),
                          color: canSupportYes,
                          onPressed: () {
                            canSupport = true;
                            setState(() {
                              canSupportYes = mainColor;
                              canSupportNo = currCardColor;
                            });
                          },
                        ),
                        new IconButton(
                          icon: new Image.asset('images/no.png', color: canSupportNo,),
                          onPressed: () {
                            canSupport = false;
                            setState(() {
                              canSupportYes = currCardColor;
                              canSupportNo = mainColor;
                            });
                          },
                        )
                      ],
                    ),
                  ),
                ),
                new Row(
                  children: <Widget>[
                    new Expanded(
                      child: new ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        child: new Container(
                          color: currCardColor,
                          child: new FlatButton(
                            child: new Text("Lvl 1", style: TextStyle(fontFamily: "Product Sans", color: currTextColor)),
                            onPressed: () {
                              climbList.add(new Climb(climbStartTime, 0.0, 1, canSupport, false));
                              matchEventList.add(new Climb(climbStartTime, 0.0, 1, canSupport, false));
                              setState(() {
                                climbImagePath = "images/add.png";
                                climbText = currTextColor;
                                climbContainerHeight = 0.0;
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
                          color: currCardColor,
                          child: new FlatButton(
                            child: new Text("Lvl 2", style: TextStyle(fontFamily: "Product Sans", color: currTextColor)),
                            onPressed: () {
                              climbList.add(new Climb(climbStartTime, 0, 2, canSupport, false));
                              matchEventList.add(new Climb(climbStartTime, 0, 2, canSupport, false));
                              setState(() {
                                climbImagePath = "images/add.png";
                                climbText = currTextColor;
                                climbContainerHeight = 0.0;
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
                          color: currCardColor,
                          child: new FlatButton(
                            child: new Text("Lvl 3", style: TextStyle(fontFamily: "Product Sans", color: currTextColor)),
                            onPressed: () {
                              climbList.add(new Climb(climbStartTime, 0, 3, canSupport, false));
                              matchEventList.add(new Climb(climbStartTime, 0, 3, canSupport, false));
                              setState(() {
                                climbImagePath = "images/add.png";
                                climbText = currTextColor;
                                climbContainerHeight = 0.0;
                              });
                            },
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
                      child: new ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        child: new Container(
                          color: Colors.red,
                          child: new FlatButton(
                            child: new Text("Not Parked"),
                            textColor: Colors.white,
                            onPressed: () {
                              climbList.add(new Climb(climbStartTime, 0, 0, canSupport, false));
                              matchEventList.add(new Climb(climbStartTime, 0, 0, canSupport, false));
                              setState(() {
                                climbImagePath = "images/add.png";
                                climbText = currTextColor;
                                climbAdd = currCardColor;
                                climbContainerHeight = 0.0;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
