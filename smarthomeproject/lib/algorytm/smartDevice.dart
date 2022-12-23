// ignore_for_file: file_names

class SmartDevice {
  final String nameDevice;
  SmartDevice(this.nameDevice);

  bool connected = true;
  bool showDialogLostConnect = true;
  int breakConnect = 0;
  double temperatura = 0;
  double humidity = 0;
  int pressure = 0;
  int weather = 0;
  int motor0 = 0;
  List<int> releAll = [];
}
