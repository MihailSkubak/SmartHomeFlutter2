import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:smarthomeproject/algorytm/smartDevice.dart';

/*connectSocket(String command, String typeDevice) async {
  try {
    String ipDevice = '';
    if (typeDevice == '119') {
      ipDevice = '192.168.0.119';
    } else if (typeDevice == '145') {
      ipDevice = '192.168.0.145';
    }
    Socket socked = await Socket.connect(ipDevice, 80);
    socked.write(command);
    try {
      socked.listen(handleClient);
    } catch (e) {
      if (kDebugMode) {
        print("Already read!");
      }
    }
  } catch (e) {
    if (kDebugMode) {
      print("Error! can not connect WS connectWs $e");
    }
  }
}*/
connectSocket(String ipDevice) async {
  try {
    Socket socked = await Socket.connect('192.168.0.$ipDevice', 80);
    return true;
  } catch (e) {
    if (kDebugMode) {
      print("Error! can not connect WS connectWs $e");
    }
    return false;
  }
}

sendCommand(String command, SmartDevice sd) async {
  try {
    Socket socked = await Socket.connect('192.168.0.${sd.nameDevice}', 80);
    socked.write(command);
  } catch (e) {
    if (kDebugMode) {
      print("Error! can not connect WS connectWs $e");
    }
  }
}

void handleClient(Uint8List data) {
  // Show the address and port of the client
  /*print('Connection from '
        '${socket.remoteAddress.address}:${socket.remotePort}');*/

  // Show what the client said
  if (kDebugMode) {
    print("client listen : ${String.fromCharCodes(data).trim()}");
  }
  /*widget.channel.close();
    connectSocket();*/
  // Send acknowledgement to client
  //socket.write("Hello from simple server!\n");
}
