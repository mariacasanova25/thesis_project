import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:thesis_project/models/medication.dart';
import 'package:thesis_project/screens/medication_details.dart';

class MedicationScreen extends StatelessWidget {
  const MedicationScreen({super.key, required this.selectedDate});

  final DateTime selectedDate;

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    return Expanded(
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('medications')
            .snapshots()
            .map((snapshots) => snapshots.docs
                .map((doc) => Medication.fromSnapshot(doc))
                .toList()),
        builder: (context, AsyncSnapshot<List<Medication>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
                child: Text('Não foram encontrados medicamentos.'));
          }

          final loadedMeds = snapshot.data!;

          final filteredMeds = loadedMeds.where((medication) {
            var endDate = DateTime(medication.endDate.year,
                medication.endDate.month, medication.endDate.day);
            var startDate = DateTime(medication.startDate.year,
                medication.startDate.month, medication.startDate.day);

            return (endDate.isAfter(selectedDate) ||
                    endDate.isAtSameMomentAs(selectedDate)) &&
                (startDate.isBefore(selectedDate) ||
                    startDate.isAtSameMomentAs(selectedDate));
          }).toList();

          if (filteredMeds.isEmpty) {
            return const Center(
              child: Text('Não tem medicamentos para tomar'),
            );
          }

          return ListView.builder(
              itemCount: filteredMeds.length,
              itemBuilder: (context, index) {
                var currentDate = DateTime.now();
                var daysLeft =
                    filteredMeds[index].endDate.difference(currentDate).inDays;

                String selectedDateForm =
                    DateFormat('yyyy-MM-dd').format(selectedDate);
                int takenMeds = 0;
                var help = filteredMeds[index].takenMeds[selectedDateForm];
                if (help != null) {
                  for (int i = 0; i < help.length; i++) {
                    if (help[i] != 'null') {
                      takenMeds++;
                    }
                  }
                }

                print(
                    'Medication: ${filteredMeds[index].name}, takenMeds: $takenMeds');

                return ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MedicationDetailsScreen(
                              medication: filteredMeds[index],
                              selectedDate: selectedDate),
                        ));
                  },
                  title: Text(
                    filteredMeds[index].name,
                    style: const TextStyle(fontSize: 20),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Dose: ${filteredMeds[index].dosage}'),
                      filteredMeds[index].frequency == 24
                          ? const Text('1 vez ao dia.')
                          : Text(
                              '${filteredMeds[index].nrMedsDay} vezes ao dia.'),
                      Text(
                          '$takenMeds/${filteredMeds[index].nrMedsDay} comprimidos tomados hoje.'),
                      Text('Termina em: $daysLeft dias.'),
                    ],
                  ),
                  leading: const Icon(
                    Icons.medication,
                    size: 64,
                    color: Colors.purple,
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios),
                );
              });
        },
      ),
    );
  }
}
