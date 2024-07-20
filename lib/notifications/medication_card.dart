import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thesis_project/medications/data/prescriptions_repository.dart';
import 'package:thesis_project/notifications/create_notification.dart';
import 'package:thesis_project/medications/taken_med.dart';

class MedicationCard extends ConsumerStatefulWidget {
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
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _MedicationCardState();
  }
}

class _MedicationCardState extends ConsumerState<MedicationCard> {
  late String imageUrl = '';
  Future<void> downloadImage() async {
    try {
      print(widget.medicationId);
      final ref =
          FirebaseStorage.instance.ref().child('${widget.medicationId}.png');
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
        ref.watch(watchUserPrescriptionProvider(widget.medicationId));

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
                    'Ingira ${prescription.dosage} comprimido(s)',
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: imageUrl.isNotEmpty
                        ? Image.network(imageUrl)
                        : const CircularProgressIndicator(),
                  ),
                  Wrap(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          widget.onResponse(false);
                          Navigator.pop(context);
                        },
                        child: const Text('Não'),
                      ),
                      const SizedBox(width: 8),
                      FilledButton(
                        onPressed: () {
                          TakenMed takenMed = TakenMed();
                          takenMed.takenMed(
                              medicationId: widget.medicationId,
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
                        child: const Text('Sim'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          List<String> timeParts =
                              prescription.times[widget.timesIndex].split('h');
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
                              prescription: prescription,
                              minute: newTime.minute,
                              selectedDateForm: widget.selectedDate,
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
