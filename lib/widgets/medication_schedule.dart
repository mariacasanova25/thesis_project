import 'dart:math';

import 'package:flutter/material.dart';
import 'package:thesis_project/models/medication.dart';

class MedicationSchedule extends StatefulWidget {
  const MedicationSchedule(
      {super.key,
      required this.date,
      required this.medication,
      required this.takenMedDB});

  final Medication medication;
  final String date;
  final void Function(String date, String time, int index) takenMedDB;

  @override
  State<MedicationSchedule> createState() => _MedicationScheduleState();
}

class _MedicationScheduleState extends State<MedicationSchedule> {
  late List<bool> medsTakenBool;
  late List<String> schedule;

  @override
  void initState() {
    super.initState();
    int takenMeds = widget.medication.getTakenMedsDay(widget.date);
    //change how this medsTakenBool is generated with index

    medsTakenBool = List<bool>.generate(widget.medication.nrMedsDay, (index) {
      return index < takenMeds;
    });
    schedule = widget.medication.getSchedule('8h00');

    var takenMedsMap = widget.medication.takenMeds[widget.date];

    if (takenMedsMap != null) {
      for (int i = 0; i < widget.medication.nrMedsDay; i++) {
        if (takenMedsMap[i] == 'null') {
          medsTakenBool[i] = false;
        } else {
          medsTakenBool[i] = true;
        }
      }
    }
  }

  void takenMed(int index, BuildContext context, String time) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        // Use dialogContext here
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
                Navigator.pop(dialogContext); // Close the dialog first

                // Ensure context is available in post-frame callback
                await Future.delayed(Duration.zero);

                TimeOfDay? picked = await showTimePicker(
                  context: dialogContext,
                  initialTime: TimeOfDay.now(),
                );

                if (picked != null) {
                  String formattedTime = '${picked.hour}h${picked.minute}';
                  print(formattedTime);
                  // Call a function to update state and database outside of the dialog context
                  _updateMedTaken(formattedTime, index, context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please select a time.')),
                  );
                }
              },
              child: const Text('Editar horas'),
            ),
            TextButton(
              onPressed: () {
                // Call a function to update state and database outside of the dialog context
                _updateMedTaken(time, index, context);
              },
              child: Text('Tomei às $time'),
            ),
          ],
        );
      },
    );
  }

  void _updateMedTaken(String time, int index, BuildContext context) {
    setState(() {
      medsTakenBool[index] = true;
      widget.takenMedDB(widget.date, time, index);
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
          ...List.generate(widget.medication.getSchedule('8h00').length,
              (index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Center(
                child: Row(
                  children: [
                    Text(
                      schedule[index],
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(width: 16),
                    medsTakenBool[index]
                        ? const Icon(Icons.check_circle, color: Colors.green)
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
                            _editSchedule(index);
                          },
                          child: const Text('Editar horário'))
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
