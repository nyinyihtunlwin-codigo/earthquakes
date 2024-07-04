import 'package:earthquakes/providers/app_data_provider.dart';
import 'package:earthquakes/utils/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<StatefulWidget> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Consumer<AppDataProvider>(
          builder: (context, provider, child) => ListView(
                padding: const EdgeInsets.all(8.0),
                children: [
                  Text(
                    'Time Settings',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Card(
                    child: Column(
                      children: [
                        ListTile(
                          title: const Text('Start Time'),
                          subtitle: Text(provider.startTime),
                          trailing: IconButton(
                            onPressed: () async {
                              final selectedDate = await selectDate();
                              if (selectedDate != null) {
                                provider.setStartTime(selectedDate);
                              }
                            },
                            icon: const Icon(Icons.calendar_month),
                          ),
                        ),
                        ListTile(
                          title: const Text('End Time'),
                          subtitle: Text(provider.endTime),
                          trailing: IconButton(
                            onPressed: () async {
                              final selectedDate = await selectDate();
                              if (selectedDate != null) {
                                provider.setEndTime(selectedDate);
                              }
                            },
                            icon: const Icon(Icons.calendar_month),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            provider.getEarthquakeData();
                            showMsg(context, 'Times are updated.');
                          },
                          child: const Text('Update Time Changes.'),
                        )
                      ],
                    ),
                  ),
                  Text(
                    'Location Settings',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Card(
                    child: SwitchListTile(
                      title:
                          Text(provider.currentCity ?? 'Your city is unknown.'),
                      subtitle: provider.currentCity == null
                          ? null
                          : Text(
                              'Earthquake data will be shown within ${provider.maxRadiusInKm} km radius from ${provider.currentCity}.'),
                      value: provider.shouldUseLocation,
                      onChanged: (value) async {
                        EasyLoading.show(status: 'Getting location...');
                        await provider.setLocation(value);
                        EasyLoading.dismiss();
                      },
                    ),
                  )
                ],
              )),
    );
  }

  Future<String?> selectDate() async {
    final date = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime.now());
    if (date != null) {
      return getFormattedDateTime(date.millisecondsSinceEpoch);
    }
    return null;
  }
}
