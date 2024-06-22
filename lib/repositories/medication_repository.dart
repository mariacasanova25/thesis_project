import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:thesis_project/models/medication.dart';

part 'medication_repository.g.dart';

class MedicationsRepository {
  const MedicationsRepository({required this.firestore});

  final FirebaseFirestore firestore;

  Stream<Medication> fetchMedication(String medicationId) {
    return firestore
        .collection('medications')
        .doc(medicationId)
        .snapshots()
        .map(
          (snapshot) => Medication.fromSnapshot(snapshot),
        );
  }
}

@riverpod
MedicationsRepository medicationRepository(MedicationRepositoryRef ref) {
  return MedicationsRepository(firestore: FirebaseFirestore.instance);
}

@riverpod
Stream<Medication> fetchMedication(
    FetchMedicationRef ref, String medicationId) {
  return ref.watch(medicationRepositoryProvider).fetchMedication(medicationId);
}
