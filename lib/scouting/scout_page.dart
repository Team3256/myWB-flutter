import 'package:flutter/material.dart';
import 'dart:io';
import 'package:mywb_flutter/user_info.dart';
import 'package:mywb_flutter/user_drawer.dart';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart' as http;
import 'package:mywb_flutter/theme.dart';
import 'package:fluro/fluro.dart';

class ScoutPage extends StatefulWidget {
  @override
  _ScoutPageState createState() => _ScoutPageState();
}

class CurrMatch {
  String key;
  String team;
  String match;
  String alliance;

  CurrMatch(this.alliance, this.match, this.team, this.key);
}

class PastMatch {
  String key;
  String blueTeams;
  String redTeams;
  String match;
}

class _ScoutPageState extends State<ScoutPage> {

  final databaseRef = FirebaseDatabase.instance.reference();
  String regionalName = "";

  List<CurrMatch> currMatchList = new List();
  List<PastMatch> recentMatchList = new List();

  var currMatchAddSub;
  var currMatchChangeSub;
  var currMatchRemoveSub;
  
  double refreshErrorHeight = 0;
  bool refreshErrorVisible = false;

  Regional lastRegional;

  @override
  void initState() {
    super.initState();
    // Instantiate Data-Types for Firebase Listeners
    currMatchAddSub = databaseRef.child("fake").onChildAdded.listen((event) {});
    currMatchChangeSub = databaseRef.child("fake").onChildAdded.listen((event) {});
    currMatchRemoveSub = databaseRef.child("fake").onChildAdded.listen((event) {});
    lastRegional = currRegional;
    // Refresh Call
    onRefresh();
  }

  Future getTeamsList(String regionalKey) async {
    teamsList.clear();
    var teamsUrl = "${dbHost}api/scouting/regional/$regionalKey/teams";
    try {
      await http.get(teamsUrl, headers: {HttpHeaders.authorizationHeader: "Bearer $authToken"}).then((response) {
        var teamsJson = jsonDecode(response.body);
        for (int i = 0; i < teamsJson.length; i++) {
          teamsList.add(teamsJson[i]["key"].toString().substring(3));
        }
        print("TeamsList: $teamsList");
      });
    }
    catch (error) {
      print("Failed to pull the teams list! - $error");
      setState(() {
        refreshErrorVisible = true;
        refreshErrorHeight = 100;
      });
    }
  }

  Future getRecentMatches(String regionalKey) async {
    recentMatchList.clear();
    var recentMatchUrl = "${dbHost}api/scouting/";
    // TODO: Get endpoint from Johnny and add shit here
  }

