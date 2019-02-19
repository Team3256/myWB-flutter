import 'package:flutter/material.dart';
import 'package:mywb_flutter/theme.dart';
import 'package:mywb_flutter/user_info.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class TeamsPage extends StatefulWidget {
  @override
  _TeamsPageState createState() => _TeamsPageState();
}

class Team {
  String teamKey;
  String teamName;
  
  Team(this.teamKey, this.teamName);
}

class _TeamsPageState extends State<TeamsPage> {

  List<Team> regionalTeamsList = new List();


  @override
  void initState() {
    super.initState();
    onRefresh();
  }

  Future onRefresh() async {
    print("Getting Teams List for ${currRegional.shortName}");
    regionalTeamsList.clear();
    var teamsUrl = "${dbHost}api/scouting/regional/${currRegional.key}/teams";
    try {
      await http.get(teamsUrl, headers: {HttpHeaders.authorizationHeader: "Bearer $authToken"}).then((response) {
        var teamsJson = jsonDecode(response.body);
        for (int i = 0; i < teamsJson.length; i++) {
          setState(() {
            regionalTeamsList.add(new Team(teamsJson[i]["key"].toString().substring(3), teamsJson[i]["nickname"]));
          });
        }
      });
    }
    catch (error) {
      print("Failed to get teams list - $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("${currRegional.shortName} Teams"),
        backgroundColor: mainColor,
      ),
      body: new RefreshIndicator(
        onRefresh: onRefresh,
        color: Colors.white,
        backgroundColor: mainColor,
        child: new Container(
          color: Colors.black,
          padding: EdgeInsets.all(8.0),
          child: new ListView.builder(
            itemCount: regionalTeamsList.length,
            itemBuilder: (BuildContext context, int index) {
              return new Container(
                padding: EdgeInsets.all(8.0),
                child: new Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        new Text(
                          regionalTeamsList[index].teamKey,
                          style: TextStyle(
                            color: mainColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 17.0
                          ),
                        ),
                        new Text(
                          regionalTeamsList[index].teamName,
                          style: TextStyle(
                              fontSize: 17.0
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
