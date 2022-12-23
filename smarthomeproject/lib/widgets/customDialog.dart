import 'package:flutter/material.dart';
import 'package:smarthomeproject/algorytm/order.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:smarthomeproject/algorytm/smartDevice.dart';

//void searchSmartDevice(BuildContext context) {
void lostDevice(SmartDevice sd, BuildContext context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
              "${"Lost-connection-to-device.label".tr()}${sd.nameDevice}!${"Try-to-connect-to-the-device.label".tr()}"),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.blue,
                textStyle: const TextStyle(
                  color: Colors.white,
                ),
              ),
              child: Text(
                'ok.label'.tr(),
                style: const TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      });
}
