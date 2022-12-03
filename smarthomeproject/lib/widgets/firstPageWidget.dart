import 'package:flutter/material.dart';
import 'package:smarthomeproject/algorytm/order.dart';
import 'package:smarthomeproject/algorytm/smartDevice.dart';
import 'package:smarthomeproject/widgets/widgetListFirstPage.dart';

// ignore: must_be_immutable
class MainPage extends StatefulWidget {
  final List<String> smartDeviceList = [];

  MainPage({super.key});
  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  final _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Smart Home'),
          leading: IconButton(
            onPressed: () {
              //setState(() {
              TextEditingController writeC = TextEditingController();
              bool connected = false;
              //writeC.text = _dev.bluetoothPassword;
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    backgroundColor: Colors.white,

                    ///darkModeOn ? Colors.grey[900] : Colors.white,
                    title: Container(
                        color: Theme.of(context).iconTheme.color,
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Write IP adress device!',
                            style: TextStyle(color: Colors.white),
                          ),
                        )),
                    content: TextField(
                      decoration: const InputDecoration(labelText: "IP:"),
                      controller: writeC,
                      keyboardType: TextInputType.number,
                    ),
                    actions: <Widget>[
                      TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Theme.of(context).iconTheme.color,
                          textStyle: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        child: const Text('Cancel',
                            style: TextStyle(color: Colors.white)),
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
                        child: const Text(
                          "Ok",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () async {
                          connected =
                              await connectSocket(writeC.text.toString());
                          if (connected) {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    backgroundColor: Colors
                                        .white, //darkModeOn ? Colors.grey[900] : Colors.white,
                                    title: const Text('Device is connected!'),
                                    actions: <Widget>[
                                      TextButton(
                                        style: TextButton.styleFrom(
                                          backgroundColor:
                                              Theme.of(context).iconTheme.color,
                                          textStyle: const TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                        child: const Text(
                                          'Ok',
                                          style: TextStyle(color: Colors.white),
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
                            if (!widget.smartDeviceList
                                .contains(writeC.text.toString())) {
                              widget.smartDeviceList
                                  .add(writeC.text.toString());
                              SmartDevice(widget.smartDeviceList.last)
                                  .getData();
                              await sendCommand(
                                  "", SmartDevice(widget.smartDeviceList.last));
                            }
                          } else {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    backgroundColor: Colors
                                        .white, //darkModeOn ? Colors.grey[900] : Colors.white,
                                    title: const Text(
                                        'Device is not connected! Do you want to repeat?'),
                                    actions: <Widget>[
                                      TextButton(
                                        style: TextButton.styleFrom(
                                          backgroundColor: Colors.red,
                                          textStyle: const TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                        child: const Text(
                                          'No',
                                          style: TextStyle(color: Colors.white),
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
                                        child: const Text(
                                          'Yes',
                                          style: TextStyle(color: Colors.white),
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
        ),
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
