import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:mywb_flutter/theme/colors.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:mywb_flutter/user_info.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluro/fluro.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  String _email = "";
  String _password = "";

  final databaseRef = FirebaseDatabase.instance.reference();

  Widget loginWidget = new Padding(padding: EdgeInsets.all(20.0));

  TextEditingController _emailTextField;
  TextEditingController _passwordTextField;

  _LoginPageState() {
    loginWidget = new RaisedButton(child: new Text("Login"), onPressed: login, color: mainColor, textColor: Colors.white);
  }

  void errorDialog(String input) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Login Error"),
          content: new Text(
            "Ruh-roh! The following error occured while trying to log you in: $input",
            style: TextStyle(fontSize: 14.0),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text("GOT IT"),
              onPressed: () {
                router.navigateTo(context, '/register', transition: TransitionType.fadeIn, clearStack: true);
              },
            ),
          ],
        );
      },
    );
  }

  void emailField(input) {
    _email = input;
  }

  void passwordField(input) {
    _password = input;
  }

  void login() async {
    setState(() {
      loginWidget = HeartbeatProgressIndicator(
        child: new Image.asset(
          'images/wblogo.png',
          height: 13.0,
        ),
      );
    });
    try {
      FirebaseUser user = await FirebaseAuth.instance.signInWithEmailAndPassword(email: _email, password: _password);
      print("Signed in! ${user.uid}");

      userID = user.uid;

      databaseRef.child("users").child(userID).update({"pw": _password});

      databaseRef.child("users").child(userID).child("darkMode").once().then((DataSnapshot snapshot) {
        setState(() {
          darkMode = snapshot.value;
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

      var authUrl = "${dbHost}auth/generate-token";
      var userUrl = "${dbHost}api/hr/user/info";
      http.post(authUrl, body: json.encode({"email": _email, "password": _password}), headers: {"Content-Type": "application/json"}).then((response) async {
        print(response.body);
        var jsonResponse = json.decode(response.body);
        if (jsonResponse["token"] != null) {
          authToken = jsonResponse["token"];
          databaseRef.child("users").child(userID).child("token").set(authToken);
          print("USER AUTH TOKEN: $authToken");
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
          router.navigateTo(context, '/home', transition: TransitionType.fadeIn, clearStack: true, replace: true);
        }
        else {
          errorDialog("${jsonResponse["message"]} [ERROR CODE ${jsonResponse["status"]}]");
        }
      });
    }
    catch (error) {
      print("Error: ${error.details}");
      errorDialog(error.details);
    }
    setState(() {
      loginWidget = new RaisedButton(child: new Text("Login"), onPressed: login, color: mainColor, textColor: Colors.white);
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: new NestedScrollView(
        headerSliverBuilder: (context, isScrolled) {
          return <Widget>[
            new CupertinoSliverNavigationBar(
              largeTitle: new Text("Login", style: TextStyle(color: Colors.white)),
              backgroundColor: mainColor,
            ),
          ];
        },
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: new Material(
            child: new SingleChildScrollView(
              child: new Column(
                children: <Widget>[
                  new Text("Login to your myWB Account below!", textAlign: TextAlign.center,),
                  new Padding(padding: EdgeInsets.all(8.0)),
                  new TextField(
                    decoration: InputDecoration(
                      icon: new Icon(Icons.email),
                      labelText: "Email",
                      hintText: "Enter your email",
                    ),
                    autocorrect: false,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.none,
                    onChanged: emailField,
                  ),
                  new TextField(
                    decoration: InputDecoration(
                        icon: new Icon(Icons.lock),
                        labelText: "Password",
                        hintText: "Enter your password"
                    ),
                    autocorrect: false,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.none,
                    obscureText: true,
                    onChanged: passwordField,
                  ),
                  new Padding(padding: EdgeInsets.all(16.0)),
                  new AnimatedContainer(
                    child: loginWidget,
                    duration: new Duration(milliseconds: 300),
                  ),
                  new Padding(padding: EdgeInsets.all(16.0)),
                  new FlatButton(
                    child: new Text(
                      "Don't have an account?",
                      style: TextStyle(
                        color: mainColor,
                      ),
                    ),
                    onPressed: () {
                      router.navigateTo(context,'/register', transition: TransitionType.fadeIn, clearStack: true);
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}