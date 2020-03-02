import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:mywb_flutter/models/attendance.dart';
import 'package:mywb_flutter/screens/auth/auth_checker.dart';
import 'package:mywb_flutter/screens/auth/login_page.dart';
import 'package:mywb_flutter/screens/auth/login_page_old.dart';
import 'package:mywb_flutter/screens/auth/register_page.dart';
import 'package:mywb_flutter/screens/auth/server_error_page.dart';
import 'package:mywb_flutter/screens/home/announcements_page.dart';
import 'package:mywb_flutter/screens/home/attendance_page.dart';
import 'package:mywb_flutter/screens/home/event_details_page.dart';
import 'package:mywb_flutter/screens/home/events_page.dart';
import 'package:mywb_flutter/screens/scouting/scouting_controller.dart';
import 'package:mywb_flutter/screens/settings/settings_about_page.dart';
import 'package:mywb_flutter/screens/settings/settings_help_page.dart';
import 'package:mywb_flutter/tab_bar_controller.dart';
import 'package:mywb_flutter/utils/config.dart';
import 'package:mywb_flutter/utils/theme.dart';

void main() {

  // AUTH ROUTES
  router.define('/check-auth', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new AuthCheckerPage();
  }));
  router.define('/login', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new LoginPage();
  }));
  router.define('/register', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new RegisterPage();
  }));
  router.define('/server-error', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new ServerErrorPage();
  }));

  // HOME ROUTES
  router.define('/home', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new TabBarController();
  }));
  router.define('/announcements', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new AnnouncementsPage();
  }));
  router.define('/events', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new EventsPage();
  }));
  router.define('/events/details', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new EventsDetailsPage();
  }));
  router.define('/attendance', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new AttendancePage();
  }));

  // SCOUTING ROUTES
  router.define('/scouting/controller', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new ScoutingController();
  }));

  // SETTINGS ROUTES
  router.define('/settings/about', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new SettingsAboutPage();
  }));
  router.define('/settings/help', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new SettingsHelpPage();
  }));

  runApp(new MaterialApp(
    title: "myWB",
    onGenerateRoute: router.generator,
    navigatorObservers: <NavigatorObserver>[routeObserver],
    debugShowCheckedModeBanner: false,
    theme: mainTheme,
    home: new AuthCheckerPage(),
  ));
}