// ignore_for_file: file_names

import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:easy_localization/easy_localization.dart';
import 'package:smarthomeproject/algorytm/smartDevice.dart';
// ignore: depend_on_referenced_packages
import 'package:shared_preferences/shared_preferences.dart';

void lostDevice(SmartDevice sd, BuildContext context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
              "${"Lost-connection-to-device.label".tr()}${sd.nameDevice}!${"Try-to-connect-to-the-device.label".tr()}"),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.blue,
                textStyle: const TextStyle(
                  color: Colors.white,
                ),
              ),
              child: Text(
                'ok.label'.tr(),
                style: const TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      });
}

void listChoiceDialog(SmartDevice sd, BuildContext context) {
  TextEditingController writeC = TextEditingController();
  TextEditingController writeC2 = TextEditingController();
  bool radioButtonRele = false;
  bool radioButtonMotor = false;
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, StateSetter setState) {
          return AlertDialog(
            title: Text("add-item.label".tr()),
            content: SingleChildScrollView(
                child: SizedBox(
                    height: 200,
                    child: Column(
                      children: [
                        TextField(
                          decoration:
                              InputDecoration(labelText: "name.label".tr()),
                          controller: writeC,
                          keyboardType: TextInputType.text,
                        ),
                        const Padding(padding: EdgeInsets.only(top: 20)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            IconButton(
                                onPressed: () {
                                  setState(() {
                                    radioButtonRele = !radioButtonRele;
                                    if (radioButtonRele) {
                                      radioButtonMotor = false;
                                    }
                                  });
                                },
                                icon: Icon(
                                  Icons.electric_bolt_outlined,
                                  size: 30,
                                  color: radioButtonRele == true
                                      ? Colors.blue
                                      : Colors.red,
                                )),
                            IconButton(
                                onPressed: () {
                                  setState(() {
                                    radioButtonMotor = !radioButtonMotor;
                                    if (radioButtonMotor) {
                                      radioButtonRele = false;
                                    }
                                  });
                                },
                                icon: Icon(
                                  Icons.curtains_closed_sharp,
                                  size: 30,
                                  color: radioButtonMotor == true
                                      ? Colors.blue
                                      : Colors.red,
                                ))
                          ],
                        ),
                        Visibility(
                          visible: radioButtonRele || radioButtonMotor,
                          child: TextField(
                            decoration:
                                InputDecoration(labelText: "number.label".tr()),
                            controller: writeC2,
                            keyboardType: TextInputType.number,
                          ),
                        )
                      ],
                    ))),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.blue,
                  textStyle: const TextStyle(
                    color: Colors.white,
                  ),
                ),
                child: Text(
                  'cancel.label'.tr(),
                  style: const TextStyle(color: Colors.white),
                ),
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
                  'ok.label'.tr(),
                  style: const TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  if (int.tryParse(writeC2.text.toString()) == null ||
                      writeC.text.toString() == '') {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("wrong-values-entered.label".tr()),
                            actions: <Widget>[
                              TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  textStyle: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                child: Text(
                                  'ok.label'.tr(),
                                  style: const TextStyle(color: Colors.white),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          );
                        });
                  } else {
                    bool isExist = false;
                    if (radioButtonRele) {
                      if (int.tryParse(writeC2.text.toString())! >
                          sd.releAll.length - 1) {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title:
                                    Text("element-does-not-exist.label".tr()),
                                actions: <Widget>[
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      textStyle: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    child: Text(
                                      'ok.label'.tr(),
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              );
                            });
                      } else {
                        if (sd.listChoiseMainName.isEmpty) {
                          sd.listChoiseMainName.add(writeC.text.toString());
                          sd.listChoiseMainType.add('rele');
                          sd.listChoiseMainNumber.add(writeC2.text.toString());
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          prefs.setStringList(
                              '${sd.nameDevice}-listChoiseMain.name',
                              sd.listChoiseMainName);
                          prefs.setStringList(
                              '${sd.nameDevice}-listChoiseMain.type',
                              sd.listChoiseMainType);
                          prefs.setStringList(
                              '${sd.nameDevice}-listChoiseMain.number',
                              sd.listChoiseMainNumber);

                          // ignore: use_build_context_synchronously
                          Navigator.pop(context);
                        } else {
                          for (int i = 0;
                              i < sd.listChoiseMainName.length;
                              i++) {
                            if (sd.listChoiseMainType[i] == 'rele') {
                              if (sd.listChoiseMainNumber[i] ==
                                  writeC2.text.toString()) {
                                isExist = true;
                              }
                            }
                          }
                          if (!isExist) {
                            sd.listChoiseMainName.add(writeC.text.toString());
                            sd.listChoiseMainType.add('rele');
                            sd.listChoiseMainNumber
                                .add(writeC2.text.toString());
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            prefs.setStringList(
                                '${sd.nameDevice}-listChoiseMain.name',
                                sd.listChoiseMainName);
                            prefs.setStringList(
                                '${sd.nameDevice}-listChoiseMain.type',
                                sd.listChoiseMainType);
                            prefs.setStringList(
                                '${sd.nameDevice}-listChoiseMain.number',
                                sd.listChoiseMainNumber);
                            // ignore: use_build_context_synchronously
                            Navigator.pop(context);
                          } else {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(
                                        "this-item-is-already-selected.label"
                                            .tr()),
                                    actions: <Widget>[
                                      TextButton(
                                        style: TextButton.styleFrom(
                                          backgroundColor: Colors.blue,
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
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                  );
                                });
                          }
                        }
                      }
                    } else if (radioButtonMotor) {
                      if (int.tryParse(writeC2.text.toString())! >
                          sd.motor.length - 1) {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title:
                                    Text("element-does-not-exist.label".tr()),
                                actions: <Widget>[
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      textStyle: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    child: Text(
                                      'ok.label'.tr(),
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              );
                            });
                      } else {
                        if (sd.listChoiseMainName.isEmpty) {
                          sd.listChoiseMainName.add(writeC.text.toString());
                          sd.listChoiseMainType.add('motor');
                          sd.listChoiseMainNumber.add(writeC2.text.toString());
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          prefs.setStringList(
                              '${sd.nameDevice}-listChoiseMain.name',
                              sd.listChoiseMainName);
                          prefs.setStringList(
                              '${sd.nameDevice}-listChoiseMain.type',
                              sd.listChoiseMainType);
                          prefs.setStringList(
                              '${sd.nameDevice}-listChoiseMain.number',
                              sd.listChoiseMainNumber);
                          // ignore: use_build_context_synchronously
                          Navigator.pop(context);
                        } else {
                          for (int i = 0;
                              i < sd.listChoiseMainName.length;
                              i++) {
                            if (sd.listChoiseMainType[i] == 'motor') {
                              if (sd.listChoiseMainNumber[i] ==
                                  writeC2.text.toString()) {
                                isExist = true;
                              }
                            }
                          }
                          if (!isExist) {
                            sd.listChoiseMainName.add(writeC.text.toString());
                            sd.listChoiseMainType.add('motor');
                            sd.listChoiseMainNumber
                                .add(writeC2.text.toString());
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            prefs.setStringList(
                                '${sd.nameDevice}-listChoiseMain.name',
                                sd.listChoiseMainName);
                            prefs.setStringList(
                                '${sd.nameDevice}-listChoiseMain.type',
                                sd.listChoiseMainType);
                            prefs.setStringList(
                                '${sd.nameDevice}-listChoiseMain.number',
                                sd.listChoiseMainNumber);
                            // ignore: use_build_context_synchronously
                            Navigator.pop(context);
                          } else {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(
                                        "this-item-is-already-selected.label"
                                            .tr()),
                                    actions: <Widget>[
                                      TextButton(
                                        style: TextButton.styleFrom(
                                          backgroundColor: Colors.blue,
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
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                  );
                                });
                          }
                        }
                      }
                    }
                  }
                },
              ),
            ],
          );
        });
      });
}
