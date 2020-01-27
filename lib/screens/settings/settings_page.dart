import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mywb_flutter/user_info.dart';
import 'package:mywb_flutter/utils/config.dart';
import 'package:mywb_flutter/utils/theme.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  final databaseRef = FirebaseDatabase.instance.reference();

  void signOutBottomSheetMenu() {
    if (Platform.isIOS) {
      showCupertinoModalPopup(context: context, builder: (BuildContext context) {
        return new CupertinoActionSheet(
//          title: new Text("Sign out"),
            message: new Text("Are you sure you want to sign out?"),
            actions: <Widget>[
              new CupertinoActionSheetAction(
                child: new Text("Sign out"),
                isDestructiveAction: true,
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  router.navigateTo(context, '/check-auth', replace: true, transition: TransitionType.fadeIn);
                },
              )
            ],
            cancelButton: new CupertinoActionSheetAction(
              child: const Text("Cancel"),
              isDefaultAction: true,
              onPressed: () {
                Navigator.pop(context);
              },
            )
        );
      });
    }
    else if (Platform.isAndroid) {
      showModalBottomSheet(context: context, builder: (BuildContext context) {
        return new SafeArea(
          child: new Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              new ListTile(
                title: new Text('Are you sure you want to sign out?'),
              ),
              new ListTile(
                leading: new Icon(Icons.check),
                title: new Text('Yes, sign me out!'),
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
                  router.navigateTo(context, '/check-auth', replace: true, transition: TransitionType.fadeIn);
                },
              ),
              new ListTile(
                leading: new Icon(Icons.clear),
                title: new Text('Cancel'),
                onTap: () {
                  router.pop(context);
                },
              ),
            ],
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        new CupertinoSliverNavigationBar(
          backgroundColor: mainColor,
          largeTitle: new Text("Settings", style: TextStyle(color: Colors.white),),
          actionsForegroundColor: Colors.white,
        ),
        SliverList(
          delegate: SliverChildListDelegate([
            new Container(
              padding: EdgeInsets.only(top: 8.0, right: 8.0, left: 8.0),
              child: new Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
                color: currCardColor,
                elevation: 6.0,
                child: Column(
                  children: <Widget>[
                    new Container(
                      width: 1000.0,
                      padding: EdgeInsets.all(16.0),
                      child: new Text(
                        currUser.firstName + " " + currUser.lastName,
                        style: TextStyle(
                            fontSize: 25.0,
                            color: mainColor,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    new Container(
                      child: new Column(
                        children: <Widget>[
                          new ListTile(
                            title: new Text("Email", style: TextStyle(fontSize: 16.0, color: currTextColor)),
                            trailing: new Text(currUser.email, style: TextStyle(fontSize: 16.0, color: currTextColor)),
                          ),
                          new ListTile(
                            title: new Text("Phone", style: TextStyle(fontSize: 16.0, color: currTextColor)),
                            trailing: new Text(currUser.phone, style: TextStyle(fontSize: 16.0, color: currTextColor)),
                          ),
                          new ListTile(
                            title: new Text("Update Profile", style: TextStyle(color: mainColor), textAlign: TextAlign.center,),
                            onTap: () {
                              router.navigateTo(context, '/updateProfile', transition: TransitionType.nativeModal);
                            },
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 8.0, right: 8.0, left: 8.0),
              child: new Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
                color: currCardColor,
                elevation: 6.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Container(
                      padding: EdgeInsets.all(16.0),
                      child: new Text("General", style: TextStyle(color: mainColor, fontFamily: "Product Sans", fontWeight: FontWeight.bold),),
                    ),
                    new ListTile(
                      title: new Text("About", style: TextStyle(fontFamily: "Product Sans", color: currTextColor)),
                      trailing: new Icon(Icons.navigate_next, color: mainColor),
                      onTap: () {
                        router.navigateTo(context, '/settings/about', transition: TransitionType.native);
                      },
                    ),
                    new ListTile(
                      title: new Text("Help", style: TextStyle(fontFamily: "Product Sans", color: currTextColor)),
                      trailing: new Icon(Icons.navigate_next, color: mainColor),
                      onTap: () {
                        router.navigateTo(context, '/settings/help', transition: TransitionType.native);
                      },
                    ),
                    new ListTile(
                      title: new Text("Sign Out", style: TextStyle(color: Colors.red, fontFamily: "Product Sans",),),
                      onTap: () {
                        signOutBottomSheetMenu();
                      },
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 8.0, right: 8.0, left: 8.0),
              child: new Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
                color: currCardColor,
                elevation: 6.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Container(
                      padding: EdgeInsets.all(16.0),
                      child: new Text("Preferences", style: TextStyle(color: mainColor, fontWeight: FontWeight.bold, fontFamily: "Product Sans"),),
                    ),
                    new SwitchListTile.adaptive(
                      title: new Text("Push Notifications", style: TextStyle(fontFamily: "Product Sans", color: currTextColor)),
                      value: true,
                      activeColor: mainColor,
                      onChanged: (bool value) {
                        setState(() {
                          // TODO: idk do smth here
                        });
                      },
                    ),
                    new Visibility(
                      visible: (currUser.perms.contains("DEV")),
                      child: new SwitchListTile.adaptive(
                        title: new Text("Dark Mode", style: TextStyle(fontFamily: "Product Sans", color: currTextColor)),
                        value: darkMode,
                        activeColor: mainColor,
                        onChanged: (bool value) {
                          print("Dark Mode - $value");
                          setState(() {
                            darkMode = value;
                            databaseRef.child("users").child(currUser.id).child("darkMode").set(darkMode);
                            if (darkMode) {
                              currCardColor = darkCardColor;
                              currBackgroundColor = darkBackgroundColor;
                              currTextColor = darkTextColor;
                              currDividerColor = darkDividerColor;
//                          mainColor = darkAccentColor;
                            }
                            else {
                              currCardColor = lightCardColor;
                              currBackgroundColor = lightBackgroundColor;
                              currTextColor = lightTextColor;
                              currDividerColor = lightDividerColor;
//                          mainColor = lightAccentColor;
                            }
                          });
                        },
                      ),
                    ),
                    new Visibility(
                      visible: (currUser.perms.contains("DEV")),
                      child: new SwitchListTile.adaptive(
                        title: new Text("Offline Mode", style: TextStyle(fontFamily: "Product Sans", color: currTextColor)),
                        value: offlineMode,
                        activeColor: mainColor,
                        onChanged: (bool value) {
                          print("Offline Mode - $value");
                          setState(() {
                            offlineMode = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 8.0, right: 8.0, left: 8.0),
              child: new Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
                color: currCardColor,
                elevation: 6.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Container(
                      padding: EdgeInsets.all(16.0),
                      child: new Text("Feedback", style: TextStyle(color: mainColor, fontWeight: FontWeight.bold, fontFamily: "Product Sans",),),
                    ),
                    new ListTile(
                      title: new Text("Report a Bug", style: TextStyle(fontFamily: "Product Sans", color: currTextColor)),
                      trailing: new Icon(Icons.navigate_next, color: mainColor),
                      onTap: () {
                        launch("https://github.com/Team3256/myWB-flutter/issues");
                      },
                    ),
                  ],
                ),
              ),
            ),
            new Padding(padding: EdgeInsets.all(8.0)),
          ]),
        )
      ],
    );
  }
}
