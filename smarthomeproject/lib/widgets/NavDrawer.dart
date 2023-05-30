// ignore_for_file: file_names

// ignore: depend_on_referenced_packages
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:smarthomeproject/algorytm/smartDevice.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_svg/flutter_svg.dart';

class NavDrawer extends StatelessWidget {
  final SmartDevice sd;
  const NavDrawer({super.key, required this.sd});
  @override
  Widget build(BuildContext context) {
    final scrollController = ScrollController();
    bool isLandscape =
        (MediaQuery.of(context).orientation == Orientation.landscape);
    if (MediaQuery.of(context).size.width < 500) {
      isLandscape = false;
    }
    List<String> listName = [];
    List<String> listValue = [];
    for (int i = 0; i < 6; i++) {
      if (i == 0) {
        listName.add('outdoor-temperature.label'.tr());
        listValue.add('${sd.temperatura} °C');
      }
      if (i == 1) {
        listName.add('outdoor-humidity.label'.tr());
        listValue.add('${sd.humidity} %');
      }
      if (i == 2) {
        listName.add('pressure.label'.tr());
        listValue.add('${sd.pressure} ${'mm.label'.tr()}');
      }
      if (i == 3) {
        listName.add('weather-forecast.label'.tr());
        if (sd.weather < 0) {
          listValue.add('${sd.weather * -1} %');
        } else {
          listValue.add('${sd.weather} %');
        }
      }
      if (i == 4) {
        listName.add('temperature-in-the-house.label'.tr());
        listValue.add('${sd.temperaturaHome} °C');
      }
      if (i == 5) {
        listName.add('humidity-in-the-house.label'.tr());
        listValue.add('${sd.humidityHome} %');
      }
    }
    return SafeArea(
      child: Drawer(
        child: ListView(
          padding:
              const EdgeInsets.only(right: 10, left: 10, bottom: 10, top: 10),
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(bottom: 5),
              alignment: Alignment.center,
              child: Text(
                "information.label".tr(),
                style: TextStyle(
                    color: Theme.of(context).iconTheme.color, fontSize: 25),
              ),
            ),
            ListView.builder(
              scrollDirection: Axis.vertical,
              padding: const EdgeInsets.all(0),
              shrinkWrap: true,
              controller: scrollController,
              itemCount: 6,
              itemBuilder: (context, index) => ListTile(
                visualDensity: const VisualDensity(horizontal: 0, vertical: -3),
                contentPadding: const EdgeInsets.only(left: 0.0, right: 0.0),
                dense: true,
                minVerticalPadding: 0,
                title: Container(
                  padding: const EdgeInsets.all(0),
                  width: isLandscape
                      ? MediaQuery.of(context).size.width * 0.14
                      : MediaQuery.of(context).size.width * 0.32,
                  child: Text(
                    '${listName[index]}:',
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
                subtitle:
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  listName[index] == 'weather-forecast.label'.tr()
                      ? sd.weather > 0 && sd.temperatura <= 1.5
                          ? SvgPicture.asset(
                              'images/snowflake.svg',
                              color: Colors.blue,
                              height: 25,
                              width: 25,
                            )
                          : Icon(
                              sd.weather > 0 && sd.temperatura > 1.5
                                  ? Icons.cloudy_snowing
                                  : sd.weather < 0
                                      ? Icons.wb_sunny_rounded
                                      : Icons.cloud_sync_rounded,
                              size: 30,
                              color: Colors.blue,
                            )
                      : Icon(
                          listName[index] == 'outdoor-temperature.label'.tr() ||
                                  listName[index] ==
                                      'temperature-in-the-house.label'.tr()
                              ? Icons.thermostat
                              : listName[index] ==
                                          'outdoor-humidity.label'.tr() ||
                                      listName[index] ==
                                          'humidity-in-the-house.label'.tr()
                                  ? Icons.water_drop
                                  : Icons.speed_rounded,
                          size: 30,
                          color: Colors.blue,
                        ),
                  const SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    child: Text(
                      listValue[index],
                      softWrap: true,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ]),
                onTap: null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
