// ignore_for_file: file_names

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:smarthomeproject/algorytm/smartDevice.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';
import 'package:smarthomeproject/widgets/customDialog.dart';
import '../theme/theme.dart';
// ignore: depend_on_referenced_packages
import 'package:easy_localization/easy_localization.dart';
// ignore: depend_on_referenced_packages, import_of_legacy_library_into_null_safe
import 'package:flutter_slidable/flutter_slidable.dart';
// ignore: depend_on_referenced_packages
import 'package:shared_preferences/shared_preferences.dart';

class CalibrationPage extends StatefulWidget {
  final SmartDevice sd;

  const CalibrationPage({super.key, required this.sd});
  @override
  CalibrationPageState createState() => CalibrationPageState();
}

class CalibrationPageState extends State<CalibrationPage> {
  final _scrollController = ScrollController();
  int choiseCalibration = 0;

  CalibrationPageState() {
    Timer.periodic(const Duration(milliseconds: 1000), (timer) async {
      if (mounted) {
        refreshPage(context);
      }
    });
  }
  refreshPage(BuildContext context) {
    setState(() {});
  }

  void startListVoiceCommandCheck() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    if (sharedPrefs.getStringList('${widget.sd.nameDevice}-nameCommandVoice') !=
        null) {
      widget.sd.nameCommandVoice = sharedPrefs
          .getStringList('${widget.sd.nameDevice}-nameCommandVoice')!;
    }
    if (sharedPrefs.getStringList('${widget.sd.nameDevice}-typeCommandVoice') !=
        null) {
      widget.sd.typeCommandVoice = sharedPrefs
          .getStringList('${widget.sd.nameDevice}-typeCommandVoice')!;
    }
    if (sharedPrefs
            .getStringList('${widget.sd.nameDevice}-numberCommandVoice') !=
        null) {
      widget.sd.numberCommandVoice = sharedPrefs
          .getStringList('${widget.sd.nameDevice}-numberCommandVoice')!;
    }
    if (sharedPrefs
            .getStringList('${widget.sd.nameDevice}-onOffCommandVoice') !=
        null) {
      widget.sd.onOffCommandVoice = sharedPrefs
          .getStringList('${widget.sd.nameDevice}-onOffCommandVoice')!;
    }
    if (sharedPrefs
            .getStringList('${widget.sd.nameDevice}-nameCalibrationMotor') !=
        null) {
      widget.sd.nameCalibrationMotor = sharedPrefs
          .getStringList('${widget.sd.nameDevice}-nameCalibrationMotor')!;
    }
  }

  @override
  void initState() {
    super.initState();
    startListVoiceCommandCheck();
  }

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
                                          subtitle: widget
                                                      .sd
                                                      .nameCalibrationMotor
                                                      .isEmpty ||
                                                  widget.sd.nameCalibrationMotor
                                                          .length <=
                                                      index
                                              ? const Text('')
                                              : Text(widget.sd
                                                  .nameCalibrationMotor[index]),
                                          leading: const Icon(
                                            Icons.lightbulb,
                                            size: 30,
                                            color: Colors.blue,
                                          ),
                                          trailing: widget.sd.motor[index] == 1
                                              ? Text(
                                                  'on.label'.tr(),
                                                  style: const TextStyle(
                                                      color: Colors.green),
                                                )
                                              : widget.sd.motor[index] == 0
                                                  ? Text(
                                                      'off.label'.tr(),
                                                      style: const TextStyle(
                                                          color: Colors.green),
                                                    )
                                                  : Text(
                                                      'not_calibrated.label'
                                                          .tr(),
                                                      style: const TextStyle(
                                                          color: Colors.red),
                                                    ),
                                          onTap: () {
                                            listCalibrationMotor(
                                                widget.sd,
                                                context,
                                                widget.sd.motor[index],
                                                index);
                                          },
                                        ),
                                      );
                                    })
                            //Calibration voice
                            : Column(children: <Widget>[
                                ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: widget
                                            .sd.nameCommandVoice.isEmpty
                                        ? 1
                                        : widget.sd.nameCommandVoice.length + 1,
                                    scrollDirection: Axis.vertical,
                                    controller: _scrollController,
                                    itemBuilder: (context, index) {
                                      return index ==
                                              widget.sd.nameCommandVoice.length
                                          ? Card(
                                              elevation: 5,
                                              child: ListTile(
                                                title: const Center(
                                                  child: Icon(
                                                    Icons.add,
                                                    size: 30,
                                                    color: Colors.blue,
                                                  ),
                                                ),
                                                onTap: () {
                                                  listCommandVoiceDialog(
                                                      widget.sd,
                                                      context,
                                                      false,
                                                      0);
                                                },
                                              ),
                                            )
                                          : Card(
                                              elevation: 5,
                                              child: Container(
                                                  decoration:
                                                      const BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          5))),
                                                  clipBehavior: Clip.hardEdge,
                                                  child: Slidable(
                                                      key: Key(widget.sd
                                                              .nameCommandVoice[
                                                          index]),
                                                      actionPane:
                                                          const SlidableScrollActionPane(),
                                                      secondaryActions: [
                                                        IconSlideAction(
                                                          caption:
                                                              "delete.label"
                                                                  .tr(),
                                                          color: Colors.red,
                                                          icon: Icons.delete,
                                                          onTap: () {
                                                            showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                                  return AlertDialog(
                                                                    title: Text(
                                                                        "are-you-sure-you-want-to-delete-this-command.label"
                                                                            .tr()),
                                                                    actions: <
                                                                        Widget>[
                                                                      TextButton(
                                                                        style: TextButton
                                                                            .styleFrom(
                                                                          backgroundColor:
                                                                              Colors.blue,
                                                                          textStyle:
                                                                              const TextStyle(
                                                                            color:
                                                                                Colors.white,
                                                                          ),
                                                                        ),
                                                                        child:
                                                                            Text(
                                                                          'no.label'
                                                                              .tr(),
                                                                          style:
                                                                              const TextStyle(color: Colors.white),
                                                                        ),
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                      ),
                                                                      TextButton(
                                                                        style: TextButton
                                                                            .styleFrom(
                                                                          backgroundColor:
                                                                              Colors.blue,
                                                                          textStyle:
                                                                              const TextStyle(
                                                                            color:
                                                                                Colors.white,
                                                                          ),
                                                                        ),
                                                                        child:
                                                                            Text(
                                                                          'yes.label'
                                                                              .tr(),
                                                                          style:
                                                                              const TextStyle(color: Colors.white),
                                                                        ),
                                                                        onPressed:
                                                                            () async {
                                                                          setState(
                                                                              () {
                                                                            widget.sd.nameCommandVoice.removeAt(index);
                                                                            widget.sd.typeCommandVoice.removeAt(index);
                                                                            widget.sd.numberCommandVoice.removeAt(index);
                                                                            widget.sd.onOffCommandVoice.removeAt(index);
                                                                          });
                                                                          SharedPreferences
                                                                              prefs =
                                                                              await SharedPreferences.getInstance();
                                                                          prefs.setStringList(
                                                                              '${widget.sd.nameDevice}-nameCommandVoice',
                                                                              widget.sd.nameCommandVoice);
                                                                          prefs.setStringList(
                                                                              '${widget.sd.nameDevice}-typeCommandVoice',
                                                                              widget.sd.typeCommandVoice);
                                                                          prefs.setStringList(
                                                                              '${widget.sd.nameDevice}-numberCommandVoice',
                                                                              widget.sd.numberCommandVoice);
                                                                          prefs.setStringList(
                                                                              '${widget.sd.nameDevice}-onOffCommandVoice',
                                                                              widget.sd.onOffCommandVoice);
                                                                          // ignore: use_build_context_synchronously
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                      ),
                                                                    ],
                                                                  );
                                                                });
                                                          },
                                                        )
                                                      ],
                                                      child: ListTile(
                                                        title: Text(
                                                            widget.sd
                                                                    .nameCommandVoice[
                                                                index],
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis),
                                                        subtitle: Text(
                                                            '${widget.sd.typeCommandVoice[index]}: ${widget.sd.numberCommandVoice[index]}'),
                                                        leading: const Icon(
                                                          Icons
                                                              .record_voice_over,
                                                          size: 30,
                                                          color: Colors.blue,
                                                        ),
                                                        trailing: widget.sd
                                                                        .onOffCommandVoice[
                                                                    index] ==
                                                                'on'
                                                            ? Text(
                                                                'on.label'.tr(),
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .green))
                                                            : Text(
                                                                'off.label'
                                                                    .tr(),
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .red)),
                                                        onTap: () {
                                                          listCommandVoiceDialog(
                                                              widget.sd,
                                                              context,
                                                              true,
                                                              index);
                                                        },
                                                      ))),
                                            );
                                    }),
                              ])
                      ],
                    ),
                  )),
            )));
  }
}
