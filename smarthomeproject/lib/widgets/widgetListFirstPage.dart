import 'package:flutter/material.dart';
import 'package:smarthomeproject/algorytm/order.dart';
import 'package:smarthomeproject/algorytm/smartDevice.dart';

class ListDeviceWidget extends StatefulWidget {
  final SmartDevice sd;

  const ListDeviceWidget({super.key, required this.sd});
  @override
  ListDeviceWidgetState createState() => ListDeviceWidgetState();
}

class ListDeviceWidgetState extends State<ListDeviceWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Card(
          elevation: 5,
          child: ExpansionTile(
            title: Text(widget.sd.nameDevice),
            children: [
              TextButton(
                child: const Text("On", style: TextStyle(fontSize: 20.0)),
                onPressed: () {
                  setState(() {
                    sendCommand("/RELE=ON0", widget.sd);
                    //widget.channel.write("/RELE=ON0");
                  });
                },
              ),
              TextButton(
                child: const Text("Off", style: TextStyle(fontSize: 20.0)),
                onPressed: () {
                  setState(() {
                    sendCommand("/RELE=OFF0", widget.sd);
                    //widget.channel.write("/RELE=OFF0");
                  });
                },
              ),
            ],
          ))
    ]);
  }
}
