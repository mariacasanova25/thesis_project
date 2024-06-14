import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:thesis_project/models/medication.dart';
import 'package:thesis_project/screens/community_forum.dart';
import 'package:thesis_project/widgets/medication_schedule.dart';

class MedicationDetailsScreen extends StatelessWidget {
  const MedicationDetailsScreen(
      {super.key, required this.medication, required this.selectedDate});

  final Medication medication;

  final DateTime selectedDate;

  Future<void> takenMed(String selectedDateForm, String time, int index) async {
    final user = FirebaseAuth.instance.currentUser!;
    final docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('medications')
        .doc(medication.id);

    try {
      final docSnapshot = await docRef.get();
      if (docSnapshot.exists) {
        final data = docSnapshot.data() as Map<String, dynamic>;
        Map<String, List<String>> takenMeds = medication.takenMeds;

        if (data['takenMeds'] != null) {
          // Ensure that takenMeds is a Map<String, List<String>>
          takenMeds =
              (data['takenMeds'] as Map<String, dynamic>).map((key, value) {
            return MapEntry(key, List<String>.from(value));
          });
        }

        // Check if the time already exists for the selected date
        if (!takenMeds.containsKey(selectedDateForm)) {
          takenMeds[selectedDateForm] = [];
          for (int i = 0; i < medication.nrMedsDay; i++) {
            takenMeds[selectedDateForm]!.add('null');
            print(takenMeds[selectedDateForm]);
          }
        }

        // Only add the time if it doesn't already exist
        if (!takenMeds[selectedDateForm]!.contains(time)) {
          takenMeds[selectedDateForm]![index] = time;
          print(takenMeds[selectedDateForm]);
        }

        // Update the document with the new takenMeds map
        await docRef.set({
          'takenMeds': takenMeds,
        }, SetOptions(merge: true));
      } else {
        // Handle case where document does not exist
        print('Document does not exist.');
      }
    } catch (e) {
      print('Error updating takenMeds: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    String selectedDateForm = DateFormat('yyyy-MM-dd').format(selectedDate);

    return Scaffold(
      appBar: AppBar(
        title: Text(medication.name),
      ),
      //this column includes all infos + message button at the end
      body: Column(
        children: [
          MedicationSchedule(
            medication: medication,
            date: selectedDateForm,
            takenMedDB: takenMed,
          ),
          Expanded(
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('medications')
                    .doc(medication.id)
                    .collection('infos')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('No medications found'));
                  }

                  final loadedInfos = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: loadedInfos.length,
                    itemBuilder: (context, index) {
                      List<String> content =
                          loadedInfos[index].data()['content'].split(',');

                      return Column(children: [
                        SizedBox(
                          width: 300,
                          //one card for each info
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(24),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                    child: Text(
                                      loadedInfos[index].data()['title'],
                                      style: const TextStyle(fontSize: 16),
                                      textAlign: TextAlign.center,
                                    ),
                                  ), //for info's title
                                  const SizedBox(height: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: content
                                        .map((e) => Text(e.trim()))
                                        .toList(),
                                  ) //for information content
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16)
                      ]);
                    },
                  );
                }),
          ),

          //add a button for messages at the end of the page
          Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                children: [
                  const Text('Continua com dúvidas?'),
                  Padding(
                      padding: const EdgeInsets.all(
                          16.0), // Add padding to avoid hitting the edge
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.messenger_outline),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const CommunityForumScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                            textStyle: const TextStyle(fontSize: 16)),
                        label: const Text("Enviar Mensagem"),
                      ))
                ],
              ))
        ],
      ),
    );
  }
}
