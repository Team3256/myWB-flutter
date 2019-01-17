import 'package:flutter/material.dart';
import 'package:mywb_flutter/theme.dart';
import 'package:mywb_flutter/user_info.dart';
import 'package:timeline_list/timeline.dart';
import 'package:fluro/fluro.dart';

class BreakdownPage extends StatefulWidget {
  @override
  _BreakdownPageState createState() => _BreakdownPageState();
}

class _BreakdownPageState extends State<BreakdownPage> {
  
  List<Widget> widgetList = [];

  Color getAllianceColor() {
    if (currAlliance == "Blue") {
      return Colors.lightBlue;
    }
    else {
      return Colors.red;
    }
  }

  Widget getHatchBreakdown(index) {
    if (matchEventList[index].dropOff != "Dropped") {
      return new Container(
        decoration: BoxDecoration(
            border: Border(
                left: BorderSide(
                    color: getAllianceColor(),
                    width: 3.0
                )
            )
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Container(
              padding: EdgeInsets.only(left: 16.0),
              child: new Text(
                "${matchEventList[index].pickupTime.toString()} - Picked Up Hatch",
                style: TextStyle(
                    color: getAllianceColor(),
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
            new Card(
              margin: EdgeInsets.all(16.0),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
              child: Container(
                padding: EdgeInsets.all(8.0),
                width: 1000,
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new Text(
                        "From: ${matchEventList[index].pickup}"
                    ),
                    new Padding(padding: EdgeInsets.all(4.0)),
                    new Text(
                        "Dropped Off: ${matchEventList[index].dropOff}"
                    ),
                  ],
                ),
              ),
            ),
            new Container(
              padding: EdgeInsets.only(left: 16.0),
              child: new Text(
                "${matchEventList[index].pickupTime + matchEventList[index].cycleTime} - Deposited Hatch",
                style: TextStyle(
                    color: getAllianceColor(),
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
          ],
        ),
      );
    }
    else {
      new Container(
        decoration: BoxDecoration(
            border: Border(
                left: BorderSide(
                    color: getAllianceColor(),
                    width: 3.0
                )
            )
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Container(
              padding: EdgeInsets.only(left: 16.0),
              child: new Text(
                "${matchEventList[index].pickupTime.toString()} - Picked Up Hatch",
                style: TextStyle(
                    color: getAllianceColor(),
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
            new Card(
              margin: EdgeInsets.all(16.0),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
              child: Container(
                padding: EdgeInsets.all(8.0),
                width: 1000,
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new Text(
                        "From: ${matchEventList[index].pickup}"
                    ),
                  ],
                ),
              ),
            ),
            new Container(
              padding: EdgeInsets.only(left: 16.0),
              child: new Text(
                "${matchEventList[index].pickupTime + matchEventList[index].cycleTime} - Dropped Hatch",
                style: TextStyle(
                    color: getAllianceColor(),
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget getCargoBreakdown(index) {
    if (matchEventList[index].dropOff != "Dropped") {
      return new Container(
        decoration: BoxDecoration(
            border: Border(
                left: BorderSide(
                    color: getAllianceColor(),
                    width: 3.0
                )
            )
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Container(
              padding: EdgeInsets.only(left: 16.0),
              child: new Text(
                "${matchEventList[index].pickupTime.toString()} - Picked Up Cargo",
                style: TextStyle(
                    color: getAllianceColor(),
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
            new Card(
              margin: EdgeInsets.all(16.0),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
              child: Container(
                padding: EdgeInsets.all(8.0),
                width: 1000,
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new Text(
                        "From: ${matchEventList[index].pickup}"
                    ),
                    new Padding(padding: EdgeInsets.all(4.0)),
                    new Text(
                        "Dropped Off: ${matchEventList[index].dropOff}"
                    ),
                  ],
                ),
              ),
            ),
            new Container(
              padding: EdgeInsets.only(left: 16.0),
              child: new Text(
                "${matchEventList[index].pickupTime + matchEventList[index].cycleTime} - Deposited Cargo",
                style: TextStyle(
                    color: getAllianceColor(),
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
          ],
        ),
      );
    }
    else {
      return new Container(
        decoration: BoxDecoration(
            border: Border(
                left: BorderSide(
                    color: getAllianceColor(),
                    width: 3.0
                )
            )
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Container(
              padding: EdgeInsets.only(left: 16.0),
              child: new Text(
                "${matchEventList[index].pickupTime.toString()} - Picked Up Cargo",
                style: TextStyle(
                    color: getAllianceColor(),
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
            new Card(
              margin: EdgeInsets.all(16.0),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
              child: Container(
                padding: EdgeInsets.all(8.0),
                width: 1000,
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new Text(
                        "From: ${matchEventList[index].pickup}"
                    ),
                  ],
                ),
              ),
            ),
            new Container(
              padding: EdgeInsets.only(left: 16.0),
              child: new Text(
                "${matchEventList[index].pickupTime + matchEventList[index].cycleTime} - Dropped Cargo",
                style: TextStyle(
                    color: getAllianceColor(),
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    for(int i = 0; i < matchEventList.length; i++) {
      print(matchEventList[i]);
      if (matchEventList[i].runtimeType == Hatch) {
        print("HATCH");
        widgetList.add(getHatchBreakdown(i));
      }
      else if (matchEventList[i].runtimeType == Cargo) {
        print("CARGO");
        widgetList.add(getCargoBreakdown(i));
      }
      widgetList.add(new Padding(padding: EdgeInsets.all(4.0)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Match $currMatch"),
        backgroundColor: getAllianceColor(),
        elevation: 0.0,
      ),
      body: new Container(
        child: new Column(
          children: <Widget>[
            new Container(
              padding: EdgeInsets.all(16.0),
              color: getAllianceColor(),
              height: 75.0,
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  new Text(
                    currTeam,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 35.0
                    ),
                  ),
                  new Text(
                    "$currAlliance Alliance",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w100,
                        fontSize: 35.0
                    ),
                  )
                ],
              ),
            ),
            new Expanded(
              child: new ListView(
                padding: EdgeInsets.all(16.0),
                children: widgetList
              )
            )
          ],
        ),
      ),
    );
  }
}
