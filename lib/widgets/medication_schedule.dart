import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thesis_project/models/medication.dart';
import 'package:thesis_project/widgets/taken_med.dart';

class MedicationSchedule extends StatefulWidget {
  const MedicationSchedule({
    super.key,
    required this.date,
    required this.medicationId,
  });

  final String medicationId;
  final String date;

  @override
  State<MedicationSchedule> createState() => _MedicationScheduleState();
}

class _MedicationScheduleState extends State<MedicationSchedule> {
  late List<String> schedule;
  bool changed = false;

  void _initializeScheduleInFirestore(Medication medication) async {
    final user = FirebaseAuth.instance.currentUser!;
    final docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('medications')
        .doc(medication.id);

    if (medication.times.isEmpty || changed) {
      await docRef.set({
        'times': schedule,
      }, SetOptions(merge: true));
    }
  }

  void takenMed(
      int index, BuildContext context, String time, Medication medication) {
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
      Medication medication) async {
    TakenMed takenMed = TakenMed();
    await takenMed.takenMed(
      medicationId: medication.id,
      timesIndex: index,
      selectedDate: widget.date,
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

  Future<void> _editSchedule(int index, Medication medication) async {
    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(DateTime.now()),
    );

    if (selectedTime != null) {
      setState(() {
        List<String> schedule2 = medication
            .getSchedule('${selectedTime.hour}h${selectedTime.minute}');
        for (int i = 0; i < schedule.length - index; i++) {
          if (index + i < schedule.length) {
            schedule[i + index] = schedule2[i];
          }
        }
        _initializeScheduleInFirestore(medication);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    final docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('medications')
        .doc(widget.medicationId);

    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: docRef.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error loading medication data'));
        } else if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Center(child: Text('Medication data not found'));
        } else {
          final medication = Medication.fromSnapshot(snapshot.data!);

          if (medication.times.isEmpty) {
            schedule = medication.getSchedule('8h00');
            _initializeScheduleInFirestore(medication);
          } else {
            schedule = medication.times;
          }

          int missingMeds =
              medication.nrMedsDay - medication.getTakenMedsDay(widget.date);

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                missingMeds == 0
                    ? const Text('Já tomou este medicamento hoje.')
                    : Text(
                        'Falta-lhe ainda tomar $missingMeds comprimido(s) hoje.'),
                Column(
                  children: List.generate(schedule.length, (index) {
                    final takenMedsForDate =
                        medication.takenMeds[widget.date] ??
                            List<String>.filled(medication.nrMedsDay, 'null');

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                takenMedsForDate[index] != 'null'
                                    ? takenMedsForDate[index]
                                    : schedule[index],
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(width: 16),
                              takenMedsForDate[index] != 'null'
                                  ? const Icon(Icons.check_circle,
                                      color: Colors.green)
                                  : FilledButton(
                                      onPressed: () {
                                        takenMed(index, context,
                                            schedule[index], medication);
                                      },
                                      child: const Text('Já tomei'),
                                    ),
                              const SizedBox(width: 16),
                              if (takenMedsForDate[index] == 'null')
                                FilledButton(
                                  onPressed: () {
                                    changed = true;
                                    _editSchedule(index, medication);
                                  },
                                  child: const Text('Editar horário'),
                                ),
                              const SizedBox(width: 16),
                            ],
                          ),
                          if (index - 1 >= 0 &&
                              takenMedsForDate[index - 1] != 'null' &&
                              takenMedsForDate[index] == 'null' &&
                              medication.getDifferenceTime(
                                      takenMedsForDate[index - 1],
                                      schedule[index]) <
                                  medication.frequency)
                            Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Row(
                                children: [
                                  const Icon(Icons.warning,
                                      color: Colors.purple),
                                  const SizedBox(width: 4),
                                  Text(
                                      'Perigo! Intervalo menor que ${medication.frequency} horas. Edite o horário.'),
                                ],
                              ),
                            ),
                        ],
                      ),
                    );
                  }),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
