import 'package:flutter/material.dart';
import 'package:mywb_flutter/theme.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HelpPage extends StatefulWidget {
  @override
  _HelpPageState createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        title: new Text("Help"),
        textTheme: TextTheme(
        ),
      ),
      body: const WebView(
        initialUrl: 'https://github.com/team3245/mywb-flutter/wiki/Help',
        javaScriptMode: JavaScriptMode.unrestricted,
      ),
    );
  }
}