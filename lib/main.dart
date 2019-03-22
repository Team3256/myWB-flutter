import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:mywb_flutter/screens/auth/auth_checker.dart';
import 'package:mywb_flutter/screens/auth/login_page.dart';
import 'package:mywb_flutter/screens/auth/register_page.dart';
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

  runApp(new MaterialApp(
    title: "myWB",
    home: new NetworkChecker(),
    onGenerateRoute: router.generator,
    debugShowCheckedModeBanner: false,
    theme: mainTheme,
  ));
}