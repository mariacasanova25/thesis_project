import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thesis_project/medications/model/prescription.dart';
import 'package:thesis_project/medications/data/prescriptions_repository.dart';
import 'package:thesis_project/adherenceStatistics/adherence_chart.dart';

class AdherenceScreen extends ConsumerStatefulWidget {
  const AdherenceScreen({super.key});

  @override
  ConsumerState<AdherenceScreen> createState() => _AdherenceScreenState();
}

class _AdherenceScreenState extends ConsumerState<AdherenceScreen> {
  Prescription? selectedMed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final userPrescriptionsAsync = ref.watch(watchUserPrescriptionsProvider);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: userPrescriptionsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => const SizedBox(width: 10),
        data: (meds) {
          if (meds.isEmpty) {
            return const Center(
                child: Text('Não foram encontrados medicamentos.'));
          }
          selectedMed ??= meds.first;
          return Column(
            children: [
              Wrap(
                spacing: 8,
                children: meds.map((med) {
                  return ChoiceChip(
                    selectedColor: colorScheme.primary,
                    checkmarkColor: colorScheme.onPrimary,
                    labelStyle: TextStyle(
                      color: selectedMed == med ? colorScheme.onPrimary : null,
                    ),
                    side: BorderSide.none,
                    onSelected: (_) {
                      setState(() {
                        selectedMed = med;
                      });
                    },
                    label: Text(med.name),
                    selected: selectedMed == med,
                  );
                }).toList(),
              ),
              const SizedBox(
                height: 24,
              ),
              if (selectedMed != null)
                Text(
                  selectedMed!.getStreak() == 0
                      ? 'Tome a medicação corretamente, para melhorar a sua saúde!'
                      : selectedMed!.getStreak() == 1
                          ? 'Há 1 dia que toma este medicamento corretamente!'
                          : 'Há ${selectedMed!.getStreak()} dias que toma este medicamento corretamente!',
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              const SizedBox(
                height: 32,
              ),
              if (selectedMed != null)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: AdherenceScatterChart(
                      data: selectedMed!,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
