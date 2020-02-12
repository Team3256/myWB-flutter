import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:mywb_flutter/models/event.dart';
import 'package:mywb_flutter/user_info.dart';
import 'package:mywb_flutter/utils/config.dart';
import 'package:mywb_flutter/utils/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EventsDetailsPage extends StatefulWidget {
  @override
  _EventsDetailsPageState createState() => _EventsDetailsPageState();
}

class _EventsDetailsPageState extends State<EventsDetailsPage> {

  var location = new Location();
  LocationData currentLocation;

  GoogleMapController mapController;
  final Set<Marker> _markers = Set();
  
  Widget fabWidget = new Container();

  String checkInText = "";
  String checkOutText = "";

  String calcDistance(double lat1, double lon1, double lat2, double lon2) {
    double theta = lon1 - lon2;
    double dist = sin(deg2rad(lat1)) * sin(deg2rad(lat2)) + cos(deg2rad(lat1)) * cos(deg2rad(lat2)) * cos(deg2rad(theta));
    dist = acos(dist);
    dist = rad2deg(dist);
    dist = dist * 60 * 1.1515;
    dist = dist * 1609.344;
    return dist.toStringAsFixed(2);
  }

  double deg2rad(double deg) {
    return (deg * pi / 180.0);
  }

  double rad2deg(double rad) {
    return (rad * 180.0 / pi);
  }

