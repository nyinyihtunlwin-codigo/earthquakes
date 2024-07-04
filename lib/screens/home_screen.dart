import 'package:earthquakes/providers/app_data_provider.dart';
import 'package:earthquakes/utils/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void didChangeDependencies() {
    Provider.of<AppDataProvider>(context, listen: false).init();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Earthquakes'),
        actions: [
          IconButton(
              onPressed: _showSortingDialog, icon: const Icon(Icons.sort))
        ],
      ),
      body: Consumer<AppDataProvider>(
        builder: (context, provider, child) => provider.hasDataLoaded
            ? provider.earthquakeModel!.features!.isEmpty
                ? const Center(
                    child: Text('No record found.'),
                  )
                : ListView.builder(
                    itemCount: provider.earthquakeModel!.features!.length,
                    itemBuilder: (context, index) {
                      final data = provider
                          .earthquakeModel!.features![index].properties!;
                      return ListTile(
                        title: Text(data.place ?? data.title ?? 'Unknown'),
                        subtitle: Text(getFormattedDateTime(
                            data.time!, 'EEE MM dd yyyy hh:mm a')),
                        trailing: Chip(
                          label: Text('${data.mag}'),
                          avatar: data.alert == null
                              ? null
                              : CircleAvatar(
                                  backgroundColor:
                                      provider.getAlertColor(data.alert!),
                                ),
                        ),
                      );
                    },
                  )
            : const Center(
                child: Text('Please wait...'),
              ),
      ),
    );
  }

  void _showSortingDialog() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Sort by'),
              content: Consumer<AppDataProvider>(
                builder: (context, provider, child) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    RadioGroup(
                      groupValue: provider.orderBy,
                      value: 'magnitude',
                      label: 'Magnitude-Desc',
                      onChanged: (value) {
                        provider.setOrder(value!);
                      },
                    ),
                    RadioGroup(
                      groupValue: provider.orderBy,
                      value: 'magnitude-asc',
                      label: 'Magnitude-Asc',
                      onChanged: (value) {
                        provider.setOrder(value!);
                      },
                    ),
                    RadioGroup(
                      groupValue: provider.orderBy,
                      value: 'time',
                      label: 'Time-Desc',
                      onChanged: (value) {
                        provider.setOrder(value!);
                      },
                    ),
                    RadioGroup(
                      groupValue: provider.orderBy,
                      value: 'time-asc',
                      label: 'Time-Asc',
                      onChanged: (value) {
                        provider.setOrder(value!);
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                )
              ],
            ));
  }
}

class RadioGroup extends StatelessWidget {
  final String groupValue;
  final String value;
  final String label;
  final Function(String?) onChanged;

  const RadioGroup(
      {super.key,
      required this.groupValue,
      required this.value,
      required this.label,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Radio<String>(
          value: value,
          groupValue: groupValue,
          onChanged: onChanged,
        ),
        Text(label),
      ],
    );
  }
}
