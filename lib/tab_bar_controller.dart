import 'package:flutter/material.dart';
import 'package:mywb_flutter/home/home_page.dart';
import 'package:mywb_flutter/user_drawer.dart';
import 'user_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:mywb_flutter/scouting/scout_page.dart';
import 'package:mywb_flutter/outreach/outreach_page.dart';
import 'package:mywb_flutter/inventory/inventory_page.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:mywb_flutter/settings/settings_page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'theme.dart';

class TabBarController extends StatefulWidget {
  @override
  _TabBarControllerState createState() => _TabBarControllerState();
}

class _TabBarControllerState extends State<TabBarController> {
  
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final databaseRef = FirebaseDatabase.instance.reference();

  int _currentTab = 0;
  String _title = "Home";
  Widget _currentWidget = new HomePage();
  Color tabBarColor = currBackgroundColor;

  void firebaseCloudMessaging_Listeners() {
    if (Platform.isIOS) iOS_Permission();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('on message $message');
      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
      },
    );
  }

  void iOS_Permission() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true)
    );
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings)
    {
      print("Settings registered: $settings");
    });
  }

  void onTabTapped(int index) {
    setState(() {
      if (currBackgroundColor == lightBackgroundColor) {
        tabBarColor = CupertinoColors.lightBackgroundGray;
      }
      else {
        tabBarColor = CupertinoColors.darkBackgroundGray;
      }
    });
    _currentTab = index;
    if (index == 0) {
      setState(() {
        _currentWidget = new HomePage();
        _title = "Home";
      });
    }
    else if (index == 1) {
      setState(() {
        _currentWidget = new ScoutPage();
        _title = "Scouting";
      });
    }
    else if (index == 2) {
      setState(() {
        _currentWidget = new SettingsPage();
        _title = "Settings";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    firebaseCloudMessaging_Listeners();
    _firebaseMessaging.subscribeToTopic("allDevices");
    databaseRef.child("stableVersion").once().then((DataSnapshot snapshot) {
      var stable = snapshot.value;
      print("Current Version: $appVersion");
      print("Stable Version: $stable");
      if (appVersion < stable) {
        print("OUTDATED APP!");
        appStatus = " [OUTDATED]";
      }
      else if (appVersion > stable) {
        print("BETA APP!");
        appStatus = " Beta $appBuild";
      }
    });
    regionalList.clear();
    try {
      var regionalsUrl = "${dbHost}api/scouting/regional/";
      http.get(regionalsUrl, headers: {HttpHeaders.authorizationHeader: "Bearer $authToken"}).then((response) {
        var regionalsJson = jsonDecode(response.body);
        for (int i = 0; i < regionalsJson.length; i++) {
          setState(() {
            regionalList.add(new Regional(regionalsJson[i]["key"], regionalsJson[i]["name"], regionalsJson[i]["shortName"]));
          });
        }
        print("RegionalsList: $regionalList");
        // Initialize Regional
        setState(() {
          currRegional = regionalList[0];
        });
      });
    }
    catch (error) {
      print("Failed to get regionals");
    }
  }

  @override
  Widget build(BuildContext context) {
    // Main Build Function for iOS/Android
    if (true) {
      return new Scaffold(
        backgroundColor: currBackgroundColor,
        drawer: new UserDrawer(),
        body: new NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool isScrolled) {
            return <Widget>[
              new CupertinoSliverNavigationBar(
                largeTitle: new Text(_title, style: TextStyle(color: Colors.white),),
                backgroundColor: mainColor,
              ),
            ];
          },
          body: _currentWidget,
        ),
        bottomNavigationBar: new CupertinoTabBar(
          onTap: onTabTapped,
          currentIndex: _currentTab,
          activeColor: mainColor,
          backgroundColor: tabBarColor,
          items: [
            new BottomNavigationBarItem(
              icon: new Icon(Icons.home),
              title: new Container()
            ),
            new BottomNavigationBarItem(
                icon: new Image.asset('images/scout.png', width: 18.0,),
                activeIcon: new Image.asset('images/scout.png', width: 18.0, color: mainColor),
                title: new Container()
            ),
            new BottomNavigationBarItem(
                icon: new Icon(Icons.settings),
                title: new Container()
            ),
          ],
        ),
      );
    }
  }
}
