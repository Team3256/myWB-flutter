import 'package:flutter/material.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:mywb_flutter/user_drawer.dart';
import 'user_info.dart';
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
  
  PageController _pageController = new PageController();
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final databaseRef = FirebaseDatabase.instance.reference();

  int currentTab = 0;
  String title = "Scouting";

  void onTabTapped(int index) {
    setState(() {
      currentTab = index;
      if (currentTab == 0) {
        title = "Scouting";
      }
      else if (currentTab == 1) {
        title = "Outreach";
      }
      else if (currentTab == 2) {
        title = "Inventory";
      }
      else if (currentTab == 3) {
        title = "Settings";
      }
    });
    _pageController.animateToPage(index, duration: const Duration(milliseconds: 200), curve: Curves.easeOut);
  }

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
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: mainColor,
        title: new Text(title,),
      ),
      drawer: new UserDrawer(),
      body: new PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          ScoutPage(),
          OutreachPage(),
          InventoryPage(),
          SettingsPage()
        ],
      ),
      bottomNavigationBar: new Stack(
        alignment: FractionalOffset.bottomCenter,
        children: <Widget>[
          new SafeArea(
            child: new FancyBottomNavigation(
              textColor: mainColor,
              onTabChangedListener: onTabTapped,
              tabs: [
                TabData(iconData: Icons.track_changes, title: "Scouting"),
                TabData(iconData: Icons.people, title: "Outreach"),
                TabData(iconData: Icons.storage, title: "Inventory"),
                TabData(iconData: Icons.settings, title: "Settings"),
              ],
            ),
          ),
          new Container(
            height: MediaQuery.of(context).padding.bottom,
            color: Colors.white,
          )
        ],
      ),
    );
  }
}
