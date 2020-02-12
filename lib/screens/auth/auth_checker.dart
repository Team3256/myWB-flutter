import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mywb_flutter/models/user.dart';
import 'package:mywb_flutter/user_info.dart';
import 'package:mywb_flutter/utils/config.dart';
import 'package:mywb_flutter/utils/theme.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:fluro/fluro.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthCheckerPage extends StatefulWidget {
  @override
  _AuthCheckerPageState createState() => _AuthCheckerPageState();
}

class _AuthCheckerPageState extends State<AuthCheckerPage> {


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
        router.navigateTo(context, '/server-error', transition: TransitionType.fadeIn, replace: true);
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
      body: Container(
        color: Colors.white,
        child: Center(
          child: new HeartbeatProgressIndicator(
              child: new Image.asset(
                'images/wblogo.png',
                height: 25.0,
              )
          ),
        ),
      ),
    );
  }
}
