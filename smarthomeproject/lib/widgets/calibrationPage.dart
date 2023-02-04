// ignore_for_file: file_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smarthomeproject/algorytm/smartDevice.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';
import '../theme/theme.dart';
// ignore: depend_on_referenced_packages
import 'package:easy_localization/easy_localization.dart';

class CalibrationPage extends StatefulWidget {
  final SmartDevice sd;

  const CalibrationPage({super.key, required this.sd});
  @override
  CalibrationPageState createState() => CalibrationPageState();
}

class CalibrationPageState extends State<CalibrationPage> {
  final _scrollController = ScrollController();
  int choiseCalibration = 0;
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
        builder: (context, theme, _) => MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: theme.getTheme(),
            title: "calibration.label".tr(),
            home: DefaultTabController(
              length: 2,
              child: Scaffold(
                  appBar: AppBar(
                      bottom: TabBar(
                        tabs: const [
                          Tab(icon: Icon(Icons.curtains_closed, size: 40)),
                          Tab(icon: Icon(Icons.settings_voice_sharp, size: 40)),
                        ],
                        onTap: (value) {
                          setState(() {
                            choiseCalibration = value;
                          });
                        },
                      ),
                      title: Text(
                        "calibration.label".tr(),
                      ),
                      leading: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          size: 30,
                        ),
                      )),
                  body: SingleChildScrollView(
                    child: Column(
                      children: [
                        choiseCalibration == 0
                            ? widget.sd.motor.isEmpty
                                ? Column(children: [
                                    const Padding(
                                        padding: EdgeInsets.only(top: 30)),
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.search,
                                            size: 20,
                                            color: Colors.blue,
                                          ),
                                          Text(
                                            'no-found-curtains.label'.tr(),
                                            style: const TextStyle(
                                                color: Colors.grey),
                                          )
                                        ])
                                  ])
                                : ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: widget.sd.motor.length,
                                    scrollDirection: Axis.vertical,
                                    controller: _scrollController,
                                    itemBuilder: (context, index) {
                                      return Card(
                                        elevation: 5,
                                        child: ListTile(
                                          title: Text('Motor $index'),
                                          leading: const Icon(
                                            Icons.lightbulb,
                                            size: 30,
                                            color: Colors.blue,
                                          ),
                                          trailing: CupertinoSwitch(
                                              value: widget.sd.motor[index] == 1
                                                  ? true
                                                  : false,
                                              onChanged: null),
                                          onTap: () {},
                                        ),
                                      );
                                    })
                            : const Text('data'),
                      ],
                    ),
                  )),
            )));
  }
}
