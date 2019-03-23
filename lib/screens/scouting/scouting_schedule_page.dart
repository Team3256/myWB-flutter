import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:mywb_flutter/theme/colors.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ScoutingSchedulePage extends StatefulWidget {
  @override
  _ScoutingSchedulePageState createState() => _ScoutingSchedulePageState();
}

class _ScoutingSchedulePageState extends State<ScoutingSchedulePage> {

  final databaseRef = FirebaseDatabase.instance.reference();

  String url = "https://github.com/team3245/mywb-flutter/wiki/";

  _ScoutingSchedulePageState() {
    databaseRef.child("scoutingSchedule").once().then((DataSnapshot snapshot) {
      print(snapshot.value);
      setState(() {
        url = snapshot.value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new CupertinoNavigationBar(
        backgroundColor: mainColor,
        middle: new Text("Scouting Schedule", style: TextStyle(color: Colors.white)),
        previousPageTitle: "Scouting",
        actionsForegroundColor: Colors.white,
      ),
      backgroundColor: currBackgroundColor,
      body: new WebView(
        initialUrl: url,
        onWebViewCreated: (WebViewController controller) {
          Future.delayed(const Duration(milliseconds: 300), () {
            controller.loadUrl(url);
          });
        },
        javaScriptMode: JavaScriptMode.unrestricted,
      ),
    );
  }
}
