import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thesis_project/profile/data/user_repository.dart';
import 'package:thesis_project/profile/domain/user.dart';
import 'package:thesis_project/profile/presentation/edit_profile_screen.dart';

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
    required String birthDate,
  }) async {
    final user = FirebaseAuth.instance.currentUser!;
    await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
      'username': username,
      'email': email,
      'role': role,
      'personNr': patientNr,
      'birthDate': DateTime.parse(birthDate),
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
          initBirthDate: user.birthDate,
          saveUserData: saveUserData,
        ),
      ),
    );
  }

  void editProfile(UserData user) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EditProfileScreen(
                  initUsername: user.username,
                  initBirthDate: user.birthDate,
                  initEmail: user.email,
                  initPatientNr: user.patientNr,
                  initRole: user.role,
                  saveUserData: saveUserData,
                )));
  }

  void logout() {
    FirebaseAuth.instance.signOut();
    Navigator.pop(context);
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
            onPressed: logout,
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
                const Center(
                  child: CircleAvatar(
                    radius: 44,
                    child: Icon(Icons.account_circle, size: 88),
                  ),
                ),
                const SizedBox(height: 32),
                Text('Nome', style: textTheme.titleSmall),
                Text(user.username, style: textTheme.titleLarge),
                const SizedBox(height: 16),
                Text('Função', style: textTheme.titleSmall),
                Text(user.role, style: textTheme.titleLarge),
                const SizedBox(height: 16),
                Text('Número de Utente', style: textTheme.titleSmall),
                Text(user.patientNr, style: textTheme.titleLarge),
                const SizedBox(height: 16),
                Text('Data de Nascimento', style: textTheme.titleSmall),
                Text(user.birthDate, style: textTheme.titleLarge),
                const SizedBox(height: 16),
                Text('Email', style: textTheme.titleSmall),
                Text(user.email, style: textTheme.titleLarge),
                const SizedBox(height: 32),
                Center(
                  child: FilledButton.icon(
                    onPressed: () => editProfile(user),
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
}
