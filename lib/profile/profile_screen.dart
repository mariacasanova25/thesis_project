import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thesis_project/profile/edit_profile.dart';
import 'package:thesis_project/profile/data/user_repository.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  String initUsername = '';
  String initEmail = '';
  String initRole = 'patient';
  String initPatientNr = '';

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
      'personNr': patientNr,
    });
    initUsername = username;
    initEmail = email;
    initPatientNr = patientNr;
    initRole = role;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated successfully')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(watchUserProvider);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Perfil'),
        ),
        body: userAsync.when(
          data: (user) {
            return Column(
              children: [
                const Icon(Icons.person_2, size: 64),
                const SizedBox(height: 8),
                Text(
                  user.username,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 24),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(user.role),
                const SizedBox(
                  height: 8,
                ),
                Text('Número de Utente: ${user.patientNr}'),
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
                            initUsername: user.username,
                            initEmail: user.email,
                            initPatientNr: user.patientNr,
                            initRole: user.role,
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
            );
          },
          error: (error, stackTrace) => const SizedBox(
            width: 10,
          ),
          loading: () => const CircularProgressIndicator(),
        ));
  }
}
