import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:thesis_project/models/medication.dart';
import 'package:thesis_project/widgets/medication_info_card.dart';
import 'package:thesis_project/widgets/medication_schedule.dart';
import 'package:thesis_project/widgets/send_message_button.dart';

class MedicationDetailsScreen extends StatelessWidget {
  const MedicationDetailsScreen(
      {super.key, required this.medication, required this.selectedDate});

  final Medication medication;

  final DateTime selectedDate;

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
            medicationId: medication.id,
            date: selectedDateForm,
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

                      return MedicationInfoCard(
                          title: loadedInfos[index].data()['title'],
                          content: content);
                    },
                  );
                }),
          ),
          //add a button for messages at the end of the page
          const SendMessageButton()
        ],
      ),
    );
  }
}
