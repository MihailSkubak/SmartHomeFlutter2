import 'package:flutter/material.dart';
import 'package:smarthomeproject/algorytm/order.dart';

class SmartDevice {
  final String nameDevice;
  SmartDevice(this.nameDevice);
  getData() async {
    getDataFromDevice(SmartDevice(nameDevice));
  }
}
