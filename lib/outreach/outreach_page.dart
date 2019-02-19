import 'package:flutter/material.dart';
import 'package:mywb_flutter/theme.dart';
import 'package:mywb_flutter/user_info.dart';
import 'package:mywb_flutter/user_drawer.dart';

class OutreachPage extends StatefulWidget {
  @override
  _OutreachPageState createState() => _OutreachPageState();
}

class _OutreachPageState extends State<OutreachPage> {
  @override
  Widget build(BuildContext context) {
    return new Container(
      padding: EdgeInsets.all(16.0),
      child: new SingleChildScrollView(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Text(
                "Current",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0, color: currTextColor)
            ),
          ],
        ),
      )
    );
  }
}
