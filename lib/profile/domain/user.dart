import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class UserData {
  const UserData(
      {required this.userId,
      required this.email,
      required this.patientNr,
      required this.role,
      required this.username,
      required this.birthDate});

  final String username;
  final String userId;
  final String email;
  final String role;
  final String patientNr;
  final String birthDate;

  factory UserData.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;

    return UserData(
        userId: snapshot.id,
        email: data['email'],
        patientNr: data['personNr'],
        role: data['role'],
        username: data['username'],
        birthDate: DateFormat('yyyy-MM-dd').format(data['birthDate'].toDate()));
  }
}
