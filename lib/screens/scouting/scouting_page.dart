import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mywb_flutter/models/curr_match.dart';
import 'package:mywb_flutter/models/regional.dart';
import 'package:mywb_flutter/screens/scouting/scout_new_page.dart';
import 'package:mywb_flutter/user_info.dart';
import 'package:mywb_flutter/utils/config.dart';
import 'package:mywb_flutter/utils/theme.dart';

class ScoutingPage extends StatefulWidget {
  @override
  _ScoutingPageState createState() => _ScoutingPageState();
}

class _ScoutingPageState extends State<ScoutingPage> with RouteAware {

  final databaseRef = FirebaseDatabase.instance.reference();

  List<CurrMatch> currMatchList = new List();

  var currMatchAddSub;
  var currMatchChangeSub;
  var currMatchRemoveSub;

  double refreshErrorHeight = 0;
  bool refreshErrorVisible = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context));
  }

  void didPopNext() {
    debugPrint("didPopNext ${runtimeType}");
    onRefresh();
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  _ScoutingPageState() {
    // Instantiate Data-Types for Firebase Listeners
    currMatchAddSub = databaseRef.child("fake").onChildAdded.listen((event) {});
    currMatchChangeSub = databaseRef.child("fake").onChildAdded.listen((event) {});
    currMatchRemoveSub = databaseRef.child("fake").onChildAdded.listen((event) {});
    databaseRef.child("currRegional").once().then((snapshot) {
        setState(() {
          currRegional = new Regional({
            "id": snapshot.value,
            "city": "Victoria",
            "country": "Canada",
            "end_date": "2020-03-07",
            "event_code": "bcvi",
            "short_name": "Canada Pacific",
            "name": "Canadian Pacific Regional",
            "start_date": "2020-03-04",
            "state_prov": "BC",
            "year": "2020"
          });
        });
        print("Current Regional: ${currRegional.id}");
        onRefresh();
    });
  }

  Future<void> onRefresh() async {
    print("Refreshing");
    setState(() {
      refreshErrorVisible = false;
      refreshErrorHeight = 0.0;
    });
    await getTeamsList(currRegional.id);
    setState(() {
      currMatchList.clear();
    });
    // Cancel Previous Subscriptions
    currMatchAddSub.cancel();
    currMatchChangeSub.cancel();
    currMatchRemoveSub.cancel();
    // Populate Current Match List
    currMatchAddSub = databaseRef.child("regionals").child(currRegional.id).child("currMatches").onChildAdded.listen((Event event) {
      setState(() {
        currMatchList.add(new CurrMatch(event.snapshot));
      });
    });
    currMatchChangeSub = databaseRef.child("regionals").child(currRegional.id).child("currMatches").onChildChanged.listen((Event event) {
      var oldValue = currMatchList.singleWhere((entry) => entry.key == event.snapshot.key);
      setState(() {
        currMatchList[currMatchList.indexOf(oldValue)] = new CurrMatch(event.snapshot);
      });
    });
    currMatchRemoveSub = databaseRef.child("regionals").child(currRegional.id).child("currMatches").onChildRemoved.listen((Event event) {
      var oldValue =
      currMatchList.singleWhere((entry) => entry.key == event.snapshot.key);
      setState(() {
        currMatchList.removeAt(currMatchList.indexOf(oldValue));
      });
    });
    getRecentMatches(currRegional.id);
  }

  Future getTeamsList(String regionalKey) async {
    // TODO: Get endpoint from BK and add shit here
  }

  Future getRecentMatches(String regionalKey) async {
//    recentMatchList.clear();
    // TODO: Get endpoint from BK and add shit here
  }

  Color getAllianceColor(String input) {
    if (input == "Blue") {
      return Colors.lightBlue;
    }
    else {
      return Colors.red;
    }
  }

  void scoutDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
            elevation: 6.0,
            title: new Text("New Match", style: TextStyle(color: currTextColor),),
            backgroundColor: currCardColor,
            content: new ScoutNewPage(),
            actions: <Widget>[
              new FlatButton(
                child: new Text("CANCEL", style: TextStyle(color: mainColor),),
                onPressed: () {
                  router.pop(context);
                },
              ),
              new FlatButton(
                child: new Text("SCOUT", style: TextStyle(color: mainColor),),
                onPressed: () {
                  if (currMatch.matchData.alliance != "" && currMatch.matchData.teamID != "" && currMatch.matchNum != 0 && (currMatch.id.contains("p") || currMatch.id.contains("qm"))) {
//                    if (currRegional.teamsList.contains(currMatch.matchData.teamID)) {
                    if (true) {
                      String unid = databaseRef.push().key;
                      currMatch.matchData.auto.matchID = currMatch.id;
                      currMatch.matchData.auto.teamID = currMatch.matchData.teamID;
                      databaseRef.child("regionals").child(currRegional.id).child("currMatches").child(unid).set({
                        "team": currMatch.matchData.teamID,
                        "alliance": currMatch.matchData.alliance,
                        "match": currMatch.matchNum,
                        "scoutedBy": currUser.firstName,
                      });
                      router.pop(context);
                      router.navigateTo(context, '/scouting/controller', transition: TransitionType.native);
                    }
                  }
                },
              )
            ],
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    if (currRegional.id == "off") {
      return CustomScrollView(
        slivers: <Widget>[
          new CupertinoSliverNavigationBar(
            backgroundColor: mainColor,
            largeTitle: new Text("Scouting", style: TextStyle(color: Colors.white),),
            actionsForegroundColor: Colors.white,
          ),
          new SliverList(
            delegate: new SliverChildListDelegate([
              new Container(
                padding: EdgeInsets.only(top: 16.0, right: 16.0, left: 16.0),
                child: new ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(16.0)),
                  child: new Container(
                    height: 200,
                    width: MediaQuery.of(context).size.width - 16,
                    child: new GoogleMap(
                      initialCameraPosition: CameraPosition(
                          target: LatLng(48.431541, -123.360401),
                          zoom: 11.0
                      ),
                      compassEnabled: false,
                      myLocationButtonEnabled: false,
                      zoomGesturesEnabled: true,
                      rotateGesturesEnabled: true,
                      scrollGesturesEnabled: true,
                      tiltGesturesEnabled: true,
                      markers: Set<Marker>.from([
                        Marker(
                            markerId: MarkerId("2020bcvi"),
                            position: LatLng(48.431541, -123.360401),
                            infoWindow: InfoWindow(title: "Canada Pacific Regional")
                        )
                      ]),
                    ),
                  ),
                ),
              ),
              new Container(
                padding: EdgeInsets.only(top: 32.0, right: 16.0, left: 16.0),
                child: new Center(
                  child: new Text(
                    "It doesn't look like you are currently at a regional\nPlease check back later for scouting",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ]),
          )
        ],
      );
    }
    else {
      return CustomScrollView(
        slivers: <Widget>[
          new CupertinoSliverNavigationBar(
            backgroundColor: mainColor,
            largeTitle: new Text("Scouting", style: TextStyle(color: Colors.white),),
            actionsForegroundColor: Colors.white,
          ),
          new SliverList(
            delegate: new SliverChildListDelegate([
              new AnimatedContainer(
                padding: EdgeInsets.only(top: 8.0, right: 8.0, left: 8.0),
                duration: const Duration(milliseconds: 300),
                curve: Curves.bounceIn,
                height: refreshErrorHeight,
                child: new Card(
                  color: Colors.black.withOpacity(0.65),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
                  child: new Container(
                      padding: EdgeInsets.all(10.0),
                      child: Row(
                        children: <Widget>[
                          new Visibility(visible: refreshErrorVisible, child: new Icon(Icons.error_outline, color: Colors.red,)),
                          new Padding(padding: EdgeInsets.all(4.0)),
                          new Visibility(visible: refreshErrorVisible, child: Container(width: MediaQuery.of(context).size.width - 100, child: new Text("Ruh-roh! It looks like we were unable to fetch the list of teams from this regional. Please refresh before scouting.", style: TextStyle(color: Colors.white),))),
                        ],
                      )
                  ),
                ),
              ),
              new Visibility(visible: refreshErrorVisible, child: new Padding(padding: EdgeInsets.all(8.0))),
              Container(
                padding: EdgeInsets.only(top: 8.0, right: 8.0, left: 8.0),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new Text(
                        "Current",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0, color: currTextColor)
                    ),
                    new GestureDetector(
                      onTap: () {
                        router.navigateTo(context, '/filter-regional', transition: TransitionType.nativeModal);
                      },
                      child: new Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
                          color: mainColor,
                          elevation: 6.0,
                          child: new ClipRRect(
                            child: Container(
                                padding: EdgeInsets.only(right: 8.0, left: 8.0, bottom: 4.0, top: 4.0),
                                child: new Text("${currRegional.shortName} Regional", style: TextStyle(color: Colors.white),)
                            ),
                          )
                      ),
                    )
                  ],
                ),
              ),
              new Container(
                padding: EdgeInsets.only(top: 8.0, left: 8.0, bottom: 4.0),
                height: 150.0,
                child: new ListView.builder(
                  itemCount: currMatchList == null ? 1 : currMatchList.length + 1,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    if (index == 0) {
                      return new Container(
                        padding: const EdgeInsets.all(8.0),
                        child: new GestureDetector(
                          onTap: () {
                            if (currRegional.id != "") {
                              scoutDialog();
                            }
                          },
                          child: new Image.asset(
                              "images/new.png",
                              height: 125.0,
                              width: 125.0,
                              color: currDividerColor
                          ),
                        ),
                      );
                    }
                    index -= 1;
                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: new Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
                        elevation: 6.0,
                        color: getAllianceColor(currMatchList[index].alliance),
                        child: new Container(
                          padding: EdgeInsets.all(8.0),
                          height: 125.0,
                          width: 125.0,
                          child: new Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              new Text(
                                currMatchList[index].match,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 25.0,
                                    fontWeight: FontWeight.w100
                                ),
                              ),
                              new Text(
                                currMatchList[index].team,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(padding: EdgeInsets.only(top: 8.0, right: 8.0, left: 8.0), child: new Text("Recent Matches", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0, color: currTextColor),)),
              new Container(
                height: 150.0,
              ),
              Container(
                padding: EdgeInsets.only(top: 8.0, right: 8.0, left: 8.0, bottom: 4.0),
                child: new Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
                  color: currCardColor,
                  elevation: 6.0,
                  child: new InkWell(
                    borderRadius: BorderRadius.all(Radius.circular(16.0)),
                    onTap: () {
                      router.navigateTo(context, '/scouting/matches', transition: TransitionType.cupertino);
                    },
                    child: new Container(
                      padding: EdgeInsets.only(top: 4.0, bottom: 4.0),
                      child: new Row(
                        children: <Widget>[
                          new Padding(padding: EdgeInsets.all(8.0)),
                          new Expanded(
                            child: new Container(
                              padding: EdgeInsets.only(right: 4.0, left: 4.0, bottom: 12, top: 12),
                              child: new Text("All Matches", style: TextStyle(color: currTextColor, fontSize: 15.0,)),
                            ),
                          ),
                          new Icon(Icons.navigate_next, color: currDividerColor),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 8.0, right: 8.0, left: 8.0, bottom: 4.0),
                child: new Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
                  color: currCardColor,
                  elevation: 6.0,
                  child: new InkWell(
                    borderRadius: BorderRadius.all(Radius.circular(16.0)),
                    onTap: () {
                      router.navigateTo(context, '/scouting/teams', transition: TransitionType.cupertino);
                    },
                    child: new Container(
                      padding: EdgeInsets.only(top: 4.0, bottom: 4.0),
                      child: new Row(
                        children: <Widget>[
                          new Padding(padding: EdgeInsets.all(8.0)),
                          new Expanded(
                            child: new Container(
                              padding: EdgeInsets.only(right: 4.0, left: 4.0, bottom: 12, top: 12),
                              child: new Text("All Teams", style: TextStyle(color: currTextColor, fontSize: 15.0,)),
                            ),
                          ),
                          new Icon(Icons.navigate_next, color: currDividerColor),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 8.0, right: 8.0, left: 8.0, bottom: 4.0),
                child: new Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
                  color: currCardColor,
                  elevation: 6.0,
                  child: new InkWell(
                    borderRadius: BorderRadius.all(Radius.circular(16.0)),
                    onTap: () {
                      router.navigateTo(context, '/scouting/schedule', transition: TransitionType.cupertino);
                    },
                    child: new Container(
                      padding: EdgeInsets.only(top: 4.0, bottom: 4.0),
                      child: new Row(
                        children: <Widget>[
                          new Padding(padding: EdgeInsets.all(8.0)),
                          new Expanded(
                            child: new Container(
                              padding: EdgeInsets.only(right: 4.0, left: 4.0, bottom: 12, top: 12),
                              child: new Text("Scouting Schedule", style: TextStyle(color: currTextColor, fontSize: 15.0,)),
                            ),
                          ),
                          new Icon(Icons.navigate_next, color: currDividerColor),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 8.0, right: 8.0, left: 8.0, bottom: 4.0),
                child: new Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
                  color: currCardColor,
                  elevation: 6.0,
                  child: new InkWell(
                    borderRadius: BorderRadius.all(Radius.circular(16.0)),
                    onTap: () {
                      router.navigateTo(context, '/scouting/pit-scouting', transition: TransitionType.cupertino);
                    },
                    child: new Container(
                      padding: EdgeInsets.only(top: 4.0, bottom: 4.0),
                      child: new Row(
                        children: <Widget>[
                          new Padding(padding: EdgeInsets.all(8.0)),
                          new Expanded(
                            child: new Container(
                              padding: EdgeInsets.only(right: 4.0, left: 4.0, bottom: 12, top: 12),
                              child: new Text("Pit Scouting", style: TextStyle(color: currTextColor, fontSize: 15.0,)),
                            ),
                          ),
                          new Icon(Icons.navigate_next, color: currDividerColor),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              new Padding(padding: EdgeInsets.all(16))
            ]),
          )
        ],
      );
    }
  }
}
