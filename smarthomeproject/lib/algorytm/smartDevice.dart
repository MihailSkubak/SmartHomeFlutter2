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
  List<int> motor = [];
  List<int> releAll = [];
  bool isListening = false;
  String textSpeech = '';
  bool onceReadListChoice = true;
  //List<bool> listChoiceRele = [];
  //List<bool> listChoiceMotor = [];
  //List<listChoice> listChoiseMain = [];
  List<String> listChoiseMainName = [];
  List<String> listChoiseMainType = [];
  List<String> listChoiseMainNumber = [];
}

/*class listChoice {
  String name;
  String type;
  int? number;
  listChoice(this.name, this.type, this.number);
}*/
