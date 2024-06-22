import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:thesis_project/repositories/prescriptions_repository.dart';
import 'package:thesis_project/screens/medication_details.dart';
import 'package:thesis_project/widgets/create_notification.dart';

class MedicationScreen extends ConsumerWidget {
  const MedicationScreen({super.key, required this.selectedDate});

  final DateTime selectedDate;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //ref.listen(watchUserPrescriptionsProvider,
    //  (_, prescriptions) => scheduleDailyNotification(prescriptions));
    final userPrescriptionsAsync = ref.watch(watchUserPrescriptionsProvider);
    return Expanded(
        child: userPrescriptionsAsync.when(
      data: (loadedMeds) {
        if (loadedMeds.isEmpty) {
          return const Center(
              child: Text('Não foram encontrados medicamentos.'));
        }
        final filteredMeds = loadedMeds.where((medication) {
          var endDate = DateTime(medication.endDate.year,
              medication.endDate.month, medication.endDate.day);
          var startDate = DateTime(medication.startDate.year,
              medication.startDate.month, medication.startDate.day);

          return (endDate.isAfter(selectedDate) ||
                  endDate.isAtSameMomentAs(selectedDate)) &&
              (startDate.isBefore(selectedDate) ||
                  startDate.isAtSameMomentAs(selectedDate));
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

              //calculate the number of already taken meds
              String selectedDateForm =
                  DateFormat('yyyy-MM-dd').format(selectedDate);
              int takenMeds = 0;
              var help = med.takenMeds[selectedDateForm];
              if (help != null) {
                for (int i = 0; i < help.length; i++) {
                  if (help[i] != 'null') {
                    takenMeds++;
                  }
                }
              }

              //creates notifications
              int notificationId = 0;
              CreateNotification notification = CreateNotification();
              for (int i = 0; i < med.times.length; i++) {
                List<String> timeParts = med.times[i].split('h');
                int hour = int.parse(timeParts[0]);
                int minute = int.parse(timeParts[1]);

                if (med.takenMeds[selectedDateForm] == null ||
                    (med.takenMeds[selectedDateForm] != null &&
                        med.takenMeds[selectedDateForm]![i] == 'null')) {
                  notification.createNotification(
                      context: context,
                      hour: hour,
                      minute: minute,
                      medication: med,
                      repeats: true,
                      id: notificationId,
                      selectedDateForm:
                          DateFormat('yyyy-MM-dd').format(selectedDate));
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
                        medicationId: med.id,
                        selectedDate: selectedDate,
                      ),
                    ),
                  );
                },
              );
            });
      },
      error: (error, stackTrace) {
        return const SizedBox(
          width: 10,
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
    ));
  }
}
