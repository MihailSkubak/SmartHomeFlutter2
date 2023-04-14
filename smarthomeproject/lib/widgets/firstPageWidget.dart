// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:smarthomeproject/algorytm/order.dart';
import 'package:smarthomeproject/algorytm/smartDevice.dart';
import 'package:smarthomeproject/theme/theme.dart';
import 'package:smarthomeproject/widgets/customDialog.dart';
import 'package:smarthomeproject/widgets/settingsPageWidget.dart';
import 'package:smarthomeproject/widgets/widgetListFirstPage.dart';
// ignore: depend_on_referenced_packages
import 'package:easy_localization/easy_localization.dart';
import 'package:smarthomeproject/algorytm/globalValue.dart' as globals;
// ignore: depend_on_referenced_packages
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class MainPage extends StatefulWidget {
  ThemeNotifier theme;
  MainPage({super.key, required this.theme});
  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  final _scrollController = ScrollController();

  void startRememberDevice() async {
    if (globals.onceDoneConnectingToDevice) {
      if (globals.rememberDevice.isNotEmpty) {
        for (int i = 0; i < globals.rememberDevice.length; i++) {
          if (await connectSocket(globals.rememberDevice[i])) {
            globals.smartDeviceList.add(globals.rememberDevice[i]);
            setState(() {});
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    startRememberDevice();
    globals.onceDoneConnectingToDevice = false;
    return WillPopScope(
        onWillPop: () async {
          exitApp(context);
          return false;
        },
        child: Scaffold(
            appBar: AppBar(
                /*backgroundColor:
                widget.theme.switchValueTheme() ? Colors.blue : Colors.red,*/
                title: Text('smart-home.label'.tr()),
                leading: const Icon(
                  Icons.home,
                  size: 45,
                ),
                actions: <Widget>[
                  IconButton(
                    onPressed: () {
                      TextEditingController writeC = TextEditingController();
                      bool connected = false;
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'write-the-number-of-device.label'.tr(),
                              ),
                            ),
                            content: TextField(
                              decoration:
                                  const InputDecoration(labelText: "IP:"),
                              controller: writeC,
                              keyboardType: TextInputType.number,
                            ),
                            actions: <Widget>[
                              TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  //Theme.of(context).iconTheme.color,
                                  textStyle: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                child: Text('cancel.label'.tr(),
                                    style:
                                        const TextStyle(color: Colors.white)),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  textStyle: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                child: Text(
                                  "ok.label".tr(),
                                  style: const TextStyle(color: Colors.white),
                                ),
                                onPressed: () async {
                                  connected = await connectSocket(
                                      writeC.text.toString());
                                  if (connected) {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text(
                                                'device-is-connected.label'
                                                    .tr()),
                                            actions: <Widget>[
                                              TextButton(
                                                style: TextButton.styleFrom(
                                                  backgroundColor: Colors.green,
                                                  textStyle: const TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                child: Text(
                                                  'ok.label'.tr(),
                                                  style: const TextStyle(
                                                      color: Colors.white),
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    Navigator.pop(context);
                                                    Navigator.pop(context);
                                                  });
                                                },
                                              ),
                                            ],
                                          );
                                        });
                                    if (!globals.rememberDevice
                                        .contains(writeC.text.toString())) {
                                      SharedPreferences prefs =
                                          await SharedPreferences.getInstance();
                                      globals.rememberDevice
                                          .add(writeC.text.toString());
                                      prefs.setStringList('key-remember-device',
                                          globals.rememberDevice);
                                    }
                                    if (!globals.smartDeviceList
                                        .contains(writeC.text.toString())) {
                                      globals.smartDeviceList
                                          .add(writeC.text.toString());
                                    }
                                  } else {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text(
                                                'device-is-not-connected-Do-you-want-to-repeat.label'
                                                    .tr()),
                                            actions: <Widget>[
                                              TextButton(
                                                style: TextButton.styleFrom(
                                                  backgroundColor: Colors.red,
                                                  textStyle: const TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                child: Text(
                                                  'no.label'.tr(),
                                                  style: const TextStyle(
                                                      color: Colors.white),
                                                ),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  Navigator.pop(context);
                                                },
                                              ),
                                              TextButton(
                                                style: TextButton.styleFrom(
                                                  backgroundColor: Colors.green,
                                                  textStyle: const TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                child: Text(
                                                  'yes.label'.tr(),
                                                  style: const TextStyle(
                                                      color: Colors.white),
                                                ),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                              ),
                                            ],
                                          );
                                        });
                                  }
                                  setState(() {});
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    icon: const Icon(
                      Icons.search,
                      size: 30,
                    ),
                  ),
                  PopupMenuButton<String>(
                      tooltip: "",
                      onSelected: (String value) async {
                        if (value == "settings.label".tr()) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SettingsPage(),
                            ),
                          );
                        }
                        if (value == "exit.label".tr()) {
                          exitApp(context);
                        }
                      },
                      icon: const Icon(Icons.more_vert),
                      itemBuilder: (BuildContext context) {
                        return {"settings.label".tr(), "exit.label".tr()}
                            .map((String choise) {
                          return PopupMenuItem<String>(
                              value: choise, child: Text(choise));
                        }).toList();
                      }),
                  /*IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SettingsPage(),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.more_vert,
                      size: 30,
                    ),
                  )*/
                ]),
            body: globals.smartDeviceList.isNotEmpty
                ? SingleChildScrollView(
                    child: Column(children: <Widget>[
                    ListView.builder(
                        shrinkWrap: true,
                        itemCount: globals.smartDeviceList.length,
                        scrollDirection: Axis.vertical,
                        controller: _scrollController,
                        itemBuilder: (context, index) {
                          return ListDeviceWidget(
                            sd: globals.objectSmartDevice.isNotEmpty
                                ? globals.objectSmartDevice.length > index
                                    ? globals.objectSmartDevice[index]
                                    : SmartDevice(
                                        globals.smartDeviceList[index])
                                : SmartDevice(globals.smartDeviceList[index]),
                          );
                        })
                  ]))
                : Center(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                        const Icon(
                          Icons.search,
                          size: 20,
                          color: Colors.blue,
                        ),
                        Text(
                          'no-found-devices.label'.tr(),
                          style: const TextStyle(color: Colors.grey),
                        )
                      ]))));
  }

  @override
  void dispose() {
    super.dispose();
  }
}
