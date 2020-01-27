import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mywb_flutter/utils/config.dart';
import 'package:mywb_flutter/utils/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ServerErrorPage extends StatefulWidget {
  @override
  _ServerErrorPageState createState() => _ServerErrorPageState();
}

class _ServerErrorPageState extends State<ServerErrorPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: currBackgroundColor,
      floatingActionButton: new IconButton(
        icon: new Icon(Icons.settings),
        color: Colors.grey,
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
      body: Container(
        child: SafeArea(
          child: Container(
            padding: EdgeInsets.only(bottom: 32.0, left: 16.0, right: 16.0, top: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Image.asset(
                  'images/robo-history.png',
                  height: 100.0,
                  fit: BoxFit.cover,
                ),
                new Padding(padding: EdgeInsets.all(16.0)),
                new Text(
                  "Server Connection Error",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                    decoration: TextDecoration.none,
                    fontSize: 35.0,
                  ),
                ),
                new Padding(padding: EdgeInsets.all(16.0)),
                new Text(
                  "We encountered a problem when trying to connect you to our servers. This page will automatically disappear if a connection with the server is established.\n\nTroubleshooting Tips:\n- Check your wireless connection\n- Restart the myWB app\n- Restart your device",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: currTextColor,
                      decoration: TextDecoration.none,
                      fontSize: 17.0,
                      fontWeight: FontWeight.normal
                  ),
                ),
                new Padding(padding: EdgeInsets.all(100.0)),
                Image.asset(
                  'images/wblogo.png',
                  height: 35.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
