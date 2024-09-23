import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:thesis_project/communityForum/presentation/community_forum.dart';
import 'package:thesis_project/medications/data/medication_repository.dart';
import 'package:thesis_project/medications/domain/prescription.dart';
import 'package:thesis_project/medications/presentation/medication_info_card.dart';
import 'package:thesis_project/medications/presentation/medication_schedule.dart';

class MedicationDetailsScreen extends StatelessWidget {
  const MedicationDetailsScreen({
    super.key,
    required this.prescription,
    required this.selectedDate,
  });

  final Prescription prescription;
  final DateTime selectedDate;

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Consumer(
          builder: (context, ref, _) {
            final medicationAsync =
                ref.watch(fetchMedicationProvider(prescription.medicationId));
            return AlertDialog(
              title: Text('Informações sobre ${prescription.name}'),
              content: medicationAsync.when(
                data: (medication) {
                  return SizedBox(
                    height: 300, // Adjust height as necessary
                    width: double.maxFinite,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: medication.infos.entries.map((entry) {
                          String key = entry.key;
                          String value = entry.value;
                          List<String> content = value.split(',');

                          return MedicationInfoCard(
                              title: key, content: content);
                        }).toList(),
                      ),
                    ),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stackTrace) => const SizedBox(
                  width: 10,
                  child: Text('Erro ao carregar informações.'),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Fechar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String selectedDateForm = DateFormat('yyyy-MM-dd').format(selectedDate);
    return Scaffold(
      appBar: AppBar(
        title: Text(prescription.name),
        actions: [
          IconButton(
            onPressed: () => _showInfoDialog(context),
            icon: const Icon(Icons.info_outline),
          ),
        ],
      ),
      // This column includes all infos + message button at the end
      body: Column(
        children: [
          MedicationSchedule(
            prescriptionId: prescription.prescriptionId,
            date: selectedDateForm,
          ),

          // Add a button for messages at the end of the page
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CommunityForumScreen(),
            ),
          );
        },
        icon: const Icon(Icons.messenger_outline),
        label: const Text('Enviar Mensagem'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
