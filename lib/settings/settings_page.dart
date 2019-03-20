import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mywb_flutter/user_info.dart';
import 'package:mywb_flutter/theme.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mywb_flutter/user_drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluro/fluro.dart';
import 'package:firebase_database/firebase_database.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  bool _notifs = true;

  final databaseRef = FirebaseDatabase.instance.reference();

  void signOutBottomSheetMenu() {
    showModalBottomSheet(
        context: context,
        builder: (builder){
          return Container(
            color: currBackgroundColor,
            child: SafeArea(
              child: new Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  new ListTile(
                    title: new Text('Are you sure you want to sign out?', style: TextStyle(color: currTextColor),),
                  ),
                  new ListTile(
                    leading: new Icon(Icons.check, color: currDividerColor,),
                    title: new Text('Yes, sign me out!', style: TextStyle(color: currTextColor),),
                    onTap: () {
                      authToken = "";
                      dbHost = "https://mywb.vcs.net/";

                      firstName = "[ERROR]";
                      middleName = "";
                      lastName = "[ERROR]";
                      email = "[ERROR]";
                      birthday = "[ERROR]";
                      phone = "[ERROR]";
                      gender = "[ERROR]";

                      role = "[ERROR]";
                      userID = "";

                      FirebaseAuth.instance.signOut();
                      router.navigateTo(context, '/login', transition: TransitionType.fadeIn, clearStack: true);
                    },
                  ),
                  new ListTile(
                    leading: new Icon(Icons.clear, color: currDividerColor,),
                    title: new Text('Cancel', style: TextStyle(color: currTextColor),),
                    onTap: () {
                      router.pop(context);
                    },
                  ),
                ],
              ),
            ),
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    // Main Build Function for iOS/Android
    if (true) {
      return Container(
        color: currCardColor,
        padding: const EdgeInsets.only(right: 16.0, left: 16.0, top: 16.0),
        child: SingleChildScrollView(
          child: new Column(
            children: <Widget>[
              new Card(
                color: currBackgroundColor,
                child: Column(
                  children: <Widget>[
                    new Container(
                      width: 1000.0,
                      padding: EdgeInsets.all(16.0),
                      child: new Text(
                        firstName + " " + lastName,
                        style: TextStyle(
                            fontSize: 25.0,
                            color: currAccentColor,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    new Container(
                      child: new Column(
                        children: <Widget>[
                          new ListTile(
                            title: new Text("Email", style: TextStyle(fontSize: 16.0, color: currTextColor)),
                            trailing: new Text(email, style: TextStyle(fontSize: 16.0, color: currTextColor)),
                          ),
                          new ListTile(
                            title: new Text("Phone", style: TextStyle(fontSize: 16.0, color: currTextColor)),
                            trailing: new Text(phone, style: TextStyle(fontSize: 16.0, color: currTextColor)),
                          ),
                          new ListTile(
                            title: new Text("Birthday", style: TextStyle(fontSize: 16.0, color: currTextColor)),
                            trailing: new Text(birthday, style: TextStyle(fontSize: 16.0, color: currTextColor)),
                          ),
                          new ListTile(
                            title: new Text("Role", style: TextStyle(fontSize: 16.0, color: currTextColor)),
                            trailing: new Text(role, style: TextStyle(fontSize: 16.0, color: currTextColor)),
                          ),
                          new ListTile(
                            title: new Text("Update Profile", style: TextStyle(color: currAccentColor), textAlign: TextAlign.center,),
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
              new Padding(padding: EdgeInsets.all(8.0)),
              new Card(
                color: currBackgroundColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Container(
                      padding: EdgeInsets.all(16.0),
                      child: new Text("General", style: TextStyle(color: currAccentColor, fontFamily: "Product Sans", fontWeight: FontWeight.bold),),
                    ),
                    new ListTile(
                      title: new Text("About", style: TextStyle(fontFamily: "Product Sans", color: currTextColor)),
                      trailing: new Icon(Icons.arrow_forward_ios, color: currAccentColor),
                      onTap: () {
                        router.navigateTo(context, '/aboutPage', transition: TransitionType.native);
                      },
                    ),
                    new Divider(height: 0.0, color: currAccentColor),
                    new ListTile(
                      title: new Text("Help", style: TextStyle(fontFamily: "Product Sans", color: currTextColor)),
                      trailing: new Icon(Icons.arrow_forward_ios, color: currAccentColor),
                      onTap: () {
                        router.navigateTo(context, '/helpPage', transition: TransitionType.native);
                      },
                    ),
                    new Divider(height: 0.0, color: currAccentColor),
                    new ListTile(
                      title: new Text("Sign Out", style: TextStyle(color: Colors.red, fontFamily: "Product Sans",),),
                      onTap: () {
                        signOutBottomSheetMenu();
                      },
                    ),
                  ],
                ),
              ),
              new Padding(padding: EdgeInsets.all(8.0)),
              new Card(
                color: currBackgroundColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Container(
                      padding: EdgeInsets.all(16.0),
                      child: new Text("Preferences", style: TextStyle(color: currAccentColor, fontWeight: FontWeight.bold, fontFamily: "Product Sans"),),
                    ),
                    new SwitchListTile.adaptive(
                      title: new Text("Push Notifications", style: TextStyle(fontFamily: "Product Sans", color: currTextColor)),
                      value: _notifs,
                      activeColor: currAccentColor,
                      onChanged: (bool value) {
                        setState(() {
                          _notifs = value;
                        });
                      },
                    ),
                    new Divider(height: 0.0, color: currAccentColor),
                    new SwitchListTile.adaptive(
                      title: new Text("Dark Mode", style: TextStyle(fontFamily: "Product Sans", color: currTextColor)),
                      value: darkMode,
                      activeColor: currAccentColor,
                      onChanged: (bool value) {
                        print("Dark Mode - $value");
                        setState(() {
                          darkMode = value;
                          databaseRef.child("users").child(userID).child("darkMode").set(darkMode);
                          if (darkMode) {
                            currCardColor = darkCardColor;
                            currBackgroundColor = darkBackgroundColor;
                            currTextColor = darkTextColor;
                            currDividerColor = darkDividerColor;
//                          currAccentColor = darkAccentColor;
                          }
                          else {
                            currCardColor = lightCardColor;
                            currBackgroundColor = lightBackgroundColor;
                            currTextColor = lightTextColor;
                            currDividerColor = lightDividerColor;
//                          currAccentColor = lightAccentColor;
                          }
                        });
                      },
                    ),
                  ],
                ),
              ),
              new Padding(padding: EdgeInsets.all(8.0)),
              new Card(
                color: currBackgroundColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Container(
                      padding: EdgeInsets.all(16.0),
                      child: new Text("Feedback", style: TextStyle(color: currAccentColor, fontWeight: FontWeight.bold, fontFamily: "Product Sans",),),
                    ),
                    new ListTile(
                      title: new Text("Report a Bug", style: TextStyle(fontFamily: "Product Sans", color: currTextColor)),
                      trailing: new Icon(Icons.arrow_forward_ios, color: currAccentColor),
                      onTap: () {
                        launch("https://github.com/Team3256/myWB-flutter/issues");
                      },
                    ),
                  ],
                ),
              ),
              new Padding(padding: EdgeInsets.all(8.0)),
            ],
          ),
        ),
      );
    }
  }
}
