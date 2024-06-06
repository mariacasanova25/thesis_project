import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thesis_project/screens/edit_profile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String initUsername = '';
  String initEmail = '';
  String initRole = 'patient';
  String initPatientNr = '';

  @override
  void initState() {
    super.initState();
    setInitUserData();
  }

  Future<void> setInitUserData() async {
    final user = FirebaseAuth.instance.currentUser!;

    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    setState(() {
      initUsername = userData.data()?['username'] ?? '';
      initEmail = userData.data()?['email'] ?? '';
      initPatientNr = userData.data()?['patientNr'] ?? '';
      initRole = userData.data()?['role'] ?? 'patient';
    });
  }

  void saveUserData({
    required String username,
    required String role,
    required String email,
    required String patientNr,
  }) async {
    final user = FirebaseAuth.instance.currentUser!;
    await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
      'username': username,
      'email': email,
      'role': role,
      'patientNr': patientNr,
    });
    setState(() {
      initUsername = username;
      initEmail = email;
      initPatientNr = patientNr;
      initRole = role;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated successfully')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
      ),
      body: initUsername.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                const Icon(Icons.person_2, size: 64),
                const SizedBox(height: 8),
                Text(
                  initUsername,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 24),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(initRole),
                const SizedBox(
                  height: 8,
                ),
                Text('Número de Utente: $initPatientNr'),
                const SizedBox(
                  height: 16,
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: FilledButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditProfileScreen(
                            initUsername: initUsername,
                            initEmail: initEmail,
                            initPatientNr: initPatientNr,
                            initRole: initRole,
                            saveUserData: saveUserData,
                          ),
                        ),
                      );
                    },
                    child: const Text('Editar Perfil'),
                  ),
                ),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                  },
                  label: const Text('Terminar Sessão'),
                  icon: const Icon(Icons.logout),
                )
              ],
            ),
    );
  }
}
