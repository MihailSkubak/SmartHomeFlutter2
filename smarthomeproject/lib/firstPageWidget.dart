import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:web_socket_channel/io.dart';

//smt here
//apply this class on home: attribute at MaterialApp()
class WebSocketLed extends StatefulWidget {
  const WebSocketLed({super.key});
  @override
  State<StatefulWidget> createState() {
    return _WebSocketLed();
  }
}

class _WebSocketLed extends State<WebSocketLed> {
  bool ledstatus = false; //boolean value to track LED status, if its ON or OFF
  IOWebSocketChannel channel =
      IOWebSocketChannel.connect("ws://192.168.0.2:81");
  bool connected = false; //boolean value to track if WebSocket is connected
  @override
  void initState() {
    ledstatus = false; //initially leadstatus is off so its FALSE
    connected = false; //initially connection status is "NO" so its FALSE

    Future.delayed(Duration.zero, () async {
      channelconnect(); //connect to WebSocket wth NodeMCU
    });

    super.initState();
  }

  channelconnect() {
    //function to connect
    try {
      channel = IOWebSocketChannel.connect(
          "ws://192.168.0.2:81"); //channel IP : Port//Tutaj: ws://
      //connected = true;
      channel.stream.listen(
        (message) {
          print(message);
          setState(() {
            if (message == "connected") {
              connected = true; //message is "connected" from NodeMCU
            } else if (message == "RELE=ON0") {
              ledstatus = true;
            } else if (message == "RELE=OFF0") {
              ledstatus = false;
            }
          });
        },
        onDone: () {
          //if WebSocket is disconnected
          print("Web socket is closed");
          setState(() {
            connected = false;
          });
        },
        onError: (error) {
          print(error.toString());
        },
      );
    } catch (_) {
      print("error on connecting to websocket.");
    }
  }

  Future<void> sendcmd(String cmd) async {
    /*if (connected == true) {
      if (ledstatus == false && cmd != "poweron" && cmd != "poweroff") {
        print("Send the valid command");
      } else {
        channel.sink.add(cmd); //sending Command to NodeMCU
      }
    } else {
      channelconnect();
      print("Websocket is not connected.");
    }*/
    channel.sink.add(cmd);
    channelconnect();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("LED - ON/OFF NodeMCU"),
          backgroundColor: Colors.redAccent),
      body: Container(
          alignment: Alignment.topCenter, //inner widget alignment to center
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                  child: connected
                      ? Text("WEBSOCKET: CONNECTED")
                      : Text("DISCONNECTED")),
              Container(
                  child: ledstatus ? Text("LED IS: ON") : Text("LED IS: OFF")),
              Container(
                  margin: EdgeInsets.only(top: 30),
                  child: TextButton(
                      onPressed: () {
                        //on button press
                        sendcmd("RELE=ON0");
                        /*if (ledstatus) {
                          //if ledstatus is true, then turn off the led
                          //if led is on, turn off
                          sendcmd("poweroff");
                          ledstatus = false;
                        } else {
                          //if ledstatus is false, then turn on the led
                          //if led is off, turn on
                          sendcmd("poweron");
                          ledstatus = true;
                        }*/
                        setState(() {});
                      },
                      child: ledstatus
                          ? Text("TURN LED OFF")
                          : Text("TURN LED ON")))
            ],
          )),
    );
  }
}
