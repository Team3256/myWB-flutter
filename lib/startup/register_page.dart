import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mywb_flutter/theme.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:mywb_flutter/user_info.dart';
import 'dart:convert';
import 'dart:io';
import 'package:progress_indicators/progress_indicators.dart';

String tempPassword = "";

String _firstName = "";
String _lastName = "";
String _email = "";
String _password = "";
String _confirm = "";

final formats = {
  InputType.both: DateFormat("EEEE, MMMM d, yyyy 'at' h:mma"),
  InputType.date: DateFormat('yyyy-MM-dd'),
  InputType.time: DateFormat("HH:mm"),
};

InputType inputType = InputType.date;
String _date;


class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  bool cancelSession = false;

  final databaseRef = FirebaseDatabase.instance.reference();

  Widget buttonChild = new Text("Create Account");

  void accountErrorDialog(String error) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Account Creation Error", style: TextStyle(fontFamily: "Product Sans"),),
          content: new Text(
            "There was an error creating your myWB Account: $error",
            style: TextStyle(fontFamily: "Product Sans", fontSize: 14.0),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text("GOT IT"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void emailVerificationDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Verify Email", style: TextStyle(fontFamily: "Product Sans"),),
            content: new EmailVerificationAlert(),
          );
        }
    );
  }

  void register() async {
    setState(() {
      buttonChild = new HeartbeatProgressIndicator(
        child: Image.asset(
          'images/wblogo.png',
          height: 15.0,
        ),
      );
    });
    if (_firstName == "" || _lastName == "") {
      print("Name cannot be empty");
      accountErrorDialog("Name cannot be empty");
    }
    else if (_password != _confirm) {
      print("Password don't match");
      accountErrorDialog("Passwords do not match");
    }
    else if (_email == "") {
      print("Email cannot be empty");
      accountErrorDialog("Email cannot be empty");
    }
    else {
      try {
        tempPassword = _password;
        FirebaseUser user = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _email, password: _password);
        print("Signed in! ${user.uid}");

        email = _email;
        userID = user.uid;

        await user.sendEmailVerification();

        emailVerificationDialog();
      }
      catch (error) {
        print("Error: ${error.details}");
        accountErrorDialog(error.details);
      }
    }
    setState(() {
      buttonChild = new Text("Create Account");
    });
  }

  void firstNameField(input) {
    _firstName = input;
  }

  void lastNameField(input) {
    _lastName = input;
  }

  void emailField(input) {
    _email = input;
  }

  void passwordField(input) {
    _password = input;
  }

  void confirmField(input) {
    _confirm = input;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        title: Text(
          "myWB",
          style: TextStyle(
            fontFamily: "Product Sans",
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      body: new Container(
        padding: EdgeInsets.fromLTRB(32.0, 16.0, 32.0, 32.0),
        child: new Center(
          child: new ListView(
            children: <Widget>[
              new Text("Create your myWB Account below!", style: TextStyle(fontFamily: "Product Sans",), textAlign: TextAlign.center,),
              new TextField(
                decoration: InputDecoration(
                    icon: new Icon(Icons.person),
                    labelText: "First Name",
                    hintText: "Enter your first name"
                ),
                autocorrect: true,
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.words,
                onChanged: firstNameField,
              ),
              new TextField(
                decoration: InputDecoration(
                    icon: new Icon(Icons.person),
                    labelText: "Last Name",
                    hintText: "Enter your last name"
                ),
                autocorrect: true,
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.words,
                onChanged: lastNameField,
              ),
              new TextField(
                decoration: InputDecoration(
                    icon: new Icon(Icons.email),
                    labelText: "Email",
                    hintText: "Enter your email"
                ),
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                textCapitalization: TextCapitalization.none,
                onChanged: emailField,
              ),
              new DateTimePickerFormField(
                inputType: inputType,
                format: formats[inputType],
                onChanged: (dateTime) {
                  setState(() {
                    _date = dateTime.toString().substring(0, 10);
                  });
                  print(_date);
                },
                decoration: InputDecoration(
                    icon: new Icon(Icons.cake),
                    labelText: "Birthday",
                    hintText: "Enter your birthday"
                ),
              ),
              new TextField(
                decoration: InputDecoration(
                    icon: new Icon(Icons.lock),
                    labelText: "Password",
                    hintText: "Enter a password"
                ),
                autocorrect: false,
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.none,
                obscureText: true,
                onChanged: passwordField,
              ),
              new TextField(
                decoration: InputDecoration(
                    icon: new Icon(Icons.lock),
                    labelText: "Confirm Password",
                    hintText: "Confirm your password"
                ),
                autocorrect: false,
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.none,
                obscureText: true,
                onChanged: confirmField,
              ),
              new Padding(padding: EdgeInsets.all(8.0)),
              new RaisedButton(
                child: buttonChild,
                onPressed: register,
                color: mainColor,
                textColor: Colors.white,
                highlightColor: mainColor,
              ),
              new Padding(padding: EdgeInsets.all(16.0)),
              new FlatButton(
                child: new Text(
                  "Already have an account?",
                  style: TextStyle(
                    color: mainColor,
                  ),
                ),
                splashColor: mainColor,
                onPressed: () {
                  router.navigateTo(context,'/login', transition: TransitionType.fadeIn);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

class EmailVerificationAlert extends StatefulWidget {
  @override
  _EmailVerificationAlertState createState() => _EmailVerificationAlertState();
}

class _EmailVerificationAlertState extends State<EmailVerificationAlert> {

  final databaseRef = FirebaseDatabase.instance.reference();

  String mainText = "Please verify your email address via the link we sent you.";
  Color textColor = Colors.black;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.0,
      child: new Column(
        children: <Widget>[
          new Text(
            mainText,
            style: TextStyle(fontFamily: "Product Sans", color: textColor),
          ),
          new Padding(padding: EdgeInsets.all(6.0)),
          new Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              new FlatButton(
                child: new Text("CHANGE EMAIL"),
                textColor: mainColor,
                onPressed: () async {
                  FirebaseAuth.instance.signInWithEmailAndPassword(email: _email, password: _password);
                  FirebaseUser user = await FirebaseAuth.instance.currentUser();
                  await user.delete();
                  router.pop(context);
                },
              ),
              new FlatButton(
                child: new Text("VERIFY"),
                textColor: Colors.white,
                color: mainColor,
                onPressed: () async {
                  FirebaseUser user = await FirebaseAuth.instance.currentUser();
                  user.reload();
                  if (!user.isEmailVerified) {
                    print("User Email Verified");
                    setState(() {
                      mainText = "Successfully verified email!\nCreating Account...";
                      textColor = Colors.greenAccent;
                    });
                    var createUserUrl = "${dbHost}auth/student/";
                    var authUrl = "${dbHost}auth/generate-token";
                    var createUserJson = jsonEncode({
                      "firstName": _firstName,
                      "middleName": "",
                      "lastName": _lastName,
                      "cellPhone": "",
                      "email": _email,
                      "password": _password,
                      "birthday": _date,
                      "gender": "MALE",
                      "student": {
                        "backupEmail": _email,
                        "grade": 0,
                        "powerSchoolId": 0,
                        "shirtSize": "small",
                        "poloSize": "small",
                        "isInFLL": false,
                        "isInFTC": false,
                        "isInFRC": true
                      }
                    });

                    print(createUserJson);

                    try {
                      http.post(createUserUrl, headers: {HttpHeaders.contentTypeHeader: "application/json"}, body: createUserJson).then((response) {
                        print(response.body);
                        var userJson = jsonDecode(response.body);
                        firstName = userJson["firstName"];
                        middleName = userJson["middleName"];
                        lastName = userJson["lastName"];
                        email = userJson["email"];
                        birthday = userJson["birthday"];
                        phone = userJson["cellPhone"];
                        gender = userJson["gender"];
                        role = userJson["type"];

                        http.post(authUrl, body: json.encode({"email": _email, "password": _password}), headers: {"Content-Type": "application/json"}).then((response) {
                          authToken = (jsonDecode(response.body))["token"];
                          databaseRef.child("users").child(userID).update({
                            "name": "$firstName $lastName",
                            "email": email,
                            "darkMode": darkMode,
                            "token": authToken
                          });

                          print("");
                          print("------------ USER DEBUG INFO ------------");
                          print("NAME: $firstName $lastName");
                          print("EMAIL: $email");
                          print("USERID: $userID");
                          print("AUTH TOKEN: $authToken");
                          print("DARK MODE: ${darkMode.toString().toUpperCase()}");
                          print("-----------------------------------------");
                          print("");

                          router.navigateTo(context,'/home', transition: TransitionType.fadeIn, clearStack: true);
                        });
                      });
                    }
                    catch (error) {
                      print("error");
                    }
                  }
                  else {
                    print("User Email Not Verified");
                    setState(() {
                      mainText = "User has not been verified. Please try again.";
                      textColor = Colors.redAccent;
                    });
                    Future.delayed(const Duration(seconds: 3), () {
                      setState(() {
                        mainText = "Please verify your email address via the link we sent you.";
                        textColor = Colors.black;
                      });
                    });
                  }
                },
              )
            ],
          )
        ],
      ),
    );
  }
}