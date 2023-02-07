// ignore_for_file: file_names

class SmartDevice {
  final String nameDevice;
  SmartDevice(this.nameDevice);

  bool connected = true;
  String nameDeviceClient = '';
  bool showDialogLostConnect = true;
  int breakConnect = 0;
  double temperatura = 0;
  double humidity = 0;
  int pressure = 0;
  int weather = 0;
  List<int> motor = [];
  List<int> releAll = [];
  bool isListening = false;
  String textSpeech = '';
  bool onceReadListChoice = true;
  //value for first page list
  List<String> listChoiseMainName = [];
  List<String> listChoiseMainType = [];
  List<String> listChoiseMainNumber = [];
  // list for voice
  List<String> nameCommandVoice = ['Включи свет в комнате'];
  List<String> typeCommandVoice = ['Rele'];
  List<String> numberCommandVoice = ['3'];
  List<String> onOffCommandVoice = ['on'];
}

/*class ListCommandForVoice {
  String name;
  String type;
  int? number;
  bool commandOnOrOff;
  ListCommandForVoice(this.name, this.type, this.number, this.commandOnOrOff);
}*/
