import 'dart:convert';

import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mywb_flutter/models/event.dart';
import 'package:mywb_flutter/user_info.dart';
import 'package:mywb_flutter/utils/config.dart';
import 'package:mywb_flutter/utils/theme.dart';
import 'package:http/http.dart' as http;
import 'package:progress_indicators/progress_indicators.dart';

class EventsPage extends StatefulWidget {
  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {

  String state = "all";

  Color allTextColor = Colors.white;
  Color practiceTextColor = currTextColor;
  Color outreachTextColor = currTextColor;

  Color allColor = mainColor;
  Color practiceColor = currBackgroundColor;
  Color outreachColor = currBackgroundColor;

  double allElevation = 6.0;
  double practiceElevation = 0.0;
  double outreachElevation = 0.0;

  List<Widget> eventsWidgetList = new List();
  List<Event> eventsList = new List();

  Future<void> getEvents() async {
    print("GET ALL EVENTS");
    setState(() {
      state = "all";

      eventsWidgetList.clear();
      eventsList.clear();

      allTextColor = Colors.white;
      practiceTextColor = currTextColor;
      outreachTextColor = currTextColor;

      allColor = mainColor;
      practiceColor = currBackgroundColor;
      outreachColor = currBackgroundColor;

      allElevation = 6.0;
      practiceElevation = 0.0;
      outreachElevation = 0.0;
    });
    await http.get("$dbHost/events", headers: {"Authentication": "Bearer $apiKey"}).then((response) async {
      print(response.body);
      var eventsJson = jsonDecode(response.body);
      for (int i = 0; i < eventsJson.length; i++) {
        Event event = new Event(eventsJson[i]);
        eventsList.add(event);
        print(event.id);
      }
      eventsList.sort((a, b) {
        return a.date.compareTo(b.date);
      });
      for (Event event in eventsList) {
        await http.get("$dbHost/users/${currUser.id}/attendance/${event.id}", headers: {"Authentication": "Bearer $apiKey"}).then((response) async {
          print(response.body);
          var responseJson = jsonDecode(response.body);
          Color statusColor;
          if (responseJson["message"] != null && event.endTime.compareTo(DateTime.now()) < 0 && event.type == "practice") {
            print("NOT ATTENDED");
            statusColor = Colors.red;
            await http.get("$dbHost/users/${currUser.id}/attendance/excused", headers: {"Authentication": "Bearer $apiKey"}).then((response) {
              var excusedJson = jsonDecode(response.body);
              for (int i = 0; i < excusedJson.length; i++) {
                if (excusedJson[i]["eventID"] == event.id && excusedJson[i]["status"] == "verified") {
                  print("EXCUSED ABSENCE FOR ${event.id}");
                  statusColor = Colors.green;
                }
              }
            });
          }
          else if (responseJson["message"] != null) {
            print("UPCOMING");
            statusColor = Colors.grey;
          }
          else if (responseJson["checkIn"] == responseJson["checkOut"]) {
            print("CURRENT EVENT");
            statusColor = mainColor;
          }
          else {
            print("EVENT ATTENDED");
            statusColor = Colors.green;
          }
          setState(() {
            eventsWidgetList.add(
                new Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
                  color: currCardColor,
                  elevation: 6.0,
                  child: new InkWell(
                    borderRadius: BorderRadius.all(Radius.circular(16.0)),
                    onTap: () {
                      autoCheckIn = false;
                      autoCheckOut = "";
                      selectedEvent = event;
                      router.navigateTo(context, '/events/details', transition: TransitionType.cupertino);
                    },
                    child: new Container(
                      padding: EdgeInsets.only(top: 4.0, bottom: 4.0),
                      child: new Column(
                        children: <Widget>[
                          new Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                child: new Center(
                                  child: new Text(
                                    DateFormat('M/d').format(event.date),
                                    style: TextStyle(
                                        color: statusColor,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ),
                                width: 50.0,
                              ),
                              new Padding(padding: EdgeInsets.all(8.0)),
                              new Expanded(
                                child: new Container(
                                  padding: EdgeInsets.all(4.0),
                                  child: new Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      new Text(
                                        event.name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: currTextColor,
                                          fontSize: 15.0,
                                        ),
                                      ),
                                      new Padding(padding: EdgeInsets.all(1.0)),
                                      new Text(
                                        event.desc,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: CupertinoColors.inactiveGray,
                                          fontSize: 14.0,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              new Icon(Icons.navigate_next, color: currDividerColor)
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                )
            );
            eventsWidgetList.add(new Padding(padding: EdgeInsets.all(4.0)));
          });
        });
      }
    });
    for (Widget widget in eventsWidgetList) {
      print(widget.runtimeType);
    }
  }

  Future<void> getPracticeEvents() async {
    setState(() {
      state = "practice";

      eventsWidgetList.clear();
      eventsList.clear();

      allTextColor = currTextColor;
      practiceTextColor = Colors.white;
      outreachTextColor = currTextColor;

      allColor = currBackgroundColor;
      practiceColor = mainColor;
      outreachColor = currBackgroundColor;

      allElevation = 0.0;
      practiceElevation = 6.0;
      outreachElevation = 0.0;
    });
    await http.get("$dbHost/events", headers: {"Authentication": "Bearer $apiKey"}).then((response) async {
      print(response.body);
      var eventsJson = jsonDecode(response.body);
      for (int i = 0; i < eventsJson.length; i++) {
        Event event = new Event(eventsJson[i]);
        if (event.type == "practice" || event.type == "practice1") {
          eventsList.add(event);
        }
      }
      eventsList.sort((a, b) {
        return a.date.compareTo(b.date);
      });
      for (Event event in eventsList) {
        await http.get("$dbHost/users/${currUser.id}/attendance/${event.id}", headers: {"Authentication": "Bearer $apiKey"}).then((response) async {
          print(response.body);
          var responseJson = jsonDecode(response.body);
          Color statusColor;
          if (responseJson["message"] != null && event.endTime.compareTo(DateTime.now()) < 0 && event.type == "practice") {
            statusColor = Colors.red;
            await http.get("$dbHost/users/${currUser.id}/attendance/excused", headers: {"Authentication": "Bearer $apiKey"}).then((response) {
              print(response.body);
              var excusedJson = jsonDecode(response.body);
              for (int i = 0; i < excusedJson.length; i++) {
                if (excusedJson[i]["eventID"] == event.id && excusedJson[i]["status"] == "verified") {
                  statusColor = Colors.green;
                }
              }
            });
          }
          else if (responseJson["message"] != null) {
            statusColor = Colors.grey;
          }
          else if (responseJson["checkIn"] == responseJson["checkOut"]) {
            statusColor = mainColor;
          }
          else {
            statusColor = Colors.green;
          }
          setState(() {
            eventsWidgetList.add(
                new Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
                  color: currCardColor,
                  elevation: 6.0,
                  child: new InkWell(
                    borderRadius: BorderRadius.all(Radius.circular(16.0)),
                    onTap: () {
                      autoCheckIn = false;
                      autoCheckOut = "";
                      selectedEvent = event;
                      router.navigateTo(context, '/events/details', transition: TransitionType.cupertino);
                    },
                    child: new Container(
                      padding: EdgeInsets.only(top: 4.0, bottom: 4.0),
                      child: new Column(
                        children: <Widget>[
                          new Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                child: new Center(
                                  child: new Text(
                                    DateFormat('M/d').format(event.date),
                                    style: TextStyle(
                                        color: statusColor,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ),
                                width: 50.0,
                              ),
                              new Padding(padding: EdgeInsets.all(8.0)),
                              new Expanded(
                                child: new Container(
                                  padding: EdgeInsets.all(4.0),
                                  child: new Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      new Text(
                                        event.name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: currTextColor,
                                          fontSize: 15.0,
                                        ),
                                      ),
                                      new Padding(padding: EdgeInsets.all(1.0)),
                                      new Text(
                                        event.desc,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: CupertinoColors.inactiveGray,
                                          fontSize: 14.0,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              new Icon(Icons.navigate_next, color: currDividerColor)
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                )
            );
            eventsWidgetList.add(new Padding(padding: EdgeInsets.all(4.0)));
          });
        });
      }
    });
  }

  Future<void> getOutreachEvents() async {
    setState(() {
      state = "outreach";

      eventsWidgetList.clear();
      eventsList.clear();

      allTextColor = currTextColor;
      practiceTextColor = currTextColor;
      outreachTextColor = Colors.white;

      allColor = currBackgroundColor;
      practiceColor = currBackgroundColor;
      outreachColor = mainColor;

      allElevation = 0.0;
      practiceElevation = 0.0;
      outreachElevation = 6.0;
    });
    await http.get("$dbHost/events", headers: {"Authentication": "Bearer $apiKey"}).then((response) async {
      print(response.body);
      var eventsJson = jsonDecode(response.body);
      for (int i = 0; i < eventsJson.length; i++) {
        Event event = new Event(eventsJson[i]);
        if (event.type == "outreach") {
          eventsList.add(event);
        }
      }
      eventsList.sort((a, b) {
        return a.date.compareTo(b.date);
      });
      for (Event event in eventsList) {
        await http.get("$dbHost/users/${currUser.id}/attendance/${event.id}", headers: {"Authentication": "Bearer $apiKey"}).then((response) async {
          print(response.body);
          var responseJson = jsonDecode(response.body);
          Color statusColor;
          if (responseJson["message"] != null && event.endTime.compareTo(DateTime.now()) < 0 && event.type == "practice") {
            statusColor = Colors.red;
            await http.get("$dbHost/users/${currUser.id}/attendance/excused", headers: {"Authentication": "Bearer $apiKey"}).then((response) {
              print(response.body);
              var excusedJson = jsonDecode(response.body);
              for (int i = 0; i < excusedJson.length; i++) {
                if (excusedJson[i]["eventID"] == event.id && excusedJson[i]["status"] == "verified") {
                  statusColor = Colors.green;
                }
              }
            });
          }
          else if (responseJson["message"] != null) {
            statusColor = Colors.grey;
          }
          else if (responseJson["checkIn"] == responseJson["checkOut"]) {
            statusColor = mainColor;
          }
          else {
            statusColor = Colors.green;
          }
          setState(() {
            eventsWidgetList.add(
                new Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
                  color: currCardColor,
                  elevation: 6.0,
                  child: new InkWell(
                    borderRadius: BorderRadius.all(Radius.circular(16.0)),
                    onTap: () {
                      autoCheckIn = false;
                      autoCheckOut = "";
                      selectedEvent = event;
                      router.navigateTo(context, '/events/details', transition: TransitionType.cupertino);
                    },
                    child: new Container(
                      padding: EdgeInsets.only(top: 4.0, bottom: 4.0),
                      child: new Column(
                        children: <Widget>[
                          new Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                child: new Center(
                                  child: new Text(
                                    DateFormat('M/d').format(event.date),
                                    style: TextStyle(
                                        color: statusColor,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ),
                                width: 50.0,
                              ),
                              new Padding(padding: EdgeInsets.all(8.0)),
                              new Expanded(
                                child: new Container(
                                  padding: EdgeInsets.all(4.0),
                                  child: new Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      new Text(
                                        event.name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: currTextColor,
                                          fontSize: 15.0,
                                        ),
                                      ),
                                      new Padding(padding: EdgeInsets.all(1.0)),
                                      new Text(
                                        event.desc,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: CupertinoColors.inactiveGray,
                                          fontSize: 14.0,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              new Icon(Icons.navigate_next, color: currDividerColor)
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                )
            );
            eventsWidgetList.add(new Padding(padding: EdgeInsets.all(4.0)));
          });
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new CupertinoNavigationBar(
        middle: new Text("Events", style: TextStyle(color: Colors.white)),
        previousPageTitle: "Home",
        actionsForegroundColor: Colors.white,
        backgroundColor: mainColor,
      ),
      backgroundColor: currBackgroundColor,
      body: new Container(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            new Row(
              children: <Widget>[
                new Expanded(
                  child: new Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
                    color: allColor,
                    elevation: allElevation,
                    child: new FlatButton(
                      child: new Text("All", style: TextStyle(color: allTextColor)),
                      onPressed: () {
                        if (state != "all") {
                          getEvents();
                        }
                      }
                    ),
                  ),
                ),
                new Expanded(
                  child: new Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
                    color: practiceColor,
                    elevation: practiceElevation,
                    child: new FlatButton(
                        child: new Text("Practice", style: TextStyle(color: practiceTextColor)),
                        onPressed: () {
                          if (state != "practice") {
                            getPracticeEvents();
                          }
                        }
                    ),
                  ),
                ),
                new Expanded(
                  child: new Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
                    color: outreachColor,
                    elevation: outreachElevation,
                    child: new FlatButton(
                        child: new Text("Outreach", style: TextStyle(color: outreachTextColor)),
                        onPressed: () {
                          if (state != "outreach") {
                            getOutreachEvents();
                          }
                        }
                    ),
                  ),
                ),
              ],
            ),
            new Padding(padding: EdgeInsets.all(4.0)),
            new Visibility(
              visible: eventsList.isNotEmpty,
              child: new Expanded(
                child: new SingleChildScrollView(
                  child: new Column(
                    children: eventsWidgetList,
                  ),
                ),
              ),
            ),
            new Visibility(
              visible: eventsList.isEmpty,
              child: new Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(32.0),
                  child: new HeartbeatProgressIndicator(
                      child: new Image.asset(
                        'images/wblogo.png',
                        height: 15.0,
                      )
                  )
              )
            )
          ],
        ),
      ),
    );
  }
}
