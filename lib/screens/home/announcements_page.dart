import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mywb_flutter/models/post.dart';
import 'package:mywb_flutter/utils/theme.dart';
import 'package:progress_indicators/progress_indicators.dart';

class AnnouncementsPage extends StatefulWidget {
  @override
  _AnnouncementsPageState createState() => _AnnouncementsPageState();
}

class _AnnouncementsPageState extends State<AnnouncementsPage> {

  List<Post> postList = new List();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new CupertinoNavigationBar(
        middle: new Text("Events", style: TextStyle(color: Colors.white)),
        previousPageTitle: "Home",
        actionsForegroundColor: Colors.white,
        backgroundColor: mainColor,
      ),
      backgroundColor: currBackgroundColor,
      body: new Container(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            new Visibility(
                visible: (postList.length == 0),
                child: new Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(32.0),
                    child: new HeartbeatProgressIndicator(
                        child: new Image.asset(
                          'images/wblogo.png',
                          height: 15.0,
                        )
                    )
                )
            )
          ],
        ),
      ),
    );
  }
}
