import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thesis_project/medications/domain/prescription.dart';
import 'package:thesis_project/medications/data/prescriptions_repository.dart';
import 'package:thesis_project/medications/presentation/taken_med.dart';
import 'package:thesis_project/medications/presentation/warning_frequency_violation.dart';

class MedicationSchedule extends ConsumerWidget {
  const MedicationSchedule({
    super.key,
    required this.date,
    required this.medicationId,
  });

  final String medicationId;
  final String date;

  void _setScheduleInFirestore(
      {required Prescription medication, List<String>? schedule}) async {
    final user = FirebaseAuth.instance.currentUser!;
    final docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('medications')
        .doc(medication.id);

    final scheduleToSet = schedule ?? medication.getSchedule('08h00');

    await docRef.set({
      'times': scheduleToSet,
    }, SetOptions(merge: true));
  }

  void takenMed(
      int index, BuildContext context, String time, Prescription medication) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Toma de Medicamento'),
          content: const Text('Tomou o medicamento a que horas?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(dialogContext);

                await Future.delayed(Duration.zero);

                TimeOfDay? picked = await showTimePicker(
                  context: dialogContext,
                  initialTime: TimeOfDay.now(),
                );

                if (picked != null) {
                  String formattedHour =
                      picked.hour < 10 ? '0${picked.hour}' : '${picked.hour}';
                  String formattedMinutes = picked.minute < 10
                      ? '0${picked.minute}'
                      : '${picked.minute}';
                  String formattedTime = '${formattedHour}h$formattedMinutes';
                  _updateMedTaken(formattedTime, index, context, medication);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Selecione um horário, por favor.')),
                  );
                }
              },
              child: const Text('Editar horas'),
            ),
            TextButton(
              onPressed: () {
                _updateMedTaken(time, index, context, medication);
                Navigator.pop(context);
              },
              child: Text('Tomei às $time'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateMedTaken(String time, int index, BuildContext context,
      Prescription medication) async {
    TakenMed takenMed = TakenMed();
    await takenMed.takenMed(
      medicationId: medication.id,
      timesIndex: index,
      selectedDate: date,
      pickedTime: time,
    );
    const snackBar = SnackBar(
      content: Text(
        'Fantastico! Mais um passo na direção de melhorar a sua saúde!',
        textAlign: TextAlign.center,
      ),
      duration: const Duration(seconds: 3),
      backgroundColor: Colors.green,
      behavior: SnackBarBehavior.floating,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> _editSchedule(
      int index, Prescription medication, BuildContext context) async {
    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(DateTime.now()),
    );

    if (selectedTime != null) {
      List<String> schedule = medication.times;
      List<String> afterSchedule =
          medication.getSchedule('${selectedTime.hour}h${selectedTime.minute}');
      for (int i = 0; i < schedule.length - index; i++) {
        if (index + i < schedule.length) {
          schedule[i + index] = afterSchedule[i];
        }
      }
      _setScheduleInFirestore(medication: medication, schedule: schedule);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userPrescriptionAsync =
        ref.watch(watchUserPrescriptionProvider(medicationId));
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: userPrescriptionAsync.when(
          data: (prescription) {
            if (prescription.times.isEmpty) {
              _setScheduleInFirestore(medication: prescription);
            }
            int missingMeds =
                prescription.nrMedsDay - prescription.getTakenMedsDay(date);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                missingMeds == 0
                    ? const Center(
                        child: Text('Já tomou este medicamento neste dia.'))
                    : Center(
                        child: Text(missingMeds == 1
                            ? 'Falta-lhe ainda tomar 1 comprimido neste dia.'
                            : 'Faltam-lhe ainda tomar $missingMeds comprimidos neste dia.'),
                      ),
                Column(
                  children: List.generate(prescription.times.length, (index) {
                    //generates an aux list because takenMes may be empty

                    final takenMedsForDate = prescription.takenMeds[date] ??
                        List<String>.filled(prescription.nrMedsDay, 'null');
                    final theme = Theme.of(context);
                    return Column(
                      children: [
                        Card(
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
                            title: takenMedsForDate[index] != 'null'
                                ? Text(takenMedsForDate[index],
                                    style: theme.textTheme.headlineLarge!)
                                : Row(
                                    children: [
                                      Text(prescription.times[index],
                                          style:
                                              theme.textTheme.headlineLarge!),
                                      const SizedBox(width: 4),
                                      const Icon(
                                        Icons.edit,
                                        size: 20,
                                        color: Colors.black,
                                      )
                                    ],
                                  ),
                            trailing: takenMedsForDate[index] != 'null'
                                ? const Icon(
                                    Icons.check,
                                    color: Colors.green,
                                    size: 32,
                                  )
                                : FilledButton(
                                    onPressed: () {
                                      takenMed(
                                          index,
                                          context,
                                          prescription.times[index],
                                          prescription);
                                    },
                                    child: const Text('Já tomei'),
                                  ),
                            onTap: () {
                              if (takenMedsForDate[index] == 'null') {
                                _editSchedule(index, prescription, context);
                              }
                            },
                          ),
                        ),
                        if (index - 1 >= 0 &&
                            takenMedsForDate[index - 1] != 'null' &&
                            takenMedsForDate[index] == 'null' &&
                            prescription.getDifferenceTime(
                                    takenMedsForDate[index - 1],
                                    prescription.times[index]) <
                                prescription.frequency)
                          WarningFrequencyViolation(prescription: prescription)
                      ],
                    );
                  }),
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) =>
              const Center(child: Text('Error loading medication data')),
        ));
  }
}
