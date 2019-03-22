import 'dart:convert';
import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mywb_flutter/theme/colors.dart';
import 'package:mywb_flutter/user_info.dart';
import 'package:http/http.dart' as http;
import 'package:progress_indicators/progress_indicators.dart';

class AuthCheckerPage extends StatefulWidget {
  @override
  _AuthCheckerPageState createState() => _AuthCheckerPageState();
}

class _AuthCheckerPageState extends State<AuthCheckerPage> {

  final databaseRef = FirebaseDatabase.instance.reference();

  Future<void> checkUserLogged() async {
    var user = await FirebaseAuth.instance.currentUser();
    await databaseRef.child("forceSignOut").once().then((DataSnapshot snapshot) async {
      if (snapshot.value) {
        print("FORCE SIGN OUT");

        authToken = "";
        dbHost = "https://mywb.vcs.net/";

        firstName = "[ERROR]";
        middleName = "";
        lastName = "[ERROR]";
        email = "[ERROR]";
        birthday = "[ERROR]";
        phone = "[ERROR]";
        gender = "[ERROR]";

        role = "[ERROR]";
        userID = "";

        await FirebaseAuth.instance.signOut();
        await new Future.delayed(const Duration(milliseconds: 300));
        router.navigateTo(context, '/register', transition: TransitionType.fadeIn, clearStack: true);
      }
      else {
        if (user != null) {
          // User is logged in
          print("USER LOGGED");
          userID = user.uid;
          await databaseRef.child("users").child(userID).once().then((DataSnapshot snapshot) {
            setState(() {
              authToken = snapshot.value["token"];
              darkMode = snapshot.value["darkMode"];
              if (darkMode) {
                currCardColor = darkCardColor;
                currBackgroundColor = darkBackgroundColor;
                currTextColor = darkTextColor;
                currDividerColor = darkDividerColor;
              }
              else {
                currCardColor = lightCardColor;
                currBackgroundColor = lightBackgroundColor;
                currTextColor = lightTextColor;
                currDividerColor = lightDividerColor;
              }
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
                await new Future.delayed(const Duration(milliseconds: 300));
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

                await new Future.delayed(const Duration(milliseconds: 500));
                router.navigateTo(context, '/home', transition: TransitionType.fadeIn, clearStack: true);
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
          await new Future.delayed(const Duration(milliseconds: 300));
          router.navigateTo(context, '/register', transition: TransitionType.fadeIn, clearStack: true);
        }
      }
    });
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
      child: Center(
        child: new HeartbeatProgressIndicator(
          child: new Image.asset(
            'images/wblogo.png',
            height: 25.0,
          )
        ),
      ),
    );
  }
}
