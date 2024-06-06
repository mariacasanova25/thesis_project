import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Medication {
  Medication({
    required this.name,
    required this.dosage,
    required this.endDate,
    required this.frequency,
    required this.startDate,
    required this.startTime,
    required this.takenMeds,
    required this.id,
  });

  final String name;
  final String id;
  final int dosage;
  final DateTime endDate;
  final DateTime startDate;
  final int frequency;
  final String startTime;
  final Map<String, List<String>> takenMeds;

  factory Medication.fromSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    final Map<String, List<String>> takenMeds =
        (data['takenMeds'] as Map<String, dynamic>).map((key, value) {
      return MapEntry(
          key, value != null ? List<String>.from(value) : <String>[]);
    });

    return Medication(
      name: data['name'],
      dosage: data['dosage'],
      endDate: data['endDate'].toDate(),
      frequency: data['frequency'],
      startDate: data['startDate'].toDate(),
      startTime: data['startTime'],
      takenMeds: takenMeds,
      id: snapshot.id,
    );
  }

  String getAdherence(DateTime date) {
    // Placeholder for adherence calculation
    return '0';
  }

  List<DateTime> generateDaysList() {
    List<DateTime> days = [];
    DateTime date = startDate;

    while (date.isBefore(DateTime.now()) ||
        date.isAtSameMomentAs(DateTime.now())) {
      days.add(DateTime(date.year, date.month, date.day));
      date = date.add(const Duration(days: 1));
    }

    return days;
  }

  int getStreak() {
    int streak = 0;
    List<DateTime> dates = generateDaysList();
    for (DateTime date in dates) {
      if (double.parse(getAdherence(date)) == 100.0) {
        streak++;
      } else {
        streak = 0;
      }
    }
    return streak;
  }

  int get nrMedsDay {
    return 24 ~/ frequency;
  }

  int getTakenMedsDay(String date) {
    if (takenMeds[date] != null) {
      return takenMeds[date]!.where((time) => time != 'null').length;
    }
    return 0;
  }

  List<String> getSchedule(String date, String startHour) {
    List<String> schedule = [];

    List<String> content = startHour.split('h');
    int hour = int.parse(content[0]);
    int minutes = int.parse(content[1]);

    for (int i = 0; i < nrMedsDay; i++) {
      int newHour = (hour + frequency * i) % 24;
      String formattedHour = newHour < 10 ? '0$newHour' : '$newHour';
      String formattedMinutes = minutes < 10 ? '0$minutes' : '$minutes';
      schedule.add('${formattedHour}h$formattedMinutes');
    }
    return schedule;
  }
}