  void scoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("New Match", style: TextStyle(color: currTextColor),),
          backgroundColor: currBackgroundColor,
          content: new ScoutingDialog(),
          actions: <Widget>[
            new FlatButton(
              child: new Text("CANCEL"),
              onPressed: () {
                router.pop(context);
              },
            ),
            new FlatButton(
              child: new Text("SCOUT"),
              onPressed: () {
                if (currAlliance != "" && currTeam != "" && currMatch != "" && habLevel != 0) {
                  if (teamsList.contains(currTeam)) {
                    currMatchKey = databaseRef.push().key;
                    databaseRef.child("regionals").child(currRegional.key).child("currMatches").child(currMatchKey).set({
                      "team": currTeam,
                      "alliance": currAlliance,
                      "match": currMatch
                    });
                    router.navigateTo(context, '/scoutOne', transition: TransitionType.native, clearStack: true);
                  }
                }
              },
            )
          ],
        );
      }
    );
  }

  Future<void> onRefresh() async {
    print("Refreshing");
    setState(() {
      refreshErrorVisible = false;
      refreshErrorHeight = 0.0;
    });
    await getTeamsList(currRegional.key);
    setState(() {
      currMatchList.clear();
    });
    // Cancel Previous Subscriptions
    currMatchAddSub.cancel();
    currMatchChangeSub.cancel();
    currMatchRemoveSub.cancel();
    // Populate Current Match List
    currMatchAddSub = databaseRef.child("regionals").child(currRegional.key).child("currMatches").onChildAdded.listen((Event event) {
      setState(() {
        currMatchList.add(new CurrMatch(event.snapshot.value["alliance"], event.snapshot.value["match"].toString(), event.snapshot.value["team"].toString(), event.snapshot.key));
      });
    });
    currMatchChangeSub = databaseRef.child("regionals").child(currRegional.key).child("currMatches").onChildChanged.listen((Event event) {
      var oldValue = currMatchList.singleWhere((entry) =>
      entry.key == event.snapshot.key);
      setState(() {
        currMatchList[currMatchList.indexOf(oldValue)] =
        new CurrMatch(event.snapshot.value["alliance"], event.snapshot.value["match"].toString(), event.snapshot.value["team"].toString(), event.snapshot.key);
      });
    });
    currMatchRemoveSub = databaseRef.child("regionals").child(currRegional.key).child("currMatches").onChildRemoved.listen((Event event) {
      var oldValue =
      currMatchList.singleWhere((entry) => entry.key == event.snapshot.key);
      setState(() {
        currMatchList.removeAt(currMatchList.indexOf(oldValue));
      });
    });
  }

  Color getAllianceColor(String input) {
    if (input == "Blue") {
      return Colors.lightBlue;
    }
    else {
      return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get Latest Data on Regional Change
    if (lastRegional != currRegional) {
      print("Updating Regional Info");
      onRefresh();
      lastRegional = currRegional;
    }
    // Main Build Function
    return new Container(
      padding: EdgeInsets.all(16.0),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: currBackgroundColor,
      child: new RefreshIndicator(
        onRefresh: onRefresh,
        backgroundColor: currAccentColor,
        color: Colors.white,
        displacement: 10.0,
        child: new SingleChildScrollView(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new AnimatedContainer(
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
              new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  new Text(
                    "Current",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0, color: currTextColor)
                  ),
                  new GestureDetector(
                    onTap: () {
                      router.navigateTo(context, '/filterRegional', transition: TransitionType.nativeModal);
                    },
                    child: new Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
                      child: new ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        child: Container(
                          padding: EdgeInsets.all(4.0),
                          color: currAccentColor,
                          child: new Text(currRegional.shortName + " Regional", style: TextStyle(color: Colors.white),)
                        ),
                      )
                    ),
                  )
                ],
              ),
              new Padding(padding: EdgeInsets.all(8.0)),
              new Container(
                height: 150.0,
                child: new ListView.builder(
                  itemCount: currMatchList == null ? 1 : currMatchList.length + 1,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    if (index == 0) {
                      return new Container(
                        width: 150.0,
                        child: new GestureDetector(
                          onTap: () {
                            if (currRegional.key != "") {
                              scoutDialog();
                            }
                          },
                          child: new Image.asset(
                            "images/new.png",
                            height: 200.0,
                            width: 200.0,
                            color: currCardColor
                          ),
                        ),
                      );
                    }
                    index -= 1;
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: new Card(
                        color: getAllianceColor(currMatchList[index].alliance),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
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
              new Divider(color: currAccentColor,),
              new Padding(padding: EdgeInsets.all(8.0)),
              new Text("Recent Matches", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0, color: currTextColor),),
              new Padding(padding: EdgeInsets.all(8.0)),
              new Container(
                height: 150.0,
              ),
              new Divider(color: currAccentColor, height: 0.0,),
              new ListTile(
                title: new Text("All Matches", style: TextStyle(color: currTextColor)),
                trailing: new Icon(Icons.arrow_forward_ios, color: currAccentColor,),
                onTap: () {

                },
              ),
              new Divider(color: currAccentColor, height: 0.0,),
              new ListTile(
                title: new Text("All Teams", style: TextStyle(color: currTextColor)),
                trailing: new Icon(Icons.arrow_forward_ios, color: currAccentColor,),
                onTap: () {
                  router.navigateTo(context, '/regionalTeams', transition: TransitionType.native);
                },
              ),
              new Divider(color: currAccentColor, height: 0.0,),
              new ListTile(
                title: new Text("Pit Scouting", style: TextStyle(color: currTextColor)),
                trailing: new Icon(Icons.arrow_forward_ios, color: currAccentColor,),
                onTap: () {
                  router.navigateTo(context, '/pitScouting', transition: TransitionType.native);
                },
              ),
              new Divider(color: currAccentColor, height: 0.0,),
              new ListTile(),
            ],
          ),
        ),
      ),
    );
  }
}

class ScoutingDialog extends StatefulWidget {
  @override
  _ScoutingDialogState createState() => _ScoutingDialogState();
}

class _ScoutingDialogState extends State<ScoutingDialog> {

