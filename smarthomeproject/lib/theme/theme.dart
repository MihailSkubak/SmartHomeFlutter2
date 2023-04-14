import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:shared_preferences/shared_preferences.dart';

class StorageManager {
  static void saveData(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is int) {
      prefs.setInt(key, value);
    } else if (value is String) {
      prefs.setString(key, value);
    } else if (value is bool) {
      prefs.setBool(key, value);
    } else {
      if (kDebugMode) {
        print("Invalid Type");
      }
    }
  }

  static Future<dynamic> readData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    dynamic obj = prefs.get(key);
    return obj;
  }

  static Future<bool> deleteData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.remove(key);
  }
}

class ThemeNotifier with ChangeNotifier {
  final darkTheme = ThemeData(
      appBarTheme: const AppBarTheme(backgroundColor: Colors.blue),
      primarySwatch: Colors.blue,
      primaryColor: Colors.black,
      brightness: Brightness.dark,
      // ignore: deprecated_member_use
      backgroundColor: const Color(0xFF212121),
      // ignore: deprecated_member_use
      accentColor: Colors.white,
      //accentIconTheme: const IconThemeData(color: Colors.black),
      dividerColor: Colors.black12,
      iconTheme: const IconThemeData(color: Colors.blue));

  final lightTheme = ThemeData(
      appBarTheme: const AppBarTheme(backgroundColor: Colors.blue),
      primarySwatch: Colors.blue,
      primaryColor: Colors.white,
      brightness: Brightness.light,
      // ignore: deprecated_member_use
      backgroundColor: const Color(0xFFE5E5E5),
      // ignore: deprecated_member_use
      accentColor: Colors.black,
      //accentIconTheme: const IconThemeData(color: Colors.blue),
      dividerColor: Colors.white54,
      iconTheme: const IconThemeData(color: Colors.blue));

  ThemeData _themeData = ThemeData(
      appBarTheme: const AppBarTheme(backgroundColor: Colors.blue),
      primarySwatch: Colors.blue,
      primaryColor: Colors.white,
      brightness: Brightness.light,
      // ignore: deprecated_member_use
      backgroundColor: const Color(0xFFE5E5E5),
      // ignore: deprecated_member_use
      accentColor: Colors.black,
      //accentIconTheme: const IconThemeData(color: Colors.white),
      dividerColor: Colors.white54,
      iconTheme: const IconThemeData(color: Colors.blue));
  ThemeData getTheme() => _themeData;

  ThemeNotifier() {
    StorageManager.readData('themeMode').then((value) {
      if (kDebugMode) {
        print('value read from storage: $value');
      }
      var themeMode = value ?? 'light';
      if (themeMode == 'light') {
        _themeData = lightTheme;
      } else {
        if (kDebugMode) {
          print('setting dark theme');
        }
        _themeData = darkTheme;
      }
      notifyListeners();
    });
  }

  void setDarkMode() async {
    _themeData = darkTheme;
    StorageManager.saveData('themeMode', 'dark');
    notifyListeners();
  }

  void setLightMode() async {
    _themeData = lightTheme;
    StorageManager.saveData('themeMode', 'light');
    notifyListeners();
  }

  bool switchValueTheme() {
    if (_themeData == darkTheme) {
      return true;
    } else {
      return false;
    }
  }
}
