import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:mywb_flutter/app_drawer.dart';
import 'package:mywb_flutter/models/regional.dart';
import 'package:mywb_flutter/screens/home/home_page.dart';
import 'package:mywb_flutter/screens/scouting/scouting_page.dart';
import 'package:mywb_flutter/screens/settings/settings_page.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:io';
import 'package:mywb_flutter/theme/colors.dart';
import 'package:mywb_flutter/user_info.dart';

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
      tabBarColor = currBackgroundColor;
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
        _currentWidget = new ScoutingPage();
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
    return Scaffold(
      body: _currentWidget,
      drawer: new AppDrawer(),
      bottomNavigationBar: new BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentTab,
        items: [
          new BottomNavigationBarItem(
              icon: new Icon(Icons.home, size: 30.0,),
              title: new Container()
          ),
          new BottomNavigationBarItem(
              icon: new Image.asset('images/scout.png', width: 18.0,),
              activeIcon: new Image.asset('images/scout.png', width: 18.0, color: mainColor),
              title: new Container()
          ),
          new BottomNavigationBarItem(
              icon: new Icon(Icons.settings, size: 30.0,),
              title: new Container()
          ),
        ],
      ),
    );
  }
}
