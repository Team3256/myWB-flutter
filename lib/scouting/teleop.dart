import 'dart:async';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:mywb_flutter/theme.dart';
import 'package:mywb_flutter/user_info.dart';
import 'package:flutter/cupertino.dart';

class TeleOp extends StatefulWidget {
  @override
  _TeleOpState createState() => _TeleOpState();
}

class _TeleOpState extends State<TeleOp> {

  //DC
  Color dcAdd = greyAccent;
  int dcTimer = 0;
  String dcImagePath = "images/add.png";
  bool reconnectVisible = false;

  //Hatch
  int hatchCounter = 0;
  Color hatchAdd = greyAccent;
  Color hatchTitle = Colors.black;
  String hatchImagePath = "images/add.png";
  int hatchTimer = 0;
  bool intakeVisible = false;
  bool dropVisible = false;
  double hatchContainerHeight = 0.0;
  String hatchIntakeLocation = "";
  String hatchDropLocation = "";

  //Cargo
  int cargoCounter = 0;
  Color cargoAdd = greyAccent;
  Color cargoTitle = Colors.black;
  String cargoImagePath = "images/add.png";
  int cargoTimer = 0;
  bool cargoIntakeVisible = false;
  bool cargoDropVisible = false;
  double cargoContainerHeight = 0.0;
  String cargoIntakeLocation = "";
  String cargoDropLocation = "";

