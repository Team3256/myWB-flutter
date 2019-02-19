import 'package:flutter/material.dart';
import 'user_info.dart';
import 'package:fluro/fluro.dart';
import 'theme.dart';

class UserDrawer extends StatefulWidget {
  @override
  _UserDrawerState createState() => _UserDrawerState();
}

class _UserDrawerState extends State<UserDrawer> {

  void signOutBottomSheetMenu() {
    showModalBottomSheet(
        context: context,
        builder: (builder){
          return SafeArea(
            child: new Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new ListTile(
                  title: new Text('Are you sure you want to sign out?'),
                ),
                new ListTile(
                  leading: new Icon(Icons.check),
                  title: new Text('Yes, sign me out!'),
                  onTap: () {
                    router.navigateTo(context, '/login', transition: TransitionType.fadeIn, clearStack: true);
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
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      width: MediaQuery.of(context).size.width - 50,
      child: new Scaffold(
        bottomNavigationBar: new SafeArea(
          child: Container(
              color: null,
              height: 135.0,
              padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 16.0),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  new Image.asset(
                    'images/wblogo.png',
                    height: 35.0,
                  ),
                  new Padding(padding: EdgeInsets.all(8.0)),
                  new ListTile(
                    title: new RaisedButton(
                      child: new Text("Sign Out", style: TextStyle(fontFamily: "Product Sans", fontSize: 17.0)),
                      color: Colors.red,
                      textColor: Colors.white,
                      onPressed: signOutBottomSheetMenu,
                    ),
                  ),
                ],
              )
          ),
        ),
        backgroundColor: currBackgroundColor,
        body: new SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              new Container(
                  padding: EdgeInsets.all(16.0),
                  color: currAccentColor,
                  height: 200.0,
                  width: 1000.0,
                  child: new Stack(
                    children: <Widget>[
                      new Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          new Padding(padding: EdgeInsets.all(50.0)),
                          new Row(
                            children: <Widget>[
                              new ClipOval(
                                child: new Image.asset(
                                  'images/default-profile.png',
                                  width: 50.0,
                                  height: 50.0,
                                  fit: BoxFit.fill,
                                ),
                              ),
                              new Padding(padding: EdgeInsets.all(8.0)),
                              new Text(
                                firstName + " " + lastName,
                                style: TextStyle(
                                    fontSize: 25.0,
                                    color: Colors.white,
                                    fontFamily: "Product Sans",
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            ],
                          )
                        ],
                      )
                    ],
                  )
              ),
              new Container(
                padding: EdgeInsets.all(8.0),
                child: new Column(
                  children: <Widget>[
                    new ListTile(
                      title: new Text(email, style: TextStyle(fontSize: 16.0, color: currTextColor)),
                      leading: Icon(Icons.email, color: currDividerColor,),
                    ),
                    new ListTile(
                      title: new Text(role, style: TextStyle(fontSize: 16.0, color: currTextColor)),
                      leading: Icon(Icons.verified_user, color: currDividerColor,),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
