import 'package:flutter/material.dart';
import 'package:mywb_flutter/user_info.dart';
import 'package:mywb_flutter/user_drawer.dart';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:mywb_flutter/theme.dart';
import 'package:fluro/fluro.dart';

class ScoutPage extends StatefulWidget {
  @override
  _ScoutPageState createState() => _ScoutPageState();
}

class Match {

  int id;
  String name;
  List<String> teamKeys;

  Match({this.id, this.name, this.teamKeys});

  factory Match.fromJson(Map<String, dynamic> json) {
    return Match(
      id: json["id"] as int,
      name: json["name"] as String,
      teamKeys: json["teamKeys"] as List<String>
    );
  }

}

class _ScoutPageState extends State<ScoutPage> {

  final scoutSource = "https://raw.githubusercontent.com/Team3256/myWB-flutter/master/lib/scouting/example.json";
  List<Match> matchList = new List();

  _ScoutPageState() {
    http.get(scoutSource).then((response) {
      var scoutingJson = json.decode(response.body);
      setState(() {
        matchList.add(Match.fromJson({"id": 1, "name": "Match 1", "teamKeys": ["3256", "971", "115", "3126", "123", "525"]}));
        matchList.add(Match.fromJson({"id": 2, "name": "Match 2", "teamKeys": ["3126", "123", "525", "3126", "123", "525"]}));
        matchList.add(Match.fromJson({"id": 3, "name": "Match 3", "teamKeys": ["1750", "2384", "137", "3126", "123", "525"]}));
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
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Scouting"),
        backgroundColor: mainColor,
      ),
      floatingActionButton: new FloatingActionButton(
        child: new Icon(Icons.add),
        backgroundColor: mainColor,
        onPressed: () {
          scoutDialog();
        },
      ),
      drawer: new UserDrawer(),
      body: new Container(
        padding: EdgeInsets.all(16.0),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Text("Current", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),),
            new Padding(padding: EdgeInsets.all(8.0)),
            new Padding(padding: EdgeInsets.all(8.0)),
            new Divider(color: mainColor,),
            new Padding(padding: EdgeInsets.all(8.0)),
            new Text("Previous Matches", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),),
            new Padding(padding: EdgeInsets.all(8.0)),
            new Container(
              height: 150.0,
              child: new ListView.builder(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsets.all(8.0),
                    child: new ClipRRect(
                      child: new Container(
                        color: Colors.blue,
                        padding: EdgeInsets.only(top: 8.0),
                        width: 130.0,
                        child: new Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            new Text(
                              matchList[index].name,
                              style: TextStyle(color: Colors.white),
                            ),
                            new Expanded(
                              child: new Container(
                                padding: EdgeInsets.all(4.0),
                                color: Colors.blue,
                                child: new Text(
                                  matchList[index].teamKeys.toString().substring(1, (matchList[index].teamKeys.toString().length / 2).toInt() - 1),
                                  style: TextStyle(color: Colors.white, fontSize: 18.0),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            new Expanded(
                              child: new Container(
                                padding: EdgeInsets.all(4.0),
                                color: Colors.red,
                                child: new Text(
                                  matchList[index].teamKeys.toString().substring((matchList[index].teamKeys.toString().length / 2).toInt(), matchList[index].teamKeys.toString().length - 1),
                                  style: TextStyle(color: Colors.white, fontSize: 18.0),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                  );
                },
                itemCount: matchList.length,
              ),
            ),
            new Divider(color: mainColor,),
          ],
        ),
      )
    );
  }
}

class ScoutingDialog extends StatefulWidget {
  @override
  _ScoutingDialogState createState() => _ScoutingDialogState();
}

class _ScoutingDialogState extends State<ScoutingDialog> {

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

