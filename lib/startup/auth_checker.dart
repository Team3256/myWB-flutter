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

  Future<void> checkUserLogged() async {
    if (authToken != "") {
      print("USER LOGGED!");
      var userUrl = "https://mywb.vcs.net/api/hr/user/info";
      http.get(userUrl, headers: {HttpHeaders.authorizationHeader: "Bearer $authToken"}).then((user) {
        print(user.body);
        var userJson = json.decode(user.body);
        firstName = userJson["firstName"];
        middleName = userJson["middleName"];
        lastName = userJson["lastName"];
        email = userJson["email"];
        birthday = userJson["birthday"];
        phone = userJson["cellPhone"];
        gender = userJson["gender"];
        role = userJson["type"];
      });
      await new Future.delayed(const Duration(milliseconds: 1500));
      router.navigateTo(context, '/logged', transition: TransitionType.fadeIn, clearStack: true);
    }
    else {
      print("USER NOT LOGGED!");
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
