// ignore_for_file: file_names

library assistant.globals;

import 'package:flutter/material.dart';

Locale savedLocale = const Locale('0', '');
String systemLocale = 'en';
List<String> langItems = ['English', 'Polski', 'Русский'];
String langItem = 'English';
List<String> rememberDevice = [];
bool onceDoneConnectingToDevice = true;
List<String> smartDeviceList = [];
List objectSmartDevice = [];
bool pushCommandForTermostat = false;
//bool readAnswer = true;
int valueChoiseIndexForTermostat = -1;
