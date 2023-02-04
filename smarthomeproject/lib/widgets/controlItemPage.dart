// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:smarthomeproject/algorytm/smartDevice.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';
import '../theme/theme.dart';

class ControlItemPage extends StatelessWidget {
  final SmartDevice sd;
  final int indexItem;
  final String nameItem;
  const ControlItemPage(
      {super.key,
      required this.sd,
      required this.indexItem,
      required this.nameItem});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
        builder: (context, theme, _) => MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: theme.getTheme(),
              title: nameItem,
              home: Scaffold(
                appBar: AppBar(
                    title: Text(nameItem),
                    leading: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        size: 30,
                      ),
                    )),
                body: const Text('data'),
              ),
            ));
  }
}
