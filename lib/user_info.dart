import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:fluro/fluro.dart';

final router = Router();

double appVersion = 2.0;
int appBuild = 1;
String appStatus = "";
String appFull = "Version $appVersion";

String authToken = "";
String dbHost = "https://mywb.vcs.net/";

String firstName = "[ERROR]";
String middleName = "";
String lastName = "[ERROR]";
String email = "[ERROR]";
String birthday = "[ERROR]";
String phone = "[ERROR]";
String gender = "[ERROR]";

String role = "[ERROR]";
String userID = "";

bool darkMode = false;

String appLegal = """
MIT License
Copyright (c) 2018 FRC WarriorBorgs 3256
Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
""";