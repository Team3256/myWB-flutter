import 'package:flutter/material.dart';

bool darkMode = true;

final mainColor = Color(0xFF014F8F);

final greyAccent = Color(0xFFDFE0E5);

// LIGHT THEME
const lightTextColor = Colors.black;
const lightAccentColor = Color(0xFF014F8F);
const lightBackgroundColor = Colors.white;
const lightCardColor = Color(0xFFDFE0E5);
const lightDividerColor = const Color(0xFFC9C9C9);

// DARK THEME
const darkTextColor = Colors.white;
const darkAccentColor = Colors.blue;
const darkBackgroundColor = const Color(0xFF212121);
const darkCardColor = const Color(0xFF2C2C2C);
const darkDividerColor = const Color(0xFF616161);

// CURRENT COLORs
var currTextColor = darkTextColor;
var currAccentColor = lightAccentColor;
var currBackgroundColor = darkBackgroundColor;
var currCardColor = darkCardColor;
var currDividerColor = darkDividerColor;

final mainTheme = new ThemeData(
  primaryColor: mainColor,
  accentColor: mainColor,
);