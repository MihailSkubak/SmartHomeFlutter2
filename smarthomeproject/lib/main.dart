import 'package:flutter/material.dart';
import 'package:smarthomeproject/theme/theme.dart';
import 'package:smarthomeproject/widgets/firstPageWidget.dart';
import 'package:provider/provider.dart';

void main() {
  return runApp(ChangeNotifierProvider<ThemeNotifier>(
    create: (_) => ThemeNotifier(),
    child: const MyApp(),
  ));
  // modify with your true address/port
  //Socket socket = await Socket.connect('192.168.0.119', 80);
  //runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
        builder: (context, theme, _) => MaterialApp(
              theme: theme.getTheme(),
              debugShowCheckedModeBanner: false,
              title: 'Smart Home',
              home: MainPage(),
            ));
  }
}
