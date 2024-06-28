import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:thesis_project/medications/model/prescription.dart';

part 'prescriptions_repository.g.dart';

class PrescriptionsRepository {
  const PrescriptionsRepository({required this.firestore});
  final FirebaseFirestore firestore;

  Stream<List<Prescription>> watchUserPrescriptions(String userId) {
    return firestore
        .collection('users')
        .doc(userId)
        .collection('medications')
        .snapshots()
        .map((snapshots) => snapshots.docs
            .map((doc) => Prescription.fromSnapshot(doc))
            .toList());
  }

  Stream<Prescription> watchUserPrescription(
      String userId, String medicationId) {
    return firestore
        .collection('users')
        .doc(userId)
        .collection('medications')
        .doc(medicationId)
        .snapshots()
        .map((snapshot) => Prescription.fromSnapshot(snapshot));
  }
}

@riverpod
PrescriptionsRepository prescriptionsRepository(
  PrescriptionsRepositoryRef ref,
) {
  return PrescriptionsRepository(firestore: FirebaseFirestore.instance);
}

@riverpod
Stream<List<Prescription>> watchUserPrescriptions(
  WatchUserPrescriptionsRef ref,
) {
  final user = FirebaseAuth.instance.currentUser!;
  return ref
      .watch(prescriptionsRepositoryProvider)
      .watchUserPrescriptions(user.uid);
}

@riverpod
Stream<Prescription> watchUserPrescription(
    WatchUserPrescriptionRef ref, String medicationId) {
  final user = FirebaseAuth.instance.currentUser!;
  return ref
      .watch(prescriptionsRepositoryProvider)
      .watchUserPrescription(user.uid, medicationId);
}
