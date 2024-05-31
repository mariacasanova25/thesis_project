import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:thesis_project/screens/community_forum.dart';

class MedicationDetailsScreen extends StatelessWidget {
  const MedicationDetailsScreen(
      {super.key,
      required this.medication,
      required this.takenMeds,
      required this.frequency,
      required this.medicationId,
      required this.selectedDate});

  final String medication;
  final int takenMeds;
  final int frequency;
  final String medicationId;
  final DateTime selectedDate;

  void takenMed() {
    final user = FirebaseAuth.instance.currentUser!;
    final selectedDateForm = DateFormat('yyyy-MM-dd').format(selectedDate);
    final res = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('medications')
        .doc(medicationId)
        .set(
      {
        'takenMeds': {
          selectedDateForm: FieldValue.increment(1),
        },
      },
      SetOptions(merge: true),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dateNow = DateTime.now();
    final missingMeds = frequency - takenMeds;
    return Scaffold(
      appBar: AppBar(
        title: Text(medication),
      ),
      //this column includes all infos + message button at the end
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('medications')
                    .doc(medicationId)
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
          if (takenMeds < frequency &&
              selectedDate ==
                  DateTime(dateNow.year, dateNow.month, dateNow.day))
            Column(
              children: [
                Text('Falta-lhe ainda tomar $missingMeds comprimido(s) hoje.'),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      return takenMed();
                    },
                    child: const Text('Já tomei'))
              ],
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
