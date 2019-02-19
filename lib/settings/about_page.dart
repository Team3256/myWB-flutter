import 'package:mywb_flutter/user_info.dart';
import 'package:mywb_flutter/theme.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import 'package:firebase_database/firebase_database.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  
  final databaseRef = FirebaseDatabase.instance.reference();

  String devicePlatform = "";
  String deviceName = "";

  List<String> betaTestersList = new List();

  @override
  void initState() {
    super.initState();
    if (Platform.isIOS) {
      devicePlatform = "iOS";
    }
    else if (Platform.isAndroid) {
      devicePlatform = "Android";
    }
    deviceName = Platform.localHostname;
    databaseRef.child("betaTesters").onChildAdded.listen((Event event) {
      setState(() {
        betaTestersList.add(event.snapshot.value.toString());
      });
    });
  }

  launchContributeUrl() async {
    const url = 'https://github.com/Team3256/myWB-flutter/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  launchGuidelinesUrl() async {
    const url = 'https://github.com/Team3256/myWB-flutter/wiki/Contributing';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: currAccentColor,
          title: new Text("About"),
        ),
        body: new SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                new Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Container(
                        padding: EdgeInsets.all(16.0),
                        child: new Text("Device", style: TextStyle(
                            color: currAccentColor,
                            fontFamily: "Product Sans",
                            fontWeight: FontWeight.bold),),
                      ),
                      new ListTile(
                        title: new Text("App Version",
                            style: TextStyle(fontFamily: "Product Sans",)),
                        trailing: new Text("$appVersion$appStatus",
                            style: TextStyle(
                                fontFamily: "Product Sans", fontSize: 16.0)),
                      ),
                      new Divider(height: 0.0, color: currAccentColor),
                      new ListTile(
                        title: new Text("Device Name",
                            style: TextStyle(fontFamily: "Product Sans",)),
                        trailing: new Text("$deviceName", style: TextStyle(
                            fontFamily: "Product Sans", fontSize: 16.0)),
                      ),
                      new Divider(height: 0.0, color: currAccentColor),
                      new ListTile(
                        title: new Text("Platform",
                            style: TextStyle(fontFamily: "Product Sans",)),
                        trailing: new Text("$devicePlatform", style: TextStyle(
                            fontFamily: "Product Sans", fontSize: 16.0)),
                      ),
                    ],
                  ),
                ),
                new Padding(padding: EdgeInsets.all(8.0)),
                new Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Container(
                        padding: EdgeInsets.all(16.0),
                        child: new Text("Credits", style: TextStyle(
                            fontFamily: "Product Sans",
                            color: currAccentColor,
                            fontWeight: FontWeight.bold),),
                      ),
                      new ListTile(
                        title: new Text("Bharat Kathi",
                            style: TextStyle(fontFamily: "Product Sans",)),
                        subtitle: new Text("App Development",
                            style: TextStyle(fontFamily: "Product Sans",)),
                        onTap: () {
                          const url = 'https://github.com/bk1031';
                          launch(url);
                        },
                      ),
                      new Divider(height: 0.0, color: currAccentColor),
                      new ListTile(
                        title: new Text("John Panos",
                            style: TextStyle(fontFamily: "Product Sans",)),
                        subtitle: new Text("Database Architecture",
                            style: TextStyle(fontFamily: "Product Sans",)),
                        onTap: () {
                          const url = 'https://github.com/johnpanos';
                          launch(url);
                        },
                      ),
                      new Divider(height: 0.0, color: currAccentColor),
                      new ListTile(
                        title: new Text("Mark Liu",
                            style: TextStyle(fontFamily: "Product Sans",)),
                        subtitle: new Text("Initial App Design",
                            style: TextStyle(fontFamily: "Product Sans",)),
                      ),
                      new Divider(height: 0.0, color: currAccentColor),
                      new ListTile(
                        title: new Text("Kashyap Chaturvedula",
                            style: TextStyle(fontFamily: "Product Sans",)),
                      ),
                      new ListTile(
                        subtitle: new Text("Beta Testers\n",
                            style: TextStyle(fontFamily: "Product Sans",)),
                      ),
                    ],
                  ),
                ),
                new Padding(padding: EdgeInsets.all(16.0)),
                new Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Container(
                        padding: EdgeInsets.all(16.0),
                        child: new Text("Contributing", style: TextStyle(
                            fontFamily: "Product Sans",
                            color: currAccentColor,
                            fontWeight: FontWeight.bold),),
                      ),
                      new ListTile(
                        title: new Text("View on GitHub",
                            style: TextStyle(fontFamily: "Product Sans",)),
                        trailing: new Icon(
                            Icons.arrow_forward_ios, color: currAccentColor),
                        onTap: () {
                          launchContributeUrl();
                        },
                      ),
                      new Divider(height: 0.0, color: currAccentColor),
                      new ListTile(
                        title: new Text("Contributing Guidelines",
                            style: TextStyle(fontFamily: "Product Sans",)),
                        trailing: new Icon(
                            Icons.arrow_forward_ios, color: currAccentColor),
                        onTap: () {
                          launchGuidelinesUrl();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }
}