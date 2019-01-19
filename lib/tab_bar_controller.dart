import 'package:flutter/material.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:mywb_flutter/user_drawer.dart';
import 'user_info.dart';
import 'package:mywb_flutter/scouting/scout_page.dart';
import 'package:mywb_flutter/outreach/outreach_page.dart';
import 'package:mywb_flutter/inventory/inventory_page.dart';
import 'package:mywb_flutter/settings/settings_page.dart';
import 'theme.dart';

class TabBarController extends StatefulWidget {
  @override
  _TabBarControllerState createState() => _TabBarControllerState();
}

class _TabBarControllerState extends State<TabBarController> {
  
  PageController _pageController = new PageController();

  int currentTab = 0;
  String title = "Scouting";

  void onTabTapped(int index) {
    setState(() {
      currentTab = index;
      if (currentTab == 0) {
        title = "Scouting";
      }
      else if (currentTab == 1) {
        title = "Outreach";
      }
      else if (currentTab == 2) {
        title = "Inventory";
      }
      else if (currentTab == 3) {
        title = "Settings";
      }
    });
    _pageController.animateToPage(index, duration: const Duration(milliseconds: 200), curve: Curves.easeOut);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: mainColor,
        title: new Text(title, style: TextStyle(fontWeight: FontWeight.bold),),
      ),
      drawer: new UserDrawer(),
      body: new PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          ScoutPage(),
          OutreachPage(),
          InventoryPage(),
          SettingsPage()
        ],
      ),
      bottomNavigationBar: new Stack(
        alignment: FractionalOffset.bottomCenter,
        children: <Widget>[
          new SafeArea(
            child: new FancyBottomNavigation(
              textColor: mainColor,
              onTabChangedListener: onTabTapped,
              tabs: [
                TabData(iconData: Icons.track_changes, title: "Scouting"),
                TabData(iconData: Icons.people, title: "Outreach"),
                TabData(iconData: Icons.storage, title: "Inventory"),
                TabData(iconData: Icons.settings, title: "Settings"),
              ],
            ),
          ),
          new Container(
            height: MediaQuery.of(context).padding.bottom,
            color: Colors.white,
          )
        ],
      ),
    );
  }
}
