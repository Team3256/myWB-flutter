import 'package:flutter/material.dart';
import 'package:mywb_flutter/user_info.dart';
import 'package:mywb_flutter/theme.dart';

class UpdateProfilePage extends StatefulWidget {
  @override
  _UpdateProfilePageState createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Update Profile"),
        backgroundColor: mainColor,
      ),
      body: new SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: new Column(
          children: <Widget>[
            new TextField(

            )
          ],
        )
      ),
    );
  }
}
