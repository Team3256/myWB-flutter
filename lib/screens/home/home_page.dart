import 'dart:convert';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:mywb_flutter/models/event.dart';
import 'package:mywb_flutter/utils/config.dart';
import 'package:mywb_flutter/utils/theme.dart';
import 'package:http/http.dart' as http;
import '../../user_info.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with RouteAware {

  final GlobalKey<AnimatedCircularChartState> _chartKey = new GlobalKey<AnimatedCircularChartState>();
  final GlobalKey<AnimatedCircularChartState> _chartKey2 = new GlobalKey<AnimatedCircularChartState>();

  var location = new Location();
  LocationData currLocation;

  List<Widget> widgetList = new List();

  List<Widget> eventsWidgetList = new List();
  List<Event> eventsList = new List();

  int practiceProgress = 0;
  int outreachProgress = 0;

  int announcementCount = 0;

  Future<void> getAnnouncements() async {
    await http.get("$dbHost/posts", headers: {"Authentication": "Bearer $apiKey"}).then((response) async {
      print(response.body);
      var postsJson = jsonDecode(response.body);
      for (int i = 0; i < postsJson.length; i++) {
        if (postsJson[i]["tags"].contains("Announcement")) {
          setState(() {
            announcementCount++;
          });
        }
      }
    });
  }

  void confirmCheckOut(Event event) {
    showCupertinoModalPopup(context: context, builder: (BuildContext context) {
      return new CupertinoActionSheet(
          title: new Text("Are you sure you want to check out?"),
          message: new Text("You will not be able to check back in again for this event."),
          actions: <Widget>[
            new CupertinoActionSheetAction(
              child: new Text("Check out"),
              isDestructiveAction: true,
              onPressed: () {
                checkOutEvent(event);
                Navigator.pop(context);
              },
            )
          ],
          cancelButton: new CupertinoActionSheetAction(
            child: const Text("Cancel"),
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
          )
      );
    });
  }

  Future<void> getEvents() async {
    print("AUTO CHECK IN - ${autoCheckIn}");
    print("AUTO CHECK OUT - ${autoCheckOut}");
    await http.get("$dbHost/events", headers: {"Authentication": "Bearer $apiKey"}).then((response) async {
      print(response.body);
      print(DateTime.now());
      eventsList.clear();
      eventsWidgetList.clear();
      double requiredPractice = 0;
      var eventsJson = jsonDecode(response.body);
      await http.get("$dbHost/users/${currUser.id}/attendance/excused", headers: {"Authentication": "Bearer $apiKey"}).then((response) {
        print(response.body);
        var excusedJson = jsonDecode(response.body);
        for (int i = 0; i < eventsJson.length; i++) {
          Event event = new Event(eventsJson[i]);
          print(event.date);
          if (event.date.month == DateTime.now().month && event.date.day >= DateTime.now().day && event.date.day - DateTime.now().day <= 2) {
            print("Added ${event.id} to list");
            eventsList.add(event);
          }
          if (event.endTime.compareTo(DateTime.now()) < 0 && event.type == "practice") {
            print(event.endTime.difference(event.startTime).inMilliseconds / 3600000);
            requiredPractice += event.endTime.difference(event.startTime).inMilliseconds / 3600000;
            for (int i = 0; i < excusedJson.length; i++) {
              if (excusedJson[i]["eventID"] == event.id && excusedJson[i]["status"] == "verified") {
                print("EXCUSED");
                requiredPractice -= event.endTime.difference(event.startTime).inMilliseconds / 3600000;
              }
            }
          }
        }
        print("REQUIRED HOURS FOR USER: " + requiredPractice.toString());
        getAttendance(requiredPractice);
        eventsList.sort((a, b) {
          return a.date.compareTo(b.date);
        });
        updateWidgetList();
      });
    });
  }

  Future<void> getAttendance(double requiredPractice) async {
    await http.get("$dbHost/users/${currUser.id}/attendance", headers: {"Authentication": "Bearer $apiKey"}).then((response) async {
      print(response.body);
      double outreachHours = 0;
      double practiceHours = 0;
      var responseJson = jsonDecode(response.body);
      for (int i = 0; i < responseJson.length; i++) {
        if (responseJson[i]["type"] == "outreach") {
          outreachHours += responseJson[i]["hours"];
        }
        else if (responseJson[i]["type"] == "practice") {
          practiceHours += responseJson[i]["hours"];
        }
      }
      print("OUTREACH PROGRESS: ${outreachHours / 50.0 * 100}%");
      print("ATTENDANCE: ${practiceHours / requiredPractice * 100}%");
      setState(() {
        outreachProgress = (outreachHours / 50.0 * 100).round();
        print(outreachProgress.toString());
        practiceProgress = (practiceHours / requiredPractice * 100).round();
        print(practiceProgress.toString());
        Color outreachColor = Colors.blueGrey[600];
        Color practiceColor = Colors.blueGrey[600];
        if (practiceProgress < 75) {
          practiceColor = Colors.red;
        }
        else if (practiceProgress < 90) {
          practiceColor = Colors.orange;
        }
        else {
          practiceColor = Colors.lightGreen;
        }
        if (outreachProgress < 75) {
          outreachColor = Colors.red;
        }
        else if (outreachProgress < 90) {
          outreachColor = Colors.orange;
        }
        else {
          outreachColor = Colors.lightGreen;
        }
        _chartKey.currentState.updateData(<CircularStackEntry>[
          new CircularStackEntry(
            <CircularSegmentEntry>[
              new CircularSegmentEntry(practiceProgress.toDouble(), practiceColor, rankKey: 'done'),
              new CircularSegmentEntry(100 - practiceProgress.toDouble(), Colors.blueGrey[600], rankKey: 'remaining'),
            ],
          ),
        ]);
        _chartKey2.currentState.updateData(<CircularStackEntry>[
          new CircularStackEntry(
            <CircularSegmentEntry>[
              new CircularSegmentEntry(outreachProgress.toDouble(), outreachColor, rankKey: 'done'),
              new CircularSegmentEntry(100 - outreachProgress.toDouble(), Colors.blueGrey[600], rankKey: 'remaining'),
            ],
          ),
        ]);
      });
    });
  }

  Future<void> updateWidgetList() async {
    for (int i = 0; i < eventsList.length; i++) {
      if (eventsWidgetList.length < 2) {
        if (eventsList[i].date.month == DateTime.now().month && eventsList[i].date.day == DateTime.now().day) {
          eventsWidgetList.add(
              new Container(
                  width: double.infinity,
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      new Padding(padding: EdgeInsets.all(8.0)),
                      new Text(
                        "TODAY",
                        style: TextStyle(color: mainColor),
                        textAlign: TextAlign.start,
                      ),
                    ],
                  )
              )
          );
        }
        else {
          eventsWidgetList.add(
              new Container(
                  width: double.infinity,
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      new Padding(padding: EdgeInsets.all(8.0)),
                      new Text(
                        "UPCOMING – ${DateFormat('MM/dd/yy').format(eventsList[i].date)}",
                        style: TextStyle(color: mainColor),
                        textAlign: TextAlign.start,
                      ),
                    ],
                  )
              )
          );
        }
      }
      String status = "";
      await http.get("$dbHost/users/${currUser.id}/attendance/${eventsList[i].id}", headers: {"Authentication": "Bearer $apiKey"}).then((response) {
        print(response.body);
        var responseJson = jsonDecode(response.body);
        if (responseJson["message"] != null) {
          status = "checkIn";
        }
        else if (responseJson["checkIn"] == responseJson["checkOut"]) {
          status = "checkOut";
          autoCheckOut = responseJson["checkIn"];
        }
        else {
          status = "attended";
        }
      });
      if (eventsWidgetList.length < 2) {
        eventsWidgetList.add(
            new InkWell(
              borderRadius: BorderRadius.all(Radius.circular(16.0)),
              onTap: () {
                autoCheckIn = false;
                autoCheckOut = "";
                selectedEvent = eventsList[i];
                router.navigateTo(context, '/events/details', transition: TransitionType.cupertino);
              },
              child: new Container(
                padding: EdgeInsets.all(8.0),
                child: new Column(
                  children: <Widget>[
                    new Text(
                      eventsList[i].name,
                      style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                    ),
                    new Padding(padding: EdgeInsets.all(8.0)),
                    new ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(16.0)),
                      child: new Container(
                        height: 150,
                        child: new GoogleMap(
                          onTap: (latlng) {
                            autoCheckIn = false;
                            autoCheckOut = "";
                            selectedEvent = eventsList[i];
                            router.navigateTo(context, '/events/details', transition: TransitionType.cupertino);
                          },
                          initialCameraPosition: CameraPosition(
                              target: LatLng(eventsList[i].latitude, eventsList[i].longitude),
                              zoom: 14.0
                          ),
                          compassEnabled: false,
                          myLocationButtonEnabled: false,
                          markers: Set<Marker>.from([
                            Marker(
                                markerId: MarkerId(eventsList[i].id),
                                position: LatLng(eventsList[i].latitude, eventsList[i].longitude),
                                infoWindow: InfoWindow(title: "Location")
                            )
                          ]),
                        ),
                      ),
                    ),
                    new Padding(padding: EdgeInsets.all(8.0)),
                    new Visibility(
                      visible: (eventsList[i].date.month == DateTime.now().month && eventsList[i].date.day == DateTime.now().day && status == "checkIn"),
                      child: new Container(
                        width: double.infinity,
                        child: new CupertinoButton(
                          child: new Text("Check In"),
                          color: mainColor,
                          borderRadius: BorderRadius.all(Radius.circular(16.0)),
                          onPressed: () {
                            checkInEvent(eventsList[i]);
                          },
                        ),
                      )
                    ),
                    new Visibility(
                        visible: status == "checkOut",
                        child: new Container(
                          width: double.infinity,
                          child: new CupertinoButton(
                            child: new Text("Check Out"),
                            color: Colors.red,
                            borderRadius: BorderRadius.all(Radius.circular(16.0)),
                            onPressed: () {
                              confirmCheckOut(eventsList[i]);
                            },
                          ),
                        )
                    ),
                    new Visibility(
                        visible: status == "attended",
                        child: new Container(
                          width: MediaQuery.of(context).size.width - 16,
                          child: new CupertinoButton(
                            child: new Text("Attended"),
                            color: Colors.green,
                            borderRadius: BorderRadius.all(Radius.circular(16.0)),
                            onPressed: () {},
                          ),
                        )
                    )
                  ],
                ),
              ),
            )
        );
      }
    }
    setState(() {
      eventsWidgetList.add(
        new Container(
          width: double.infinity,
          child: new FlatButton(
            child: new Text("VIEW ALL EVENTS"),
            textColor: mainColor,
            onPressed: () {
              router.navigateTo(context, '/events', transition: TransitionType.cupertino);
            },
          ),
        )
      );
    });
  }

  Future<void> checkInEvent(Event event) async {
    try {
      currLocation = await location.getLocation();
      selectedEvent = event;
      autoCheckIn = true;
      router.navigateTo(context, '/events/details', transition: TransitionType.cupertino);
    } catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
//        error = 'Permission denied';
      }
      currLocation = null;
    }
  }

  Future<void> checkOutEvent(Event event) async {
    try {
      currLocation = await location.getLocation();
      selectedEvent = event;
      router.navigateTo(context, '/events/details', transition: TransitionType.cupertino);
    } catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
//        error = 'Permission denied';
      }
      currLocation = null;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context));
  }

  void didPopNext() {
    debugPrint("didPopNext ${runtimeType}");
    getEvents();
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getEvents();
    getAnnouncements();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        new CupertinoSliverNavigationBar(
          backgroundColor: mainColor,
          largeTitle: new Text("Home", style: TextStyle(color: Colors.white),),
          actionsForegroundColor: Colors.white,
        ),
        SliverList(
          delegate: SliverChildListDelegate([
            new Container(
              padding: EdgeInsets.only(top: 8.0, right: 8.0, left: 8.0),
              child: new Row(
                children: <Widget>[
                  new Expanded(
                    flex: 5,
                    child: new Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
                      color: currCardColor,
                      elevation: 6.0,
                      child: new InkWell(
                        borderRadius: BorderRadius.all(Radius.circular(16.0)),
                        onTap: () {
                          router.navigateTo(context, '/attendance', transition: TransitionType.cupertino);
                        },
                        child: new Container(
                          height: 100,
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              new AnimatedCircularChart(
                                key: _chartKey,
                                size: const Size(100, 100),
                                initialChartData: <CircularStackEntry>[
                                  new CircularStackEntry(
                                    <CircularSegmentEntry>[
                                      new CircularSegmentEntry(
                                        0.0,
                                        Colors.blue[400],
                                        rankKey: 'completed',
                                      ),
                                      new CircularSegmentEntry(
                                        100.0,
                                        Colors.blueGrey[600],
                                        rankKey: 'remaining',
                                      ),
                                    ],
                                    rankKey: 'progress',
                                  ),
                                ],
                                chartType: CircularChartType.Radial,
                                percentageValues: true,
                                holeLabel: '$practiceProgress%',
                                labelStyle: new TextStyle(
                                  color: Colors.blueGrey[600],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24.0,
                                ),
                              ),
                              new AnimatedCircularChart(
                                key: _chartKey2,
                                size: const Size(100, 100),
                                initialChartData: <CircularStackEntry>[
                                  new CircularStackEntry(
                                    <CircularSegmentEntry>[
                                      new CircularSegmentEntry(
                                        0.0,
                                        Colors.blue[400],
                                        rankKey: 'completed',
                                      ),
                                      new CircularSegmentEntry(
                                        100.0,
                                        Colors.blueGrey[600],
                                        rankKey: 'remaining',
                                      ),
                                    ],
                                    rankKey: 'progress',
                                  ),
                                ],
                                chartType: CircularChartType.Radial,
                                percentageValues: true,
                                holeLabel: '$outreachProgress%',
                                labelStyle: new TextStyle(
                                  color: Colors.blueGrey[600],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24.0,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  new Padding(padding: EdgeInsets.all(4.0)),
                  new Expanded(
                    flex: 3,
                    child: new Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
                      color: currCardColor,
                      elevation: 6.0,
                      child: new InkWell(
                        borderRadius: BorderRadius.all(Radius.circular(16.0)),
                        onTap: () {
                        },
                        child: new Container(
                          height: 100,
                          child: new Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              new Text(
                                announcementCount.toString(),
                                style: TextStyle(fontSize: 35.0, color: darkMode ? Colors.grey : Colors.black54),
                              ),
                              new Text(
                                "Announcements",
                                style: TextStyle(fontSize: 13.0, color: currTextColor),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            new Visibility(
              visible: eventsWidgetList.isNotEmpty,
              child: new Container(
                padding: EdgeInsets.only(top: 8.0, right: 8.0, left: 8.0),
                child: new Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
                  color: currCardColor,
                  elevation: 6.0,
                  child: new Container(
                    padding: EdgeInsets.all(8.0),
                    child: new Column(
                      children: eventsWidgetList,
                    ),
                  ),
                ),
              ),
            ),
            new Visibility(
              visible: eventsWidgetList.isEmpty,
              child: new Container(
                padding: EdgeInsets.only(top: 8.0, right: 8.0, left: 8.0),
                child: new Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
                  color: currCardColor,
                  elevation: 6.0,
                  child: new Container(
                    padding: EdgeInsets.all(32.0),
                    child: new HeartbeatProgressIndicator(
                        child: new Image.asset(
                          'images/wblogo.png',
                          height: 15.0,
                        )
                    )
                  ),
                ),
              ),
            )
          ]),
        ),
      ],
    );
  }
}
