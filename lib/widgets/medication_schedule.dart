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
  late List<bool> medsTaken;
  late List<String> schedule;

  @override
  void initState() {
    super.initState();
    int takenMeds = widget.medication.getTakenMedsDay(widget.date);
    //change how this medsTaken is generated with index

    medsTaken = List<bool>.generate(widget.medication.nrMedsDay, (index) {
      return index < takenMeds;
    });
    schedule = widget.medication.getSchedule(widget.date, '8h00');
  }

  void takenMed(String time, int index) {
    setState(() {
      medsTaken[index] = true;
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
        List<String> schedule2 = widget.medication.getSchedule(
            widget.date, '${selectedTime.hour}h${selectedTime.minute}');
        print(schedule2);
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
          ...List.generate(
              widget.medication.getSchedule(widget.date, '8h00').length,
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
                    medsTaken[index]
                        ? const Icon(Icons.check_circle, color: Colors.green)
                        : FilledButton(
                            onPressed: () {
                              takenMed(schedule[index], index);
                            },
                            child: const Text('Já tomei'),
                          ),
                    const SizedBox(width: 16),
                    if (!medsTaken[index])
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
