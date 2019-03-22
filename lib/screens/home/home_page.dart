import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mywb_flutter/theme/colors.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool isScrolled) {
        return [
          new CupertinoSliverNavigationBar(
            largeTitle: new Text(
              "Home",
              style: TextStyle(
                color: Colors.white
              ),
            ),
            backgroundColor: mainColor,
          ),
        ];
      },
      body: Container(
        color: currBackgroundColor,
        child: new Center(
          child: new Text(
            "Wow, such empty...",
            style: TextStyle(color: currTextColor),
          ),
        ),
      ),
    );
  }
}
