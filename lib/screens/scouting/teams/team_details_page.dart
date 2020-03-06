import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mywb_flutter/utils/theme.dart';

import '../../../user_info.dart';

class TeamDetailsPage extends StatefulWidget {
  @override
  _TeamDetailsPageState createState() => _TeamDetailsPageState();
}

class _TeamDetailsPageState extends State<TeamDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new CupertinoNavigationBar(
        middle: new Text("FRC ${currTeam.id}", style: TextStyle(color: Colors.white)),
        previousPageTitle: "Home",
        actionsForegroundColor: Colors.white,
        backgroundColor: mainColor,
      ),
      backgroundColor: currBackgroundColor,
      body: new SingleChildScrollView(
        padding: EdgeInsets.all(8.0),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Text(
              currTeam.nickname,
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
                    child: new Text(currTeam.id, style: TextStyle(color: Colors.white)),
                    padding: EdgeInsets.only(top: 4.0, bottom: 4.0, right: 8.0, left: 8.0),
                  ),
                ),
                new Text("Infinite Recharge 2020")
              ],
            ),
            new Padding(padding: EdgeInsets.all(4.0)),
            new Text(
              currTeam.name,
            ),
            new Padding(padding: EdgeInsets.all(4.0)),

          ],
        ),
      ),
    );
  }
}
