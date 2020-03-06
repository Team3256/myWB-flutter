import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mywb_flutter/user_info.dart';
import 'package:mywb_flutter/utils/config.dart';
import 'package:mywb_flutter/utils/theme.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ScoutingBreakdownPage extends StatefulWidget {
  @override
  _ScoutingBreakdownPageState createState() => _ScoutingBreakdownPageState();
}

class _ScoutingBreakdownPageState extends State<ScoutingBreakdownPage> {

  bool showQr = false;
  bool failedUpload = false;
  bool uploading = false;

  List<Widget> qrWidgetList = new List();
  PageController _pageController = new PageController();

  void onPageChanged(int index) {
    if (index == 0) {
      setState(() {
        showQr = false;
      });
    }
    else if (index == 1) {
      setState(() {
        showQr = true;
      });
    }
  }


  void showError(String error) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return new CupertinoAlertDialog(
          title: new Text("Server Error"),
          content: new Text("An error occured while uploading match data: $error Please send the Match QR Codes to Bharat or Sam."),
          actions: <Widget>[
            new CupertinoDialogAction(
              child: new Text("Got it"),
              onPressed: () {
                router.pop(context);
              },
            )
          ],
        );
      }
    );
  }

  void showSuccess() {
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return new CupertinoAlertDialog(
            title: new Text("${currMatch.id} Uploaded!"),
            content: new Text("${currMatch.id} for team ${currMatch.matchData.teamID} has been successfully uploaded!"),
            actions: <Widget>[
              new CupertinoDialogAction(
                child: new Text("Got it"),
                onPressed: () {
                  router.pop(context);
                  router.pop(context);
                  router.pop(context);
                },
              )
            ],
          );
        }
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new CupertinoNavigationBar(
        middle: new Text("${currMatch.id.contains("p") ? "Practice" : ""} Match ${currMatch.matchNum}", style: TextStyle(color: Colors.white),),
        backgroundColor: mainColor,
        actionsForegroundColor: Colors.white,
      ),
      backgroundColor: currBackgroundColor,
      body: Container(
        padding: EdgeInsets.all(8),
        child: new Column(
          children: <Widget>[
            new Row(
              children: <Widget>[
                new Expanded(
                  child: new Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
                    color: showQr ? currBackgroundColor : mainColor,
                    elevation: showQr ? 0.0 : 6.0,
                    child: new FlatButton(
                        child: new Text("Breakdown", style: TextStyle(color: showQr ? currTextColor : Colors.white)),
                        onPressed: () {
                          setState(() {
                            showQr = false;
                          });
                          _pageController.animateToPage(0, duration: const Duration(milliseconds: 200), curve: Curves.easeOut);
                        }
                    ),
                  ),
                ),
                new Expanded(
                  child: new Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
                    color: !showQr ? currBackgroundColor : mainColor,
                    elevation: !showQr ? 0.0 : 6.0,
                    child: new FlatButton(
                        child: new Text("QR Code", style: TextStyle(color: !showQr ? currTextColor : Colors.white)),
                        onPressed: () {
                          setState(() {
                            showQr = true;
                          });
                          _pageController.animateToPage(1, duration: const Duration(milliseconds: 200), curve: Curves.easeOut);
                        }
                    ),
                  ),
                ),
              ],
            ),
            new Expanded(
              child: new PageView(
                controller: _pageController,
                onPageChanged: onPageChanged,
                children: <Widget>[
                  new Container(
                    child: new InkWell(
                      onTap: () {
                        Clipboard.setData(new ClipboardData(text: jsonEncode(currMatch).toString()));
                      },
                      child: new Center(
                        child: new Text(
                          jsonEncode(currMatch).toString(),
                          style: TextStyle(fontSize: 10, color: currTextColor),
                        ),
                      ),
                    ),
                  ),
                  new Container(
                    padding: EdgeInsets.all(16),
                    child: new SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          new Text(
                            "QR 1",
                            style: TextStyle(fontSize: 17, color: currTextColor, fontWeight: FontWeight.bold),
                          ),
                          new Padding(padding: EdgeInsets.all(4)),
                          new Text(
                            jsonEncode(currMatch).toString().substring(0, (jsonEncode(currMatch).length / 3).floor()),
                            style: TextStyle(fontSize: 10, color: currTextColor),
                          ),
                          new Padding(padding: EdgeInsets.all(8)),
                          new ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                            child: new QrImage(
                              data: jsonEncode(currMatch).toString().substring(0, (jsonEncode(currMatch).length / 3).floor()),
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              size: 250,
                              errorStateBuilder: (context, error) {
                                return new Text(error, style: TextStyle(color: Colors.red),);
                              },
                            ),
                          ),
                          new Padding(padding: EdgeInsets.all(8)),
                          new Text(
                            "QR 2",
                            style: TextStyle(fontSize: 17, color: currTextColor, fontWeight: FontWeight.bold),
                          ),
                          new Padding(padding: EdgeInsets.all(4)),
                          new Text(
                            jsonEncode(currMatch).toString().substring((jsonEncode(currMatch).length / 3).floor(), (jsonEncode(currMatch).length / 3).floor() * 2),
                            style: TextStyle(fontSize: 10, color: currTextColor),
                          ),
                          new Padding(padding: EdgeInsets.all(8)),
                          new ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                            child: new QrImage(
                              data: jsonEncode(currMatch).toString().substring((jsonEncode(currMatch).length / 3).floor(), (jsonEncode(currMatch).length / 3).floor() * 2),
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              size: 250,
                              errorStateBuilder: (context, error) {
                                return new Text(error, style: TextStyle(color: Colors.red),);
                              },
                            ),
                          ),
                          new Padding(padding: EdgeInsets.all(8)),
                          new Text(
                            "QR 3",
                            style: TextStyle(fontSize: 17, color: currTextColor, fontWeight: FontWeight.bold),
                          ),
                          new Padding(padding: EdgeInsets.all(4)),
                          new Text(
                            jsonEncode(currMatch).toString().substring((jsonEncode(currMatch).length / 3).floor() * 2, (jsonEncode(currMatch).length / 3).floor() * 3),
                            style: TextStyle(fontSize: 10, color: currTextColor),
                          ),
                          new Padding(padding: EdgeInsets.all(8)),
                          new ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                            child: new QrImage(
                              data: jsonEncode(currMatch).toString().substring((jsonEncode(currMatch).length / 3).floor() * 2, (jsonEncode(currMatch).length / 3).floor() * 3),
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              size: 250,
                              errorStateBuilder: (context, error) {
                                return new Text(error, style: TextStyle(color: Colors.red),);
                              },
                            ),
                          ),
                          new Padding(padding: EdgeInsets.all(8)),
                        ]
                      ),
                    ),
                  )
                ],
              ),
            ),
            new Visibility(
              visible: !offlineMode,
              child: new SafeArea(
                child: new Container(
                  width: double.infinity,
                  child: uploading ? new Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(32.0),
                      child: new HeartbeatProgressIndicator(
                          child: new Image.asset(
                            'images/wblogo.png',
                            height: 15.0,
                          )
                      )
                  ) : new CupertinoButton(
                    child: new Text("Upload Match"),
                    color: mainColor,
                    borderRadius: BorderRadius.all(Radius.circular(16.0)),
                    onPressed: () async {
                      Clipboard.setData(ClipboardData(text: jsonEncode(currMatch).toString()));
                      setState(() {
                        uploading = true;
                      });
                      try {
                        await http.post("$dbHost/scouting/matches", headers: {"Authentication": "Bearer $apiKey"}, body: jsonEncode(currMatch)).then((response) {
                          print(response.body);
                          if (response.statusCode == 200) {
                            showSuccess();
                          }
                          else {
                            showError(response.body.toString());
                            setState(() {
                              failedUpload = true;
                            });
                          }
                        });
                      } catch (e) {
                        showError(e.toString());
                        setState(() {
                          failedUpload = true;
                        });
                      }
                      setState(() {
                        uploading = false;
                      });
                    },
                  ),
                ),
              ),
            ),
            new Visibility(
              visible: failedUpload,
              child: new SafeArea(
                child: new Container(
                  width: double.infinity,
                  child: new CupertinoButton(
                    child: new Text("Done"),
                    color: mainColor,
                    borderRadius: BorderRadius.all(Radius.circular(16.0)),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: jsonEncode(currMatch).toString()));
                      showCupertinoModalPopup(
                          context: context,
                          builder: (BuildContext context) {
                            return new CupertinoActionSheet(
                                title: new Text("Don't forget to save all 3 QR Codes!"),
                                cancelButton: new CupertinoActionSheetAction(
                                  child: new Text("Got it"),
                                  onPressed: () {
                                    router.pop(context);
                                    router.pop(context);
                                    router.pop(context);
                                  },
                                )
                            );
                          }
                      );
                    },
                  ),
                ),
              ),
            ),
            new Visibility(
              visible: offlineMode,
              child: new SafeArea(
                child: new Container(
                  width: double.infinity,
                  child: new CupertinoButton(
                    child: new Text("Done"),
                    color: mainColor,
                    borderRadius: BorderRadius.all(Radius.circular(16.0)),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: jsonEncode(currMatch).toString()));
                      showCupertinoModalPopup(
                        context: context,
                        builder: (BuildContext context) {
                          return new CupertinoActionSheet(
                            title: new Text("Don't forget to save all 3 QR Codes!"),
                            cancelButton: new CupertinoActionSheetAction(
                              child: new Text("Got it"),
                              onPressed: () {
                                router.pop(context);
                                router.pop(context);
                                router.pop(context);
                              },
                            )
                          );
                        }
                      );
                    },
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
