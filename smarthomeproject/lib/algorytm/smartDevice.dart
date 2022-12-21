import 'package:flutter/material.dart';
import 'package:smarthomeproject/algorytm/order.dart';

class SmartDevice {
  final String nameDevice;
  SmartDevice(this.nameDevice);
  getData(SmartDevice sd) async {
    getDataFromDevice(sd);
  }

  double temperatura = 0;
  double humidity = 0;
  int pressure = 0;
  int weather = 0;
  int motor0 = 0;
  List<int> releAll = [];
}
