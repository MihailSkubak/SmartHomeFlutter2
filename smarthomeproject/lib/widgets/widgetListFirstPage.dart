import 'dart:async';
import 'package:flutter/material.dart';
import 'package:smarthomeproject/algorytm/order.dart';
import 'package:smarthomeproject/algorytm/smartDevice.dart';
import 'package:smarthomeproject/widgets/customDialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:smarthomeproject/algorytm/globalValue.dart' as globals;

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
    //widget.sd.lostConnect = false;
    widget.sd.showDialogLostConnect = true;
    getDataFromDevice(widget.sd, context);
    sendCommand("", widget.sd);
  }

  PopupMenuItem _buildPopupMenuItem(String title, IconData iconData) {
    return PopupMenuItem(
      onTap: () {
        if (!widget.sd.connected) {
          setState(() {
            widget.sd.connected = true;
            //widget.sd.lostConnect = false;
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
            //TabDownDetails details;
            /*RenderBox renderBox =
                stationKey.currentContext?.findRenderObject() as RenderBox;
            Offset offset = renderBox.localToGlobal(Offset.zero);*/
            /*PopupMenuButton(
              itemBuilder: (ctx) => [
                _buildPopupMenuItem(
                    widget.sd.connected ? 'Connected' : 'Disconnected',
                    Icons.wifi),
              ],
            );*/
            showMenu(
                context: context,
                position: RelativeRect.fromLTRB(
                    detail.globalPosition.dx + 65,
                    detail.globalPosition.dy + 0,
                    detail.globalPosition.dx + 65,
                    detail.globalPosition.dy + 0),
                items: [
                  _buildPopupMenuItem(
                      widget.sd.connected
                          ? 'disconnected.label'.tr()
                          : 'connected.label'.tr(),
                      Icons.wifi)
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
                    size: 20,
                    color: widget.sd.connected ? Colors.blue : Colors.red,
                  ),
                ]),
                children: [
                  Text("Temperatura : ${widget.sd.temperatura.toString()}"),
                  TextButton(
                    child: const Text("On", style: TextStyle(fontSize: 20.0)),
                    onPressed: () async {
                      await sendCommand("/RELE=ON0", widget.sd);
                      setState(() {
                        //widget.channel.write("/RELE=ON0");
                      });
                    },
                  ),
                  TextButton(
                    child: const Text("Off", style: TextStyle(fontSize: 20.0)),
                    onPressed: () async {
                      await sendCommand("/RELE=OFF0", widget.sd);
                      setState(() {
                        //widget.channel.write("/RELE=OFF0");
                      });
                    },
                  ),
                ],
              )))
    ]);
  }
}
