// ignore_for_file: file_names

import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smarthomeproject/algorytm/order.dart';
import 'package:smarthomeproject/algorytm/smartDevice.dart';
// ignore: depend_on_referenced_packages
import 'package:easy_localization/easy_localization.dart';
import 'package:smarthomeproject/algorytm/globalValue.dart' as globals;
import 'package:smarthomeproject/algorytm/voiceSpeech.dart';
// ignore: depend_on_referenced_packages, import_of_legacy_library_into_null_safe
import 'package:avatar_glow/avatar_glow.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smarthomeproject/theme/theme.dart';
import 'package:smarthomeproject/widgets/calibrationPage.dart';
import 'package:smarthomeproject/widgets/controlPage.dart';
import 'package:smarthomeproject/widgets/customDialog.dart';
// ignore: depend_on_referenced_packages
import 'package:shared_preferences/shared_preferences.dart';
// ignore: depend_on_referenced_packages, import_of_legacy_library_into_null_safe
import 'package:flutter_slidable/flutter_slidable.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_spinbox/material.dart';

class ListDeviceWidget extends StatefulWidget {
  final SmartDevice sd;
  final ThemeNotifier theme;

  const ListDeviceWidget({super.key, required this.sd, required this.theme});
  @override
  ListDeviceWidgetState createState() => ListDeviceWidgetState();
}

class ListDeviceWidgetState extends State<ListDeviceWidget> {
  final _scrollController = ScrollController();
  ListDeviceWidgetState() {
    Timer.periodic(const Duration(milliseconds: 1000), (timer) async {
      if (mounted) {
        refreshPage(context);
      }
    });
  }
  refreshPage(BuildContext context) {
    setState(() {});
  }

