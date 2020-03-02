import 'package:flutter/material.dart';
import 'package:mywb_flutter/models/auto_line.dart';
import 'package:mywb_flutter/models/match.dart';
import 'package:mywb_flutter/models/match_data.dart';
import 'package:mywb_flutter/user_info.dart';
import 'package:mywb_flutter/utils/theme.dart';

class ScoutNewPage extends StatefulWidget {
  @override
  _ScoutNewPageState createState() => _ScoutNewPageState();
}

class _ScoutNewPageState extends State<ScoutNewPage> {

  bool errVisible = false;
  Color errColor = Colors.redAccent;
  String errText = "";
  String prefix = "";

  _ScoutNewPageState() {
    currMatch = new Match();
    currMatch.matchData = new MatchData();
    currMatch.matchData.auto = new AutoLine();
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      color: currCardColor,
      height: 350.0,
      child: new SingleChildScrollView(
        child: new Column(
          children: <Widget>[
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new Container(
                  width: 100.0,
                  child: new TextField(
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18.0, color: currTextColor),
                    autocorrect: false,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        labelText: "Match #",
                        border: InputBorder.none,
                        labelStyle: TextStyle(color: mainColor)
                    ),
                    onChanged: (input) {
                      currMatch.matchNum = int.parse(input);
                    },
                  ),
                ),
                new Container(
                  width: 100.0,
                  child: new TextField(
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18.0, color: currTextColor),
                    autocorrect: false,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        labelText: "Team #",
                        border: InputBorder.none,
                        labelStyle: TextStyle(color: mainColor)
                    ),
                    onChanged: (input) {
                      setState(() {
                        errVisible = true;
                        errText = "";
                      });
                      currMatch.matchData.teamID = input;
                      if (currMatch.matchData.teamID == "") {
                        setState(() {
                          errVisible = false;
                        });
                      }
                      else if (currRegional.teamsList.contains(currMatch.matchData.teamID)) {
                        setState(() {
                          errColor = Colors.greenAccent;
                          errVisible = true;
                          errText = "Valid Team";
                        });
                      }
                      else {
                        setState(() {
                          errColor = Colors.redAccent;
                          errVisible = true;
                          errText = "Invalid Team";
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
            new Visibility(visible: errVisible, child: new Text(errText, style: TextStyle(color: errColor),)),
            new Visibility(visible: errVisible, child: new Padding(padding: EdgeInsets.all(4.0))),
            new Text("Alliance:", style: TextStyle(fontWeight: FontWeight.bold, color: currTextColor),),
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Expanded(
                  child: new FlatButton(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
                    child: new Text("BLUE"),
                    textColor: currMatch.matchData.alliance == "Blue" ? Colors.white : currTextColor,
                    color: currMatch.matchData.alliance == "Blue" ? Colors.blue : currCardColor,
                    onPressed: () {
                      setState(() {
                        currMatch.matchData.alliance = "Blue";
                      });
                    },
                  ),
                ),
                new Expanded(
                  child: new FlatButton(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
                    child: new Text("RED"),
                    textColor: currMatch.matchData.alliance == "Red" ? Colors.white : currTextColor,
                    color: currMatch.matchData.alliance == "Red" ? Colors.red : currCardColor,
                    onPressed: () {
                      setState(() {
                        currMatch.matchData.alliance = "Red";
                      });
                    },
                  ),
                ),
              ],
            ),
            new Padding(padding: EdgeInsets.all(4.0)),
            new Text("Starting Position:", style: TextStyle(fontWeight: FontWeight.bold, color: currTextColor),),
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Expanded(
                  child: new FlatButton(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
                    child: new Text("L"),
                    textColor: currMatch.matchData.auto.startPosition == "Left" ? Colors.white : currTextColor,
                    color: currMatch.matchData.auto.startPosition == "Left" ? mainColor : currCardColor,
                    onPressed: () {
                      setState(() {
                        currMatch.matchData.auto.startPosition = "Left";
                      });
                    },
                  ),
                ),
                new Expanded(
                  child: new FlatButton(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
                    child: new Text("M"),
                    textColor: currMatch.matchData.auto.startPosition == "Middle" ? Colors.white : currTextColor,
                    color: currMatch.matchData.auto.startPosition == "Middle" ? mainColor : currCardColor,
                    onPressed: () {
                      setState(() {
                        currMatch.matchData.auto.startPosition = "Middle";
                      });
                    },
                  ),
                ),
                new Expanded(
                  child: new FlatButton(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
                    child: new Text("R"),
                    textColor: currMatch.matchData.auto.startPosition == "Right" ? Colors.white : currTextColor,
                    color: currMatch.matchData.auto.startPosition == "Right" ? mainColor : currCardColor,
                    onPressed: () {
                      setState(() {
                        currMatch.matchData.auto.startPosition = "Right";
                      });
                    },
                  ),
                ),
              ],
            ),
            new Padding(padding: EdgeInsets.all(4.0)),
            new Text("Preloaded Cells:", style: TextStyle(fontWeight: FontWeight.bold, color: currTextColor),),
            Container(
              child: new Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  new IconButton(
                    icon: new Image.asset("images/subtract.png", color: currMatch.matchData.preload != 0 ? mainColor : currDividerColor,),
                    onPressed: () {
                      if (currMatch.matchData.preload != 0) {
                        setState(() {
                          currMatch.matchData.preload--;
                        });
                      }
                    },
                  ),
                  new Padding(padding: EdgeInsets.all(4)),
                  new Text(
                    (currMatch.matchData.preload).toString(),
                    style: TextStyle(fontSize: 20.0, color: currTextColor),
                  ),
                  new Padding(padding: EdgeInsets.all(4)),
                  new IconButton(
                    icon: new Image.asset("images/add.png", color: currMatch.matchData.preload + 1 <= 3 ? mainColor : currDividerColor,),
                    onPressed: () {
                      if (currMatch.matchData.preload + 1 <= 3) {
                        setState(() {
                          currMatch.matchData.preload++;
                        });
                      }
                    },
                  )
                ],
              ),
            ),
            new Padding(padding: EdgeInsets.all(4.0)),
            new Text("Match Type:", style: TextStyle(fontWeight: FontWeight.bold, color: currTextColor),),
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Expanded(
                  child: new FlatButton(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
                    child: new Text("Practice"),
                    textColor: prefix == "p" ? Colors.white : currTextColor,
                    color: prefix == "p" ? mainColor : currCardColor,
                    onPressed: () {
                      setState(() {
                        prefix = "p";
                        currMatch.id = "$prefix${currMatch.matchNum}";
                      });
                      print(currMatch.id);
                    },
                  ),
                ),
                new Expanded(
                  child: new FlatButton(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
                    child: new Text("Qualifier"),
                    textColor: prefix == "qm" ? Colors.white : currTextColor,
                    color: prefix == "qm" ? mainColor : currCardColor,
                    onPressed: () {
                      setState(() {
                        prefix = "qm";
                        currMatch.id = "$prefix${currMatch.matchNum}";
                      });
                      print(currMatch.id);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
