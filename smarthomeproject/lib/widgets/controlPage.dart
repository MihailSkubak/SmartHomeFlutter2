// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:smarthomeproject/algorytm/smartDevice.dart';
// ignore: depend_on_referenced_packages
import 'package:easy_localization/easy_localization.dart';
import 'package:smarthomeproject/widgets/controlItemPage.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';
import '../theme/theme.dart';

class ControlPage extends StatelessWidget {
  final SmartDevice sd;
  const ControlPage({super.key, required this.sd});

  Widget choiseImg(int index) {
    String img = '';
    if (index == 0) {
      img = 'images/kitchen.jpg';
    } else if (index == 1) {
      img = 'images/living_room.jpg';
    } else if (index == 2) {
      img = 'images/bathroom.jpg';
    } else if (index == 3) {
      img = 'images/toilet.jpg';
    } else if (index == 4) {
      img = 'images/room_parents.jpg';
    } else if (index == 5) {
      img = 'images/room_children.jpg';
    } else if (index == 6) {
      img = 'images/corridor.jpg';
    } else if (index == 7) {
      img = 'images/balkon.jpg';
    } else {
      img = 'images/my_room.jpg';
    }
    return Image.asset(img);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
        builder: (context, theme, _) => MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'control.label'.tr(),
              home: Scaffold(
                appBar: AppBar(
                    title: Text('control.label'.tr()),
                    leading: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        size: 30,
                      ),
                    )),
                body: GridView.count(
                  crossAxisCount: 2,
                  children: List.generate(10, (index) {
                    return Center(
                        child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ControlItemPage(
                                    sd: sd,
                                    indexItem: index,
                                    nameItem: 'Item $index',
                                  ),
                                ),
                              );
                            },
                            child: Stack(
                              children: [
                                choiseImg(index),
                                Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.black, width: 5)),
                                ),
                                Center(
                                  child: Text(
                                    'Item $index',
                                    style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue[900]),
                                  ),
                                ),
                              ],
                            )));
                  }),
                ),
              ),
            ));
  }
}
