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
        title: new Text("bruh"),
      ),
      body: new WebView(
        initialUrl: "$webHost/#/login",
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}