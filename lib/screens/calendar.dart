import 'package:flutter/material.dart';
import 'package:thesis_project/screens/medication.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
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
                    const Text('JUN'),
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
        MedicationScreen(
          selectedDate:
              DateTime(selectedDay.year, selectedDay.month, selectedDay.day),
        )
      ],
    );
  }
}
