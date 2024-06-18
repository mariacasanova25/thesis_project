import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:thesis_project/models/medication.dart';
import 'package:thesis_project/screens/medication_details.dart';

class MedicationScreen extends StatefulWidget {
  const MedicationScreen({super.key, required this.selectedDate});

  final DateTime selectedDate;

  @override
  State<MedicationScreen> createState() => _MedicationScreenState();
}

class _MedicationScreenState extends State<MedicationScreen> {
  void scheduleDailyNotification(
      int id, int hour, int minute, Medication medication) async {
    String selectedDateForm =
        DateFormat('yyyy-MM-dd').format(widget.selectedDate);

    String localTimeZone =
        await AwesomeNotifications().getLocalTimeZoneIdentifier();

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
          id: id,
          channelKey: 'high_channel',
          actionType: ActionType.Default,
          title: 'Medication Reminder',
          body: 'Did you take your medication: ${medication.name}?',
          payload: {
            'medicationId': medication.id,
            'selectedDate': selectedDateForm
          }),
      schedule: NotificationCalendar(
          hour: hour,
          minute: minute,
          second: 0,
          repeats: true,
          timeZone: localTimeZone),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Daily notification scheduled at $hour h $minute'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    return Expanded(
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('medications')
            .snapshots()
            .map((snapshots) => snapshots.docs
                .map((doc) => Medication.fromSnapshot(doc))
                .toList()),
        builder: (context, AsyncSnapshot<List<Medication>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
                child: Text('Não foram encontrados medicamentos.'));
          }

          final loadedMeds = snapshot.data!;

          final filteredMeds = loadedMeds.where((medication) {
            var endDate = DateTime(medication.endDate.year,
                medication.endDate.month, medication.endDate.day);
            var startDate = DateTime(medication.startDate.year,
                medication.startDate.month, medication.startDate.day);

            return (endDate.isAfter(widget.selectedDate) ||
                    endDate.isAtSameMomentAs(widget.selectedDate)) &&
                (startDate.isBefore(widget.selectedDate) ||
                    startDate.isAtSameMomentAs(widget.selectedDate));
          }).toList();

          if (filteredMeds.isEmpty) {
            return const Center(
              child: Text('Não tem medicamentos para tomar'),
            );
          }
          return ListView.builder(
              itemCount: filteredMeds.length,
              itemBuilder: (context, index) {
                final med = filteredMeds[index];
                var currentDate = DateTime.now();
                var daysLeft = med.endDate.difference(currentDate).inDays;

                String selectedDateForm =
                    DateFormat('yyyy-MM-dd').format(widget.selectedDate);
                int takenMeds = 0;
                var help = med.takenMeds[selectedDateForm];
                if (help != null) {
                  for (int i = 0; i < help.length; i++) {
                    if (help[i] != 'null') {
                      takenMeds++;
                    }
                  }
                }

                int notificationId = 0;
                for (int i = 0; i < med.times.length; i++) {
                  List<String> timeParts = med.times[i].split('h');
                  int hour = int.parse(timeParts[0]);
                  int minute = int.parse(timeParts[1]);

                  if (med.takenMeds[selectedDateForm] == null ||
                      (med.takenMeds[selectedDateForm] != null &&
                          med.takenMeds[selectedDateForm]![i] == 'null')) {
                    scheduleDailyNotification(
                        notificationId, hour, minute, med);
                  }
                  notificationId++;
                }

                return ListTile(
                  title: Text(
                    med.name,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Dose: ${med.dosage}'),
                      Text('Termina em: $daysLeft dias.'),
                      const SizedBox(height: 8),
                    ],
                  ),
                  leading: CircularProgressIndicator(
                    backgroundColor:
                        Theme.of(context).colorScheme.primaryContainer,
                    value: takenMeds / med.nrMedsDay,
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    size: 18,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MedicationDetailsScreen(
                          medication: med,
                          selectedDate: widget.selectedDate,
                        ),
                      ),
                    );
                  },
                );
              });
        },
      ),
    );
  }
}
