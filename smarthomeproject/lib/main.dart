import 'package:flutter/material.dart';
import 'package:smarthomeproject/theme/theme.dart';
import 'package:smarthomeproject/widgets/firstPageWidget.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smarthomeproject/algorytm/globalValue.dart' as globals;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  final sharedPrefs = await SharedPreferences.getInstance();
  if (sharedPrefs.getString('key-dropdown-language') != null) {
    var tmp = sharedPrefs.getString('key-dropdown-language');
    if (tmp == "en") {
      globals.savedLocale = const Locale('en', 'US');
    } else if (tmp == "pl") {
      globals.savedLocale = const Locale('pl', 'PL');
    } else if (tmp == "ru") {
      globals.savedLocale = const Locale('ru', 'RU');
    }
  }
  return runApp(ChangeNotifierProvider<ThemeNotifier>(
      create: (_) => ThemeNotifier(),
      child: EasyLocalization(
        supportedLocales: const [
          Locale('en', 'US'),
          Locale('pl', 'PL'),
          Locale('ru', 'RU')
        ],
        path: 'lang', // <-- change the path of the translation files
        fallbackLocale: const Locale('en', 'US'),
        child: const MyApp(),
      )));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
        builder: (context, theme, _) => MaterialApp(
              theme: theme.getTheme(),
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,
              localeResolutionCallback: (locale, supportedLocales) {
                globals.systemLocale = locale!.languageCode;
                if (globals.savedLocale != const Locale('0', '')) {
                  return globals.savedLocale;
                } else if (locale.languageCode == 'pl') {
                  return const Locale('pl', 'PL');
                } else if (locale.languageCode == 'ru') {
                  return const Locale('ru', 'RU');
                } else {
                  return const Locale('en', 'US');
                }
              },
              debugShowCheckedModeBanner: false,
              title: 'Smart Home',
              home: MainPage(),
            ));
  }
}
