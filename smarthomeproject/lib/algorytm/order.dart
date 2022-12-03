import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:smarthomeproject/algorytm/smartDevice.dart';

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
    try {
      handleClient(socked, sd);
    } catch (e) {
      if (kDebugMode) {
        print("Already read!");
      }
      socked.close();
    }
  } catch (e) {
    if (kDebugMode) {
      print("Error! can not connect WS connectWs $e");
    }
  }
}

getDataFromDevice(SmartDevice sd) async {
  //int timerPeriod = 0;
  Timer.periodic(const Duration(milliseconds: 30000), (timer) async {
    //timerPeriod = 30000;
    try {
      Socket socked = await Socket.connect('192.168.0.${sd.nameDevice}', 80);
      try {
        handleClient(socked, sd);
        //socked.close();
      } catch (e) {
        if (kDebugMode) {
          print("Already read!");
        }
        socked.close();
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error! can not connect WS connectWs $e");
      }
    }
  });
}

void handleClient(Socket client, SmartDevice sd) {
  String reply = '';
  client.listen((data) {
    if (kDebugMode) {
      print("client listen : ${String.fromCharCodes(data).trim()}");
      reply = String.fromCharCodes(data).trim();
      print("Reply: $reply");
    }
  }, onDone: () {
    if (kDebugMode) {
      print("server done");
      client.close();
    }
  });
}
