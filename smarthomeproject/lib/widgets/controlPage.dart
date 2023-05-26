// ignore_for_file: file_names

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:smarthomeproject/algorytm/smartDevice.dart';
// ignore: depend_on_referenced_packages
import 'package:easy_localization/easy_localization.dart';
import 'package:smarthomeproject/widgets/controlItemPage.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';
import 'package:smarthomeproject/widgets/customDialog.dart';
import '../theme/theme.dart';
// ignore: depend_on_referenced_packages
import 'package:shared_preferences/shared_preferences.dart';

class ControlPage extends StatefulWidget {
  final SmartDevice sd;
  final ThemeNotifier theme;
  const ControlPage({super.key, required this.sd, required this.theme});
  @override
  ControlPageState createState() => ControlPageState();
}

class ControlPageState extends State<ControlPage> {
  bool isLandscape = false;
  ControlPageState() {
    Timer.periodic(const Duration(milliseconds: 1000), (timer) async {
      if (mounted) {
        refreshPage(context);
      }
    });
  }
  refreshPage(BuildContext context) {
    setState(() {});
  }

  void startListControlCheck() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    if (sharedPrefs.getStringList('${widget.sd.nameDevice}-listControl') !=
        null) {
      widget.sd.listControl =
          sharedPrefs.getStringList('${widget.sd.nameDevice}-listControl')!;
    }
    if (sharedPrefs
            .getStringList('${widget.sd.nameDevice}-imageListForControlPath') !=
        null) {
      widget.sd.imageListForControlPath = sharedPrefs
          .getStringList('${widget.sd.nameDevice}-imageListForControlPath')!;
    }
  }

  @override
  void initState() {
    super.initState();
    startListControlCheck();
  }

  Widget choiseImg() {
    /*String img = '';
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
    }*/
    return Image.asset(
      'images/my_room.jpg',
      width: isLandscape
          ? MediaQuery.of(context).size.width / 4
          : MediaQuery.of(context).size.width / 2,
      height: isLandscape
          ? MediaQuery.of(context).size.width / 4
          : MediaQuery.of(context).size.width / 2,
    );
  }

  Widget choiseImgFile(File imageFile) {
    return Image.file(
      width: isLandscape
          ? MediaQuery.of(context).size.width / 4
          : MediaQuery.of(context).size.width / 2,
      height: isLandscape
          ? MediaQuery.of(context).size.width / 4
          : MediaQuery.of(context).size.width / 2,
      imageFile,
      fit: BoxFit.cover,
    );
  }

  @override
  Widget build(BuildContext context) {
    isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    return Consumer<ThemeNotifier>(
        builder: (context, theme, _) => MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: theme.getTheme(),
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
                  crossAxisCount: isLandscape ? 4 : 2,
                  children:
                      List.generate(widget.sd.listControl.length + 1, (index) {
                    return widget.sd.listControl.isEmpty ||
                            index >= widget.sd.listControl.length
                        ? Center(
                            child: InkWell(
                                onTap: () {
                                  listCreateEditControl(
                                      widget.sd, context, false, index);
                                },
                                child: Stack(
                                  children: [
                                    choiseImg(),
                                    Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.black, width: 5)),
                                    ),
                                    Center(
                                      child: Container(
                                          color: Colors.white,
                                          child: const Icon(
                                            Icons.add,
                                            size: 50,
                                            color: Colors.blue,
                                          )),
                                    ),
                                  ],
                                )))
                        : Center(
                            child: InkWell(
                                onLongPress: () {
                                  listCreateEditControl(
                                      widget.sd, context, true, index);
                                },
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ControlItemPage(
                                        sd: widget.sd,
                                        indexItem: index,
                                        nameItem: widget.sd.listControl[index],
                                        theme: widget.theme,
                                      ),
                                    ),
                                  );
                                },
                                child: Stack(
                                  children: [
                                    widget.sd.imageListForControlPath[index] ==
                                            'empty'
                                        ? choiseImg()
                                        : choiseImgFile(File(widget.sd
                                            .imageListForControlPath[index])),
                                    Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.black, width: 5)),
                                    ),
                                    Center(
                                      child: Container(
                                          color: Colors.white,
                                          child: Text(
                                            widget.sd.listControl[index],
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontSize: 30,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blue[900]),
                                          )),
                                    ),
                                  ],
                                )));
                  }),
                ),
              ),
            ));
  }
}
