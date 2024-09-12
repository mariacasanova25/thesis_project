import 'package:cloud_firestore/cloud_firestore.dart';

class Medication {
  const Medication(
      {required this.medicationId, required this.name, required this.infos});

  final String name;
  final String medicationId;
  final Map<String, String> infos;

  factory Medication.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();

    final Map<String, String> infos =
        (data!['infos'] as Map<String, dynamic>).map((key, value) {
      return MapEntry(key, value != null ? value.toString() : '');
    });

    return Medication(
      name: data['name'],
      infos: infos,
      medicationId: snapshot.id,
    );
  }
}
