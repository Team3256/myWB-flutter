import 'package:flutter/material.dart';
import 'package:mywb_flutter/theme.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:mywb_flutter/user_info.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  String _email = "";
  String _password = "";

  Widget buttonChild = new Text("Login");

  void emailField(input) {
    _email = input;
  }

  void passwordField(input) {
    _password = input;
  }

  void login() async {
    setState(() {
      buttonChild = HeartbeatProgressIndicator(
        child: new Image.asset(
          'images/wblogo.png',
          color: Colors.white,
          height: 13.0,
        ),
      );
    });
    var authUrl = "https://mywb.vcs.net/auth/generate-token";
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(authUrl));
    request.headers.set('content-type', 'application/json');
    request.add(utf8.encode(json.encode({"email": _email, "password": _password})));
    HttpClientResponse response = await request.close();
    String reply = await response.transform(utf8.decoder).join();
    httpClient.close();
    print(reply);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Login"),
        backgroundColor: mainColor,
      ),
      body: new Container(
        padding: EdgeInsets.fromLTRB(32.0, 16.0, 32.0, 32.0),
        child: new Center(
          child: new Column(
            children: <Widget>[
              new Text("Login to your myWB Account below!"),
              new Padding(padding: EdgeInsets.all(8.0)),
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
              new Padding(padding: EdgeInsets.all(8.0)),
              new RaisedButton(
                child: buttonChild,
                onPressed: login,
                color: mainColor,
                textColor: Colors.white,
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
                  router.pop(context);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
