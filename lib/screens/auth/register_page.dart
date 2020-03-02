import 'package:flutter/material.dart';
import 'package:mywb_flutter/utils/config.dart';
import 'package:webview_flutter/webview_flutter.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Account Not Found"),
      ),
      body: new Center(
        child: new Text(
          "Please go to http://vcrobotics.net/#/login to create a myWB Account!"
        ),
      )
    );
  }
}