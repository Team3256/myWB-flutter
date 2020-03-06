import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_database/firebase_database.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mywb_flutter/models/curr_match.dart';
import 'package:mywb_flutter/models/regional.dart';
import 'package:mywb_flutter/models/spin.dart';
import 'package:mywb_flutter/screens/scouting/scout_new_page.dart';
import 'package:mywb_flutter/user_info.dart';
import 'package:mywb_flutter/utils/config.dart';
import 'package:mywb_flutter/utils/theme.dart';

class OfflineScoutingPage extends StatefulWidget {
  @override
  _OfflineScoutingPageState createState() => _OfflineScoutingPageState();
}

class _OfflineScoutingPageState extends State<OfflineScoutingPage> with RouteAware {

  List<CurrMatch> currMatchList = new List();

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

  @override
  void initState() {
    super.initState();
    // Instantiate Data-Types for Firebase Listeners
    onRefresh();
  }

  Future<void> onRefresh() async {
    print("Refreshing");
    // check for current
    if (currRegional == null) {
      // TODO: replace with default regional
      setState(() {
        currRegional = new Regional({
          "id": "2020bcvi",
          "city": "Victoria",
          "country": "Canada",
          "startDate": "2020-03-04",
          "endDate": "2020-03-07",
          "year": 2020,
          "shortName": "Canadian Pacific",
          "name": "Canadian Pacific Regional",
          "eventCode": "bcvi",
          "teams": []
        });
      });
    }
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
                    currMatch.id += ("-" + currRegional.id);
                    currMatch.regionalID = currRegional.id;
                    currMatch.matchData.matchID = currMatch.id;
                    currMatch.matchData.scouterID = "404";
                    currMatch.matchData.auto.matchID = currMatch.id;
                    currMatch.matchData.auto.teamID = currMatch.matchData.teamID;
                    currMatch.matchData.spin = new Spin();
                    router.pop(context);
                    router.navigateTo(context, '/scouting/controller', transition: TransitionType.native);
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
    return new Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          new CupertinoSliverNavigationBar(
            backgroundColor: mainColor,
            largeTitle: new Text("Scouting", style: TextStyle(color: Colors.white),),
            actionsForegroundColor: Colors.white,
          ),
          new SliverList(
            delegate: new SliverChildListDelegate([
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
                      },
                      child: new Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
                          color: mainColor,
                          elevation: 6.0,
                          child: new ClipRRect(
                            child: Container(
                                padding: EdgeInsets.only(right: 8.0, left: 8.0, bottom: 4.0, top: 4.0),
                                child: new Text("${currRegional.shortName} Regional [OFFLINE]", style: TextStyle(color: Colors.white),)
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
              new Padding(padding: EdgeInsets.all(16))
            ]),
          )
        ],
      ),
    );
  }
}
