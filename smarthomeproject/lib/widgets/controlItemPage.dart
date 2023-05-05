// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:smarthomeproject/algorytm/smartDevice.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';
import 'package:smarthomeproject/widgets/customDialog.dart';
import '../theme/theme.dart';

class ControlItemPage extends StatefulWidget {
  final SmartDevice sd;
  final int indexItem;
  final String nameItem;
  const ControlItemPage(
      {super.key,
      required this.sd,
      required this.indexItem,
      required this.nameItem});
  @override
  ControlItemPageState createState() => ControlItemPageState();
}

class ControlItemPageState extends State<ControlItemPage> {
  bool isLandscape = false;
  List<String> listChoiseMainNameControlItemPage = [];
  List<String> listChoiseMainTypeControlItemPage = [];
  List<String> listChoiseMainNumberControlItemPage = [];

  int indexFromAllList(int index) {
    for (int i = 0; i < widget.sd.listChoiseMainNameControlItem.length; i++) {
      if (widget.sd.listChoiseMainNameControlItem[i] ==
          listChoiseMainNameControlItemPage[index]) {
        return i;
      }
    }
    return -1;
  }

  @override
  Widget build(BuildContext context) {
    isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    listChoiseMainNameControlItemPage = [];
    listChoiseMainTypeControlItemPage = [];
    listChoiseMainNumberControlItemPage = [];
    for (int i = 0; i < widget.sd.listChoiseMainNameControlItem.length; i++) {
      if (widget.sd.listChoiseMainRoomControlItem[i] == widget.nameItem) {
        listChoiseMainNameControlItemPage
            .add(widget.sd.listChoiseMainNameControlItem[i]);
        listChoiseMainTypeControlItemPage
            .add(widget.sd.listChoiseMainTypeControlItem[i]);
        listChoiseMainNumberControlItemPage
            .add(widget.sd.listChoiseMainNumberControlItem[i]);
      }
    }
    return Consumer<ThemeNotifier>(
        builder: (context, theme, _) => MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: theme.getTheme(),
              title: widget.nameItem,
              home: Scaffold(
                appBar: AppBar(
                    title: Text(widget.nameItem),
                    leading: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        size: 30,
                      ),
                    )),
                body: GridView.count(
                  crossAxisCount: isLandscape ? 4 : 2,
                  children: List.generate(
                      listChoiseMainNameControlItemPage.length + 1, (index) {
                    return widget.sd.listChoiseMainNameControlItem.isEmpty ||
                            index >= listChoiseMainNameControlItemPage.length
                        ? Center(
                            child: InkWell(
                                onTap: () {
                                  listChoiceDialogControlItem(widget.sd,
                                      context, false, 0, widget.nameItem);
                                },
                                child: Stack(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.black, width: 5)),
                                    ),
                                    Center(
                                      child: Container(
                                          color: Colors.white,
                                          child: const Icon(
                                            Icons.add,
                                            size: 50,
                                            color: Colors.blue,
                                          )),
                                    ),
                                  ],
                                )))
                        : Center(
                            child: InkWell(
                                onLongPress: () {
                                  listChoiceDialogControlItem(
                                      widget.sd,
                                      context,
                                      true,
                                      indexFromAllList(index),
                                      widget.nameItem);
                                },
                                onTap: () {},
                                child: Stack(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.black, width: 5)),
                                    ),
                                    Center(
                                        child: Column(children: [
                                      Container(
                                          color: Colors.white,
                                          child: const Icon(
                                            Icons.lightbulb,
                                            size: 50,
                                            color: Colors.blue,
                                          )),
                                      Container(
                                          color: Colors.white,
                                          child: Text(
                                            listChoiseMainNameControlItemPage[
                                                index],
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontSize: 30,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blue[900]),
                                          )),
                                    ])),
                                  ],
                                )));
                  }),
                ),
              ),
            ));
  }
}
