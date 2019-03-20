import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:mywb_flutter/user_info.dart';
import 'package:mywb_flutter/theme.dart';
import 'package:mywb_flutter/user_drawer.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: currBackgroundColor,
      drawer: new UserDrawer(),
      body: new NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            new CupertinoSliverNavigationBar(
              largeTitle: new Text("Home", style: TextStyle(color: Colors.white),),
              backgroundColor: mainColor,
            ),
          ];
        },
        body: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Text("Wow, such empty...", style: TextStyle(color: currTextColor),)
          ],
        ),
      ),
    );
  }
}