  //fouls
  String foulImagePath = "images/add.png";
  Color foulAdd = greyAccent;
  Color foulText = Colors.black;
  String foulReason = "";
  double foulTime = 0.0;
  double foulContainerHeight = 0.0;
  FocusNode _focusController = new FocusNode();
  TextEditingController _foulController = new TextEditingController();

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
                        hatchDropLocation = "";
                        hatchIntakeLocation = "";
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
                new Text("Intake Location: $hatchIntakeLocation", style: TextStyle(fontWeight: FontWeight.bold),),
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
                                  hatchIntakeLocation = "Human Player Station";
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
                new Visibility(visible: dropVisible, child: new Text("Drop Location: $hatchDropLocation", style: TextStyle(fontWeight: FontWeight.bold),)),
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
                                hatchDropLocation = "Cargo Ship";
                                hatchStopwatch.stop();
                                setState(() {
                                  hatchCounter++;
                                  hatchList.add(new Hatch(hatchIntakeLocation, hatchDropLocation, stopwatch.elapsedMilliseconds/1000, hatchStopwatch.elapsedMilliseconds/1000, "Tele-Op"));
                                  dropVisible = false;
                                  intakeVisible = false;
                                  hatchContainerHeight = 0.0;
                                  hatchAdd = greyAccent;
                                  hatchTitle = Colors.black;
                                  hatchImagePath = "images/add.png";
                                });
                                matchEventList.add(new Hatch(hatchIntakeLocation, hatchDropLocation, stopwatch.elapsedMilliseconds/1000, hatchStopwatch.elapsedMilliseconds/1000, "Tele-Op"));
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
                            color: greyAccent,
                            child: new FlatButton(
                              child: new Text("Rocket Lvl 1"),
                              onPressed: () {
                                hatchDropLocation = "Rocket Lvl 1";
                                hatchStopwatch.stop();
                                setState(() {
                                  hatchCounter++;
                                  hatchList.add(new Hatch(hatchIntakeLocation, hatchDropLocation, stopwatch.elapsedMilliseconds/1000, hatchStopwatch.elapsedMilliseconds/1000, "Tele-Op"));
                                  dropVisible = false;
                                  intakeVisible = false;
                                  hatchContainerHeight = 0.0;
                                  hatchAdd = greyAccent;
                                  hatchTitle = Colors.black;
                                  hatchImagePath = "images/add.png";
                                });
                                matchEventList.add(new Hatch(hatchIntakeLocation, hatchDropLocation, stopwatch.elapsedMilliseconds/1000, hatchStopwatch.elapsedMilliseconds/1000, "Tele-Op"));
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
                            color: greyAccent,
                            child: new FlatButton(
                              child: new Text("Rocket Lvl 2"),
                              onPressed: () {
                                hatchDropLocation = "Rocket Lvl 2";
                                hatchStopwatch.stop();
                                setState(() {
                                  hatchCounter++;
                                  hatchList.add(new Hatch(hatchIntakeLocation, hatchDropLocation, stopwatch.elapsedMilliseconds/1000, hatchStopwatch.elapsedMilliseconds/1000, "Tele-Op"));
                                  dropVisible = false;
                                  intakeVisible = false;
                                  hatchContainerHeight = 0.0;
                                  hatchAdd = greyAccent;
                                  hatchTitle = Colors.black;
                                  hatchImagePath = "images/add.png";
                                });
                                matchEventList.add(new Hatch(hatchIntakeLocation, hatchDropLocation, stopwatch.elapsedMilliseconds/1000, hatchStopwatch.elapsedMilliseconds/1000, "Tele-Op"));
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
                            color: greyAccent,
                            child: new FlatButton(
                              child: new Text("Rocket Lvl 3"),
                              onPressed: () {
                                hatchDropLocation = "Rocket Lvl 3";
                                hatchStopwatch.stop();
                                setState(() {
                                  hatchCounter++;
                                  hatchList.add(new Hatch(hatchIntakeLocation, hatchDropLocation, stopwatch.elapsedMilliseconds/1000, hatchStopwatch.elapsedMilliseconds/1000, "Tele-Op"));
                                  dropVisible = false;
                                  intakeVisible = false;
                                  hatchContainerHeight = 0.0;
                                  hatchAdd = greyAccent;
                                  hatchTitle = Colors.black;
                                  hatchImagePath = "images/add.png";
                                });
                                matchEventList.add(new Hatch(hatchIntakeLocation, hatchDropLocation, stopwatch.elapsedMilliseconds/1000, hatchStopwatch.elapsedMilliseconds/1000, "Tele-Op"));
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
                              child: new Text("Droppped"),
                              textColor: Colors.white,
                              onPressed: () {
                                hatchDropLocation = "Dropped";
                                hatchStopwatch.stop();
                                setState(() {
                                  hatchList.add(new Hatch(hatchIntakeLocation, hatchDropLocation, stopwatch.elapsedMilliseconds/1000, hatchStopwatch.elapsedMilliseconds/1000, "Tele-Op"));
                                  dropVisible = false;
                                  intakeVisible = false;
                                  hatchContainerHeight = 0.0;
                                  hatchAdd = greyAccent;
                                  hatchTitle = Colors.black;
                                  hatchImagePath = "images/add.png";
                                });
                                matchEventList.add(new Hatch(hatchIntakeLocation, hatchDropLocation, stopwatch.elapsedMilliseconds/1000, hatchStopwatch.elapsedMilliseconds/1000, "Tele-Op"));
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
                    color: greyAccent,
                    child: new ListTile(
                      title: new Text("$hatchTimer sec"),
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
                    style: TextStyle(fontSize: 20.0),
                  ),
                  new IconButton(
                    icon: new Image.asset(cargoImagePath, color: cargoAdd,),
                    onPressed: () {
                      if (cargoImagePath == "images/add.png") {
                        cargoStopwatch.reset();
                        cargoStopwatch.start();
                        new Timer.periodic(new Duration(milliseconds: 500), (Timer timer) {
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
                          cargoTitle = Colors.black;
                          cargoAdd = greyAccent;
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
                new Text("Intake Location: $cargoIntakeLocation", style: TextStyle(fontWeight: FontWeight.bold),),
                new Visibility(visible: cargoIntakeVisible, child: new Padding(padding: EdgeInsets.all(4.0))),
                new Visibility(
                  visible: cargoIntakeVisible,
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
                                  cargoIntakeLocation = "Human Player Station";
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
                            color: greyAccent,
                            child: new FlatButton(
                              child: new Text("Ground"),
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
                new Visibility(visible: cargoDropVisible, child: new Text("Drop Location: $cargoDropLocation", style: TextStyle(fontWeight: FontWeight.bold),)),
                new Visibility(visible: cargoDropVisible, child: new Padding(padding: EdgeInsets.all(4.0))),
                new Visibility(
                  visible: cargoDropVisible,
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
                                cargoDropLocation = "Cargo Ship";
                                cargoStopwatch.stop();
                                setState(() {
                                  cargoCounter++;
                                  cargoList.add(new Cargo(cargoIntakeLocation, cargoDropLocation, stopwatch.elapsedMilliseconds/1000, cargoStopwatch.elapsedMilliseconds/1000, "Tele-Op"));
                                  cargoDropVisible = false;
                                  cargoIntakeVisible = false;
                                  cargoContainerHeight = 0.0;
                                  cargoAdd = greyAccent;
                                  cargoTitle = Colors.black;
                                  cargoImagePath = "images/add.png";
                                });
                                matchEventList.add(new Cargo(cargoIntakeLocation, cargoDropLocation, stopwatch.elapsedMilliseconds/1000, cargoStopwatch.elapsedMilliseconds/1000, "Tele-Op"));
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
                            color: greyAccent,
                            child: new FlatButton(
                              child: new Text("Rocket Lvl 1"),
                              onPressed: () {
                                cargoDropLocation = "Rocket Lvl 1";
                                cargoStopwatch.stop();
                                setState(() {
                                  cargoCounter++;
                                  cargoList.add(new Cargo(cargoIntakeLocation, cargoDropLocation, stopwatch.elapsedMilliseconds/1000, cargoStopwatch.elapsedMilliseconds/1000, "Tele-Op"));
                                  cargoDropVisible = false;
                                  cargoIntakeVisible = false;
                                  cargoContainerHeight = 0.0;
                                  cargoAdd = greyAccent;
                                  cargoTitle = Colors.black;
                                  cargoImagePath = "images/add.png";
                                });
                                matchEventList.add(new Cargo(cargoIntakeLocation, cargoDropLocation, stopwatch.elapsedMilliseconds/1000, cargoStopwatch.elapsedMilliseconds/1000, "Tele-Op"));
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
                            color: greyAccent,
                            child: new FlatButton(
                              child: new Text("Rocket Lvl 2"),
                              onPressed: () {
                                cargoDropLocation = "Rocket Lvl 2";
                                cargoStopwatch.stop();
                                setState(() {
                                  cargoCounter++;
                                  cargoList.add(new Cargo(cargoIntakeLocation, cargoDropLocation, stopwatch.elapsedMilliseconds/1000, cargoStopwatch.elapsedMilliseconds/1000, "Tele-Op"));
                                  cargoDropVisible = false;
                                  cargoIntakeVisible = false;
                                  cargoContainerHeight = 0.0;
                                  cargoAdd = greyAccent;
                                  cargoTitle = Colors.black;
                                  cargoImagePath = "images/add.png";
                                });
                                matchEventList.add(new Cargo(cargoIntakeLocation, cargoDropLocation, stopwatch.elapsedMilliseconds/1000, cargoStopwatch.elapsedMilliseconds/1000, "Tele-Op"));
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
                            color: greyAccent,
                            child: new FlatButton(
                              child: new Text("Rocket Lvl 3"),
                              onPressed: () {
                                cargoDropLocation = "Rocket Lvl 3";
                                cargoStopwatch.stop();
                                setState(() {
                                  cargoCounter++;
                                  cargoList.add(new Cargo(cargoIntakeLocation, cargoDropLocation, stopwatch.elapsedMilliseconds/1000, cargoStopwatch.elapsedMilliseconds/1000, "Tele-Op"));
                                  cargoDropVisible = false;
                                  cargoIntakeVisible = false;
                                  cargoContainerHeight = 0.0;
                                  cargoAdd = greyAccent;
                                  cargoTitle = Colors.black;
                                  cargoImagePath = "images/add.png";
                                });
                                matchEventList.add(new Cargo(cargoIntakeLocation, cargoDropLocation, stopwatch.elapsedMilliseconds/1000, cargoStopwatch.elapsedMilliseconds/1000, "Tele-Op"));
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
                              child: new Text("Droppped"),
                              textColor: Colors.white,
                              onPressed: () {
                                cargoDropLocation = "Dropped";
                                cargoStopwatch.stop();
                                setState(() {
                                  cargoList.add(new Cargo(cargoIntakeLocation, cargoDropLocation, stopwatch.elapsedMilliseconds/1000, cargoStopwatch.elapsedMilliseconds/1000, "Tele-Op"));
                                  cargoDropVisible = false;
                                  cargoIntakeVisible = false;
                                  cargoContainerHeight = 0.0;
                                  cargoAdd = greyAccent;
                                  cargoTitle = Colors.black;
                                  cargoImagePath = "images/add.png";
                                });
                                matchEventList.add(new Cargo(cargoIntakeLocation, cargoDropLocation, stopwatch.elapsedMilliseconds/1000, cargoStopwatch.elapsedMilliseconds/1000, "Tele-Op"));
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
                    color: greyAccent,
                    child: new ListTile(
                      title: new Text("$cargoTimer sec"),
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
                                dcList.add(new Disconnect(stopwatch.elapsedMilliseconds/1000, dcStopwatch.elapsedMilliseconds/1000));
                                print("Robot Disconnect @ ${dcList.elementAt(dcList.length - 2)} for ${dcList.elementAt(dcList.length - 1)} seconds!");
                                reconnectVisible = false;
                              });
                              matchEventList.add(new Disconnect(stopwatch.elapsedMilliseconds/1000, dcStopwatch.elapsedMilliseconds/1000));
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
                    style: TextStyle(fontSize: 20.0),
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
                          foulText = Colors.black;
                          foulContainerHeight = 0.0;
                          foulImagePath = "images/add.png";
                          foulAdd = greyAccent;
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
                color: greyAccent,
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
                      foulText = Colors.black;
                      foulImagePath = "images/add.png";
                      foulAdd = greyAccent;
                    });
                  },
                  decoration: InputDecoration(
                      labelText: "Foul Reason",
                      hintText: "Leave empty if you don't know"
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}