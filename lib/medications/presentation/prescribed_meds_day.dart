import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:thesis_project/medications/data/prescriptions_repository.dart';
import 'package:thesis_project/medications/presentation/medication_details.dart';
import 'package:thesis_project/notifications/presentation/create_notification.dart';

class PrescribedMedsDay extends ConsumerWidget {
  const PrescribedMedsDay({super.key, required this.selectedDate});

  final DateTime selectedDate;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //ref.listen(watchUserPrescriptionsProvider,
    //  (_, prescriptions) => scheduleDailyNotification(prescriptions));
    final userPrescriptionsAsync = ref.watch(watchUserPrescriptionsProvider);
    return userPrescriptionsAsync.when(
      data: (prescriptions) {
        if (prescriptions.isEmpty) {
          return const Center(
              child: Text('Não foram encontrados medicamentos.'));
        }
        final currentPrescriptions = prescriptions.where((medication) {
          var endDate = DateTime(medication.endDate.year,
              medication.endDate.month, medication.endDate.day);
          var startDate = DateTime(medication.startDate.year,
              medication.startDate.month, medication.startDate.day);

          return (endDate.isAfter(selectedDate) ||
                  endDate.isAtSameMomentAs(selectedDate)) &&
              (startDate.isBefore(selectedDate) ||
                  startDate.isAtSameMomentAs(selectedDate));
        }).toList();

        if (currentPrescriptions.isEmpty) {
          return const Center(
            child: Text('Não tem medicamentos para tomar.'),
          );
        }
        return ListView.builder(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 6,
            ),
            itemCount: currentPrescriptions.length,
            itemBuilder: (context, index) {
              final prescription = currentPrescriptions[index];

              var daysLeft =
                  prescription.endDate.difference(selectedDate).inDays;

              //calculate the number of already taken meds
              String selectedDateForm =
                  DateFormat('yyyy-MM-dd').format(selectedDate);
              int takenMeds = 0;
              var help = prescription.takenMeds[selectedDateForm];
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
              for (int i = 0; i < prescription.times.length; i++) {
                List<String> timeParts = prescription.times[i].split('h');
                int hour = int.parse(timeParts[0]);
                int minute = int.parse(timeParts[1]);

                if (prescription.takenMeds[selectedDateForm] == null ||
                    (prescription.takenMeds[selectedDateForm] != null &&
                        prescription.takenMeds[selectedDateForm]![i] ==
                            'null')) {
                  notification.createNotification(
                      context: context,
                      hour: hour,
                      minute: minute,
                      prescription: prescription,
                      repeats: true,
                      id: notificationId,
                      selectedDateForm:
                          DateFormat('yyyy-MM-dd').format(selectedDate));
                }
                notificationId++;
              }

              return Card(
                margin: const EdgeInsets.all(6),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  leading: Image.asset('assets/images/pills.png'),
                  title: Text(
                    prescription.name,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('${prescription.dosage} Comprimido(s)'),
                      daysLeft == 0
                          ? const Text('Termina hoje.')
                          : Text('Termina em: $daysLeft dia(s).'),
                      const SizedBox(height: 8),
                      // takenMeds / prescription.nrMedsDay,
                    ],
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
                          medicationId: prescription.medicationId,
                          prescriptionId: prescription.prescriptionId,
                          selectedDate: selectedDate,
                          medicationName: prescription.name,
                        ),
                      ),
                    );
                  },
                ),
              );
            });
      },
      error: (error, stackTrace) {
        return const SizedBox(
          width: 10,
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}