  Color blueBtnColor = currBackgroundColor;
  Color redBtnColor = currBackgroundColor;
  Color blueBtnTxtColor = currTextColor;
  Color redBtnTxtColor = currTextColor;

  Color oneBtnColor = currBackgroundColor;
  Color twoBtnColor = currBackgroundColor;
  Color oneBtnTxtColor = currTextColor;
  Color twoBtn1TxtColor = currTextColor;

  bool errVisible = false;
  Color errColor = Colors.redAccent;
  String errText = "";

  _ScoutingDialogState() {
    currAlliance = "";
    currMatch = "";
    currTeam = "";
    habLevel = 0;
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      color: currBackgroundColor,
      height: 250.0,
      child: new Column(
        children: <Widget>[
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Container(
                width: 100.0,
                child: new TextField(
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18.0, color: currTextColor),
                  autocorrect: false,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: "Match #",
                      border: InputBorder.none,
                      labelStyle: TextStyle(color: currAccentColor)
                  ),
                  onChanged: (input) {
                    currMatch = input;
                  },
                ),
              ),
              new Container(
                width: 100.0,
                child: new TextField(
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18.0, color: currTextColor),
                  autocorrect: false,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: "Team #",
                      border: InputBorder.none,
                      labelStyle: TextStyle(color: currAccentColor)
                  ),
                  onChanged: (input) {
                    setState(() {
                      errVisible = true;
                      errText = "";
                    });
                    currTeam = input;
                    if (currTeam == "") {
                      setState(() {
                        errVisible = false;
                      });
                    }
                    else if (teamsList.contains(currTeam)) {
                      setState(() {
                        errColor = Colors.greenAccent;
                        errVisible = true;
                        errText = "Valid Team";
                      });
                    }
                    else {
                      setState(() {
                        errColor = Colors.redAccent;
                        errVisible = true;
                        errText = "Invalid Team";
                      });
                    }
                  },
                ),
              ),
            ],
          ),
          new Visibility(visible: errVisible, child: new Text(errText, style: TextStyle(color: errColor),)),
          new Visibility(visible: errVisible, child: new Padding(padding: EdgeInsets.all(4.0))),
          new Text("Alliance:", style: TextStyle(fontWeight: FontWeight.bold, color: currTextColor),),
          new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Expanded(
                child: new FlatButton(
                  child: new Text("BLUE"),
                  textColor: blueBtnTxtColor,
                  color: blueBtnColor,
                  onPressed: () {
                    setState(() {
                      currAlliance = "Blue";
                      blueBtnColor = Colors.lightBlue;
                      blueBtnTxtColor = Colors.white;
                      redBtnColor = currBackgroundColor;
                      redBtnTxtColor = currTextColor;
                    });
                  },
                ),
              ),
              new Expanded(
                child: new FlatButton(
                  child: new Text("RED"),
                  textColor: redBtnTxtColor,
                  color: redBtnColor,
                  onPressed: () {
                    setState(() {
                      currAlliance = "Red";
                      blueBtnColor = currBackgroundColor;
                      blueBtnTxtColor = currTextColor;
                      redBtnColor = Colors.red;
                      redBtnTxtColor = Colors.white;
                    });
                  },
                ),
              ),
            ],
          ),
          new Padding(padding: EdgeInsets.all(4.0)),
          new Text("HAB Starting Position:", style: TextStyle(fontWeight: FontWeight.bold, color: currTextColor),),
          new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Expanded(
                child: new FlatButton(
                  child: new Text("ONE"),
                  textColor: oneBtnTxtColor,
                  color: oneBtnColor,
                  onPressed: () {
                    setState(() {
                      habLevel = 1;
                      oneBtnColor = currAccentColor;
                      oneBtnTxtColor = Colors.white;
                      twoBtnColor = currBackgroundColor;
                      twoBtn1TxtColor = currTextColor;
                    });
                  },
                ),
              ),
              new Expanded(
                child: new FlatButton(
                  child: new Text("TWO"),
                  textColor: twoBtn1TxtColor,
                  color: twoBtnColor,
                  onPressed: () {
                    setState(() {
                      habLevel = 2;
                      twoBtnColor = currAccentColor;
                      twoBtn1TxtColor = Colors.white;
                      oneBtnColor = currBackgroundColor;
                      oneBtnTxtColor = currTextColor;
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

