import 'package:flutter/material.dart';
import 'package:smarthomeproject/algorytm/order.dart';

/*void searchSmartDevice(BuildContext context) {
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
            child: const Text('Cancel', style: TextStyle(color: Colors.white)),
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
            onPressed: () {
              connected = connectSocket(writeC.toString());
              Navigator.pop(context);
              if (connected) {
                answerForConnect('Device connected!', context);
                SmartDevice sd = SmartDevice(writeC.toString());
              } else {
                answerForConnect(
                    'Device is not connected! Do you want to repeat?', context);
              }
            },
          ),
        ],
      );
    },
  );
}

void answerForConnect(String answer, BuildContext context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor:
              Colors.white, //darkModeOn ? Colors.grey[900] : Colors.white,
          title: Text(answer),
          actions: <Widget>[
            answer == 'Device is not connected! Do you want to repeat?'
                ? TextButton(
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
                    },
                  )
                : Container(),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor:
                    answer == 'Device is not connected! Do you want to repeat?'
                        ? Colors.green
                        : Theme.of(context).iconTheme.color,
                textStyle: const TextStyle(
                  color: Colors.white,
                ),
              ),
              child: Text(
                answer == 'Device is not connected! Do you want to repeat?'
                    ? 'Yes'
                    : 'Ok',
                style: const TextStyle(color: Colors.white),
              ),
              onPressed: () {
                if (answer ==
                    'Device is not connected! Do you want to repeat?') {
                  Navigator.pop(context);
                  searchSmartDevice(context);
                } else {
                  Navigator.pop(context);
                }
              },
            ),
          ],
        );
      });
}*/
