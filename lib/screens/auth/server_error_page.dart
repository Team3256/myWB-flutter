import 'dart:convert';

import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mywb_flutter/models/user.dart';
import 'package:mywb_flutter/utils/config.dart';
import 'package:mywb_flutter/utils/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

import '../../user_info.dart';

class ServerErrorPage extends StatefulWidget {
  @override
  _ServerErrorPageState createState() => _ServerErrorPageState();
}

class _ServerErrorPageState extends State<ServerErrorPage> {

  bool alertView = false;

  Future<void> checkAuth() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey("dbHost")) {
      prefs.setString("dbHost", dbHost);
    }
    if (!prefs.containsKey("darkMode")) {
      prefs.setBool("darkMode", darkMode);
    }
    dbHost = prefs.getString("dbHost");
    darkMode = prefs.getBool("darkMode");
    if (darkMode) {
      setState(() {
        currBackgroundColor = darkBackgroundColor;
        currCardColor = darkCardColor;
        currDividerColor = darkDividerColor;
        currTextColor = darkTextColor;
      });
    }
    else {
      setState(() {
        currBackgroundColor = lightBackgroundColor;
        currCardColor = lightCardColor;
        currDividerColor = lightDividerColor;
        currTextColor = lightTextColor;
      });
    }
    if (user != null) {
      print("USER LOGGED");
      try {
        await http.get("$dbHost/users/${user.uid}", headers: {"Authentication": "Bearer $apiKey"}).then((response) async {
          print(response.body);
          var responseJson = json.decode(response.body);
          if (responseJson["message"] != null) {
            // Failed to find user with current uid
            print(responseJson["message"]);
            print("USER DOESN'T EXIST IN DB");
            await Future.delayed(const Duration(milliseconds: 100));
            router.navigateTo(context, '/login', transition: TransitionType.fadeIn, replace: true, clearStack: true);
          }
          else {
            currUser = User(json.decode(response.body));
            print("");
            print("------------ USER DEBUG INFO ------------");
            print("NAME: ${currUser.firstName} ${currUser.lastName}");
            print("EMAIL: ${currUser.email}");
            print("USERID: ${currUser.id}");
            print("-----------------------------------------");
            await Future.delayed(const Duration(milliseconds: 100));
            router.navigateTo(context, '/home', transition: TransitionType.fadeIn, replace: true, clearStack: true);
          }
        });
      } catch (error) {
        print("Error occured, are you online?");
        print("ERROR: $error}");
        await Future.delayed(const Duration(seconds: 5));
        if (!alertView) {
          router.navigateTo(context, '/server-error', transition: TransitionType.fadeIn, replace: true);
        }
      }
    }
    else {
      print("USER NOT LOGGED");
      await Future.delayed(const Duration(milliseconds: 100));
      router.navigateTo(context, '/login', transition: TransitionType.fadeIn, replace: true, clearStack: true);
    }
  }

  @override
  void initState() {
    super.initState();
    checkAuth();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: currBackgroundColor,
      floatingActionButton: new IconButton(
        icon: new Icon(Icons.settings),
        color: Colors.grey,
        onPressed: () {
          setState(() {
            alertView = true;
          });
          String newHost = "";
          showCupertinoDialog(context: context, builder: (context) {
            return CupertinoAlertDialog(
              title: new Text("Custom Server Host\n"),
              content: new CupertinoTextField(
                autocorrect: false,
                autofocus: true,
                onChanged: (String input) {
                  newHost = input;
                },
                placeholder: dbHost,
              ),
              actions: <Widget>[
                new CupertinoDialogAction(
                  child: new Text("Cancel"),
                  onPressed: () {
                    router.pop(context);
                  },
                ),
                new CupertinoDialogAction(
                  child: new Text("Set"),
                  onPressed: () async {
                    if (newHost != "") {
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      setState(() {
                        dbHost = newHost;
                        prefs.setString("dbHost", dbHost);
                        alertView = false;
                      });
                    }
                    router.pop(context);
                  },
                ),
              ],
            );
          });
        },
      ),
      body: Container(
        child: SafeArea(
          child: Container(
            padding: EdgeInsets.only(bottom: 32.0, left: 16.0, right: 16.0, top: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Image.asset(
                  'images/robo-history.png',
                  height: 100.0,
                  fit: BoxFit.cover,
                ),
                new Text(
                  "Server Connection Error",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                    decoration: TextDecoration.none,
                    fontSize: 35.0,
                  ),
                ),
                new Text(
                  "We encountered a problem when trying to connect you to our servers. This page will automatically disappear if a connection with the server is established.\n\nTroubleshooting Tips:\n- Check your wireless connection\n- Restart the myWB app\n- Restart your device",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: currTextColor,
                      decoration: TextDecoration.none,
                      fontSize: 17.0,
                      fontWeight: FontWeight.normal
                  ),
                ),
                new Padding(padding: EdgeInsets.all(16.0)),
                new FlatButton(
                  child: new Text("OFFLINE MODE", style: TextStyle(color: mainColor),),
                  onPressed: () {
                    offlineMode = true;
                    router.navigateTo(context, '/scouting/offline', replace: true);
                  },
                ),
                Image.asset(
                  'images/wblogo.png',
                  height: 35.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
