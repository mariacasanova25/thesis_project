import 'package:flutter/material.dart';
import 'package:thesis_project/widgets/taken_med.dart';

class MedicationCard extends StatelessWidget {
  const MedicationCard(
      {super.key,
      required this.onResponse,
      required this.medicationId,
      required this.selectedDate,
      required this.timesIndex});

  final Function(bool) onResponse;
  final String selectedDate;
  final String medicationId;
  final int timesIndex;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Did you take your medication?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    final takenMed = TakenMed();
                    takenMed.takenMed(
                        medicationId: medicationId,
                        selectedDate: selectedDate,
                        timesIndex: timesIndex);
                    Navigator.pop(context);
                  },
                  child: const Text('Yes'),
                ),
                ElevatedButton(
                  onPressed: () => onResponse(false),
                  child: const Text('No'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
