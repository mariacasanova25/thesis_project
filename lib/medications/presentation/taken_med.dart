import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:thesis_project/medications/domain/prescription.dart';

class TakenMed {
  Future<void> takenMed(
      {required String prescriptionId,
      required String selectedDate,
      required int timesIndex,
      String? pickedTime}) async {
    final user = FirebaseAuth.instance.currentUser!;
    final docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('prescriptions')
        .doc(prescriptionId);

    try {
      final docSnapshot = await docRef.get();
      if (docSnapshot.exists) {
        final medication = Prescription.fromSnapshot(docSnapshot);

        Map<String, List<String>> takenMeds = medication.takenMeds;

        // Check if the time already exists for the selected date
        if (!takenMeds.containsKey(selectedDate)) {
          takenMeds[selectedDate] = [];
          for (int i = 0; i < medication.nrMedsDay; i++) {
            takenMeds[selectedDate]!.add('null');
          }
        }
        String time = '';
        if (pickedTime == null) {
          time = medication.times[timesIndex];
        } else {
          time = pickedTime;
        }
        // Only add the time if it doesn't already exist
        if (!takenMeds[selectedDate]!.contains(time)) {
          takenMeds[selectedDate]![timesIndex] = time;
          print(takenMeds[selectedDate]);
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
}
