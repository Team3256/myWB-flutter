import 'package:flutter/material.dart';
import 'package:mywb_flutter/startup/onboarding_page.dart';
import 'package:mywb_flutter/startup/login_page.dart';
import 'package:fluro/fluro.dart';
import 'user_info.dart';

void main() {

  router.define('/login', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new LoginPage();
  }));

  runApp(
    new MaterialApp(
      title: "myWB",
      home: LoginPage(),
      onGenerateRoute: router.generator,
      debugShowCheckedModeBanner: false,
    )
  );
}