// ignore_for_file: file_names

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:easy_localization/easy_localization.dart';
import 'package:smarthomeproject/algorytm/order.dart';
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

void listChoiceDialog(
    SmartDevice sd, BuildContext context, bool change, int index) {
  TextEditingController writeC = TextEditingController();
  TextEditingController writeC2 = TextEditingController();
  bool radioButtonRele = false;
  bool radioButtonMotor = false;
  if (change) {
    writeC.text = sd.listChoiseMainName[index];
    writeC2.text = sd.listChoiseMainNumber[index];
    if (sd.listChoiseMainType[index] == 'rele') radioButtonRele = true;
    if (sd.listChoiseMainType[index] == 'motor') radioButtonMotor = true;
  }
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, StateSetter setState) {
          return AlertDialog(
            title: change
                ? Text("edit-item.label".tr())
                : Text("add-item.label".tr()),
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
                                if (change) {
                                  if (sd.listChoiseMainNumber[i] ==
                                      index.toString()) {
                                    isExist = false;
                                  } else {
                                    isExist = true;
                                  }
                                } else {
                                  isExist = true;
                                }
                              }
                            }
                          }
                          if (!isExist) {
                            if (change) {
                              sd.listChoiseMainName[index] =
                                  writeC.text.toString();
                              sd.listChoiseMainType[index] = 'rele';
                              sd.listChoiseMainNumber[index] =
                                  writeC2.text.toString();
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
                            }
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
                                if (change) {
                                  if (sd.listChoiseMainNumber[i] ==
                                      index.toString()) {
                                    isExist = false;
                                  } else {
                                    isExist = true;
                                  }
                                } else {
                                  isExist = true;
                                }
                              }
                            }
                          }
                          if (!isExist) {
                            if (change) {
                              sd.listChoiseMainName[index] =
                                  writeC.text.toString();
                              sd.listChoiseMainType[index] = 'motor';
                              sd.listChoiseMainNumber[index] =
                                  writeC2.text.toString();
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
                            }
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

void listCommandVoiceDialog(
    SmartDevice sd, BuildContext context, bool change, int index) {
  TextEditingController writeC = TextEditingController();
  TextEditingController writeC2 = TextEditingController();
  int choiseCommand = 0;
  bool radioButtonRele = false;
  bool radioButtonMotor = false;
  if (change) {
    writeC.text = sd.nameCommandVoice[index];
    writeC2.text = sd.numberCommandVoice[index];
    if (sd.onOffCommandVoice[index] == 'off') choiseCommand = 0;
    if (sd.onOffCommandVoice[index] == 'on') choiseCommand = 1;
    if (sd.typeCommandVoice[index] == 'Rele') radioButtonRele = true;
    if (sd.typeCommandVoice[index] == 'Motor') radioButtonMotor = true;
  }
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, StateSetter setState) {
          return AlertDialog(
            title: change
                ? Text("edit-command.label".tr())
                : Text("add-command.label".tr()),
            content: SingleChildScrollView(
                child: SizedBox(
                    height: 240,
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
                        ),
                        const Padding(padding: EdgeInsets.only(top: 15)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            InkWell(
                                onTap: () {
                                  setState(() {
                                    choiseCommand = 0;
                                  });
                                },
                                child: Row(
                                  children: [
                                    choiseCommand == 1
                                        ? const Icon(
                                            Icons.circle_outlined,
                                            size: 30,
                                            color: Colors.blue,
                                          )
                                        : const Icon(
                                            Icons.check_circle_outline_outlined,
                                            size: 30,
                                            color: Colors.blue,
                                          ),
                                    Text('off.label'.tr())
                                  ],
                                )),
                            InkWell(
                                onTap: () {
                                  setState(() {
                                    choiseCommand = 1;
                                  });
                                },
                                child: Row(
                                  children: [
                                    choiseCommand == 0
                                        ? const Icon(
                                            Icons.circle_outlined,
                                            size: 30,
                                            color: Colors.blue,
                                          )
                                        : const Icon(
                                            Icons.check_circle_outline_outlined,
                                            size: 30,
                                            color: Colors.blue,
                                          ),
                                    Text('on.label'.tr())
                                  ],
                                ))
                          ],
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
                        if (change) {
                          sd.nameCommandVoice[index] = writeC.text.toString();
                          sd.typeCommandVoice[index] = 'Rele';
                          sd.numberCommandVoice[index] =
                              writeC2.text.toString();
                          if (choiseCommand == 0) {
                            sd.onOffCommandVoice[index] = 'off';
                          }
                          if (choiseCommand == 1) {
                            sd.onOffCommandVoice[index] = 'on';
                          }
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          prefs.setStringList(
                              '${sd.nameDevice}-nameCommandVoice',
                              sd.nameCommandVoice);
                          prefs.setStringList(
                              '${sd.nameDevice}-typeCommandVoice',
                              sd.typeCommandVoice);
                          prefs.setStringList(
                              '${sd.nameDevice}-numberCommandVoice',
                              sd.numberCommandVoice);
                          prefs.setStringList(
                              '${sd.nameDevice}-onOffCommandVoice',
                              sd.onOffCommandVoice);
                        } else {
                          sd.nameCommandVoice.add(writeC.text.toString());
                          sd.typeCommandVoice.add('Rele');
                          sd.numberCommandVoice.add(writeC2.text.toString());
                          if (choiseCommand == 0) {
                            sd.onOffCommandVoice.add('off');
                          }
                          if (choiseCommand == 1) {
                            sd.onOffCommandVoice.add('on');
                          }
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          prefs.setStringList(
                              '${sd.nameDevice}-nameCommandVoice',
                              sd.nameCommandVoice);
                          prefs.setStringList(
                              '${sd.nameDevice}-typeCommandVoice',
                              sd.typeCommandVoice);
                          prefs.setStringList(
                              '${sd.nameDevice}-numberCommandVoice',
                              sd.numberCommandVoice);
                          prefs.setStringList(
                              '${sd.nameDevice}-onOffCommandVoice',
                              sd.onOffCommandVoice);
                        }
                        setState(() {});
                        // ignore: use_build_context_synchronously
                        Navigator.pop(context);
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
                        if (change) {
                          sd.nameCommandVoice[index] = writeC.text.toString();
                          sd.typeCommandVoice[index] = 'Motor';
                          sd.numberCommandVoice[index] =
                              writeC2.text.toString();
                          if (choiseCommand == 0) {
                            sd.onOffCommandVoice[index] = 'off';
                          }
                          if (choiseCommand == 1) {
                            sd.onOffCommandVoice[index] = 'on';
                          }
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          prefs.setStringList(
                              '${sd.nameDevice}-nameCommandVoice',
                              sd.nameCommandVoice);
                          prefs.setStringList(
                              '${sd.nameDevice}-typeCommandVoice',
                              sd.typeCommandVoice);
                          prefs.setStringList(
                              '${sd.nameDevice}-numberCommandVoice',
                              sd.numberCommandVoice);
                          prefs.setStringList(
                              '${sd.nameDevice}-onOffCommandVoice',
                              sd.onOffCommandVoice);
                        } else {
                          sd.nameCommandVoice.add(writeC.text.toString());
                          sd.typeCommandVoice.add('Motor');
                          sd.numberCommandVoice.add(writeC2.text.toString());
                          if (choiseCommand == 0) {
                            sd.onOffCommandVoice.add('off');
                          }
                          if (choiseCommand == 1) {
                            sd.onOffCommandVoice.add('on');
                          }
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          prefs.setStringList(
                              '${sd.nameDevice}-nameCommandVoice',
                              sd.nameCommandVoice);
                          prefs.setStringList(
                              '${sd.nameDevice}-typeCommandVoice',
                              sd.typeCommandVoice);
                          prefs.setStringList(
                              '${sd.nameDevice}-numberCommandVoice',
                              sd.numberCommandVoice);
                          prefs.setStringList(
                              '${sd.nameDevice}-onOffCommandVoice',
                              sd.onOffCommandVoice);
                        }
                        setState(() {});
                        // ignore: use_build_context_synchronously
                        Navigator.pop(context);
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

void listCalibrationMotor(
    SmartDevice sd, BuildContext context, int choiseCommand, int index) {
  TextEditingController writeC = TextEditingController();
  try {
    writeC.text = sd.nameCalibrationMotor[index];
  } catch (e) {
    if (kDebugMode) {
      print('Empty nameCalibrationMotor!');
    }
  }
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, StateSetter setState) {
          return AlertDialog(
            title: Text("calibration_motor.label".tr()),
            content: SingleChildScrollView(
                child: SizedBox(
                    height: 130,
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
                            InkWell(
                                onTap: () {
                                  setState(() {
                                    choiseCommand = 0;
                                  });
                                },
                                child: Row(
                                  children: [
                                    choiseCommand == 0
                                        ? const Icon(
                                            Icons.check_circle_outline_outlined,
                                            size: 30,
                                            color: Colors.blue,
                                          )
                                        : const Icon(
                                            Icons.circle_outlined,
                                            size: 30,
                                            color: Colors.blue,
                                          ),
                                    Text('off.label'.tr())
                                  ],
                                )),
                            InkWell(
                                onTap: () {
                                  setState(() {
                                    choiseCommand = 1;
                                  });
                                },
                                child: Row(
                                  children: [
                                    choiseCommand == 1
                                        ? const Icon(
                                            Icons.check_circle_outline_outlined,
                                            size: 30,
                                            color: Colors.blue,
                                          )
                                        : const Icon(
                                            Icons.circle_outlined,
                                            size: 30,
                                            color: Colors.blue,
                                          ),
                                    Text('on.label'.tr())
                                  ],
                                ))
                          ],
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
                  if (writeC.text.toString() == '' || choiseCommand == 2) {
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
                    sd.nameCalibrationMotor[index] = writeC.text.toString();
                    sd.motor[index] = choiseCommand;
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.setStringList('${sd.nameDevice}-nameCalibrationMotor',
                        sd.nameCalibrationMotor);
                    if (index > 9) {
                      if (choiseCommand == 1) {
                        await sendCommand("/KM=ONN$index", sd);
                      } else if (choiseCommand == 0) {
                        await sendCommand("/KM=OFFF$index", sd);
                      }
                    } else {
                      if (choiseCommand == 1) {
                        await sendCommand("/KM=ON$index", sd);
                      } else if (choiseCommand == 0) {
                        await sendCommand("/KM=OFF$index", sd);
                      }
                    }
                    // ignore: use_build_context_synchronously
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          );
        });
      });
}

void listCalibrationMotorFromAllList(
    SmartDevice sd, BuildContext context, int index) {
  int choiseCommand = 2;
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, StateSetter setState) {
          return AlertDialog(
            title: Text(
              "warning.label".tr(),
              style: const TextStyle(color: Colors.red),
            ),
            content: SingleChildScrollView(
                child: SizedBox(
                    height: 130,
                    child: Column(
                      children: [
                        Text(
                            'your_motor_is_not_calibrated_choose_its_position_now.label'
                                .tr()),
                        const Padding(padding: EdgeInsets.only(top: 20)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            InkWell(
                                onTap: () {
                                  setState(() {
                                    choiseCommand = 0;
                                  });
                                },
                                child: Row(
                                  children: [
                                    choiseCommand == 0
                                        ? const Icon(
                                            Icons.check_circle_outline_outlined,
                                            size: 30,
                                            color: Colors.blue,
                                          )
                                        : const Icon(
                                            Icons.circle_outlined,
                                            size: 30,
                                            color: Colors.blue,
                                          ),
                                    Text('off.label'.tr())
                                  ],
                                )),
                            InkWell(
                                onTap: () {
                                  setState(() {
                                    choiseCommand = 1;
                                  });
                                },
                                child: Row(
                                  children: [
                                    choiseCommand == 1
                                        ? const Icon(
                                            Icons.check_circle_outline_outlined,
                                            size: 30,
                                            color: Colors.blue,
                                          )
                                        : const Icon(
                                            Icons.circle_outlined,
                                            size: 30,
                                            color: Colors.blue,
                                          ),
                                    Text('on.label'.tr())
                                  ],
                                ))
                          ],
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
                  if (choiseCommand == 2) {
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
                    sd.motor[index] = choiseCommand;
                    if (index > 9) {
                      if (choiseCommand == 1) {
                        await sendCommand("/KM=ONN$index", sd);
                      } else if (choiseCommand == 0) {
                        await sendCommand("/KM=OFFF$index", sd);
                      }
                    } else {
                      if (choiseCommand == 1) {
                        await sendCommand("/KM=ON$index", sd);
                      } else if (choiseCommand == 0) {
                        await sendCommand("/KM=OFF$index", sd);
                      }
                    }
                    // ignore: use_build_context_synchronously
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          );
        });
      });
}
