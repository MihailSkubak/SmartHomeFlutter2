// ignore_for_file: file_names

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:smarthomeproject/algorytm/order.dart';
import 'package:smarthomeproject/algorytm/smartDevice.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';
import 'package:smarthomeproject/widgets/NavDrawer.dart';
import 'package:smarthomeproject/widgets/customDialog.dart';
import '../theme/theme.dart';

class ControlItemPage extends StatefulWidget {
  final SmartDevice sd;
  final int indexItem;
  final String nameItem;
  const ControlItemPage(
      {super.key,
      required this.sd,
      required this.indexItem,
      required this.nameItem});
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
                                  choiseEditOrDeleteForControlItemPage(
                                      context,
                                      widget.sd,
                                      indexFromAllList(index),
                                      widget.nameItem);
                                },
                                onTap: () {
                                  setState(() {
                                    if (!checkValueForSendCommand(
                                        indexFromAllList(index))) {
                                      if (widget.sd
                                                  .listChoiseMainTypeControlItem[
                                              indexFromAllList(index)] ==
                                          'rele') {
                                        widget.sd.releAll[int.tryParse(widget.sd
                                                .listChoiseMainNumberControlItem[
                                            indexFromAllList(index)])!] = 1;
                                        if (int.tryParse(widget.sd
                                                    .listChoiseMainNumberControlItem[
                                                indexFromAllList(index)])! >=
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
                                        if (widget.sd.motor[int.tryParse(widget
                                                    .sd
                                                    .listChoiseMainNumberControlItem[
                                                indexFromAllList(index)])!] ==
                                            2) {
                                          //Not calibrated
                                          listCalibrationMotorFromAllList(
                                              widget.sd,
                                              context,
                                              int.tryParse(widget.sd
                                                      .listChoiseMainNumberControlItem[
                                                  indexFromAllList(index)])!);
                                        } else {
                                          if (int.tryParse(widget.sd
                                                      .listChoiseMainNumberControlItem[
                                                  indexFromAllList(index)])! >=
                                              10) {
                                            widget.sd.motor[int.tryParse(widget
                                                    .sd
                                                    .listChoiseMainNumberControlItem[
                                                indexFromAllList(index)])!] = 1;
                                            sendCommand(
                                                "/M=ONN${widget.sd.listChoiseMainNumberControlItem[indexFromAllList(index)]}",
                                                widget.sd);
                                          } else {
                                            widget.sd.motor[int.tryParse(widget
                                                    .sd
                                                    .listChoiseMainNumberControlItem[
                                                indexFromAllList(index)])!] = 1;
                                            sendCommand(
                                                "/M=ON${widget.sd.listChoiseMainNumberControlItem[indexFromAllList(index)]}",
                                                widget.sd);
                                          }
                                        }
                                      } else if (widget.sd
                                                      .listChoiseMainTypeControlItem[
                                                  indexFromAllList(index)] ==
                                              'termostat' ||
                                          widget.sd.listChoiseMainTypeControlItem[
                                                  indexFromAllList(index)] ==
                                              'humidityTermostat') {
                                        if (widget.sd
                                                    .listChoiseMainTypeControlItem[
                                                indexFromAllList(index)] ==
                                            'termostat') {
                                          widget.sd.termostat = 0;
                                          sendCommand(
                                              "GET /Q:non HTTP/1.1", widget.sd);
                                          sendCommand("GET /QN:non HTTP/1.1",
                                              widget.sd);
                                        } else if (widget.sd
                                                    .listChoiseMainTypeControlItem[
                                                indexFromAllList(index)] ==
                                            'humidityTermostat') {
                                          widget.sd.humidityTermostat = 0;
                                          sendCommand(
                                              "GET /E:non HTTP/1.1", widget.sd);
                                          sendCommand("GET /EN:non HTTP/1.1",
                                              widget.sd);
                                        }
                                        widget.sd.releAll[int.tryParse(widget.sd
                                                .listChoiseMainNumberControlItem[
                                            indexFromAllList(index)])!] = 1;
                                        if (int.tryParse(widget.sd
                                                    .listChoiseMainNumberControlItem[
                                                indexFromAllList(index)])! >=
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
                                        widget.sd.releAll[int.tryParse(widget.sd
                                                .listChoiseMainNumberControlItem[
                                            indexFromAllList(index)])!] = 0;
                                        if (int.tryParse(widget.sd
                                                    .listChoiseMainNumberControlItem[
                                                indexFromAllList(index)])! >=
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
                                        if (widget.sd.motor[int.tryParse(widget
                                                    .sd
                                                    .listChoiseMainNumberControlItem[
                                                indexFromAllList(index)])!] ==
                                            2) {
                                          //Not calibrated
                                          listCalibrationMotorFromAllList(
                                              widget.sd,
                                              context,
                                              int.tryParse(widget.sd
                                                      .listChoiseMainNumberControlItem[
                                                  indexFromAllList(index)])!);
                                        } else {
                                          if (int.tryParse(widget.sd
                                                      .listChoiseMainNumberControlItem[
                                                  indexFromAllList(index)])! >=
                                              10) {
                                            widget.sd.motor[int.tryParse(widget
                                                    .sd
                                                    .listChoiseMainNumberControlItem[
                                                indexFromAllList(index)])!] = 0;
                                            sendCommand(
                                                "/M=OFFF${widget.sd.listChoiseMainNumberControlItem[indexFromAllList(index)]}",
                                                widget.sd);
                                          } else {
                                            widget.sd.motor[int.tryParse(widget
                                                    .sd
                                                    .listChoiseMainNumberControlItem[
                                                indexFromAllList(index)])!] = 0;
                                            sendCommand(
                                                "/M=OFF${widget.sd.listChoiseMainNumberControlItem[indexFromAllList(index)]}",
                                                widget.sd);
                                          }
                                        }
                                      } else if (widget.sd
                                                      .listChoiseMainTypeControlItem[
                                                  indexFromAllList(index)] ==
                                              'termostat' ||
                                          widget.sd.listChoiseMainTypeControlItem[
                                                  indexFromAllList(index)] ==
                                              'humidityTermostat') {
                                        if (widget.sd
                                                    .listChoiseMainTypeControlItem[
                                                indexFromAllList(index)] ==
                                            'termostat') {
                                          widget.sd.termostat = 0;
                                          sendCommand(
                                              "GET /Q:non HTTP/1.1", widget.sd);
                                          sendCommand("GET /QN:non HTTP/1.1",
                                              widget.sd);
                                        } else if (widget.sd
                                                    .listChoiseMainTypeControlItem[
                                                indexFromAllList(index)] ==
                                            'humidityTermostat') {
                                          widget.sd.humidityTermostat = 0;
                                          sendCommand(
                                              "GET /E:non HTTP/1.1", widget.sd);
                                          sendCommand("GET /EN:non HTTP/1.1",
                                              widget.sd);
                                        }
                                        widget.sd.releAll[int.tryParse(widget.sd
                                                .listChoiseMainNumberControlItem[
                                            indexFromAllList(index)])!] = 0;
                                        if (int.tryParse(widget.sd
                                                    .listChoiseMainNumberControlItem[
                                                indexFromAllList(index)])! >=
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
                                  });
                                },
                                child: Stack(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.black, width: 5)),
                                    ),
                                    Center(
                                        child: Column(children: [
                                      Container(
                                          color: Colors.white,
                                          child: const Icon(
                                            Icons.lightbulb,
                                            size: 50,
                                            color: Colors.blue,
                                          )),
                                      Container(
                                          color: Colors.white,
                                          child: Text(
                                            listChoiseMainNameControlItemPage[
                                                index],
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontSize: 30,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blue[900]),
                                          )),
                                    ])),
                                  ],
                                )));
                  }),
                ),
              ),
            ));
  }
}
