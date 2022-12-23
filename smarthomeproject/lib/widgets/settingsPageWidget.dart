// ignore_for_file: file_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';
import '../theme/theme.dart';
import 'package:smarthomeproject/algorytm/globalValue.dart' as globals;
// ignore: depend_on_referenced_packages
import 'package:easy_localization/easy_localization.dart';
// ignore: depend_on_referenced_packages
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({
    super.key,
  });
  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  @override
  void initState() {
    super.initState();
    if (globals.systemLocale == 'en') {
      globals.langItem = 'English';
    } else if (globals.systemLocale == 'pl') {
      globals.langItem = 'Polski';
    } else if (globals.systemLocale == 'ru') {
      globals.langItem = 'Русский';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
        builder: (context, theme, _) => MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: theme.getTheme(),
            home: Scaffold(
                appBar: AppBar(
                    title: Text('settings.label'.tr()),
                    leading: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        size: 30,
                      ),
                    )),
                body: SingleChildScrollView(
                    child: Column(children: <Widget>[
                  ListTile(
                    title: Text('theme.label'.tr()),
                    leading: const Icon(
                      Icons.dark_mode,
                      size: 30,
                      color: Colors.blue,
                    ),
                    trailing: CupertinoSwitch(
                      value: theme.switchValueTheme(),
                      onChanged: (value) {
                        setState(() {
                          if (value) {
                            theme.setDarkMode();
                          } else {
                            theme.setLightMode();
                          }
                        });
                      },
                    ),
                  ),
                  ListTile(
                      title: Text('language.label'.tr()),
                      leading: const Icon(
                        Icons.language_outlined,
                        size: 30,
                        color: Colors.blue,
                      ),
                      trailing: DropdownButton<String>(
                        //dropdownColor:
                        value: globals.langItem,
                        onChanged: (newValue) async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          setState(() {
                            if (newValue == 'English') {
                              globals.savedLocale = const Locale('en', 'US');
                              globals.systemLocale = 'en';
                              context.setLocale(globals.savedLocale);
                              globals.langItem = 'English';
                            } else if (newValue == 'Polski') {
                              globals.savedLocale = const Locale('pl', 'PL');
                              globals.systemLocale = 'pl';
                              context.setLocale(globals.savedLocale);
                              globals.langItem = 'Polski';
                            } else if (newValue == 'Русский') {
                              globals.savedLocale = const Locale('ru', 'RU');
                              globals.systemLocale = 'ru';
                              context.setLocale(globals.savedLocale);
                              globals.langItem = 'Русский';
                            }
                            prefs.setString(
                                'key-dropdown-language', globals.systemLocale);
                          });
                        },
                        items: globals.langItems.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      )),
                ])))));
  }
}
