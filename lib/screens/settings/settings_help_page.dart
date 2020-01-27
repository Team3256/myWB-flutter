import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mywb_flutter/utils/config.dart';
import 'package:mywb_flutter/utils/theme.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SettingsHelpPage extends StatefulWidget {
  @override
  _SettingsHelpPageState createState() => _SettingsHelpPageState();
}

class _SettingsHelpPageState extends State<SettingsHelpPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new CupertinoNavigationBar(
        middle: new Text("Help", style: TextStyle(color: Colors.white)),
        backgroundColor: mainColor,
        actionsForegroundColor: Colors.white,
      ),
      body: new WebView(
        initialUrl: "https://github.com/Team3256/myWB-flutter/wiki",
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
