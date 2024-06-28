import 'package:flutter/material.dart';
import 'package:thesis_project/medications/prescribed_meds_day.dart';

class PrescribedMedsScreen extends StatefulWidget {
  const PrescribedMedsScreen({super.key});

  @override
  State<PrescribedMedsScreen> createState() => _PrescribedMedsScreenState();
}

class _PrescribedMedsScreenState extends State<PrescribedMedsScreen> {
  var selectedDay = DateTime.now();

  List<DateTime> daysList = [
    for (int i = 2; i > 0; i--) DateTime.now().subtract(Duration(days: i)),
    DateTime.now(),
    for (int i = 1; i <= 5; i++) DateTime.now().add(Duration(days: i)),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //Card(child: Text(_lastMessage)),
        SizedBox(
          height: 100,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            scrollDirection: Axis.horizontal,
            itemCount: daysList.length,
            separatorBuilder: (context, index) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final day = daysList[index];
              return ChoiceChip(
                showCheckmark: false,
                label: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(day.day.toString()),
                    Text(day.month.toString().toUpperCase()),
                  ],
                ),
                selected: selectedDay.day == day.day,
                onSelected: (_) {
                  setState(() => selectedDay = day);
                },
              );
            },
          ),
        ),
        //TODO use pageView
        PrescribedMedsDay(
          selectedDate:
              DateTime(selectedDay.year, selectedDay.month, selectedDay.day),
        ),
      ],
    );
  }
}
