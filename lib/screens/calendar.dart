import 'package:flutter/material.dart';
import 'package:thesis_project/screens/medication.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() {
    return _CalendarScreenState();
  }
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime selectedDay = DateTime.now();

  @override
  void initState() {
    selectedDay = DateTime.now();
    super.initState();
  }

  List<DateTime> generateDaysList(int year, int month) {
    List<DateTime> days = [];

    for (int i = 2; i > 0; i--) {
      DateTime date = DateTime.now().subtract(Duration(days: i));
      days.add(date);
    }
    days.add(DateTime.now());
    for (int i = 1; i <= 3; i++) {
      DateTime date = DateTime.now().add(Duration(days: i));
      days.add(date);
    }
    return days;
  }

  @override
  Widget build(BuildContext context) {
    List<DateTime> genList =
        generateDaysList(DateTime.now().year, DateTime.now().month);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
      ),
      body: Column(children: [
        Container(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: genList.length,
            itemBuilder: (context, index) => Container(
              width: 150,
              child: ListTile(
                title: Text(genList[index].day.toString()),
                textColor: selectedDay.day == genList[index].day
                    ? Colors.purple
                    : Colors.black,
                onTap: () {
                  setState(() {
                    selectedDay = genList[index];
                  });
                },
              ),
            ),
          ),
        ),
        MedicationScreen(
          selectedDate:
              DateTime(selectedDay.year, selectedDay.month, selectedDay.day),
        )
      ]),
    );
  }
}
