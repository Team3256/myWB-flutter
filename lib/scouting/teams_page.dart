import 'package:flutter/cupertino.dart';
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
  String location;
  
  Team(this.teamKey, this.teamName, this.location);
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
            regionalTeamsList.add(new Team(teamsJson[i]["key"].toString().substring(3), teamsJson[i]["nickname"], "${teamsJson[i]["city"]}, ${teamsJson[i]["state_prov"]}, ${teamsJson[i]["country"]}"));
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
      appBar: new CupertinoNavigationBar(
        middle: new Text("${currRegional.shortName} Teams", style: TextStyle(color: Colors.white)),
        backgroundColor: currAccentColor,
        actionsForegroundColor: Colors.white,
        previousPageTitle: "Scouting",
      ),
      body: new RefreshIndicator(
        onRefresh: onRefresh,
        color: Colors.white,
        backgroundColor: currAccentColor,
        child: new Container(
          color: currBackgroundColor,
          padding: EdgeInsets.all(16.0),
          child: new ListView.builder(
            itemCount: regionalTeamsList.length,
            itemBuilder: (BuildContext context, int index) {
              return new Container(
                child: new Column(
                  children: <Widget>[
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          child: new Center(
                            child: new Text(
                              regionalTeamsList[index].teamKey,
                              style: TextStyle(
                                color: mainColor,
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
                                  regionalTeamsList[index].teamName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: currTextColor,
                                      fontSize: 15.0,
                                  ),
                                ),
                                new Padding(padding: EdgeInsets.all(1.0)),
                                new Text(
                                  regionalTeamsList[index].location,
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
                    new Divider(color: currDividerColor)
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
