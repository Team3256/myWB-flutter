import 'dart:convert';

import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mywb_flutter/models/regional.dart';
import 'package:http/http.dart' as http;
import 'package:mywb_flutter/user_info.dart';
import 'package:mywb_flutter/utils/config.dart';
import 'package:mywb_flutter/utils/theme.dart';

class ScoutingTeamsPage extends StatefulWidget {
  @override
  _ScoutingTeamsPageState createState() => _ScoutingTeamsPageState();
}

class _ScoutingTeamsPageState extends State<ScoutingTeamsPage> {

  @override
  void initState() {
    super.initState();
    currRegional.teamsList.sort((a, b) {
      return a.id.compareTo(b.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new CupertinoNavigationBar(
        middle: new Text("Teams @ ${currRegional.shortName}", style: TextStyle(color: Colors.white)),
        backgroundColor: mainColor,
        actionsForegroundColor: Colors.white,
      ),
      backgroundColor: currBackgroundColor,
      body: Container(
        padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
        child: new ListView.builder(
          itemCount: currRegional.teamsList.length,
          itemBuilder: (BuildContext context, int index) {
            return new Container(
              padding: EdgeInsets.only(bottom: 4, top: 4),
              child: new Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
                color: currCardColor,
                elevation: 6.0,
                child: new InkWell(
                  borderRadius: BorderRadius.all(Radius.circular(16.0)),
                  onTap: () {
                    currTeam = currRegional.teamsList[index];
                    router.navigateTo(context, '/scouting/teams/details', transition: TransitionType.cupertino);
                  },
                  child: new Container(
                    padding: EdgeInsets.only(top: 4.0, bottom: 4.0),
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(left: 8.0),
                          child: new Center(
                            child: new Text(
                              currRegional.teamsList[index].id,
                              style: TextStyle(
                                  color: mainColor,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                          width: 60.0,
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
                                  currRegional.teamsList[index].nickname,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: currTextColor,
                                    fontSize: 15.0,
                                  ),
                                ),
                                new Padding(padding: EdgeInsets.all(1.0)),
                                new Text(
                                  currRegional.teamsList[index].name,
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
                  ),
                ),
              )
            );
          },
        ),
      ),
    );
  }
}
