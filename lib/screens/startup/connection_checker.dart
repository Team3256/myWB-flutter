import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:mywb_flutter/screens/auth/auth_checker.dart';
import 'package:mywb_flutter/screens/startup/connection_checker_again.dart';
import 'package:mywb_flutter/user_info.dart';

class NetworkChecker extends StatefulWidget {
  @override
  _NetworkCheckerState createState() => _NetworkCheckerState();
}

class _NetworkCheckerState extends State<NetworkChecker> {

  final connectionRef = FirebaseDatabase.instance.reference().child(".info/connected");

  Future<void> checkConnection() async {
    connectionRef.onValue.listen(connectionListener);
  }

  connectionListener(Event event) {
    print(event.snapshot.value);
    if (event.snapshot.value) {
      print("Connected");
      router.navigateTo(context, '/check-auth', transition: TransitionType.fadeIn, clearStack: true);
    }
    else {
      print("Not Connected");
      router.navigateTo(context, '/check-connection-again', transition: TransitionType.fadeIn, clearStack: true);
    }
  }

  @override
  void initState() {
    super.initState();
    checkConnection();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Container(
          color: Colors.white,
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
                    color: Colors.black,
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
    );
  }
}