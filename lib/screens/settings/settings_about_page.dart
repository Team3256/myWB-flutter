import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mywb_flutter/utils/config.dart';
import 'package:mywb_flutter/utils/theme.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsAboutPage extends StatefulWidget {
  @override
  _SettingsAboutPageState createState() => _SettingsAboutPageState();
}

class _SettingsAboutPageState extends State<SettingsAboutPage> {

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
        appBar: CupertinoNavigationBar(
          backgroundColor: mainColor,
          actionsForegroundColor: Colors.white,
          previousPageTitle: "Settings",
          middle: new Text(
            "About",
            style: TextStyle(
                color: Colors.white
            ),
          ),
        ),
        backgroundColor: currBackgroundColor,
        body: new SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 8.0, right: 8.0, left: 8.0),
                  child: new Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
                    color: currCardColor,
                    elevation: 6.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Container(
                          padding: EdgeInsets.all(16.0),
                          child: new Text("Device", style: TextStyle(
                              color: mainColor,
                              fontFamily: "Product Sans",
                              fontWeight: FontWeight.bold),),
                        ),
                        new ListTile(
                          title: new Text("App Version",
                              style: TextStyle(fontFamily: "Product Sans", color: currTextColor)),
                          trailing: new Text("$appVersion$appStatus",
                              style: TextStyle(
                                  fontFamily: "Product Sans", fontSize: 16.0, color: currTextColor)),
                        ),
                        new ListTile(
                          title: new Text("Device Name",
                              style: TextStyle(fontFamily: "Product Sans", color: currTextColor)),
                          trailing: new Text("$deviceName", style: TextStyle(
                              fontFamily: "Product Sans", fontSize: 16.0, color: currTextColor)),
                        ),
                        new ListTile(
                          title: new Text("Platform",
                              style: TextStyle(fontFamily: "Product Sans", color: currTextColor)),
                          trailing: new Text("$devicePlatform", style: TextStyle(
                              fontFamily: "Product Sans", fontSize: 16.0, color: currTextColor)),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 8.0, right: 8.0, left: 8.0),
                  child: new Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
                    color: currCardColor,
                    elevation: 6.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Container(
                          padding: EdgeInsets.all(16.0),
                          child: new Text("Credits", style: TextStyle(
                              fontFamily: "Product Sans",
                              color: mainColor,
                              fontWeight: FontWeight.bold),),
                        ),
                        new ListTile(
                          title: new Text("Bharat Kathi",
                              style: TextStyle(fontFamily: "Product Sans", color: currTextColor)),
                          subtitle: new Text("App/Database Development",
                              style: TextStyle(fontFamily: "Product Sans", color: Colors.grey)),
                          onTap: () {
                            const url = 'https://github.com/bk1031';
                            launch(url);
                          },
                        ),
                        new ListTile(
                          title: new Text("John Panos",
                              style: TextStyle(fontFamily: "Product Sans", color: currTextColor)),
                          subtitle: new Text("Initial Database Development",
                              style: TextStyle(fontFamily: "Product Sans", color: Colors.grey)),
                          onTap: () {
                            const url = 'https://github.com/johnpanos';
                            launch(url);
                          },
                        ),
                        new ListTile(
                          title: new Text("Marc Liu",
                              style: TextStyle(fontFamily: "Product Sans", color: currTextColor)),
                          subtitle: new Text("Initial App Design",
                              style: TextStyle(fontFamily: "Product Sans", color: Colors.grey)),
                        ),
                        new Divider(height: 0.0, color: currDividerColor, indent: 8.0, endIndent: 8.0,),
                        new ListTile(
                          title: new Text("Samuel Stephen",
                              style: TextStyle(fontFamily: "Product Sans", color: currTextColor)),
                        ),
                        new ListTile(
                          title: new Text("Flaumbert Ruas",
                              style: TextStyle(fontFamily: "Product Sans", color: currTextColor)),
                        ),
                        new ListTile(
                          title: new Text("Kashyap Chaturvedula",
                              style: TextStyle(fontFamily: "Product Sans", color: currTextColor)),
                        ),
                        new ListTile(
                          title: new Text("Thomas Liang",
                              style: TextStyle(fontFamily: "Product Sans", color: currTextColor)),
                        ),
                        new ListTile(
                          subtitle: new Text("Beta Testers\n",
                              style: TextStyle(fontFamily: "Product Sans", color: Colors.grey)),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 8.0, right: 8.0, left: 8.0),
                  child: new Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
                    color: currCardColor,
                    elevation: 6.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Container(
                          padding: EdgeInsets.all(16.0),
                          child: new Text("Contributing", style: TextStyle(
                              fontFamily: "Product Sans",
                              color: mainColor,
                              fontWeight: FontWeight.bold),),
                        ),
                        new ListTile(
                          title: new Text("View on GitHub",
                              style: TextStyle(fontFamily: "Product Sans", color: currTextColor)),
                          trailing: new Icon(
                              Icons.navigate_next, color: mainColor),
                          onTap: () {
                            launchContributeUrl();
                          },
                        ),
                        new ListTile(
                          title: new Text("Contributing Guidelines",
                              style: TextStyle(fontFamily: "Product Sans", color: currTextColor)),
                          trailing: new Icon(
                              Icons.navigate_next, color: mainColor),
                          onTap: () {
                            launchGuidelinesUrl();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                new Padding(padding: EdgeInsets.all(8.0)),
                new Text("® WarriorBorgs Systems and Logistics Department", style: TextStyle(color: currDividerColor, fontStyle: FontStyle.italic))
              ],
            ),
          ),
        )
    );
  }
}