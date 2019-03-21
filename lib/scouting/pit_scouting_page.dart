import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:mywb_flutter/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PitScoutingPage extends StatefulWidget {
  @override
  _PitScoutingPageState createState() => _PitScoutingPageState();
}

class _PitScoutingPageState extends State<PitScoutingPage> {
  
  final databaseRef = FirebaseDatabase.instance.reference();

  String url = "https://github.com/team3245/mywb-flutter/wiki/";
  
  _PitScoutingPageState() {
    databaseRef.child("pitScouting").once().then((DataSnapshot snapshot) {
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
        backgroundColor: currAccentColor,
        middle: new Text("Pit Scouting", style: TextStyle(color: Colors.white)),
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
