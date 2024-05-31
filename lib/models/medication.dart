import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Medication {
  Medication(
      {required this.name,
      required this.dosage,
      required this.endDate,
      required this.frequency,
      required this.startDate,
      required this.takenMeds,
      required this.id});

  final String name;
  final String id;
  final int dosage;
  final DateTime endDate;
  final DateTime startDate;
  final int frequency;
  final Map<String, int> takenMeds;

  factory Medication.fromSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    return Medication(
        name: data['name'],
        dosage: data['dosage'],
        endDate: data['endDate'].toDate(),
        frequency: data['frequency'],
        startDate: data['startDate'].toDate(),
        takenMeds: (data['takenMeds'] as Map?)?.cast<String, int>() ?? {},
        id: snapshot.id);
  }

  String getAdherence(DateTime date) {
    int takenMedsDay = takenMeds[DateFormat('yyyy-MM-dd').format(date)] ?? 0;
    return (takenMedsDay / (dosage * frequency) * 100).toStringAsFixed(0);
  }

  List<DateTime> generateDaysList() {
    List<DateTime> days = [];
    DateTime date;
    date = startDate;
    days.add(date);

    while (date.isBefore(DateTime.now())) {
      date = date.add(const Duration(days: 1));
      date = DateTime(date.year, date.month, date.day);
      if (date.isAtSameMomentAs(DateTime(
              DateTime.now().year, DateTime.now().month, DateTime.now().day)) ||
          date.isBefore(DateTime(
              DateTime.now().year, DateTime.now().month, DateTime.now().day))) {
        days.add(date);
      }
    }

    return days;
  }

  int getStreak() {
    int streak = 0;
    List<DateTime> dates = generateDaysList();
    for (int i = 0; i < dates.length; i++) {
      if (double.parse(getAdherence(dates[i])) == 100.0) {
        streak++;
      } else {
        streak = 0;
      }
    }
    return streak;
  }
}
