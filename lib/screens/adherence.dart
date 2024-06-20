import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thesis_project/models/prescription.dart';
import 'package:thesis_project/repositories/prescriptions_repository.dart';
import 'package:thesis_project/widgets/adherence_chart.dart';

class AdherenceScreen extends StatefulWidget {
  const AdherenceScreen({super.key});

  @override
  State<AdherenceScreen> createState() => _AdherenceScreenState();
}

class _AdherenceScreenState extends State<AdherenceScreen> {
  Prescription? selectedMed;

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    return Scaffold(
      appBar: AppBar(title: const Text('A Minha Adesão')),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: StreamBuilder<Iterable<Prescription>>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(user.uid)
                    .collection('medications')
                    .snapshots()
                    .map((snapshots) => snapshots.docs
                        .map((doc) => Prescription.fromSnapshot(doc))),
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                        child: Text('Não foram encontrados medicamentos.'));
                  }
                  if (snapshot.hasData) {
                    var loadedMeds = snapshot.data!.toList();
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
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
