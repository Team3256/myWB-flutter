import 'dart:convert';
import 'dart:io';
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
import 'package:shared_preferences/shared_preferences.dart';

import '../../user_info.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {

  Animation<Offset> animation;
  AnimationController animationController;
  double loginWidgetHeight = 0;
  bool tapToBegin = true;

  String _email = "";
  String _password = "";

  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'https://www.googleapis.com/auth/userinfo.profile',
      'https://www.googleapis.com/auth/userinfo.email',
    ],
  );

  Future<void> signInWithGoogle() async {
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
        await http.get("$dbHost/users/${result.user.uid}", headers: {"Authentication": "Bearer $apiKey"}).then((response) async {
          print(response.body);
          var responseJson = json.decode(response.body);
          if (responseJson["message"] != null) {
            // Failed to find user with current uid
            print("USER DOESN'T EXIST IN DB");
            await Future.delayed(const Duration(milliseconds: 100));
            router.navigateTo(context, '/register', transition: TransitionType.native);
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
        errorDialog("Failed to connect to the server, are you online?");
      }
    } catch (error) {
      print(error);
    }
  }

  void errorDialog(String error) {
    if (Platform.isIOS) {
      showCupertinoDialog(context: context, builder: (context) {
        return CupertinoAlertDialog(
          title: new Text("Server Error\n"),
          content: new Text(error),
          actions: <Widget>[
            new CupertinoDialogAction(
              child: new Text("OK"),
              onPressed: () {
                // TODO: Figure out wat to do here
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
              title: new Text("Server Error", style: TextStyle(color: currTextColor),),
              backgroundColor: currBackgroundColor,
              content: new Text(error),
              actions: <Widget>[
                new FlatButton(
                  child: new Text("GOT IT"),
                  textColor: mainColor,
                  onPressed: () {
                  },
                ),
              ],
            );
          }
      );
    }
  }

  void emailField(input) {
    _email = input;
  }

  void passwordField(input) {
    _password = input;
  }

  void loginEmail() {
    if (_email == "yeet@vcrobotics.net" && _password == "riplane") {
      // yeahh, we logged in
      FirebaseAuth.instance.signInWithEmailAndPassword(email: "yeet@vcrobotics.net", password: "riplane");
      currUser = new User({
        "id": "YhAmV6AUQWaAMDlY3PGIaMNZ86l1",
        "firstName": "Yeet",
        "lastName": "Yat",
        "email": "yeet@vcrobotics.net",
        "phone": "123456890",
        "grade": 12,
        "role": "Lead",
        "varsity": true,
        "shirtSize": "M",
        "jacketSize": "M",
        "discordID": "404",
        "discordAuthToken": "404",
        "perms": [],
        "subteams": []
      });
      router.navigateTo(context, '/home', transition: TransitionType.fadeIn, replace: true);
    }
  }

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 400));
    animation = Tween<Offset>(begin: Offset(0, 0), end: Offset(0, -1.15))
        .animate(animationController);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: mainColor,
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new Expanded(
            child: new Text(
              "Tap anywhere to get started",
              style: TextStyle(color: currBackgroundColor),
              textAlign: TextAlign.center,
            ),
          ),
          new IconButton(
            icon: new Icon(Icons.settings),
            color: currBackgroundColor,
            onPressed: () {
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
                    textCapitalization: TextCapitalization.characters,
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
        ],
      ),
      body: new Stack(
        children: <Widget>[
          new InkWell(
            onTap: () {
              animationController.forward();
              setState(() {
                tapToBegin = false;
                loginWidgetHeight = MediaQuery.of(context).size.height - 200;
              });
            },
            child: Align(
              alignment: AlignmentDirectional(0.0, 0.0),
              child: SlideTransition(
                  position: animation,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 750),
                    height: 250,
                    width: 150,
                    child: new Image.asset('images/wblogo_blue.png'),
                  ))
            ),
          ),
          Align(
            alignment: FractionalOffset.bottomCenter,
            child: new AnimatedContainer(
              padding: EdgeInsets.all(16.0),
              width: double.infinity,
              height: loginWidgetHeight,
              color: currCardColor,
              duration: const Duration(milliseconds: 400),
              child: new Column(
                children: <Widget>[
//                  new Text("Login", style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
//                  new Padding(padding: EdgeInsets.all(16.0),),
                  new Text("Log into your myWB Account below!", textAlign: TextAlign.center,),
                  new TextField(
                    decoration: InputDecoration(
                        icon: new Icon(Icons.email),
                        labelText: "Email",
                        hintText: "Enter your email"
                    ),
                    onChanged: emailField,
                    autocorrect: false,
                    keyboardType: TextInputType.emailAddress,
                    textCapitalization: TextCapitalization.none,
                  ),
                  new TextField(
                    decoration: InputDecoration(
                        icon: new Icon(Icons.lock),
                        labelText: "Password",
                        hintText: "Enter your password"
                    ),
                    onChanged: passwordField,
                    onSubmitted: (input) {
                      loginEmail();
                    },
                    autocorrect: false,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.none,
                    obscureText: true,
                  ),
                  new Padding(padding: EdgeInsets.all(16.0)),
                  new Container(
                    height: 50.0,
                    width: double.infinity,
                    child: new CupertinoButton(
                      child: new Text("Login"),
                      color: mainColor,
                      borderRadius: BorderRadius.circular(16),
                      onPressed: () {
                        loginEmail();
                      },
                    ),
                  ),
                  new Padding(padding: EdgeInsets.all(8.0)),
                  new Text("——  OR  ——"),
                  new Padding(padding: EdgeInsets.all(8.0)),
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
                ],
              ),
            )
          )
        ],
      ),
    );
  }
}
