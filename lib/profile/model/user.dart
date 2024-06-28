import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  const UserData(
      {required this.userId,
      required this.email,
      required this.patientNr,
      required this.role,
      required this.username});

  final String username;
  final String userId;
  final String email;
  final String role;
  final String patientNr;

  factory UserData.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;

    return UserData(
        userId: snapshot.id,
        email: data['email'],
        patientNr: data['personNr'],
        role: data['role'],
        username: data['username']);
  }
}
