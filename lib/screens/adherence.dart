import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thesis_project/models/prescription.dart';
import 'package:thesis_project/repositories/prescriptions_repository.dart';
import 'package:thesis_project/widgets/adherence_chart.dart';

class AdherenceScreen extends ConsumerStatefulWidget {
  const AdherenceScreen({super.key});

  @override
  ConsumerState<AdherenceScreen> createState() => _AdherenceScreenState();
}

class _AdherenceScreenState extends ConsumerState<AdherenceScreen> {
  Prescription? selectedMed;

  @override
  Widget build(BuildContext context) {
    final userPrescriptionsAsync = ref.watch(watchUserPrescriptionsProvider);

    return Scaffold(
        appBar: AppBar(title: const Text('A Minha Adesão')),
        body: Column(children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: userPrescriptionsAsync.when(
                  data: (loadedMeds) {
                    if (loadedMeds.isEmpty) {
                      return const Center(
                          child: Text('Não foram encontrados medicamentos.'));
                    }
                    return Center(
                      child: Column(
                        children: [
                          Wrap(
                            spacing: 8,
                            children: loadedMeds.map((med) {
                              return ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    selectedMed = med;
                                  });
                                },
                                child: Text(med.name),
                              );
                            }).toList(),
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          if (selectedMed != null)
                            selectedMed!.getStreak() == 0
                                ? const Text(
                                    'Tome a medicação corretamente, para melhorar a sua saúde!')
                                : Text(
                                    'Há ${selectedMed!.getStreak()} dias que toma este medicamento corretamente!',
                                    style: const TextStyle(fontSize: 16),
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
                      ),
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (error, stackTrace) {
                    return const SizedBox(
                      width: 10,
                    );
                  }),
            ),
          )
        ]));
  }
}
