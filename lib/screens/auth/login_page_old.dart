import 'dart:convert';
import 'package:fluro/fluro.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mywb_flutter/main.dart';
import 'package:mywb_flutter/models/user.dart';
import 'package:mywb_flutter/utils/config.dart';
import 'package:mywb_flutter/utils/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../user_info.dart';

class LoginPageOld extends StatefulWidget {
  @override
  _LoginPageOldState createState() => _LoginPageOldState();
}

class _LoginPageOldState extends State<LoginPageOld> {

  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'https://www.googleapis.com/auth/userinfo.profile',
      'https://www.googleapis.com/auth/userinfo.email',
    ],
  );

  Future<String> signInWithGoogle() async {
    try {
      GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken
      );
      AuthResult result = await FirebaseAuth.instance.signInWithCredential(credential);
      print(result.user.uid);
      print(result.user.displayName);
      print(result.user.email);
      try {
        await http.get("$dbHost/users/${result.user.uid}").then((response) async {
          print(response.body);
          var responseJson = json.decode(response.body);
          if (responseJson["message"] != null) {
            // Failed to find user with current uid
            print("USER DOESN'T EXIST IN DB");
            await Future.delayed(const Duration(milliseconds: 100));
            // TODO: Navigate to register page
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
        // TODO: create a server error page and navigate to it
      }
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      color: mainColor,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Image(image: AssetImage("images/wblogo_blue.png"), height: 200.0),
            SizedBox(height: 50),
            OutlineButton(
              onPressed: () {
                signInWithGoogle();
              },
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
              highlightElevation: 0.0,
              borderSide: BorderSide(color: Colors.grey),
              highlightedBorderColor: mainColor,
              highlightColor: Colors.white,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image(image: AssetImage("images/google_logo.png"), height: 25.0),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        'Sign in with Google',
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.grey,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            new CupertinoButton(
              child: new Text("Sign in with email instead"),
              onPressed: () {

              },
            )
          ],
        ),
      ),
    );
  }
}
