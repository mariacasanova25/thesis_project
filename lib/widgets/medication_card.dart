import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thesis_project/repositories/prescriptions_repository.dart';
import 'package:thesis_project/widgets/create_notification.dart';
import 'package:thesis_project/widgets/taken_med.dart';

class MedicationCard extends ConsumerWidget {
  const MedicationCard({
    super.key,
    required this.onResponse,
    required this.medicationId,
    required this.selectedDate,
    required this.timesIndex,
  });

  final Function(bool) onResponse;
  final String selectedDate;
  final String medicationId;
  final int timesIndex;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prescriptionAsync =
        ref.watch(watchUserPrescriptionProvider(medicationId));

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
          padding: const EdgeInsets.all(16),
          child: prescriptionAsync.when(
            data: (prescription) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Hora de tomar ${prescription.name}.',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Ingira ${prescription.dosage} dose(s)',
                    style: const TextStyle(fontSize: 14),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () => onResponse(false),
                        child: const Text('Não'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          TakenMed takenMed = TakenMed();
                          takenMed.takenMed(
                              medicationId: medicationId,
                              selectedDate: selectedDate,
                              timesIndex: timesIndex);
                          const snackBar = SnackBar(
                            content: Text(
                              'Fantastico! Mais um passo na direção de melhorar a sua saúde!',
                              textAlign: TextAlign.center,
                            ),
                            duration: Duration(seconds: 3),
                            backgroundColor: Colors.green,
                            behavior: SnackBarBehavior.floating,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          Navigator.pop(context);
                        },
                        child: const Text('Sim'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          List<String> timeParts =
                              prescription.times[timesIndex].split('h');
                          int hour = int.parse(timeParts[0]);
                          int minute = int.parse(timeParts[1]);

                          DateTime initialTime =
                              DateTime(2024, 1, 1, hour, minute);

                          // Add 15 minutes
                          DateTime newTime =
                              initialTime.add(const Duration(minutes: 5));

                          CreateNotification snoozeNotification =
                              CreateNotification();
                          snoozeNotification.createNotification(
                              context: context,
                              hour: newTime.hour,
                              id: 100,
                              medication: prescription,
                              minute: newTime.minute,
                              selectedDateForm: selectedDate,
                              repeats: false);
                          Navigator.pop(context);
                        },
                        child: const Text('Adiar'),
                      )
                    ],
                  ),
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stackTrace) => const SizedBox(
              width: 10,
            ),
          )),
    );
  }
}
