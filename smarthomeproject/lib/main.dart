import 'dart:io';

import 'package:flutter/material.dart';
import 'package:smarthomeproject/firstPageWidget.dart';

/*void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  connecting() async {
    Socket sock = await Socket.connect('192.168.1.101', 80);
  }

  @override
  Widget build(BuildContext context) {
    connecting();
    return const MaterialApp(
      home: WebSocketLed(sock),
    );
  }
}*/
import 'package:flutter/foundation.dart';

void main() async {
  // modify with your true address/port
  Socket socket = await Socket.connect('192.168.0.119', 80);
  runApp(MyApp(socket: socket));
}

connectSocket(String command) async {
  try {
    Socket socked = await Socket.connect('192.168.0.119', 80);
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
}

void handleClient(Uint8List data) {
  // Show the address and port of the client
  /*print('Connection from '
        '${socket.remoteAddress.address}:${socket.remotePort}');*/

  // Show what the client said
  if (kDebugMode) {
    print("client listen  : ${String.fromCharCodes(data).trim()}");
  }
  /*widget.channel.close();
    connectSocket();*/
  // Send acknowledgement to client
  //socket.write("Hello from simple server!\n");
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.socket});
  final Socket socket;
  //Socket socket = null;
  /*connecting() async {
    Socket socket = await Socket.connect('192.168.0.119', 80);
  }*/

  @override
  Widget build(BuildContext context) {
    //connecting();
    final title = 'TcpSocket Demo';
    return MaterialApp(
      title: title,
      home: MyHomePage(
        title: title,
        channel: socket,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  Socket channel;

  MyHomePage({required this.title, required this.channel});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    try {
      widget.channel.listen(handleClient);
    } catch (e) {
      if (kDebugMode) {
        print("Already read!");
      }
    }
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Container(
            child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextButton(
                child: const Text("On", style: TextStyle(fontSize: 20.0)),
                onPressed: () {
                  setState(() {
                    connectSocket("/RELE=ON0");
                    //widget.channel.write("/RELE=ON0");
                  });
                },
              ),
              TextButton(
                child: const Text("Off", style: TextStyle(fontSize: 20.0)),
                onPressed: () {
                  setState(() {
                    connectSocket("/RELE=OFF0");
                    //widget.channel.write("/RELE=OFF0");
                  });
                },
              ),
            ],
          ),
        )));
  }

  /*void _togglePower() {
    widget.channel.write("POWER\n");
  }*/

  @override
  void dispose() {
    widget.channel.close();
    super.dispose();
  }
}
