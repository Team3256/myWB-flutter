import 'dart:async';
import 'package:flutter/material.dart';
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

  void serverConnectionDialog() {
    // flutter defined function
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Connection Error", style: TextStyle(fontFamily: "Product Sans"),),
          content: new Text(
            "It looks like we are unable to connect you to the server at this time. This alert will automatically disappear when a connection to the server is established.",
          ),
        );
      },
    );
  }

  Future<void> checkUserLogged() async {
    if (authToken != "") {
      print("USER LOGGED");
      var userUrl = "${dbHost}api/hr/user/info";
      try {
        await http.get(userUrl, headers: {HttpHeaders.authorizationHeader: "Bearer $authToken"}).then((user) async {
          print(user.body);
          print("Connected!");
          var userJson = json.decode(user.body);
          if (userJson["error"] != null) {
            // Ruh-roh Auth Token went Breah-Brat
            print("USER NOT LOGGED");
            router.navigateTo(context, '/login', transition: TransitionType.fadeIn, clearStack: true);
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
            await new Future.delayed(const Duration(milliseconds: 1500));
            router.navigateTo(context, '/logged', transition: TransitionType.fadeIn, clearStack: true);
          }
        });
      }
      catch (error) {
        await new Future.delayed(const Duration(milliseconds: 300));
        print("Connection Failed!");
        serverConnectionDialog();
      }
    }
    else {
      print("USER NOT LOGGED");
      router.navigateTo(context, '/login', transition: TransitionType.fadeIn, clearStack: true);
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
