import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:mywb_flutter/theme/colors.dart';
import 'package:mywb_flutter/user_info.dart';

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
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
              new UserAccountsDrawerHeader(
                accountName: new Text(
                  firstName + " " + lastName,
                  style: TextStyle(
                      fontSize: 25.0,
                      color: Colors.white,
                      fontFamily: "Product Sans",
                      fontWeight: FontWeight.bold
                  ),
                ),
                accountEmail: new Text(
                  email,
                  style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.white,
                    fontFamily: "Product Sans",
                  ),
                ),
                currentAccountPicture: new Container(
                  padding: EdgeInsets.all(8.0),
                  child: new ClipOval(
                    child: new Image.asset(
                      'images/default-profile.png',
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
//                decoration: new BoxDecoration(
//                  image: new DecorationImage(
//                    fit: BoxFit.cover,
//                    image: new CachedNetworkImageProvider("http://vcrobotics.net/Page%20Media_PermanentOther/homerobotpicture2.jpg")
//                  )
//                ),
              ),
              new Container(
                padding: EdgeInsets.all(8.0),
                child: new Column(
                  children: <Widget>[
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