  void startListChoiseCheck() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    if (sharedPrefs
            .getStringList('${widget.sd.nameDevice}-listChoiseMain.name') !=
        null) {
      widget.sd.listChoiseMainName = sharedPrefs
          .getStringList('${widget.sd.nameDevice}-listChoiseMain.name')!;
    }
    if (sharedPrefs
            .getStringList('${widget.sd.nameDevice}-listChoiseMain.type') !=
        null) {
      widget.sd.listChoiseMainType = sharedPrefs
          .getStringList('${widget.sd.nameDevice}-listChoiseMain.type')!;
    }
    if (sharedPrefs
            .getStringList('${widget.sd.nameDevice}-listChoiseMain.number') !=
        null) {
      widget.sd.listChoiseMainNumber = sharedPrefs
          .getStringList('${widget.sd.nameDevice}-listChoiseMain.number')!;
    }
    if (sharedPrefs.getString('${widget.sd.nameDevice}-nameDeviceClient') !=
        null) {
      widget.sd.nameDeviceClient =
          sharedPrefs.getString('${widget.sd.nameDevice}-nameDeviceClient')!;
    } else {
      widget.sd.nameDeviceClient = widget.sd.nameDevice;
    }
  }

  @override
  void initState() {
    super.initState();
    if (!globals.objectSmartDevice.contains(widget.sd)) {
      globals.objectSmartDevice.add(widget.sd);
    }
    widget.sd.showDialogLostConnect = true;
    getDataFromDevice(widget.sd, context);
    sendCommand("", widget.sd);
    startListChoiseCheck();
  }

  PopupMenuItem _buildPopupMenuItemConnect(String title, IconData iconData) {
    return PopupMenuItem(
      onTap: () {
        if (!widget.sd.connected) {
          setState(() {
            widget.sd.connected = true;
            widget.sd.showDialogLostConnect = true;
          });
          getDataFromDevice(widget.sd, context);
          sendCommand("", widget.sd);
        } else {
          setState(() {
            widget.sd.connected = false;
          });
        }
      },
      child: Row(
        children: [
          Icon(
            iconData,
            color: widget.sd.connected ? Colors.red : Colors.blue,
          ),
          Text(title),
        ],
      ),
    );
  }

  PopupMenuItem _buildPopupMenuItemRenameDevice(
      String title, IconData iconData) {
    return PopupMenuItem(
      onTap: () {
        TextEditingController writeC = TextEditingController();
        writeC.text = widget.sd.nameDeviceClient;
        if (writeC.text == '') {
          writeC.text = widget.sd.nameDevice;
        }
        Future.delayed(
            const Duration(seconds: 0),
            () => showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                      title: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'write-the-name-of-device.label'.tr(),
                        ),
                      ),
                      content: TextField(
                        decoration:
                            InputDecoration(labelText: "name.label".tr()),
                        controller: writeC,
                        keyboardType: TextInputType.text,
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
                          child: Text('ok.label'.tr(),
                              style: const TextStyle(color: Colors.white)),
                          onPressed: () async {
                            setState(() {
                              if (writeC.text == '') {
                                widget.sd.nameDeviceClient =
                                    widget.sd.nameDevice;
                              } else {
                                widget.sd.nameDeviceClient =
                                    writeC.text.toString();
                              }
                            });
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            prefs.setString(
                                '${widget.sd.nameDevice}-nameDeviceClient',
                                widget.sd.nameDeviceClient);
                            // ignore: use_build_context_synchronously
                            Navigator.pop(context);
                          },
                        )
                      ]);
                }));
      },
      child: Row(
        children: [
          Icon(
            iconData,
            color: Colors.blue,
          ),
          Text(title),
        ],
      ),
    );
  }

  // ignore: prefer_typing_uninitialized_variables
  var detail;
  void getDetails(details) {
    detail = details;
  }

  double valueCheck = 0;
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      GestureDetector(
          onTapDown: (details) => getDetails(details),
          onLongPress: () {
            showMenu(
                context: context,
                position: RelativeRect.fromLTRB(
                    detail.globalPosition.dx + 65,
                    detail.globalPosition.dy + 0,
                    detail.globalPosition.dx + 65,
                    detail.globalPosition.dy + 0),
                items: [
                  _buildPopupMenuItemConnect(
                      widget.sd.connected
                          ? 'disconnected.label'.tr()
                          : 'connected.label'.tr(),
                      Icons.wifi),
                  _buildPopupMenuItemRenameDevice('rename-device.label'.tr(),
                      Icons.drive_file_rename_outline_rounded)
                ]);
          },
          child: Card(
              elevation: 5,
              child: widget.sd.pressure == 0
                  ? ListTile(
                      leading: const Icon(
                        Icons.maps_home_work_sharp,
                        size: 45,
                      ),
                      title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              widget.sd.nameDeviceClient,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            Visibility(
                                visible: widget.sd.nameDeviceClient !=
                                        widget.sd.nameDevice
                                    ? true
                                    : false,
                                child: Text(
                                  widget.sd.nameDevice,
                                  style: const TextStyle(color: Colors.grey),
                                ))
                          ]),
                      subtitle: Row(children: [
                        Icon(
                          Icons.wifi,
                          size: 22,
                          color: widget.sd.connected ? Colors.blue : Colors.red,
                        ),
                        widget.sd.pressure != 0
                            ? Row(children: [
                                const Icon(
                                  Icons.thermostat,
                                  size: 20,
                                  color: Colors.blue,
                                ),
                                Text(
                                    '${widget.sd.temperatura.toStringAsFixed(1)}°C  ')
                              ])
                            : const SizedBox(height: 0, width: 0),
                        widget.sd.pressure != 0
                            ? Row(children: [
                                const Icon(
                                  Icons.water_drop,
                                  size: 20,
                                  color: Colors.blue,
                                ),
                                Text(
                                    '${widget.sd.humidity.toStringAsFixed(1)} %')
                              ])
                            : const SizedBox(height: 0, width: 0),
                      ]))
                  : ExpansionTile(
                      initiallyExpanded: true,
                      leading: const Icon(
                        Icons.maps_home_work_sharp,
                        size: 45,
                      ),
                      title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              widget.sd.nameDeviceClient,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            Visibility(
                                visible: widget.sd.nameDeviceClient !=
                                        widget.sd.nameDevice
                                    ? true
                                    : false,
                                child: Text(
                                  widget.sd.nameDevice,
                                  style: const TextStyle(color: Colors.grey),
                                ))
                          ]),
                      subtitle: Row(children: [
                        Icon(
                          Icons.wifi,
                          size: 22,
                          color: widget.sd.connected ? Colors.blue : Colors.red,
                        ),
                        widget.sd.pressure != 0
                            ? Row(children: [
                                const Icon(
                                  Icons.thermostat,
                                  size: 20,
                                  color: Colors.blue,
                                ),
                                Text(
                                    '${widget.sd.temperatura.toStringAsFixed(1)}°C  ')
                              ])
                            : const SizedBox(height: 0, width: 0),
                        widget.sd.pressure != 0
                            ? Row(children: [
                                const Icon(
                                  Icons.water_drop,
                                  size: 20,
                                  color: Colors.blue,
                                ),
                                Text(
                                    '${widget.sd.humidity.toStringAsFixed(1)} %')
                              ])
                            : const SizedBox(height: 0, width: 0),
                      ]),
                      children: [
                        Container(
                            height: 1,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: Colors.yellow[100],
                              border: const Border(
                                top: BorderSide(
                                  color: Colors.grey,
                                  width: 1,
                                ),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: const Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                            )),
                        const Padding(
                          padding: EdgeInsets.only(bottom: 10),
                        ),
                        widget.sd.pressure != 0
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Row(children: [
                                    const Icon(
                                      Icons.speed_rounded,
                                      size: 30,
                                      color: Colors.blue,
                                    ),
                                    Text(
                                        ' ${widget.sd.pressure}${'mm.label'.tr()}')
                                  ]),
                                  Row(children: [
                                    widget.sd.weather > 0 &&
                                            widget.sd.temperatura <= 1.5
                                        ? SvgPicture.asset(
                                            'images/snowflake.svg',
                                            color: Colors.blue,
                                            height: 25,
                                            width: 25,
                                          )
                                        : Icon(
                                            widget.sd.weather > 0 &&
                                                    widget.sd.temperatura > 1.5
                                                ? Icons.cloudy_snowing
                                                : widget.sd.weather < 0
                                                    ? Icons.wb_sunny_rounded
                                                    : Icons.cloud_sync_rounded,
                                            size: 30,
                                            color: Colors.blue,
                                          ),
                                    widget.sd.weather < 0
                                        ? Text(
                                            ' ${(widget.sd.weather * -1).toString()} %')
                                        : Text(
                                            ' ${widget.sd.weather.toString()} %')
                                  ]),
                                ],
                              )
                            : const SizedBox(height: 0, width: 0),
                        const Padding(
                          padding: EdgeInsets.only(bottom: 5),
                        ),
                        Container(
                            height: 1,
                            width: MediaQuery.of(context).size.width - 40,
                            decoration: BoxDecoration(
                                color: Colors.yellow[100],
                                border: const Border(
                                  top: BorderSide(
                                    color: Colors.grey,
                                    width: 1,
                                  ),
                                ))),
                        const Padding(
                          padding: EdgeInsets.only(bottom: 5),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Row(children: [
                              const Icon(
                                Icons.thermostat,
                                size: 30,
                                color: Colors.blue,
                              ),
                              Text(
                                  '${widget.sd.temperaturaHome.toStringAsFixed(1)}°C  ')
                            ]),
                            Row(children: [
                              const Icon(
                                Icons.water_drop,
                                size: 30,
                                color: Colors.blue,
                              ),
                              Text(
                                  '${widget.sd.humidityHome.toStringAsFixed(1)} %')
                            ])
                          ],
                        ),
                        Column(children: <Widget>[
                          ListView.builder(
                              shrinkWrap: true,
                              itemCount: widget.sd.releAll.isEmpty
                                  ? 0
                                  : widget.sd.listChoiseMainName.isEmpty
                                      ? 1
                                      : widget.sd.listChoiseMainName.length >= 6
                                          ? widget.sd.listChoiseMainName.length
                                          : widget.sd.listChoiseMainName
                                                  .length +
                                              1,
                              scrollDirection: Axis.vertical,
                              controller: _scrollController,
                              itemBuilder: (context, index) {
                                return index ==
                                        widget.sd.listChoiseMainName.length
                                    ? Card(
                                        elevation: 5,
                                        child: ListTile(
                                          title: const Center(
                                            child: Icon(
                                              Icons.add,
                                              size: 30,
                                              color: Colors.blue,
                                            ),
                                          ),
                                          onTap: () {
                                            listChoiceDialog(
                                                widget.sd, context, false, 0);
                                          },
                                        ),
                                      )
                                    : Card(
                                        elevation: 5,
                                        child: Container(
                                            decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5))),
                                            clipBehavior: Clip.hardEdge,
                                            child: Slidable(
                                                key: Key(widget.sd
                                                    .listChoiseMainName[index]),
                                                actionPane:
                                                    const SlidableScrollActionPane(),
                                                secondaryActions: [
                                                  IconSlideAction(
                                                    caption:
                                                        "delete.label".tr(),
                                                    color: Colors.red,
                                                    icon: Icons.delete,
                                                    onTap: () {
                                                      showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return AlertDialog(
                                                              title: Text(
                                                                  "are-you-sure-you-want-to-delete-this-item.label"
                                                                      .tr()),
                                                              actions: <Widget>[
                                                                TextButton(
                                                                  style: TextButton
                                                                      .styleFrom(
                                                                    backgroundColor:
                                                                        Colors
                                                                            .blue,
                                                                    textStyle:
                                                                        const TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                  child: Text(
                                                                    'no.label'
                                                                        .tr(),
                                                                    style: const TextStyle(
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                ),
                                                                TextButton(
                                                                  style: TextButton
                                                                      .styleFrom(
                                                                    backgroundColor:
                                                                        Colors
                                                                            .blue,
                                                                    textStyle:
                                                                        const TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                  child: Text(
                                                                    'yes.label'
                                                                        .tr(),
                                                                    style: const TextStyle(
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                  onPressed:
                                                                      () async {
                                                                    setState(
                                                                        () {
                                                                      widget.sd
                                                                          .listChoiseMainName
                                                                          .removeAt(
                                                                              index);
                                                                      widget.sd
                                                                          .listChoiseMainType
                                                                          .removeAt(
                                                                              index);
                                                                      widget.sd
                                                                          .listChoiseMainNumber
                                                                          .removeAt(
                                                                              index);
                                                                    });
                                                                    SharedPreferences
                                                                        prefs =
                                                                        await SharedPreferences
                                                                            .getInstance();
                                                                    prefs.setStringList(
                                                                        '${widget.sd.nameDevice}-listChoiseMain.name',
                                                                        widget
                                                                            .sd
                                                                            .listChoiseMainName);
                                                                    prefs.setStringList(
                                                                        '${widget.sd.nameDevice}-listChoiseMain.type',
                                                                        widget
                                                                            .sd
                                                                            .listChoiseMainType);
                                                                    prefs.setStringList(
                                                                        '${widget.sd.nameDevice}-listChoiseMain.number',
                                                                        widget
                                                                            .sd
                                                                            .listChoiseMainNumber);
                                                                    // ignore: use_build_context_synchronously
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                ),
                                                              ],
                                                            );
                                                          });
                                                    },
                                                  )
                                                ],
                                                child: ListTile(
                                                  title: Text(widget.sd
                                                          .listChoiseMainName[
                                                      index]),
                                                  leading: const Icon(
                                                    Icons.lightbulb,
                                                    size: 30,
                                                    color: Colors.blue,
                                                  ),
                                                  trailing: SizedBox(
                                                      width: index ==
                                                                  widget.sd
                                                                      .termostatNumber ||
                                                              index ==
                                                                  widget.sd
                                                                      .humidityTermostatNumber
                                                          ? 179
                                                          : 59,
                                                      height: 40,
                                                      child: Row(
                                                        children: [
                                                          index ==
                                                                      widget.sd
                                                                          .termostatNumber ||
                                                                  index ==
                                                                      widget.sd
                                                                          .humidityTermostatNumber
                                                              ? Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Colors
                                                                            .blue[
                                                                        200],
                                                                    borderRadius: const BorderRadius
                                                                            .all(
                                                                        Radius.circular(
                                                                            5.0)),
                                                                    boxShadow: [
                                                                      BoxShadow(
                                                                        color: Colors
                                                                            .grey
                                                                            .withOpacity(0.5),
                                                                        spreadRadius:
                                                                            5,
                                                                        blurRadius:
                                                                            7,
                                                                        offset: const Offset(
                                                                            0,
                                                                            3), // changes position of shadow
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  width: 120,
                                                                  height: 37,
                                                                  child:
                                                                      SpinBox(
                                                                    iconColor: MaterialStateProperty.all<
                                                                        Color>(widget
                                                                            .theme
                                                                            .switchValueTheme()
                                                                        ? Colors
                                                                            .white
                                                                        : Colors
                                                                            .black),
                                                                    cursorColor:
                                                                        Colors
                                                                            .blue,
                                                                    decoration:
                                                                        const InputDecoration(
                                                                      contentPadding:
                                                                          EdgeInsets.only(
                                                                              top: 50),
                                                                    ),
                                                                    spacing: 3,
                                                                    decimals: 1,
                                                                    step: 0.1,
                                                                    min: 0.0,
                                                                    max: 50.0,
                                                                    value:
                                                                        valueCheck,
                                                                    onChanged:
                                                                        (value) {
                                                                      setState(
                                                                          () {
                                                                        valueCheck =
                                                                            value;
                                                                      });
                                                                    },
                                                                  ))
                                                              : const SizedBox(),
                                                          CupertinoSwitch(
                                                            value: widget.sd.listChoiseMainType[
                                                                        index] ==
                                                                    'rele'
                                                                ? widget.sd.releAll[int.tryParse(widget.sd.listChoiseMainNumber[
                                                                            index])!] ==
                                                                        1
                                                                    ? true
                                                                    : false
                                                                : widget.sd.motor[int.tryParse(widget
                                                                            .sd
                                                                            .listChoiseMainNumber[index])!] ==
                                                                        1
                                                                    ? true
                                                                    : false,
                                                            onChanged: (value) {
                                                              setState(() {
                                                                if (value) {
                                                                  if (widget.sd
                                                                              .listChoiseMainType[
                                                                          index] ==
                                                                      'rele') {
                                                                    widget.sd
                                                                        .releAll[int.tryParse(widget
                                                                            .sd
                                                                            .listChoiseMainNumber[
                                                                        index])!] = 1;
                                                                    if (int.tryParse(widget
                                                                            .sd
                                                                            .listChoiseMainNumber[index])! >=
                                                                        10) {
                                                                      sendCommand(
                                                                          "/RELE=ONN${widget.sd.listChoiseMainNumber[index]}",
                                                                          widget
                                                                              .sd);
                                                                    } else {
                                                                      sendCommand(
                                                                          "/RELE=ON${widget.sd.listChoiseMainNumber[index]}",
                                                                          widget
                                                                              .sd);
                                                                    }
                                                                  } else {
                                                                    if (widget
                                                                            .sd
                                                                            .motor[int.tryParse(widget
                                                                                .sd.listChoiseMainNumber[
                                                                            index])!] ==
                                                                        2) {
                                                                      //Not calibrated
                                                                      listCalibrationMotorFromAllList(
                                                                          widget
                                                                              .sd,
                                                                          context,
                                                                          int.tryParse(widget
                                                                              .sd
                                                                              .listChoiseMainNumber[index])!);
                                                                    } else {
                                                                      if (int.tryParse(widget
                                                                              .sd
                                                                              .listChoiseMainNumber[index])! >=
                                                                          10) {
                                                                        widget
                                                                            .sd
                                                                            .motor[int.tryParse(widget
                                                                                .sd.listChoiseMainNumber[
                                                                            index])!] = 1;
                                                                        sendCommand(
                                                                            "/M=ONN${widget.sd.listChoiseMainNumber[index]}",
                                                                            widget.sd);
                                                                      } else {
                                                                        widget
                                                                            .sd
                                                                            .motor[int.tryParse(widget
                                                                                .sd.listChoiseMainNumber[
                                                                            index])!] = 1;
                                                                        sendCommand(
                                                                            "/M=ON${widget.sd.listChoiseMainNumber[index]}",
                                                                            widget.sd);
                                                                      }
                                                                    }
                                                                  }
                                                                } else {
                                                                  if (widget.sd
                                                                              .listChoiseMainType[
                                                                          index] ==
                                                                      'rele') {
                                                                    widget.sd
                                                                        .releAll[int.tryParse(widget
                                                                            .sd
                                                                            .listChoiseMainNumber[
                                                                        index])!] = 0;
                                                                    if (int.tryParse(widget
                                                                            .sd
                                                                            .listChoiseMainNumber[index])! >=
                                                                        10) {
                                                                      sendCommand(
                                                                          "/RELE=OFFF${widget.sd.listChoiseMainNumber[index]}",
                                                                          widget
                                                                              .sd);
                                                                    } else {
                                                                      sendCommand(
                                                                          "/RELE=OFF${widget.sd.listChoiseMainNumber[index]}",
                                                                          widget
                                                                              .sd);
                                                                    }
                                                                  } else {
                                                                    if (widget
                                                                            .sd
                                                                            .motor[int.tryParse(widget
                                                                                .sd.listChoiseMainNumber[
                                                                            index])!] ==
                                                                        2) {
                                                                      //Not calibrated
                                                                      listCalibrationMotorFromAllList(
                                                                          widget
                                                                              .sd,
                                                                          context,
                                                                          int.tryParse(widget
                                                                              .sd
                                                                              .listChoiseMainNumber[index])!);
                                                                    } else {
                                                                      if (int.tryParse(widget
                                                                              .sd
                                                                              .listChoiseMainNumber[index])! >=
                                                                          10) {
                                                                        widget
                                                                            .sd
                                                                            .motor[int.tryParse(widget
                                                                                .sd.listChoiseMainNumber[
                                                                            index])!] = 0;
                                                                        sendCommand(
                                                                            "/M=OFFF${widget.sd.listChoiseMainNumber[index]}",
                                                                            widget.sd);
                                                                      } else {
                                                                        widget
                                                                            .sd
                                                                            .motor[int.tryParse(widget
                                                                                .sd.listChoiseMainNumber[
                                                                            index])!] = 0;
                                                                        sendCommand(
                                                                            "/M=OFF${widget.sd.listChoiseMainNumber[index]}",
                                                                            widget.sd);
                                                                      }
                                                                    }
                                                                  }
                                                                }
                                                              });
                                                            },
                                                          ),
                                                        ],
                                                      )),
                                                  onLongPress: () {
                                                    listChoiceDialog(widget.sd,
                                                        context, true, index);
                                                  },
                                                ))),
                                      );
                              })
                        ]),
                        /*TextButton(
                    child: const Text("On", style: TextStyle(fontSize: 20.0)),
                    onPressed: () async {
                      await sendCommand("/RELE=ON0", widget.sd);
                      setState(() {});
                    },
                  ),
                  TextButton(
                    child: const Text("Off", style: TextStyle(fontSize: 20.0)),
                    onPressed: () async {
                      await sendCommand("/RELE=OFF0", widget.sd);
                      setState(() {});
                    },
                  ),*/
                        Text(widget.sd.textSpeech),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                  padding: EdgeInsets.zero,
                                  child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ControlPage(
                                              sd: widget.sd,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Column(children: <Widget>[
                                        Container(
                                          height: 35,
                                          padding:
                                              const EdgeInsets.only(top: 0),
                                          child: SvgPicture.asset(
                                            'images/control.svg',
                                            color: Colors.blue,
                                            height: 35,
                                            width: 35,
                                          ),
                                        ),
                                        Container(
                                            padding:
                                                const EdgeInsets.only(top: 0),
                                            child: Text(
                                              "control.label"
                                                  .tr(), // zmiana nazwy
                                              textAlign: TextAlign.center,
                                              style:
                                                  const TextStyle(fontSize: 14),
                                            )),
                                      ]))),
                              AvatarGlow(
                                animate: widget.sd.isListening,
                                glowColor: widget.sd.isListening
                                    ? Colors.blue
                                    : Colors.red,
                                endRadius: 75.0,
                                repeat: true,
                                child: FloatingActionButton(
                                  backgroundColor: widget.sd.isListening
                                      ? Colors.blue
                                      : Colors.red,
                                  onPressed: () async {
                                    setState(() {
                                      listenSpeak(widget.sd, (value) {
                                        widget.sd.textSpeech = value;
                                      }, (value) {
                                        widget.sd.isListening = value;
                                      });
                                    });
                                    for (int i = 0;
                                        i < widget.sd.nameCommandVoice.length;
                                        i++) {
                                      if (widget.sd.nameCommandVoice[i] ==
                                          widget.sd.textSpeech) {
                                        if (widget.sd.typeCommandVoice[i] ==
                                            'Rele') {
                                          if (int.tryParse(widget
                                                  .sd.numberCommandVoice[i])! >
                                              9) {
                                            if (widget
                                                    .sd.onOffCommandVoice[i] ==
                                                'off') {
                                              await sendCommand(
                                                  "/RELE=OFFF${widget.sd.numberCommandVoice[i]}",
                                                  widget.sd);
                                            } else {
                                              await sendCommand(
                                                  "/RELE=ONN${widget.sd.numberCommandVoice[i]}",
                                                  widget.sd);
                                            }
                                          } else {
                                            if (widget
                                                    .sd.onOffCommandVoice[i] ==
                                                'off') {
                                              await sendCommand(
                                                  "/RELE=OFF${widget.sd.numberCommandVoice[i]}",
                                                  widget.sd);
                                            } else {
                                              await sendCommand(
                                                  "/RELE=ON${widget.sd.numberCommandVoice[i]}",
                                                  widget.sd);
                                            }
                                          }
                                        }
                                        if (widget.sd.typeCommandVoice[i] ==
                                            'Motor') {
                                          if (int.tryParse(widget
                                                  .sd.numberCommandVoice[i])! >
                                              9) {
                                            if (widget
                                                    .sd.onOffCommandVoice[i] ==
                                                'off') {
                                              await sendCommand(
                                                  "/M=OFFF${widget.sd.numberCommandVoice[i]}",
                                                  widget.sd);
                                            } else {
                                              await sendCommand(
                                                  "/M=ONN${widget.sd.numberCommandVoice[i]}",
                                                  widget.sd);
                                            }
                                          } else {
                                            if (widget
                                                    .sd.onOffCommandVoice[i] ==
                                                'off') {
                                              await sendCommand(
                                                  "/M=OFF${widget.sd.numberCommandVoice[i]}",
                                                  widget.sd);
                                            } else {
                                              await sendCommand(
                                                  "/M=ON${widget.sd.numberCommandVoice[i]}",
                                                  widget.sd);
                                            }
                                          }
                                        }
                                      }
                                    }
                                  },
                                  child: Icon(widget.sd.isListening
                                      ? Icons.mic
                                      : Icons.mic_off),
                                ),
                              ),
                              Container(
                                  padding: EdgeInsets.zero,
                                  child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                CalibrationPage(
                                              sd: widget.sd,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Column(children: <Widget>[
                                        const Icon(
                                          Icons.published_with_changes_sharp,
                                          size: 35,
                                          color: Colors.blue,
                                        ),
                                        Container(
                                            padding:
                                                const EdgeInsets.only(top: 0),
                                            child: Text(
                                              "calibration.label"
                                                  .tr(), // zmiana nazwy
                                              textAlign: TextAlign.center,
                                              style:
                                                  const TextStyle(fontSize: 14),
                                            )),
                                      ]))),
                            ])
                      ],
                    )))
    ]);
  }
}
