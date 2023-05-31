// ignore_for_file: file_names

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:smarthomeproject/algorytm/globalValue.dart';
import 'package:smarthomeproject/algorytm/order.dart';
import 'package:smarthomeproject/algorytm/smartDevice.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';
import 'package:smarthomeproject/widgets/NavDrawer.dart';
import 'package:smarthomeproject/widgets/customDialog.dart';
import '../theme/theme.dart';
// ignore: depend_on_referenced_packages
import 'package:easy_localization/easy_localization.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_spinbox/material.dart';

class ControlItemPage extends StatefulWidget {
  final SmartDevice sd;
  final int indexItem;
  final String nameItem;
  final ThemeNotifier theme;
  const ControlItemPage(
      {super.key,
      required this.sd,
      required this.indexItem,
      required this.nameItem,
      required this.theme});
  @override
  ControlItemPageState createState() => ControlItemPageState();
}

class ControlItemPageState extends State<ControlItemPage> {
  ControlItemPageState() {
    Timer.periodic(const Duration(milliseconds: 1000), (timer) async {
      if (mounted) {
        refreshPage(context);
      }
    });
  }
  refreshPage(BuildContext context) {
    setState(() {});
  }

  bool isLandscape = false;
  List<String> listChoiseMainNameControlItemPage = [];
  List<String> listChoiseMainTypeControlItemPage = [];
  List<String> listChoiseMainNumberControlItemPage = [];

  int indexFromAllList(int index) {
    for (int i = 0; i < widget.sd.listChoiseMainNameControlItem.length; i++) {
      if (widget.sd.listChoiseMainNameControlItem[i] ==
          listChoiseMainNameControlItemPage[index]) {
        return i;
      }
    }
    return -1;
  }

  bool checkValueForSendCommand(int index) {
    if (widget.sd.listChoiseMainTypeControlItem[index] == 'motor') {
      if (widget.sd.motor[int.tryParse(
              widget.sd.listChoiseMainNumberControlItem[index])!] ==
          1) {
        return true;
      } else {
        return false;
      }
    } else {
      if (widget.sd.releAll[int.tryParse(
              widget.sd.listChoiseMainNumberControlItem[index])!] ==
          1) {
        return true;
      } else {
        return false;
      }
    }
  }

  int indexTermostat = 0;

