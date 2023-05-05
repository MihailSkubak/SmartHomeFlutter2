import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:smarthomeproject/algorytm/smartDevice.dart';
import 'package:smarthomeproject/widgets/customDialog.dart';

connectSocket(String ipDevice) async {
  try {
    // ignore: unused_local_variable
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

getDataFromDevice(SmartDevice sd, context) {
  Timer.periodic(const Duration(milliseconds: 20000), (timer) async {
    if (sd.connected) {
      try {
        Socket socked = await Socket.connect('192.168.0.${sd.nameDevice}', 80);
        try {
          sd.connected = true;
          sd.breakConnect = 0;
          handleClient(socked, sd);
        } catch (e) {
          if (kDebugMode) {
            print("Already read!");
          }
          socked.close();
        }
      } catch (e) {
        if (kDebugMode) {
          print('Lost Connected!!!');
        }
        if (sd.breakConnect == 1) {
          timer.cancel();
          sd.connected = false;
          sd.breakConnect = 0;
          if (sd.showDialogLostConnect) {
            sd.showDialogLostConnect = false;
            lostDevice(sd, context);
          }
        } else {
          sd.breakConnect++;
        }
      }
    } else {
      if (kDebugMode) {
        print('Disconnected!!!');
      }
      timer.cancel();
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
      if (reply.length > 10) {
        sd.releAll = [];
        sd.motor = [];
        if (sd.nameDevice == '145') {
          bool start = false;
          String out = '';
          int index = 0;
          for (int i = 0; i < reply.length; i++) {
            String tmp = reply.substring(i, i + 1);
            if (tmp.compareTo(",") == 0) start = true;
            if (tmp.compareTo(";") == 0) start = true;
            if (!start) {
              out += tmp;
            }
            if (start) {
              out = out.substring(0, out.length);
              if (index == 0) {
                try {
                  out = out.substring(3);
                  if (out == '/RELE=OFF0') sd.releAll.add(0);
                  if (out == '/RELE=ON0') sd.releAll.add(1);
                  if (out == 'non') sd.releAll.add(2);
                } catch (e) {
                  sd.releAll.add(2);
                }
              }
              if (index == 1) {
                try {
                  out = out.substring(3);
                  if (out == '/RELE=OFF1') sd.releAll.add(0);
                  if (out == '/RELE=ON1') sd.releAll.add(1);
                  if (out == 'non') sd.releAll.add(2);
                } catch (e) {
                  sd.releAll.add(2);
                }
              }
              if (index == 2) {
                try {
                  out = out.substring(3);
                  if (out == '/RELE=OFF2') sd.releAll.add(0);
                  if (out == '/RELE=ON2') sd.releAll.add(1);
                  if (out == 'non') sd.releAll.add(2);
                } catch (e) {
                  sd.releAll.add(2);
                }
              }
              if (index == 3) {
                try {
                  out = out.substring(3);
                  if (out == '/RELE=OFF3') sd.releAll.add(0);
                  if (out == '/RELE=ON3') sd.releAll.add(1);
                  if (out == 'non') sd.releAll.add(2);
                } catch (e) {
                  sd.releAll.add(2);
                }
              }
              /*if (index == 3) {
                if (sd.onceReadListChoice) {
                  if (sd.listChoiceRele.isEmpty) {
                    for (int i = 0; i < sd.releAll.length; i++) {
                      sd.listChoiceRele.add(false);
                    }
                  }
                  if (sd.listChoiceMotor.isEmpty) {
                    for (int i = 0; i < sd.motor.length; i++) {
                      sd.listChoiceMotor.add(false);
                    }
                  }
                  sd.onceReadListChoice = false;
                }
              }*/
              out = '';
              start = false;
              index++;
            }
          }
        }
        if (sd.nameDevice == '119') {
          bool start = false;
          String out = '';
          int index = 0;
          for (int i = 0; i < reply.length; i++) {
            String tmp = reply.substring(i, i + 1);
            if (tmp.compareTo(",") == 0) start = true;
            if (tmp.compareTo(";") == 0) start = true;
            if (!start) {
              out += tmp;
            }
            if (start) {
              out = out.substring(0, out.length);
              if (index == 0) {
                try {
                  out = out.substring(2);
                  sd.temperatura = double.tryParse(out)!;
                } catch (e) {
                  sd.temperatura = 0;
                }
              }
              if (index == 1) {
                try {
                  out = out.substring(2);
                  sd.humidity = double.tryParse(out)!;
                } catch (e) {
                  sd.humidity = 0;
                }
              }
              if (index == 2) {
                try {
                  out = out.substring(2);
                  sd.pressure = int.tryParse(out)!;
                } catch (e) {
                  sd.pressure = 0;
                }
              }
              if (index == 3) {
                try {
                  out = out.substring(2);
                  sd.weather = int.tryParse(out)!;
                } catch (e) {
                  sd.weather = 0;
                }
              }
              if (index == 4) {
                try {
                  out = out.substring(3);
                  sd.temperaturaHome = double.tryParse(out)!;
                } catch (e) {
                  sd.temperaturaHome = 0;
                }
              }
              if (index == 5) {
                try {
                  out = out.substring(3);
                  sd.humidityHome = double.tryParse(out)!;
                } catch (e) {
                  sd.humidityHome = 0;
                }
              }
              if (index == 6) {
                try {
                  out = out.substring(3);
                  if (out == '/M=OFF0') sd.motor.add(0);
                  if (out == '/M=ON0') sd.motor.add(1);
                  if (out == 'non') sd.motor.add(2);
                } catch (e) {
                  sd.motor.add(2);
                }
              }
              if (index == 7) {
                try {
                  out = out.substring(3);
                  if (out == '/M=OFF1') sd.motor.add(0);
                  if (out == '/M=ON1') sd.motor.add(1);
                  if (out == 'non') sd.motor.add(2);
                } catch (e) {
                  sd.motor.add(2);
                }
              }
              if (index == 8) {
                try {
                  out = out.substring(3);
                  if (out == '/M=OFF2') sd.motor.add(0);
                  if (out == '/M=ON2') sd.motor.add(1);
                  if (out == 'non') sd.motor.add(2);
                } catch (e) {
                  sd.motor.add(2);
                }
              }
              if (index == 9) {
                try {
                  out = out.substring(3);
                  if (out == '/M=OFF3') sd.motor.add(0);
                  if (out == '/M=ON3') sd.motor.add(1);
                  if (out == 'non') sd.motor.add(2);
                } catch (e) {
                  sd.motor.add(2);
                }
              }
              if (index == 10) {
                try {
                  out = out.substring(3);
                  if (out == '/RELE=OFF0') sd.releAll.add(0);
                  if (out == '/RELE=ON0') sd.releAll.add(1);
                  if (out == 'non') sd.releAll.add(2);
                } catch (e) {
                  sd.releAll.add(2);
                }
              }
              if (index == 11) {
                try {
                  out = out.substring(3);
                  if (out == '/RELE=OFF1') sd.releAll.add(0);
                  if (out == '/RELE=ON1') sd.releAll.add(1);
                  if (out == 'non') sd.releAll.add(2);
                } catch (e) {
                  sd.releAll.add(2);
                }
              }
              if (index == 12) {
                try {
                  out = out.substring(3);
                  if (out == '/RELE=OFF2') sd.releAll.add(0);
                  if (out == '/RELE=ON2') sd.releAll.add(1);
                  if (out == 'non') sd.releAll.add(2);
                } catch (e) {
                  sd.releAll.add(2);
                }
              }
              if (index == 13) {
                try {
                  out = out.substring(3);
                  if (out == '/RELE=OFF3') sd.releAll.add(0);
                  if (out == '/RELE=ON3') sd.releAll.add(1);
                  if (out == 'non') sd.releAll.add(2);
                } catch (e) {
                  sd.releAll.add(2);
                }
              }
              if (index == 14) {
                try {
                  out = out.substring(3);
                  if (out == '/RELE=OFF4') sd.releAll.add(0);
                  if (out == '/RELE=ON4') sd.releAll.add(1);
                  if (out == 'non') sd.releAll.add(2);
                } catch (e) {
                  sd.releAll.add(2);
                }
              }
              if (index == 15) {
                try {
                  out = out.substring(3);
                  if (out == '/RELE=OFF5') sd.releAll.add(0);
                  if (out == '/RELE=ON5') sd.releAll.add(1);
                  if (out == 'non') sd.releAll.add(2);
                } catch (e) {
                  sd.releAll.add(2);
                }
              }
              if (index == 16) {
                try {
                  out = out.substring(3);
                  if (out == '/RELE=OFF6') sd.releAll.add(0);
                  if (out == '/RELE=ON6') sd.releAll.add(1);
                  if (out == 'non') sd.releAll.add(2);
                } catch (e) {
                  sd.releAll.add(2);
                }
              }
              if (index == 17) {
                try {
                  out = out.substring(3);
                  if (out == '/RELE=OFF7') sd.releAll.add(0);
                  if (out == '/RELE=ON7') sd.releAll.add(1);
                  if (out == 'non') sd.releAll.add(2);
                } catch (e) {
                  sd.releAll.add(2);
                }
              }
              if (index == 18) {
                try {
                  out = out.substring(3);
                  if (out == '/RELE=OFF8') sd.releAll.add(0);
                  if (out == '/RELE=ON8') sd.releAll.add(1);
                  if (out == 'non') sd.releAll.add(2);
                } catch (e) {
                  sd.releAll.add(2);
                }
              }
              if (index == 19) {
                try {
                  out = out.substring(3);
                  if (out == '/RELE=OFF9') sd.releAll.add(0);
                  if (out == '/RELE=ON9') sd.releAll.add(1);
                  if (out == 'non') sd.releAll.add(2);
                } catch (e) {
                  sd.releAll.add(2);
                }
              }
              if (index == 20) {
                try {
                  out = out.substring(4);
                  if (out == '/RELE=OFFF10') sd.releAll.add(0);
                  if (out == '/RELE=ONN10') sd.releAll.add(1);
                  if (out == 'non') sd.releAll.add(2);
                } catch (e) {
                  sd.releAll.add(2);
                }
              }
              if (index == 21) {
                try {
                  out = out.substring(4);
                  if (out == '/RELE=OFFF11') sd.releAll.add(0);
                  if (out == '/RELE=ONN11') sd.releAll.add(1);
                  if (out == 'non') sd.releAll.add(2);
                } catch (e) {
                  sd.releAll.add(2);
                }
              }
              if (index == 22) {
                try {
                  out = out.substring(4);
                  if (out == '/RELE=OFFF12') sd.releAll.add(0);
                  if (out == '/RELE=ONN12') sd.releAll.add(1);
                  if (out == 'non') sd.releAll.add(2);
                } catch (e) {
                  sd.releAll.add(2);
                }
              }
              if (index == 23) {
                try {
                  out = out.substring(4);
                  if (out == '/RELE=OFFF13') sd.releAll.add(0);
                  if (out == '/RELE=ONN13') sd.releAll.add(1);
                  if (out == 'non') sd.releAll.add(2);
                } catch (e) {
                  sd.releAll.add(2);
                }
              }
              if (index == 24) {
                try {
                  out = out.substring(4);
                  if (out == '/RELE=OFFF14') sd.releAll.add(0);
                  if (out == '/RELE=ONN14') sd.releAll.add(1);
                  if (out == 'non') sd.releAll.add(2);
                } catch (e) {
                  sd.releAll.add(2);
                }
              }
              if (index == 25) {
                try {
                  out = out.substring(4);
                  if (out == '/RELE=OFFF15') sd.releAll.add(0);
                  if (out == '/RELE=ONN15') sd.releAll.add(1);
                  if (out == 'non') sd.releAll.add(2);
                } catch (e) {
                  sd.releAll.add(2);
                }
              }
              //////////////////////
              if (index == 26) {
                try {
                  out = out.substring(2);
                  sd.termostat = double.tryParse(out)!;
                } catch (e) {
                  sd.termostat = 0;
                }
              }
              if (index == 27) {
                try {
                  out = out.substring(2);
                  sd.humidityTermostat = double.tryParse(out)!;
                } catch (e) {
                  sd.humidityTermostat = 0;
                }
              }
              /*if (index == 28) {
                try {
                  out = out.substring(3);
                  sd.termostatNumber = int.tryParse(out)!;
                } catch (e) {
                  sd.termostatNumber = -1000;
                }
              }
              if (index == 29) {
                try {
                  out = out.substring(3);
                  sd.humidityTermostatNumber = int.tryParse(out)!;
                } catch (e) {
                  sd.humidityTermostatNumber = -1000;
                }
              }*/
              /*if (index == 20) {
                if (sd.onceReadListChoice) {
                  if (sd.listChoiceRele.isEmpty) {
                    for (int i = 0; i < sd.releAll.length; i++) {
                      sd.listChoiceRele.add(false);
                    }
                  }
                  if (sd.listChoiceMotor.isEmpty) {
                    for (int i = 0; i < sd.motor.length; i++) {
                      sd.listChoiceMotor.add(false);
                    }
                  }
                  sd.onceReadListChoice = false;
                }
              }*/
              out = '';
              start = false;
              index++;
            }
          }
        }
      }
    }
  }, onDone: () {
    if (kDebugMode) {
      print("server done");
      client.close();
    }
  });
}
