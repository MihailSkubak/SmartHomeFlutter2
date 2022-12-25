// ignore_for_file: file_names

import 'dart:async';
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

class ListDeviceWidget extends StatefulWidget {
  final SmartDevice sd;

  const ListDeviceWidget({super.key, required this.sd});
  @override
  ListDeviceWidgetState createState() => ListDeviceWidgetState();
}

class ListDeviceWidgetState extends State<ListDeviceWidget> {
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

  @override
  void initState() {
    super.initState();
    if (!globals.objectSmartDevice.contains(widget.sd)) {
      globals.objectSmartDevice.add(widget.sd);
    }
    widget.sd.showDialogLostConnect = true;
    getDataFromDevice(widget.sd, context);
    sendCommand("", widget.sd);
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
      onTap: () {},
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
              child: ExpansionTile(
                leading: const Icon(
                  Icons.maps_home_work_sharp,
                  size: 45,
                ),
                title: Text(widget.sd.nameDevice),
                subtitle: Row(children: [
                  Icon(
                    Icons.wifi,
                    size: 22,
                    color: widget.sd.connected ? Colors.blue : Colors.red,
                  ),
                  Row(children: [
                    const Icon(
                      Icons.thermostat,
                      size: 20,
                      color: Colors.blue,
                    ),
                    Text('${widget.sd.temperatura.toStringAsFixed(1)}°C  ')
                  ]),
                  Row(children: [
                    const Icon(
                      Icons.water_drop,
                      size: 20,
                      color: Colors.blue,
                    ),
                    Text('${widget.sd.humidity.toStringAsFixed(1)} %')
                  ]),
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
                          ))),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 5),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(children: [
                        const Icon(
                          Icons.speed_rounded,
                          size: 30,
                          color: Colors.blue,
                        ),
                        Text(' ${widget.sd.pressure}${'mm.label'.tr()}')
                      ]),
                      Row(children: [
                        widget.sd.weather > 0 && widget.sd.temperatura <= 1.5
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
                        Text(' ${widget.sd.weather.toString()} %')
                      ]),
                    ],
                  ),
                  TextButton(
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
                  ),
                  Text(widget.sd.textSpeech),
                  AvatarGlow(
                    animate: widget.sd.isListening,
                    glowColor: widget.sd.isListening ? Colors.blue : Colors.red,
                    endRadius: 75.0,
                    //duration: const Duration(milliseconds: 2000),
                    //repeatPauseDuration: const Duration(milliseconds: 100),
                    repeat: true,
                    child: FloatingActionButton(
                      backgroundColor:
                          widget.sd.isListening ? Colors.blue : Colors.red,
                      onPressed: () {
                        setState(() {
                          listenSpeak(widget.sd, (value) {
                            widget.sd.textSpeech = value;
                          }, (value) {
                            widget.sd.isListening = value;
                          });
                        });
                      },
                      child: Icon(
                          widget.sd.isListening ? Icons.mic : Icons.mic_off),
                    ),
                  )
                ],
              )))
    ]);
  }
}
