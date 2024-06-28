import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:thesis_project/medications/data/medication_repository.dart';
import 'package:thesis_project/medications/medication_info_card.dart';
import 'package:thesis_project/medications/medication_schedule.dart';
import 'package:thesis_project/communityForum/send_message_button.dart';

class MedicationDetailsScreen extends ConsumerWidget {
  const MedicationDetailsScreen(
      {super.key,
      required this.medicationId,
      required this.selectedDate,
      required this.medicationName});

  final String medicationId;

  final DateTime selectedDate;
  final String medicationName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String selectedDateForm = DateFormat('yyyy-MM-dd').format(selectedDate);
    final medicationAsync = ref.watch(fetchMedicationProvider(medicationId));
    return Scaffold(
      appBar: AppBar(
        title: Text(medicationName),
      ),
      //this column includes all infos + message button at the end
      body: Column(
        children: [
          MedicationSchedule(
            medicationId: medicationId,
            date: selectedDateForm,
          ),
          Expanded(
              child: medicationAsync.when(
            data: (medication) {
              return ListView.builder(
                itemCount: medication.infos.length,
                itemBuilder: (context, index) {
                  String key = medication.infos.keys.elementAt(index);
                  String value = medication.infos[key]!;
                  List<String> content = value.split(',');

                  return MedicationInfoCard(title: key, content: content);
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stackTrace) => const SizedBox(
              width: 10,
            ),
          )),
          //add a button for messages at the end of the page
          const SendMessageButton()
        ],
      ),
    );
  }
}
