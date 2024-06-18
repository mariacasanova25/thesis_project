import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thesis_project/models/medication.dart';
import 'package:thesis_project/widgets/taken_med.dart';

class MedicationSchedule extends StatefulWidget {
  const MedicationSchedule({
    super.key,
    required this.date,
    required this.medication,
  });

  final Medication medication;
  final String date;

  @override
  State<MedicationSchedule> createState() => _MedicationScheduleState();
}

class _MedicationScheduleState extends State<MedicationSchedule> {
  late List<bool> medsTakenBool;
  late List<String> schedule;
  bool changed = false;

  @override
  void initState() {
    super.initState();
    int takenMeds = widget.medication.getTakenMedsDay(widget.date);

    medsTakenBool = List<bool>.generate(widget.medication.nrMedsDay, (index) {
      return index < takenMeds;
    });

    schedule = widget.medication.times.isEmpty
        ? widget.medication.getSchedule('8h00')
        : widget.medication.times;

    _initializeScheduleInFirestore();

    var takenMedsMap = widget.medication.takenMeds[widget.date];
    if (takenMedsMap != null) {
      for (int i = 0; i < widget.medication.nrMedsDay; i++) {
        medsTakenBool[i] = takenMedsMap[i] != 'null';
      }
    }
  }

  Future<void> _initializeScheduleInFirestore() async {
    final user = FirebaseAuth.instance.currentUser!;
    final docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('medications')
        .doc(widget.medication.id);

    if (widget.medication.times.isEmpty || changed) {
      await docRef.set({
        'times': schedule,
      }, SetOptions(merge: true));
    }
  }

  void takenMed(int index, BuildContext context, String time) {
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
                  _updateMedTaken(formattedTime, index, context);
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
                _updateMedTaken(time, index, context);
                Navigator.pop(context);
              },
              child: Text('Tomei às $time'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateMedTaken(
      String time, int index, BuildContext context) async {
    TakenMed takenMed = TakenMed();
    takenMed.takenMed(
        medicationId: widget.medication.id,
        timesIndex: index,
        selectedDate: widget.date,
        pickedTime: time);
    setState(() {
      medsTakenBool[index] = true;
      widget.medication.takenMeds.update(widget.date, (times) {
        times[index] = time;
        return times;
      }, ifAbsent: () {
        var times = List<String>.filled(widget.medication.nrMedsDay, 'null');
        times[index] = time;
        return times;
      });
    });
  }

  Future<void> _editSchedule(int index) async {
    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(DateTime.now()),
    );

    if (selectedTime != null) {
      setState(() {
        List<String> schedule2 = widget.medication
            .getSchedule('${selectedTime.hour}h${selectedTime.minute}');
        for (int i = 0; i < schedule.length - index; i++) {
          if (index + i < schedule.length) {
            schedule[i + index] = schedule2[i];
          }
        }
        _initializeScheduleInFirestore();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    int missingMeds = widget.medication.nrMedsDay -
        widget.medication.getTakenMedsDay(widget.date);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          missingMeds == 0
              ? const Text('Já tomou este medicamento hoje.')
              : Text('Falta-lhe ainda tomar $missingMeds comprimido(s) hoje.'),
          Column(
            children: List.generate(schedule.length, (index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          medsTakenBool[index]
                              ? widget.medication.takenMeds[widget.date]![index]
                              : schedule[index],
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(width: 16),
                        medsTakenBool[index]
                            ? const Icon(Icons.check_circle,
                                color: Colors.green)
                            : FilledButton(
                                onPressed: () {
                                  takenMed(index, context, schedule[index]);
                                },
                                child: const Text('Já tomei'),
                              ),
                        const SizedBox(width: 16),
                        if (!medsTakenBool[index])
                          FilledButton(
                            onPressed: () {
                              changed = true;
                              _editSchedule(index);
                            },
                            child: const Text('Editar horário'),
                          ),
                        const SizedBox(width: 16),
                      ],
                    ),
                    if (index - 1 >= 0 &&
                        medsTakenBool[index - 1] == true &&
                        medsTakenBool[index] == false &&
                        widget.medication.getDifferenceTime(
                                widget.medication
                                    .takenMeds[widget.date]![index - 1],
                                schedule[index]) <
                            widget.medication.frequency)
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Row(
                          children: [
                            const Icon(Icons.warning, color: Colors.purple),
                            const SizedBox(width: 4),
                            Text(
                                'Perigo! Intervalo menor que ${widget.medication.frequency} horas. Edite o horário.'),
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
}
