import 'package:flutter/material.dart';
import 'package:mywb_flutter/user_info.dart';
import 'package:mywb_flutter/theme.dart';
import 'package:mywb_flutter/user_drawer.dart';
import 'package:fluro/fluro.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Settings"),
        backgroundColor: mainColor,
      ),
      drawer: new UserDrawer(),
      body: new SingleChildScrollView(
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
                          color: mainColor,
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
            new Padding(padding: EdgeInsets.all(8.0)),
            new Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Container(
                    padding: EdgeInsets.all(16.0),
                    child: new Text("General", style: TextStyle(color: mainColor, fontFamily: "Product Sans", fontWeight: FontWeight.bold),),
                  ),
                  new ListTile(
                    title: new Text("About", style: TextStyle(fontFamily: "Product Sans",)),
                    trailing: new Icon(Icons.arrow_forward_ios, color: mainColor),
                    onTap: () {
                    },
                  ),
                  new Divider(height: 0.0, color: mainColor),
                  new ListTile(
                    title: new Text("Help", style: TextStyle(fontFamily: "Product Sans",)),
                    trailing: new Icon(Icons.arrow_forward_ios, color: mainColor),
                    onTap: () {
                    },
                  ),
                  new Divider(height: 0.0, color: mainColor),
                  new ListTile(
                      title: new Text("Legal", style: TextStyle(fontFamily: "Product Sans",)),
                      trailing: new Icon(Icons.arrow_forward_ios, color: mainColor),
                      onTap: () {
//                      showLicensePage(
//                          context: context,
//                          applicationVersion: appFull + appStatus,
//                          applicationName: "VC DECA App",
//                          applicationLegalese: appLegal,
//                          applicationIcon: new Image.asset(
//                            'images/logo_blue_trans',
//                            height: 35.0,
//                          )
//                      );
                      }
                  ),
                  new Divider(height: 0.0, color: mainColor),
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
                    child: new Text("Preferences", style: TextStyle(color: mainColor, fontWeight: FontWeight.bold, fontFamily: "Product Sans"),),
                  ),
                  new SwitchListTile(
                    title: new Text("Push Notifications", style: TextStyle(fontFamily: "Product Sans",)),
                    value: true,
                    onChanged: (bool value) {
                    },
                  ),
                  new Divider(height: 0.0, color: mainColor),
                  new SwitchListTile(
                    title: new Text("Chat Notifications", style: TextStyle(fontFamily: "Product Sans",)),
                    value: true,
                    onChanged: (bool value) {
                    },
                  ),
//                new Divider(height: 0.0, color: mainColor),
//                new SwitchListTile(
//                  title: new Text("Dark Mode", style: TextStyle(fontFamily: "Product Sans",)),
//                  value: darkMode,
//                  onChanged: (bool value) {
//                    setState(() {
//                      darkMode = value;
//                      databaseRef.child("users").child(userID).update({"darkMode": darkMode});
//                    });
//                  },
//                ),
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
                    child: new Text("Feedback", style: TextStyle(color: mainColor, fontWeight: FontWeight.bold, fontFamily: "Product Sans"),),
                  ),
                  new ListTile(
                    title: new Text("Provide Feedback", style: TextStyle(fontFamily: "Product Sans",)),
                    trailing: new Icon(Icons.arrow_forward_ios, color: mainColor),
                    onTap: () {
                    },
                  ),
                  new Divider(height: 0.0, color: mainColor),
                  new ListTile(
                    title: new Text("Report a Bug", style: TextStyle(fontFamily: "Product Sans",)),
                    trailing: new Icon(Icons.arrow_forward_ios, color: mainColor),
                    onTap: () {
                    },
                  ),
                  new Divider(height: 0.0, color: mainColor),
                ],
              ),
            ),
          ],
        ),
      )
    );
  }
}
