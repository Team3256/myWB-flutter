import 'package:flutter/material.dart';
import 'package:mywb_flutter/user_info.dart';
import 'package:mywb_flutter/theme.dart';
import 'package:mywb_flutter/user_drawer.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Home"),
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
                          color: Colors.blue,
                          fontFamily: "Product Sans",
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  new Container(
                    color: Colors.white,
                    child: new Column(
                      children: <Widget>[
                        new ListTile(
                          title: new Text("Email", style: TextStyle(fontFamily: "Product Sans"),),
                          trailing: new Text(email, style: TextStyle(fontSize: 16.0, fontFamily: "Product Sans")),
                        ),
                        new ListTile(
                          title: new Text("Phone", style: TextStyle(fontFamily: "Product Sans",)),
                          trailing: new Text(phone, style: TextStyle(fontSize: 16.0, fontFamily: "Product Sans")),
                        ),
                        new ListTile(
                          title: new Text("Birthday", style: TextStyle(fontFamily: "Product Sans",)),
                          trailing: new Text(birthday, style: TextStyle(fontSize: 14.0, fontFamily: "Product Sans")),
                        ),
                        new ListTile(
                          title: new Text("Role", style: TextStyle(fontFamily: "Product Sans",)),
                          trailing: new Text(role, style: TextStyle(fontSize: 16.0, fontFamily: "Product Sans")),
                        ),
                        new ListTile(
                          title: new Text("Update Profile", style: TextStyle(fontFamily: "Product Sans", color: Colors.blue), textAlign: TextAlign.center,),
                          onTap: () {
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
                    child: new Text("General", style: TextStyle(color: Colors.blue, fontFamily: "Product Sans", fontWeight: FontWeight.bold),),
                  ),
                  new ListTile(
                    title: new Text("About", style: TextStyle(fontFamily: "Product Sans",)),
                    trailing: new Icon(Icons.arrow_forward_ios, color: Colors.blue),
                    onTap: () {
                    },
                  ),
                  new Divider(height: 0.0, color: Colors.blue),
                  new ListTile(
                    title: new Text("Help", style: TextStyle(fontFamily: "Product Sans",)),
                    trailing: new Icon(Icons.arrow_forward_ios, color: Colors.blue),
                    onTap: () {
                    },
                  ),
                  new Divider(height: 0.0, color: Colors.blue),
                  new ListTile(
                      title: new Text("Legal", style: TextStyle(fontFamily: "Product Sans",)),
                      trailing: new Icon(Icons.arrow_forward_ios, color: Colors.blue),
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
                  new Divider(height: 0.0, color: Colors.blue),
                  new ListTile(
                    title: new Text("Sign Out", style: TextStyle(color: Colors.red, fontFamily: "Product Sans"),),
                  ),
                  new Divider(height: 0.0, color: Colors.blue),
                  new ListTile(
                    title: new Text("\nDelete Account\n", style: TextStyle(color: Colors.red, fontFamily: "Product Sans"),),
                    subtitle: new Text("Deleting your VC DECA Account will remove all the data linked to your account as well. You will be required to create a new account in order to sign in again.\n", style: TextStyle(fontSize: 12.0, fontFamily: "Product Sans")),
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
                    child: new Text("Preferences", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontFamily: "Product Sans"),),
                  ),
                  new SwitchListTile(
                    title: new Text("Push Notifications", style: TextStyle(fontFamily: "Product Sans",)),
                    value: true,
                    onChanged: (bool value) {
                    },
                  ),
                  new Divider(height: 0.0, color: Colors.blue),
                  new SwitchListTile(
                    title: new Text("Chat Notifications", style: TextStyle(fontFamily: "Product Sans",)),
                    value: true,
                    onChanged: (bool value) {
                    },
                  ),
//                new Divider(height: 0.0, color: Colors.blue),
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
                    child: new Text("Feedback", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontFamily: "Product Sans"),),
                  ),
                  new ListTile(
                    title: new Text("Provide Feedback", style: TextStyle(fontFamily: "Product Sans",)),
                    trailing: new Icon(Icons.arrow_forward_ios, color: Colors.blue),
                    onTap: () {
                    },
                  ),
                  new Divider(height: 0.0, color: Colors.blue),
                  new ListTile(
                    title: new Text("Report a Bug", style: TextStyle(fontFamily: "Product Sans",)),
                    trailing: new Icon(Icons.arrow_forward_ios, color: Colors.blue),
                    onTap: () {
                    },
                  ),
                  new Divider(height: 0.0, color: Colors.blue),
                ],
              ),
            ),
          ],
        ),
      )
    );
  }
}
