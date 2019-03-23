import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:mywb_flutter/screens/auth/auth_checker.dart';
import 'package:mywb_flutter/screens/auth/login_page.dart';
import 'package:mywb_flutter/screens/auth/register_page.dart';
import 'package:mywb_flutter/screens/scouting/breakdown_page.dart';
import 'package:mywb_flutter/screens/scouting/filter_teams_page.dart';
import 'package:mywb_flutter/screens/scouting/pit_scouting_page.dart';
import 'package:mywb_flutter/screens/scouting/scouting_controller.dart';
import 'package:mywb_flutter/screens/scouting/scouting_page.dart';
import 'package:mywb_flutter/screens/scouting/scouting_schedule_page.dart';
import 'package:mywb_flutter/screens/scouting/teams_list_page.dart';
import 'package:mywb_flutter/screens/settings/about_page.dart';
import 'package:mywb_flutter/screens/settings/help_page.dart';
import 'package:mywb_flutter/screens/startup/connection_checker.dart';
import 'package:mywb_flutter/screens/startup/connection_checker_again.dart';
import 'package:mywb_flutter/screens/startup/onboarding_page.dart';
import 'package:mywb_flutter/tab_bar_controller.dart';
import 'package:mywb_flutter/theme/theme.dart';
import 'package:mywb_flutter/user_info.dart';

void main() {

  // Startup Routes
  router.define('/check-connection', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new NetworkChecker();
  }));
  router.define('/check-connection-again', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new NetworkCheckerAgain();
  }));
  router.define('/check-auth', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new AuthCheckerPage();
  }));

  // Auth Routes
  router.define('/onboarding', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new OnboardingPage();
  }));
  router.define('/register', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new RegisterPage();
  }));
  router.define('/login', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new LoginPage();
  }));

  // Home Routes
  router.define('/home', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new TabBarController();
  }));

  // Scouting Routes
  router.define('/scout', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new ScoutingPage();
  }));
  router.define('/scout-controller', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new ScoutingController();
  }));
  router.define('/breakdown', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new BreakdownPage();
  }));
  router.define('/pit-scouting', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new PitScoutingPage();
  }));
  router.define('/filter-regional', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new FilterRegionalPage();
  }));
  router.define('/regional-teams', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new TeamsPage();
  }));
  router.define('/scouting-schedule', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new ScoutingSchedulePage();
  }));

  // Settings Routes
  router.define('/about', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new AboutPage();
  }));
  router.define('/help', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new HelpPage();
  }));

  runApp(new MaterialApp(
    title: "myWB",
    home: new NetworkChecker(),
    onGenerateRoute: router.generator,
    debugShowCheckedModeBanner: false,
    theme: mainTheme,
  ));
}