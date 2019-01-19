import 'package:flutter/material.dart';
import 'package:mywb_flutter/user_info.dart';
import 'package:mywb_flutter/user_drawer.dart';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:mywb_flutter/theme.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluro/fluro.dart';

class ScoutPage extends StatefulWidget {
  @override
  _ScoutPageState createState() => _ScoutPageState();
}

class Match {

  int id;
  String teamNumber;
  String alliance;

  Match(this.id, this.teamNumber, this.alliance);
}

class _ScoutPageState extends State<ScoutPage> {
  
  final databaseRef = FirebaseDatabase.instance.reference();

  final scoutSource = "https://raw.githubusercontent.com/Team3256/myWB-flutter/master/lib/scouting/example.json";
  List<Match> matchList = new List();

  _ScoutPageState() {
    matchList.add(new Match(1, "3256", "Blue"));
    databaseRef.child("scouting").child("").child("currRegional").once().then((DataSnapshot snapshot) {
      setState(() {
        currRegional = snapshot.value;
      });
    });
    databaseRef.child("scouting").child(currRegional).child("currMatched").onChildAdded.listen((Event event) {
      print(event.snapshot.value);
      setState(() {

      });
    });
  }

  void scoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("New Match"),
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
                  databaseRef.child("scouting").child(currRegional).child("currMatches").child(currMatch).child(currAlliance).child(currTeam).update({
                    "habStart": habLevel
                  });
                  router.navigateTo(context, '/scoutOne', transition: TransitionType.native, clearStack: true);
                }
              },
            )
          ],
        );
      }
    );
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
    return new Container(
      padding: EdgeInsets.all(16.0),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: Colors.white,
      child: new SingleChildScrollView(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Text("Current - $currRegional", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),),
            new Padding(padding: EdgeInsets.all(8.0)),
            new Container(
              height: 150.0,
              child: new ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  Container(
                    width: 150.0,
                    child: new GestureDetector(
                      onTap: () {
                        scoutDialog();
                      },
                      child: new Image.asset(
                        "images/new.png",
                        height: 200.0,
                        width: 200.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            new Divider(color: mainColor,),
            new Padding(padding: EdgeInsets.all(8.0)),
            new Text("Recent Matches", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),),
            new Padding(padding: EdgeInsets.all(8.0)),
            new Container(
              height: 150.0,
            ),
            new Divider(color: mainColor, height: 0.0,),
            new ListTile(
              title: new Text("All Matches"),
              trailing: new Icon(Icons.arrow_forward_ios, color: mainColor,),
              onTap: () {

              },
            ),
            new Divider(color: mainColor, height: 0.0,),
            new ListTile(
              title: new Text("Team Statistics"),
              trailing: new Icon(Icons.arrow_forward_ios, color: mainColor,),
              onTap: () {

              },
            ),
            new Divider(color: mainColor, height: 0.0,),
            new ListTile(
              title: new Text("Pit Scouting"),
              trailing: new Icon(Icons.arrow_forward_ios, color: mainColor,),
              onTap: () {

              },
            ),
            new Divider(color: mainColor, height: 0.0,),
            new ListTile(),
          ],
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
  
  final databaseRef = FirebaseDatabase.instance.reference();

  Color blueBtnColor = Colors.white;
  Color redBtnColor = Colors.white;
  Color blueBtnTxtColor = Colors.black;
  Color redBtnTxtColor = Colors.black;

  Color oneBtnColor = Colors.white;
  Color twoBtnColor = Colors.white;
  Color oneBtnTxtColor = Colors.black;
  Color twoBtn1TxtColor = Colors.black;

  _ScoutingDialogState() {
    currAlliance = "";
    currMatch = "";
    currTeam = "";
    habLevel = 0;
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      color: Colors.white,
      height: 210.0,
      child: new Column(
        children: <Widget>[
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Container(
                width: 100.0,
                child: new TextField(
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18.0),
                  autocorrect: false,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: "Match #",
                      border: InputBorder.none
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
                  style: TextStyle(fontSize: 18.0),
                  autocorrect: false,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: "Team #",
                      border: InputBorder.none
                  ),
                  onChanged: (input) {
                    currTeam = input;
                  },
                ),
              ),
            ],
          ),
          new Text("Alliance:", style: TextStyle(fontWeight: FontWeight.bold),),
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
                      redBtnColor = Colors.white;
                      redBtnTxtColor = Colors.black;
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
                      blueBtnColor = Colors.white;
                      blueBtnTxtColor = Colors.black;
                      redBtnColor = Colors.red;
                      redBtnTxtColor = Colors.white;
                    });
                  },
                ),
              ),
            ],
          ),
          new Padding(padding: EdgeInsets.all(4.0)),
          new Text("HAB Starting Position:", style: TextStyle(fontWeight: FontWeight.bold),),
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
                      oneBtnColor = mainColor;
                      oneBtnTxtColor = Colors.white;
                      twoBtnColor = Colors.white;
                      twoBtn1TxtColor = Colors.black;
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
                      twoBtnColor = mainColor;
                      twoBtn1TxtColor = Colors.white;
                      oneBtnColor = Colors.white;
                      oneBtnTxtColor = Colors.black;
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

