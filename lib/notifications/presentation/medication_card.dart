import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thesis_project/medications/data/prescriptions_repository.dart';
import 'package:thesis_project/medications/presentation/taken_med.dart';
import 'package:thesis_project/notifications/presentation/create_notification.dart';

class MedicationCard extends ConsumerStatefulWidget {
  const MedicationCard({
    super.key,
    required this.onResponse,
    required this.prescriptionId,
    required this.selectedDate,
    required this.timesIndex,
  });

  final Function(bool) onResponse;
  final String selectedDate;
  final String prescriptionId;
  final int timesIndex;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _MedicationCardState();
  }
}

class _MedicationCardState extends ConsumerState<MedicationCard> {
  late String imageUrl = '';
  Future<void> downloadImage() async {
    try {
      final ref =
          FirebaseStorage.instance.ref().child('${widget.prescriptionId}.png');
      final url = await ref.getDownloadURL();
      setState(() {
        imageUrl = url;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    downloadImage();
  }

  @override
  Widget build(BuildContext context) {
    final prescriptionAsync =
        ref.watch(watchUserPrescriptionProvider(widget.prescriptionId));

    return prescriptionAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => const SizedBox.shrink(),
      data: (prescription) {
        return AlertDialog(
          title: Text(
            'Hora de tomar ${prescription.name}.',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                prescription.times[widget.timesIndex],
                style: const TextStyle(fontSize: 14),
              ),
              Text(
                'Ingira ${prescription.dosage} comprimido(s)',
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 16),
              Center(
                child: imageUrl.isNotEmpty
                    ? Image.network(imageUrl)
                    : Image.asset(
                        'assets/images/pills.png',
                        width: 80,
                      ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                widget.onResponse(false);
                Navigator.pop(context);
              },
              child: const Text('Não'),
            ),
            FilledButton(
              onPressed: () {
                TakenMed takenMed = TakenMed();
                takenMed.takenMed(
                    prescriptionId: widget.prescriptionId,
                    selectedDate: widget.selectedDate,
                    timesIndex: widget.timesIndex);
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
              child: const Text('Já tomei'),
            ),
            ElevatedButton(
              onPressed: () {
                List<String> timeParts =
                    prescription.times[widget.timesIndex].split('h');
                int hour = int.parse(timeParts[0]);
                int minute = int.parse(timeParts[1]);

                DateTime initialTime = DateTime(2024, 1, 1, hour, minute);

                // Add 15 minutes
                DateTime newTime = initialTime.add(const Duration(minutes: 5));

                CreateNotification snoozeNotification = CreateNotification();
                snoozeNotification.createNotification(
                    context: context,
                    hour: newTime.hour,
                    id: 100,
                    prescription: prescription,
                    minute: newTime.minute,
                    selectedDateForm: widget.selectedDate,
                    repeats: false);
                Navigator.pop(context);
              },
              child: const Text('Adiar 15min'),
            )
          ],
        );
      },
    );
  }
}
