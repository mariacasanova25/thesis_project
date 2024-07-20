import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thesis_project/profile/edit_profile_screen.dart';
import 'package:thesis_project/profile/data/user_repository.dart';
import 'package:thesis_project/profile/model/user.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  void saveUserData({
    required String username,
    required String role,
    required String email,
    required String patientNr,
    required String bornDate,
  }) async {
    final user = FirebaseAuth.instance.currentUser!;
    await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
      'username': username,
      'email': email,
      'role': role,
      'personNr': patientNr,
      'bornDate': DateTime.parse(bornDate),
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Perfil editado com sucesso!')),
      );
    }
  }

  void openEditProfileScreen(UserData user) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfileScreen(
          initUsername: user.username,
          initEmail: user.email,
          initPatientNr: user.patientNr,
          initRole: user.role,
          initBornDate: user.bornDate,
          saveUserData: saveUserData,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final userAsync = ref.watch(watchUserProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.pop(context);
            },
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: userAsync.when(
          error: (error, _) => Center(
              child: Text('Erro ao carregar perfil',
                  style: textTheme.headlineLarge)),
          loading: () => const Center(child: CircularProgressIndicator()),
          data: (user) => SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: [
                      const CircleAvatar(
                        radius: 44,
                        child: Icon(Icons.account_circle, size: 88),
                      ),
                      const SizedBox(height: 16),
                      Text(user.username, style: textTheme.headlineLarge),
                      Text(user.role, style: textTheme.headlineSmall),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                _buildProfileInfo(
                    'Número de Utente', user.patientNr, textTheme),
                _buildProfileInfo(
                    'Data de Nascimento', user.bornDate, textTheme),
                const SizedBox(height: 32),
                Center(
                  child: FilledButton.icon(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditProfileScreen(
                                    initUsername: user.username,
                                    initBornDate: user.bornDate,
                                    initEmail: user.email,
                                    initPatientNr: user.patientNr,
                                    initRole: user.role,
                                    saveUserData: saveUserData,
                                  )));
                    },
                    label: const Text('Editar Perfil'),
                    icon: const Icon(Icons.edit),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileInfo(String label, String value, TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label: ', style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
