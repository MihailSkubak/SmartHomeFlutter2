import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/theme.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({
    super.key,
  });
  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
        builder: (context, theme, _) => MaterialApp(
            theme: theme.getTheme(),
            home: Scaffold(
                appBar: AppBar(
                    title: const Text('Settings'),
                    leading: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        size: 30,
                      ),
                    )),
                body: Column(children: <Widget>[
                  Card(
                      elevation: 5,
                      child: ListTile(
                        title: const Text('Theme'),
                        leading: const Icon(
                          Icons.dark_mode,
                          size: 30,
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
                      ))
                ]))));
  }
}
