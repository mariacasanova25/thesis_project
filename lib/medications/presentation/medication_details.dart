import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:thesis_project/communityForum/presentation/community_forum.dart';
import 'package:thesis_project/medications/data/medication_repository.dart';
import 'package:thesis_project/medications/presentation/medication_info_card.dart';
import 'package:thesis_project/medications/presentation/medication_schedule.dart';

class MedicationDetailsScreen extends ConsumerWidget {
  const MedicationDetailsScreen({
    super.key,
    required this.medicationId,
    required this.selectedDate,
    required this.medicationName,
  });

  final String medicationId;
  final DateTime selectedDate;
  final String medicationName;

  void _showInfoDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final medicationAsync =
            ref.watch(fetchMedicationProvider(medicationId));

        return AlertDialog(
          title: Text('Informações sobre $medicationName'),
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

                      return MedicationInfoCard(title: key, content: content);
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
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String selectedDateForm = DateFormat('yyyy-MM-dd').format(selectedDate);
    final medicationAsync = ref.watch(fetchMedicationProvider(medicationId));
    return Scaffold(
      appBar: AppBar(
        title: Text(medicationName),
        actions: [
          IconButton(
            onPressed: () {
              _showInfoDialog(context, ref);
            },
            icon: const Icon(Icons.info_outline),
          ),
        ],
      ),
      // This column includes all infos + message button at the end
      body: Column(
        children: [
          MedicationSchedule(
            medicationId: medicationId,
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
