import 'package:flutter/material.dart';
import 'package:smarthomeproject/algorytm/order.dart';
import 'package:smarthomeproject/algorytm/smartDevice.dart';
import 'package:smarthomeproject/theme/theme.dart';
import 'package:smarthomeproject/widgets/settingsPageWidget.dart';
import 'package:smarthomeproject/widgets/widgetListFirstPage.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:smarthomeproject/algorytm/globalValue.dart' as globals;
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class MainPage extends StatefulWidget {
  final List<String> smartDeviceList = [];
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
            widget.smartDeviceList.add(globals.rememberDevice[i]);
            SmartDevice(widget.smartDeviceList.last).getData();
            await sendCommand("", SmartDevice(widget.smartDeviceList.last));
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
    return Scaffold(
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
                  //setState(() {
                  TextEditingController writeC = TextEditingController();
                  bool connected = false;
                  //writeC.text = _dev.bluetoothPassword;
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        //backgroundColor: Colors.white,

                        ///darkModeOn ? Colors.grey[900] : Colors.white,
                        title: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'write-the-name-of-device.label'.tr(),
                            //style: TextStyle(color: Colors.blue),
                          ),
                        ),
                        content: TextField(
                          decoration: const InputDecoration(labelText: "IP:"),
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
                                style: const TextStyle(color: Colors.white)),
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
                              connected =
                                  await connectSocket(writeC.text.toString());
                              if (connected) {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        //darkModeOn ? Colors.grey[900] : Colors.white,
                                        title: Text(
                                            'device-is-connected.label'.tr()),
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
                                if (!widget.smartDeviceList
                                    .contains(writeC.text.toString())) {
                                  widget.smartDeviceList
                                      .add(writeC.text.toString());
                                  SmartDevice(widget.smartDeviceList.last)
                                      .getData();
                                  await sendCommand("",
                                      SmartDevice(widget.smartDeviceList.last));
                                }
                              } else {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        //darkModeOn ? Colors.grey[900] : Colors.white,
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
                  //});
                },
                icon: const Icon(
                  Icons.search,
                  size: 30,
                ),
              ),
              IconButton(
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
              )
            ]),
        body: SingleChildScrollView(
            child: Column(children: <Widget>[
          ListView.builder(
              //key: Key('builder ${_selected.toString()}'), //attention
              //padding: EdgeInsets.only(left: 13.0, right: 13.0, bottom: 25.0),
              shrinkWrap: true,
              //physics: NeverScrollableScrollPhysics(),
              itemCount: widget.smartDeviceList.length,
              scrollDirection: Axis.vertical,
              controller: _scrollController,
              itemBuilder: (context, index) {
                return ListDeviceWidget(
                  sd: SmartDevice(widget.smartDeviceList[index]),
                );
              })
        ])));
  }

  @override
  void dispose() {
    //widget.channel.close();
    super.dispose();
  }
}
