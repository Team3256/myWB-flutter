import 'package:flutter/material.dart';
import 'package:mywb_flutter/home/home_page.dart';
import 'package:mywb_flutter/inventory/inventory_page.dart';
import 'package:mywb_flutter/outreach/outreach_page.dart';
import 'package:mywb_flutter/scouting/breakdown_page.dart';
import 'package:mywb_flutter/scouting/filter_regional_page.dart';
import 'package:mywb_flutter/scouting/scout_page.dart';
import 'package:mywb_flutter/scouting/start_scout_page.dart';
import 'package:mywb_flutter/scouting/teams_page.dart';
import 'package:mywb_flutter/settings/about_page.dart';
import 'package:mywb_flutter/settings/help_page.dart';
import 'package:mywb_flutter/settings/settings_page.dart';
import 'package:mywb_flutter/settings/update_profile.dart';
import 'package:mywb_flutter/startup/auth_checker.dart';
import 'package:mywb_flutter/startup/onboarding_page.dart';
import 'package:mywb_flutter/startup/login_page.dart';
import 'package:fluro/fluro.dart';
import 'package:mywb_flutter/tab_bar_controller.dart';
import 'package:mywb_flutter/theme.dart';
import 'user_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {

  router.define('/login', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new LoginPage();
  }));

  router.define('/logged', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new TabBarController();
  }));

  router.define('/scout', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new ScoutPage();
  }));

  router.define('/scoutOne', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new ScoutPageOne();
  }));

  router.define('/breakdown', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new BreakdownPage();
  }));

  router.define('/outreach', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new OutreachPage();
  }));

  router.define('/inventory', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new InventoryPage();
  }));

  router.define('/settings', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new SettingsPage();
  }));

  router.define('/updateProfile', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new UpdateProfilePage();
  }));

  router.define('/aboutPage', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new AboutPage();
  }));

  router.define('/helpPage', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new HelpPage();
  }));

  router.define('/filterRegional', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new FilterRegionalPage();
  }));

  router.define('/regionalTeams', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new TeamsPage();
  }));

  runApp(
    new MaterialApp(
      title: "myWB",
      home: AuthCheckerPage(),
      onGenerateRoute: router.generator,
      debugShowCheckedModeBanner: false,
      theme: mainTheme
    )
  );
}