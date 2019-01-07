import 'package:flutter/material.dart';
import 'package:mywb_flutter/home/home_page.dart';
import 'package:mywb_flutter/inventory/inventory_page.dart';
import 'package:mywb_flutter/outreach/outreach_page.dart';
import 'package:mywb_flutter/scouting/scout_page.dart';
import 'package:mywb_flutter/settings/settings_page.dart';
import 'package:mywb_flutter/startup/auth_checker.dart';
import 'package:mywb_flutter/startup/onboarding_page.dart';
import 'package:mywb_flutter/startup/login_page.dart';
import 'package:fluro/fluro.dart';
import 'package:mywb_flutter/theme.dart';
import 'user_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {

  router.define('/login', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new LoginPage();
  }));

  router.define('/logged', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new HomePage();
  }));

  router.define('/scout', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new ScoutPage();
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