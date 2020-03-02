import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mywb_flutter/screens/home/home_page.dart';
import 'package:mywb_flutter/screens/scouting/scouting_page.dart';
import 'package:mywb_flutter/screens/settings/settings_page.dart';
import 'package:mywb_flutter/user_info.dart';
import 'package:mywb_flutter/utils/config.dart';
import 'package:mywb_flutter/utils/theme.dart';

class TabBarController extends StatefulWidget {
  @override
  _TabBarControllerState createState() => _TabBarControllerState();
}

class _TabBarControllerState extends State<TabBarController> {

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final databaseRef = FirebaseDatabase.instance.reference();

  int currTab = 0;
  Widget _homeBody = new HomePage();
  Widget _scoutBody = new ScoutingPage();
  Widget _settingsBody = new SettingsPage();
  Widget body;

  void updateRequiredDialog() {
    if (Platform.isIOS) {
      showCupertinoDialog(context: context, builder: (context) {
        return CupertinoAlertDialog(
          title: new Text("Update Required\n"),
          content: new Text("It looks like you are using an outdated version of the myWB App. Please update your app from the App Store."),
          actions: <Widget>[
            new CupertinoDialogAction(
              child: new Text("OK"),
              onPressed: () {
                exit(0);
              },
            ),
          ],
        );
      });
    }
    else if (Platform.isAndroid) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: new Text("Update Required", style: TextStyle(color: currTextColor),),
              backgroundColor: currBackgroundColor,
              content: new Text(
                  "It looks like you are using an outdated version of the myWB App. Please update your app from the Play Store."
              ),
              actions: <Widget>[
                new FlatButton(
                  child: new Text("GOT IT"),
                  textColor: mainColor,
                  onPressed: () {
                    exit(0);
                  },
                ),
              ],
            );
          }
      );
    }
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

  Future<void> appDiagnostics() async {
    await databaseRef.child("stableVersion").once().then((DataSnapshot snapshot) async {
      print("App Version: $appVersion");
      print("APP VERSION: ${appVersion.getVersionCode()}");
      print("STABLE VERSION: ${snapshot.value}");
      print("VERSION DIFF: ${appVersion.getVersionCode() - int.parse(snapshot.value.toString())}");
      if (int.parse(snapshot.value.toString()) - appVersion.getVersionCode() >= 1000) {
        // Outdated app!
        appStatus = " [OUTDATED]";
        await databaseRef.child("forceUpdate").once().then((DataSnapshot snapshot) {
          print("Force Update: ${snapshot.value}");
          if (snapshot.value) {
            print("Force this boi to update");
            updateRequiredDialog();
          }
          else {
            print("outdated, no force");
          }
        });
      }
      else if (appVersion.getVersionCode() > int.parse(snapshot.value.toString())) {
        // Beta app!
        print("BETA APP!");
        appStatus = " Beta ${appVersion.getBuild().toString()}";
      }
      else {
        // Perfect!
      }
    });
  }

  void onTabTapped(int index) {
    setState(() {
      currTab = index;
      if (currTab == 0) {
        body = _homeBody;
      }
      else if (currTab == 1) {
        body = _scoutBody;
      }
      else if (currTab == 2) {
        body = _settingsBody;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    firebaseCloudMessaging_Listeners();
    _firebaseMessaging.subscribeToTopic("ALL_DEVICES");
    currUser.perms.forEach((perm) {
      _firebaseMessaging.subscribeToTopic(perm);
    });
    currUser.subteams.forEach((subteam) {
      _firebaseMessaging.subscribeToTopic(subteam.toUpperCase());
    });
    databaseRef.child("users").child(currUser.id).child("fcm").set(_firebaseMessaging.getToken());
    databaseRef.child("users").child(currUser.id).update({
      "appVersion": "${appVersion.toString()}$appStatus",
      "deviceName": Platform.localHostname,
      "platform": Platform.operatingSystem
    });
    appDiagnostics();
    onTabTapped(0);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: currBackgroundColor,
      body: body,
      bottomNavigationBar: new BottomNavigationBar(
        currentIndex: currTab,
        backgroundColor: currCardColor,
        fixedColor: mainColor,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        unselectedItemColor: darkMode ? Colors.grey : Colors.black54,
        onTap: onTabTapped,
        items: <BottomNavigationBarItem>[
          new BottomNavigationBarItem(
            icon: new Icon(Icons.home),
            title: new Text("Home")
          ),
          new BottomNavigationBarItem(
              icon: new Image.asset(
                'images/scout.png',
                height: 25.0,
                color: currTab == 1 ? mainColor : (darkMode ? Colors.grey : Colors.black54),
              ),
              title: new Text("Scouting")
          ),
          new BottomNavigationBarItem(
              icon: new Icon(Icons.settings),
              title: new Text("Settings")
          ),
        ],
      ),
    );
  }
}
