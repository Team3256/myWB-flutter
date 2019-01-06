import 'package:flutter/material.dart';
import 'package:intro_views_flutter/Models/page_view_model.dart';
import 'package:intro_views_flutter/intro_views_flutter.dart';
import 'package:fluro/fluro.dart';
import 'package:mywb_flutter/user_info.dart';

class OnboardingPage extends StatefulWidget {
  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {

  final pages = [
    PageViewModel(
        pageColor: const Color(0xFF1B5084),
        iconImageAssetPath: '',
        body: Text("Task Management done right."),
        title: Text(""),
        textStyle: TextStyle(fontFamily: 'MyFont', color: Colors.white),
        mainImage: Image.asset(
          'images/slide1.png',
          height: 285.0,
          width: 285.0,
          alignment: Alignment.center,
        )),
    PageViewModel(
      pageColor: const Color(0xFF1B5084),
      iconImageAssetPath: '',
      body: Text("Outreach Check-in made easy."),
      title: Text(""),
      mainImage: Image.asset(
        'images/slide2.png',
        height: 285.0,
        width: 285.0,
        alignment: Alignment.center,
      ),
      textStyle: TextStyle(fontFamily: 'MyFont', color: Colors.white),
    ),
    PageViewModel(
      pageColor: const Color(0xFF1B5084),
      iconImageAssetPath: '',
      body: Text("Scouting done cool(er)."),
      title: Text(""),
      mainImage: Image.asset(
        'images/slide3.png',
        height: 285.0,
        width: 285.0,
        alignment: Alignment.center,
      ),
      textStyle: TextStyle(fontFamily: 'MyFont', color: Colors.white),
    ),
    PageViewModel(
      pageColor: const Color(0xFF1B5084),
      iconImageAssetPath: '',
      body: Text("Welcome to the (new) myWB app."),
      title: Text(""),
      mainImage: Image.asset(
        'images/slide4.png',
        height: 285.0,
        width: 285.0,
        alignment: Alignment.center,
      ),
      textStyle: TextStyle(fontFamily: 'MyFont', color: Colors.white),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return new Container(
      color: const Color(0xFF1B5084),
      child: SafeArea(
        child: new IntroViewsFlutter(
          pages,
          onTapDoneButton: () {
            router.navigateTo(context, '/login', transition: TransitionType.fadeIn, replace: true, clearStack: true);
          },
          showSkipButton: true,
        ),
      ),
    );
  }
}
