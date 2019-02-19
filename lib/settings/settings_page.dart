import 'package:flutter/material.dart';
import 'package:mywb_flutter/user_info.dart';
import 'package:mywb_flutter/theme.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mywb_flutter/user_drawer.dart';
import 'package:fluro/fluro.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  bool _notifs = true;

  @override
  Widget build(BuildContext context) {
    return new SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          new Card(
            color: Colors.white,
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
                  color: Colors.white,
                  child: new Column(
                    children: <Widget>[
                      new ListTile(
                        title: new Text("Email"),
                        trailing: new Text(email, style: TextStyle(fontSize: 16.0)),
                      ),
                      new ListTile(
                        title: new Text("Phone"),
                        trailing: new Text(phone, style: TextStyle(fontSize: 16.0)),
                      ),
                      new ListTile(
                        title: new Text("Birthday"),
                        trailing: new Text(birthday, style: TextStyle(fontSize: 14.0)),
                      ),
                      new ListTile(
                        title: new Text("Role"),
                        trailing: new Text(role, style: TextStyle(fontSize: 16.0)),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Container(
                  padding: EdgeInsets.all(16.0),
                  child: new Text("General", style: TextStyle(color: currAccentColor, fontFamily: "Product Sans", fontWeight: FontWeight.bold),),
                ),
                new ListTile(
                  title: new Text("About", style: TextStyle(fontFamily: "Product Sans",)),
                  trailing: new Icon(Icons.arrow_forward_ios, color: currAccentColor),
                  onTap: () {
                    router.navigateTo(context, '/aboutPage', transition: TransitionType.native);
                  },
                ),
                new Divider(height: 0.0, color: currAccentColor),
                new ListTile(
                  title: new Text("Help", style: TextStyle(fontFamily: "Product Sans",)),
                  trailing: new Icon(Icons.arrow_forward_ios, color: currAccentColor),
                  onTap: () {
                    router.navigateTo(context, '/helpPage', transition: TransitionType.native);
                  },
                ),
                new Divider(height: 0.0, color: currAccentColor),
                new ListTile(
                    title: new Text("Legal", style: TextStyle(fontFamily: "Product Sans",)),
                    trailing: new Icon(Icons.arrow_forward_ios, color: currAccentColor),
                    onTap: () {
                      showLicensePage(
                          context: context,
                          applicationVersion: appFull + appStatus,
                          applicationName: "myWB App",
                          applicationLegalese: appLegal,
                          applicationIcon: new Image.asset(
                            'images/logo_blue_trans',
                            height: 35.0,
                          )
                      );
                    }
                ),
                new Divider(height: 0.0, color: currAccentColor),
                new ListTile(
                  title: new Text("Sign Out", style: TextStyle(color: Colors.red, fontFamily: "Product Sans"),),
                ),
              ],
            ),
          ),
          new Padding(padding: EdgeInsets.all(8.0)),
          new Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Container(
                  padding: EdgeInsets.all(16.0),
                  child: new Text("Preferences", style: TextStyle(color: currAccentColor, fontWeight: FontWeight.bold, fontFamily: "Product Sans"),),
                ),
                new SwitchListTile.adaptive(
                  title: new Text("Push Notifications", style: TextStyle(fontFamily: "Product Sans",)),
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
                  title: new Text("Dark Mode", style: TextStyle(fontFamily: "Product Sans",)),
                  value: darkMode,
                  activeColor: currAccentColor,
                  onChanged: (bool value) {
                    setState(() {
                      darkMode = value;
                      if (darkMode) {
                        currTextColor = darkTextColor;
                        currAccentColor = darkAccentColor;
                        currBackgroundColor = darkBackgroundColor;
                        currCardColor = darkCardColor;
                        currDividerColor = darkDividerColor;
                      }
                      else {
                        currTextColor = lightTextColor;
                        currAccentColor = lightAccentColor;
                        currBackgroundColor = lightBackgroundColor;
                        currCardColor = lightCardColor;
                        currDividerColor = lightDividerColor;
                      }
                    });
                  },
                ),
              ],
            ),
          ),
          new Padding(padding: EdgeInsets.all(8.0)),
          new Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Container(
                  padding: EdgeInsets.all(16.0),
                  child: new Text("Feedback", style: TextStyle(color: currAccentColor, fontWeight: FontWeight.bold, fontFamily: "Product Sans"),),
                ),
                new ListTile(
                  title: new Text("Report a Bug", style: TextStyle(fontFamily: "Product Sans",)),
                  trailing: new Icon(Icons.arrow_forward_ios, color: currAccentColor),
                  onTap: () {
                    launch("https://github.com/Team3256/myWB-flutter/issues");
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