  void errorDialog(String error) {
    if (Platform.isIOS) {
      showCupertinoDialog(context: context, builder: (context) {
        return CupertinoAlertDialog(
          title: new Text("Server Error\n"),
          content: new Text(error),
          actions: <Widget>[
            new CupertinoDialogAction(
              child: new Text("OK"),
              onPressed: () {
                router.pop(context);
              },
            ),
          ],
        );
      });
    }
    else if (Platform.isAndroid) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: new Text("Server Error", style: TextStyle(color: currTextColor),),
              backgroundColor: currBackgroundColor,
              content: new Text(error),
              actions: <Widget>[
                new FlatButton(
                  child: new Text("GOT IT"),
                  textColor: mainColor,
                  onPressed: () {
                    router.pop(context);
                  },
                ),
              ],
            );
          }
      );
    }
  }

  void excusedAbsenceDialog() {
    String reason = "";
    showCupertinoDialog(context: context, builder: (context) {
      return CupertinoAlertDialog(
        title: new Text("Request Excused Absence\n"),
        content: new CupertinoTextField(
          placeholder: "Reason for absence",
          autocorrect: true,
          autofocus: true,
          onChanged: (input) {
            reason = input;
          },
        ),
        actions: <Widget>[
          new CupertinoDialogAction(
            child: new Text("Cancel"),
            isDefaultAction: true,
            onPressed: () {
              router.pop(context);
            },
          ),
          new CupertinoDialogAction(
            child: new Text("Request"),
            onPressed: () async {
              print(reason);
              await http.post("$dbHost/users/${currUser.id}/attendance/excused", body: jsonEncode({
                "eventID": selectedEvent.id,
                "status": "unverified",
                "reason": reason
              }), headers: {"Authentication": "Bearer $apiKey"}).then((response) {
                print(response.body);
                var responseJson = jsonDecode(response.body);
                if (responseJson["message"] != null) {
                  // bruh error
                  errorDialog(responseJson["message"]);
                }
                else {
                  setState(() {
                    fabWidget = new Container(
                      height: 80.0,
                      width: MediaQuery.of(context).size.width - 16,
                      child: Column(
                        children: <Widget>[
                          new Text("\"$reason\""),
                          new Padding(padding: EdgeInsets.all(4.0)),
                          new Container(
                            width: MediaQuery.of(context).size.width - 16,
                            child: new CupertinoButton(
                                child: new Text("Excused Absence Requested"),
                                color: Colors.red,
                                borderRadius: BorderRadius.all(Radius.circular(16.0)),
                                onPressed: () {}
                            ),
                          )
                        ],
                      ),
                    );
                  });
                }
              });
              router.pop(context);
            },
          ),
        ],
      );
    });
  }

  void confirmCheckOut(String checkIn) {
    showCupertinoModalPopup(context: context, builder: (BuildContext context) {
      return new CupertinoActionSheet(
          title: new Text("Are you sure you want to check out?"),
          message: new Text("You will not be able to check back in again for this event."),
          actions: <Widget>[
            new CupertinoActionSheetAction(
              child: new Text("Check out"),
              isDestructiveAction: true,
              onPressed: () {
                checkOut(checkIn);
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

  Future<void> checkIn() async {
    try {
      autoCheckIn = false;
      currentLocation = await location.getLocation();
      print("locationLatitude: ${currentLocation.latitude}");
      print("locationLongitude: ${currentLocation.longitude}");
      double distance = double.parse(calcDistance(currentLocation.latitude, currentLocation.longitude, selectedEvent.latitude, selectedEvent.longitude));
      print(distance);
      if (distance <= selectedEvent.radius) {
        try {
          String now = DateTime.now().toString();
          http.post("$dbHost/events/${selectedEvent.id}/attendance", body: jsonEncode({
            "userID": currUser.id,
            "checkIn": now,
            "checkOut": now,
            "status": "present"
          }), headers: {"Authentication": "Bearer $apiKey"}).then((response) async {
            print(response.body);
            var responseJson = jsonDecode(response.body);
            if (responseJson["message"] != null) {
              // bruh error
              errorDialog(responseJson["message"]);
            }
            else {
              setState(() {
                checkInText = DateFormat("jm").format(DateTime.parse(responseJson["checkIn"])).toString();
                checkOutText = "––";
                fabWidget = new Container(
                  width: MediaQuery.of(context).size.width - 16,
                  child: new CupertinoButton(
                    child: new Text("Check Out"),
                    color: Colors.red,
                    borderRadius: BorderRadius.all(Radius.circular(16.0)),
                    onPressed: () {
                      checkOut(now);
                    },
                  ),
                );
              });
            }
          });
        } catch(e) {
          errorDialog(e);
        }
      }
      else {
        errorDialog("You are not inside the event geofence! Please stay within ${selectedEvent.radius} meters of the shown coordinates in order to track attendance.");
      }
    } catch (e) {
      currentLocation = null;
      errorDialog(e);
    }
  }

  Future<void> checkOut(String checkIn) async {
    try {
      currentLocation = await location.getLocation();
      print("locationLatitude: ${currentLocation.latitude}");
      print("locationLongitude: ${currentLocation.longitude}");
      double distance = double.parse(calcDistance(currentLocation.latitude, currentLocation.longitude, selectedEvent.latitude, selectedEvent.longitude));
      print(distance);
      if (distance <= selectedEvent.radius) {
        try {
          http.post("$dbHost/events/${selectedEvent.id}/attendance", body: jsonEncode({
            "userID": currUser.id,
            "checkIn": checkIn,
            "checkOut": DateTime.now().toString(),
            "status": "present"
          }), headers: {"Authentication": "Bearer $apiKey"}).then((response) async {
            print(response.body);
            var responseJson = jsonDecode(response.body);
            if (responseJson["message"] != null) {
              // bruh error
              errorDialog(responseJson["message"]);
            }
            else {
              setState(() {
                checkInText = DateFormat("jm").format(DateTime.parse(responseJson["checkIn"])).toString();
                checkOutText = DateFormat("jm").format(DateTime.parse(responseJson["checkOut"])).toString();
                fabWidget = new Container(
                  width: MediaQuery.of(context).size.width - 16,
                  child: new CupertinoButton(
                    child: new Text("Attended – ${double.parse(responseJson["hours"].toString()).toStringAsFixed(2)}h"),
                    color: Colors.green,
                    borderRadius: BorderRadius.all(Radius.circular(16.0)),
                    onPressed: () {},
                  ),
                );
              });
            }
          });
        } catch(e) {
          errorDialog(e);
        }
      }
      else {
        errorDialog("It looks life you have left the event location! Please stay within ${selectedEvent.radius} meters of the shown coordinates in order to track attendance.");
      }
    } catch (e) {
      currentLocation = null;
      errorDialog(e);
    }
  }

  Future<void> _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
    currentLocation = await location.getLocation();
    print("locationLatitude: ${currentLocation.latitude}");
    print("locationLongitude: ${currentLocation.longitude}");
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId(selectedEvent.id),
          position: LatLng(selectedEvent.latitude, selectedEvent.longitude),
          infoWindow: InfoWindow(title: selectedEvent.name)
        ),
      );
    });
  }
  
  Future<void> setupFab() async {
    await http.get("$dbHost/users/${currUser.id}/attendance/${selectedEvent.id}", headers: {"Authentication": "Bearer $apiKey"}).then((response) async {
      print(response.body);
      var responseJson = jsonDecode(response.body);
      if (responseJson["message"] != null) {
        if (selectedEvent.startTime.month == DateTime.now().month && selectedEvent.startTime.day == DateTime.now().day) {
          setState(() {
            fabWidget = new Container(
              width: MediaQuery.of(context).size.width - 16,
              child: new CupertinoButton(
                child: new Text("Check In"),
                color: mainColor,
                borderRadius: BorderRadius.all(Radius.circular(16.0)),
                onPressed: () {
                  checkIn();
                },
              ),
            );
          });
        }
        else if (selectedEvent.endTime.compareTo(DateTime.now()) < 0) {
          setState(() {
            fabWidget = new Container(
              height: 80.0,
              width: MediaQuery.of(context).size.width - 16,
              child: Column(
                children: <Widget>[
                  new Text("You did not attend this event.", style: TextStyle(color: Colors.red),),
                  new Padding(padding: EdgeInsets.all(4.0)),
                  new Container(
                    width: MediaQuery.of(context).size.width - 16,
                    child: new CupertinoButton(
                      child: new Text("Request Excused Absence"),
                      color: mainColor,
                      borderRadius: BorderRadius.all(Radius.circular(16.0)),
                      onPressed: excusedAbsenceDialog
                    ),
                  )
                ],
              ),
            );
          });
          await http.get("$dbHost/users/${currUser.id}/attendance/excused", headers: {"Authentication": "Bearer $apiKey"}).then((response) {
            print(response.body);
            var excusedJson = jsonDecode(response.body);
            for (int i = 0; i < excusedJson.length; i++) {
              if (excusedJson[i]["eventID"] == selectedEvent.id && excusedJson[i]["status"] == "unverified") {
                setState(() {
                  fabWidget = new Container(
                    height: 80.0,
                    width: MediaQuery.of(context).size.width - 16,
                    child: Column(
                      children: <Widget>[
                        new Text("\"${excusedJson[i]["reason"]}\""),
                        new Padding(padding: EdgeInsets.all(4.0)),
                        new Container(
                          width: MediaQuery.of(context).size.width - 16,
                          child: new CupertinoButton(
                              child: new Text("Excused Absence Requested"),
                              color: Colors.red,
                              borderRadius: BorderRadius.all(Radius.circular(16.0)),
                              onPressed: () {}
                          ),
                        )
                      ],
                    ),
                  );
                });
              }
              else if (excusedJson[i]["eventID"] == selectedEvent.id && excusedJson[i]["status"] == "verified") {
                setState(() {
                  fabWidget = new Container(
                    height: 80.0,
                    width: MediaQuery.of(context).size.width - 16,
                    child: Column(
                      children: <Widget>[
                        new Text("\"${excusedJson[i]["reason"]}\""),
                        new Padding(padding: EdgeInsets.all(4.0)),
                        new Container(
                          width: MediaQuery.of(context).size.width - 16,
                          child: new CupertinoButton(
                              child: new Text("Absence Excused"),
                              color: Colors.green,
                              borderRadius: BorderRadius.all(Radius.circular(16.0)),
                              onPressed: () {}
                          ),
                        )
                      ],
                    ),
                  );
                });
              }
            }
          });
        }
        else {
          setState(() {
            fabWidget = new Container(
              height: 50.0,
              width: MediaQuery.of(context).size.width - 16,
              child: Center(child: new Text("This event has not started yet.")),
            );
          });
        }
      }
      else if (responseJson["checkIn"] == responseJson["checkOut"]) {
        if (selectedEvent.startTime.month == DateTime.now().month && selectedEvent.startTime.day == DateTime.now().day) {
          setState(() {
            checkInText = DateFormat("jm").format(DateTime.parse(responseJson["checkIn"])).toString();
            checkOutText = "––";
            fabWidget = new Container(
              width: MediaQuery.of(context).size.width - 16,
              child: new CupertinoButton(
                child: new Text("Check Out"),
                color: Colors.red,
                borderRadius: BorderRadius.all(Radius.circular(16.0)),
                onPressed: () {
                  confirmCheckOut(responseJson["checkIn"]);
                },
              ),
            );
          });
        }
        else {
          // bruh they didn't check out
        }
      }
      else {
        setState(() {
          checkInText = DateFormat("jm").format(DateTime.parse(responseJson["checkIn"])).toString();
          checkOutText = DateFormat("jm").format(DateTime.parse(responseJson["checkOut"])).toString();
          fabWidget = new Container(
            width: MediaQuery.of(context).size.width - 16,
            child: new CupertinoButton(
              child: new Text("Attended – ${double.parse(responseJson["hours"].toString()).toStringAsFixed(2)}h"),
              color: Colors.green,
              borderRadius: BorderRadius.all(Radius.circular(16.0)),
              onPressed: () {},
            ),
          );
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    setupFab();
    if (autoCheckIn) {
      print("AUTO CHECK IN ACTIVATED - ${autoCheckIn}");
      checkIn();
    }
    if (autoCheckOut != "") {
      print("AUTO CHECK OUT ACTIVATED - ${autoCheckOut}");
      checkOut(autoCheckOut);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new CupertinoNavigationBar(
        middle: new Text("Details", style: TextStyle(color: Colors.white)),
        previousPageTitle: "Home",
        actionsForegroundColor: Colors.white,
        backgroundColor: mainColor,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: fabWidget,
      backgroundColor: currBackgroundColor,
      body: new SingleChildScrollView(
        padding: EdgeInsets.all(8.0),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Text(
              selectedEvent.name,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            ),
            new Padding(padding: EdgeInsets.all(4.0)),
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
                  color: mainColor,
                  elevation: 6.0,
                  child: new Container(
                    child: new Text(selectedEvent.type, style: TextStyle(color: Colors.white)),
                    padding: EdgeInsets.only(top: 4.0, bottom: 4.0, right: 8.0, left: 8.0),
                  ),
                ),
                new Text("${DateFormat("LLLL d, yyyy").format(selectedEvent.date)}")
              ],
            ),
            new Padding(padding: EdgeInsets.all(4.0)),
            new Text(
              selectedEvent.desc,
            ),
            new Padding(padding: EdgeInsets.all(4.0)),
            new ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(16.0)),
              child: new Container(
                height: 250,
                child: new GoogleMap(
                  onMapCreated: _onMapCreated,
                  myLocationButtonEnabled: true,
                  myLocationEnabled: true,
                  markers: _markers,
                  initialCameraPosition: CameraPosition(
                      target: LatLng(selectedEvent.latitude, selectedEvent.longitude),
                      zoom: 14.0
                  ),
                ),
              ),
            ),
            new Padding(padding: EdgeInsets.all(4.0)),
            new ListTile(
              leading: new Text("Start Time"),
              trailing: new Text("${DateFormat("jm").format(selectedEvent.startTime)}"),
            ),
            new ListTile(
              leading: new Text("End Time"),
              trailing: new Text("${DateFormat("jm").format(selectedEvent.endTime)}"),
            ),
            new Visibility(visible: (checkInText != ""), child: new Divider(color: mainColor, indent: 8.0, endIndent: 8.0)),
            new Visibility(
              visible: (checkInText != ""),
              child: new ListTile(
                leading: new Text("Check In Time"),
                trailing: new Text(checkInText),
              ),
            ),
            new Visibility(
              visible: (checkOutText != ""),
              child: new ListTile(
                leading: new Text("Check Out Time"),
                trailing: new Text(checkOutText),
              ),
            ),
            new Visibility(visible: (checkOutText != ""), child: new Padding(padding: EdgeInsets.all(32.0))),
          ],
        ),
      ),
    );
  }
}
