import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mywb_flutter/models/regional.dart';
import 'package:http/http.dart' as http;
import 'package:mywb_flutter/user_info.dart';
import 'package:mywb_flutter/utils/config.dart';
import 'package:mywb_flutter/utils/theme.dart';

class FilterRegionalPage extends StatefulWidget {
  @override
  _FilterRegionalPageState createState() => _FilterRegionalPageState();
}

class _FilterRegionalPageState extends State<FilterRegionalPage> {

  Widget getLeading(Regional regional) {
    if (currRegional == regional) {
      return new Icon(Icons.check, color: mainColor,);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new CupertinoNavigationBar(
        middle: new Text("Select A Regional", style: TextStyle(color: Colors.white)),
        backgroundColor: mainColor,
        actionsForegroundColor: Colors.white,
      ),
      backgroundColor: currBackgroundColor,
      body: Container(
        padding: EdgeInsets.all(8.0),
        child: new ListView.builder(
          itemCount: regionalList.length,
          itemBuilder: (BuildContext context, int index) {
            return new Container(
              child: new Column(
                children: <Widget>[
                  new ListTile(
                    title: new Text(regionalList[index].shortName, style: TextStyle(color: currTextColor),),
                    subtitle: new Text(regionalList[index].id, style: TextStyle(color: currDividerColor),),
                    trailing: getLeading(regionalList[index]),
                    onTap: () {
                      setState(() {
                        currRegional = regionalList[index];
                      });
                      router.pop(context);
                    },
                  ),
                  new Divider(
                    color: currDividerColor,
                    height: 0.0,
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