  @override
  Widget build(BuildContext context) {
    isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    listChoiseMainNameControlItemPage = [];
    listChoiseMainTypeControlItemPage = [];
    listChoiseMainNumberControlItemPage = [];
    for (int i = 0; i < widget.sd.listChoiseMainNameControlItem.length; i++) {
      if (widget.sd.listChoiseMainRoomControlItem[i] == widget.nameItem) {
        listChoiseMainNameControlItemPage
            .add(widget.sd.listChoiseMainNameControlItem[i]);
        listChoiseMainTypeControlItemPage
            .add(widget.sd.listChoiseMainTypeControlItem[i]);
        listChoiseMainNumberControlItemPage
            .add(widget.sd.listChoiseMainNumberControlItem[i]);
      }
    }
    return Consumer<ThemeNotifier>(
        builder: (context, theme, _) => MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: theme.getTheme(),
              title: widget.nameItem,
              home: Scaffold(
                  endDrawer: NavDrawer(
                    sd: widget.sd,
                  ),
                  appBar: AppBar(
                    title: Text(widget.nameItem),
                    leading: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        size: 30,
                      ),
                    ),
                    actions: [
                      Builder(builder: (BuildContext context) {
                        return IconButton(
                          icon: const Icon(
                            color: Colors.white,
                            Icons.info_outline,
                          ),
                          onPressed: () {
                            Scaffold.of(context).openEndDrawer();
                          },
                          tooltip: MaterialLocalizations.of(context)
                              .openAppDrawerTooltip,
                        );
                      })
                    ],
                  ),
                  body: GridView.count(
                    crossAxisCount: isLandscape ? 4 : 2,
                    children: List.generate(
                        listChoiseMainNameControlItemPage.length + 1, (index) {
                      return widget.sd.listChoiseMainNameControlItem.isEmpty ||
                              index >= listChoiseMainNameControlItemPage.length
                          ? Center(
                              child: InkWell(
                                  onTap: () {
                                    listChoiceDialogControlItem(widget.sd,
                                        context, false, 0, widget.nameItem);
                                  },
                                  child: Stack(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            color: Colors.blue[200],
                                            border: const Border(
                                              right: BorderSide(
                                                  color: Colors.black,
                                                  width: 2),
                                              bottom: BorderSide(
                                                  color: Colors.black,
                                                  width: 2),
                                            )),
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
                                    choiseEditOrDeleteForControlItemPage(
                                        context,
                                        widget.sd,
                                        indexFromAllList(index),
                                        widget.nameItem);
                                  },
                                  onTap: () {
                                    setState(() {
                                      if (!widget.sd.readAnswerCheck) {
                                        widget.sd.readAnswer = true;
                                        if (!checkValueForSendCommand(
                                            indexFromAllList(index))) {
                                          if (widget.sd
                                                      .listChoiseMainTypeControlItem[
                                                  indexFromAllList(index)] ==
                                              'rele') {
                                            widget
                                                .sd.releAll[int.tryParse(widget
                                                    .sd
                                                    .listChoiseMainNumberControlItem[
                                                indexFromAllList(index)])!] = 1;
                                            if (int.tryParse(widget.sd
                                                        .listChoiseMainNumberControlItem[
                                                    indexFromAllList(
                                                        index)])! >=
                                                10) {
                                              sendCommand(
                                                  "/RELE=ONN${widget.sd.listChoiseMainNumberControlItem[indexFromAllList(index)]}",
                                                  widget.sd);
                                            } else {
                                              sendCommand(
                                                  "/RELE=ON${widget.sd.listChoiseMainNumberControlItem[indexFromAllList(index)]}",
                                                  widget.sd);
                                            }
                                          } else if (widget.sd
                                                      .listChoiseMainTypeControlItem[
                                                  indexFromAllList(index)] ==
                                              'motor') {
                                            if (widget.sd
                                                    .motor[int.tryParse(widget
                                                        .sd
                                                        .listChoiseMainNumberControlItem[
                                                    indexFromAllList(
                                                        index)])!] ==
                                                2) {
                                              //Not calibrated
                                              listCalibrationMotorFromAllList(
                                                  widget.sd,
                                                  context,
                                                  int.tryParse(widget.sd
                                                          .listChoiseMainNumberControlItem[
                                                      indexFromAllList(
                                                          index)])!);
                                            } else {
                                              if (int.tryParse(widget.sd
                                                          .listChoiseMainNumberControlItem[
                                                      indexFromAllList(
                                                          index)])! >=
                                                  10) {
                                                widget.sd
                                                    .motor[int.tryParse(widget
                                                        .sd
                                                        .listChoiseMainNumberControlItem[
                                                    indexFromAllList(
                                                        index)])!] = 1;
                                                sendCommand(
                                                    "/M=ONN${widget.sd.listChoiseMainNumberControlItem[indexFromAllList(index)]}",
                                                    widget.sd);
                                              } else {
                                                widget.sd
                                                    .motor[int.tryParse(widget
                                                        .sd
                                                        .listChoiseMainNumberControlItem[
                                                    indexFromAllList(
                                                        index)])!] = 1;
                                                sendCommand(
                                                    "/M=ON${widget.sd.listChoiseMainNumberControlItem[indexFromAllList(index)]}",
                                                    widget.sd);
                                              }
                                            }
                                          } else if (widget.sd
                                                          .listChoiseMainTypeControlItem[
                                                      indexFromAllList(
                                                          index)] ==
                                                  'termostat' ||
                                              widget.sd.listChoiseMainTypeControlItem[
                                                      indexFromAllList(
                                                          index)] ==
                                                  'humidityTermostat') {
                                            if (widget.sd
                                                        .listChoiseMainTypeControlItem[
                                                    indexFromAllList(index)] ==
                                                'termostat') {
                                              widget.sd.termostat = 0;
                                              sendCommand("GET /Q:non HTTP/1.1",
                                                  widget.sd);
                                              sendCommand(
                                                  "GET /QN:non HTTP/1.1",
                                                  widget.sd);
                                            } else if (widget.sd
                                                        .listChoiseMainTypeControlItem[
                                                    indexFromAllList(index)] ==
                                                'humidityTermostat') {
                                              widget.sd.humidityTermostat = 0;
                                              sendCommand("GET /E:non HTTP/1.1",
                                                  widget.sd);
                                              sendCommand(
                                                  "GET /EN:non HTTP/1.1",
                                                  widget.sd);
                                            }
                                            widget
                                                .sd.releAll[int.tryParse(widget
                                                    .sd
                                                    .listChoiseMainNumberControlItem[
                                                indexFromAllList(index)])!] = 1;
                                            if (int.tryParse(widget.sd
                                                        .listChoiseMainNumberControlItem[
                                                    indexFromAllList(
                                                        index)])! >=
                                                10) {
                                              sendCommand(
                                                  "/RELE=ONN${widget.sd.listChoiseMainNumberControlItem[indexFromAllList(index)]}",
                                                  widget.sd);
                                            } else {
                                              sendCommand(
                                                  "/RELE=ON${widget.sd.listChoiseMainNumberControlItem[indexFromAllList(index)]}",
                                                  widget.sd);
                                            }
                                          }
                                        } else {
                                          if (widget.sd
                                                      .listChoiseMainTypeControlItem[
                                                  indexFromAllList(index)] ==
                                              'rele') {
                                            widget
                                                .sd.releAll[int.tryParse(widget
                                                    .sd
                                                    .listChoiseMainNumberControlItem[
                                                indexFromAllList(index)])!] = 0;
                                            if (int.tryParse(widget.sd
                                                        .listChoiseMainNumberControlItem[
                                                    indexFromAllList(
                                                        index)])! >=
                                                10) {
                                              sendCommand(
                                                  "/RELE=OFFF${widget.sd.listChoiseMainNumberControlItem[indexFromAllList(index)]}",
                                                  widget.sd);
                                            } else {
                                              sendCommand(
                                                  "/RELE=OFF${widget.sd.listChoiseMainNumberControlItem[indexFromAllList(index)]}",
                                                  widget.sd);
                                            }
                                          } else if (widget.sd
                                                      .listChoiseMainTypeControlItem[
                                                  indexFromAllList(index)] ==
                                              'motor') {
                                            if (widget.sd
                                                    .motor[int.tryParse(widget
                                                        .sd
                                                        .listChoiseMainNumberControlItem[
                                                    indexFromAllList(
                                                        index)])!] ==
                                                2) {
                                              //Not calibrated
                                              listCalibrationMotorFromAllList(
                                                  widget.sd,
                                                  context,
                                                  int.tryParse(widget.sd
                                                          .listChoiseMainNumberControlItem[
                                                      indexFromAllList(
                                                          index)])!);
                                            } else {
                                              if (int.tryParse(widget.sd
                                                          .listChoiseMainNumberControlItem[
                                                      indexFromAllList(
                                                          index)])! >=
                                                  10) {
                                                widget.sd
                                                    .motor[int.tryParse(widget
                                                        .sd
                                                        .listChoiseMainNumberControlItem[
                                                    indexFromAllList(
                                                        index)])!] = 0;
                                                sendCommand(
                                                    "/M=OFFF${widget.sd.listChoiseMainNumberControlItem[indexFromAllList(index)]}",
                                                    widget.sd);
                                              } else {
                                                widget.sd
                                                    .motor[int.tryParse(widget
                                                        .sd
                                                        .listChoiseMainNumberControlItem[
                                                    indexFromAllList(
                                                        index)])!] = 0;
                                                sendCommand(
                                                    "/M=OFF${widget.sd.listChoiseMainNumberControlItem[indexFromAllList(index)]}",
                                                    widget.sd);
                                              }
                                            }
                                          } else if (widget.sd
                                                          .listChoiseMainTypeControlItem[
                                                      indexFromAllList(
                                                          index)] ==
                                                  'termostat' ||
                                              widget.sd.listChoiseMainTypeControlItem[
                                                      indexFromAllList(
                                                          index)] ==
                                                  'humidityTermostat') {
                                            if (widget.sd
                                                        .listChoiseMainTypeControlItem[
                                                    indexFromAllList(index)] ==
                                                'termostat') {
                                              widget.sd.termostat = 0;
                                              sendCommand("GET /Q:non HTTP/1.1",
                                                  widget.sd);
                                              sendCommand(
                                                  "GET /QN:non HTTP/1.1",
                                                  widget.sd);
                                            } else if (widget.sd
                                                        .listChoiseMainTypeControlItem[
                                                    indexFromAllList(index)] ==
                                                'humidityTermostat') {
                                              widget.sd.humidityTermostat = 0;
                                              sendCommand("GET /E:non HTTP/1.1",
                                                  widget.sd);
                                              sendCommand(
                                                  "GET /EN:non HTTP/1.1",
                                                  widget.sd);
                                            }
                                            widget
                                                .sd.releAll[int.tryParse(widget
                                                    .sd
                                                    .listChoiseMainNumberControlItem[
                                                indexFromAllList(index)])!] = 0;
                                            if (int.tryParse(widget.sd
                                                        .listChoiseMainNumberControlItem[
                                                    indexFromAllList(
                                                        index)])! >=
                                                10) {
                                              sendCommand(
                                                  "/RELE=OFFF${widget.sd.listChoiseMainNumberControlItem[indexFromAllList(index)]}",
                                                  widget.sd);
                                            } else {
                                              sendCommand(
                                                  "/RELE=OFF${widget.sd.listChoiseMainNumberControlItem[indexFromAllList(index)]}",
                                                  widget.sd);
                                            }
                                          }
                                        }
                                      }
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.blue[200],
                                        border: Border(
                                          right: BorderSide(
                                              color: Colors.black,
                                              width: index % 2 != 0 ? 0 : 2),
                                          bottom: const BorderSide(
                                              color: Colors.black, width: 2),
                                        )),
                                    child: Center(
                                        child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                          Container(
                                              color: Colors.transparent,
                                              child: Text(
                                                listChoiseMainNameControlItemPage[
                                                    index],
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black),
                                              )),
                                          widget.sd.listChoiseMainTypeControlItem[
                                                          indexFromAllList(
                                                              index)] ==
                                                      'humidityTermostat' ||
                                                  widget.sd.listChoiseMainTypeControlItem[
                                                          indexFromAllList(
                                                              index)] ==
                                                      'termostat'
                                              ? Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.blue[200],
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                5.0)),
                                                  ),
                                                  width: 150,
                                                  height: 50,
                                                  child: SpinBox(
                                                    iconColor:
                                                        MaterialStateProperty
                                                            .all<Color>(
                                                                Colors.black),
                                                    cursorColor: Colors.blue,
                                                    decoration:
                                                        const InputDecoration(
                                                      contentPadding:
                                                          EdgeInsets.only(
                                                              top: 65),
                                                    ),
                                                    spacing: 3,
                                                    decimals: 1,
                                                    step: 0.1,
                                                    min: 0.0,
                                                    max: 100.0,
                                                    value: widget.sd.listChoiseMainNumberControlItem[
                                                                indexFromAllList(
                                                                    index)] ==
                                                            widget.sd
                                                                .termostatNumber
                                                                .toString()
                                                        ? widget.sd.termostat
                                                        : widget.sd
                                                            .humidityTermostat,
                                                    onChanged: (value) {
                                                      if (!widget
                                                          .sd.readAnswerCheck) {
                                                        setState(() {
                                                          widget.sd.readAnswer =
                                                              true;
                                                          pushCommandForTermostat =
                                                              true;
                                                          indexTermostat =
                                                              indexFromAllList(
                                                                  index);
                                                          if (widget.sd
                                                                      .listChoiseMainNumberControlItem[
                                                                  indexFromAllList(
                                                                      index)] ==
                                                              widget.sd
                                                                  .termostatNumber
                                                                  .toString()) {
                                                            widget.sd
                                                                    .termostat =
                                                                value;
                                                          } else {
                                                            widget.sd
                                                                    .humidityTermostat =
                                                                value;
                                                          }
                                                        });
                                                      }
                                                    },
                                                  ))
                                              : widget.sd.listChoiseMainTypeControlItem[
                                                          indexFromAllList(
                                                              index)] ==
                                                      'motor'
                                                  ? Image.asset(
                                                      widget.sd.motor[int.tryParse(widget
                                                                      .sd
                                                                      .listChoiseMainNumberControlItem[
                                                                  indexFromAllList(
                                                                      index)])!] ==
                                                              1
                                                          ? 'images/curtains_open.png'
                                                          : 'images/curtains_close.png',
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.185, //150
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.185,
                                                    )
                                                  : Image.asset(
                                                      widget.sd.releAll[int.tryParse(widget
                                                                      .sd
                                                                      .listChoiseMainNumberControlItem[
                                                                  indexFromAllList(
                                                                      index)])!] ==
                                                              1
                                                          ? 'images/bulb_on.png'
                                                          : 'images/bulb_off.png',
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.185,
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.185,
                                                    ),
                                          widget.sd.listChoiseMainTypeControlItem[
                                                      indexFromAllList(
                                                          index)] ==
                                                  'humidityTermostat'
                                              ? textAndInformation(
                                                  'humidityTermostat')
                                              : widget.sd.listChoiseMainTypeControlItem[
                                                          indexFromAllList(
                                                              index)] ==
                                                      'termostat'
                                                  ? textAndInformation(
                                                      'termostat')
                                                  : const SizedBox(height: 20),
                                        ])),
                                  )));
                    }),
                  ),
                  bottomNavigationBar: pushCommandForTermostat
                      ? SizedBox(
                          height: 65,
                          child: InkWell(
                            child: Column(
                              children: [
                                const Icon(
                                  Icons.check_box_outlined,
                                  size: 40,
                                ),
                                Text(
                                  'complete.label'.tr(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                              ],
                            ),
                            onTap: () async {
                              if (!widget.sd.readAnswerCheck) {
                                setState(() {
                                  widget.sd.readAnswer = true;
                                  pushCommandForTermostat =
                                      !pushCommandForTermostat;
                                });
                                if (!pushCommandForTermostat) {
                                  if (widget.sd.listChoiseMainNumberControlItem[
                                          indexTermostat] ==
                                      widget.sd.termostatNumber.toString()) {
                                    if (widget.sd.termostat == 0) {
                                      //GET /Q:12.0 HTTP/1.1
                                      await sendCommand(
                                          "GET /Q:non HTTP/1.1", widget.sd);
                                      await sendCommand(
                                          "GET /QN:non HTTP/1.1", widget.sd);
                                    } else {
                                      await sendCommand(
                                          "GET /Q:${widget.sd.termostat} HTTP/1.1",
                                          widget.sd);
                                      await sendCommand(
                                          "GET /QN:${widget.sd.termostatNumber} HTTP/1.1",
                                          widget.sd);
                                    }
                                  } else {
                                    if (widget.sd.humidityTermostat == 0) {
                                      await sendCommand(
                                          "GET /E:non HTTP/1.1", widget.sd);
                                      await sendCommand(
                                          "GET /EN:non HTTP/1.1", widget.sd);
                                    } else {
                                      await sendCommand(
                                          "GET /E:${widget.sd.humidityTermostat} HTTP/1.1",
                                          widget.sd);
                                      await sendCommand(
                                          "GET /EN:${widget.sd.humidityTermostatNumber} HTTP/1.1",
                                          widget.sd);
                                    }
                                  }
                                }
                              }
                            },
                          ))
                      : const SizedBox(
                          height: 0,
                        )),
            ));
  }

  Widget textAndInformation(String name) {
    if (name == 'termostat') {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            widget.sd.releAll[widget.sd.termostatNumber] == 1
                ? 'on-ControlItem.label'.tr()
                : 'off-ControlItem.label'.tr(),
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text('${widget.sd.temperaturaHome}°C')
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            widget.sd.releAll[widget.sd.humidityTermostatNumber] == 1
                ? 'on-ControlItem.label'.tr()
                : 'off-ControlItem.label'.tr(),
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text('${widget.sd.humidityHome} %')
        ],
      );
    }
  }
}
