import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:mywb_flutter/theme.dart';
import 'package:mywb_flutter/user_info.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:fluro/fluro.dart';
import 'dart:io';
import 'dart:convert';

class AuthCheckerPage extends StatefulWidget {
  @override
  _AuthCheckerPageState createState() => _AuthCheckerPageState();
}

class _AuthCheckerPageState extends State<AuthCheckerPage> {

  final databaseRef = FirebaseDatabase.instance.reference();

  Future<void> checkUserLogged() async {
    var user = await FirebaseAuth.instance.currentUser();
    if (user != null) {
      // User is logged in
      print("USER LOGGED");
      userID = user.uid;
      await databaseRef.child("users").child(userID).once().then((DataSnapshot snapshot) {
        setState(() {
          authToken = snapshot.value["token"];
          darkMode = snapshot.value["darkMode"];
        });
      });
      var userUrl = "${dbHost}api/hr/user/info";
      try {
        await http.get(userUrl, headers: {HttpHeaders.authorizationHeader: "Bearer $authToken"}).then((user) async {
          print(user.body);
          print("Connected!");
          var userJson = json.decode(user.body);
          if (userJson["error"] != null) {
            // Ruh-roh Auth Token went Breah-Brat
            print("USER NOT LOGGED");
            router.navigateTo(context, '/register', transition: TransitionType.fadeIn, clearStack: true);
          }
          else {
            firstName = userJson["firstName"];
            middleName = userJson["middleName"];
            lastName = userJson["lastName"];
            email = userJson["email"];
            birthday = userJson["birthday"];
            phone = userJson["cellPhone"];
            gender = userJson["gender"];
            role = userJson["type"];

            print("");
            print("------------ USER DEBUG INFO ------------");
            print("NAME: $firstName $lastName");
            print("EMAIL: $email");
            print("USERID: $userID");
            print("AUTH TOKEN: $authToken");
            print("DARK MODE: ${darkMode.toString().toUpperCase()}");
            print("-----------------------------------------");
            print("");

            await new Future.delayed(const Duration(milliseconds: 1500));
            router.navigateTo(context, '/logged', transition: TransitionType.fadeIn, clearStack: true);
          }
        });
      }
      catch (error) {
        await new Future.delayed(const Duration(milliseconds: 300));
        print("Ruh-roh - $error");
        router.navigateTo(context, '/register', transition: TransitionType.fadeIn, clearStack: true);
      }
    }
    else {
      print("USER NOT LOGGED");
      router.navigateTo(context, '/register', transition: TransitionType.fadeIn, clearStack: true);
    }
  }

  @override
  void initState() {
    super.initState();
    checkUserLogged();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: new Center(
        child: new HeartbeatProgressIndicator(
          child: new Image.asset(
            'images/wblogo.png',
            height: 25.0,
          ),
        ),
      ),
    );
  }
}
