import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thesis_project/profile/presentation/profile_info_box.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({
    super.key,
    required this.initEmail,
    required this.initPatientNr,
    required this.initRole,
    required this.initUsername,
    required this.saveUserData,
    required this.initBirthDate,
  });

  final String initUsername;
  final String initEmail;
  final String initRole;
  final String initPatientNr;
  final String initBirthDate;
  final Function({
    required String username,
    required String email,
    required String role,
    required String patientNr,
    required String birthDate,
  }) saveUserData;

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  late String username;
  late String email;
  late String role;
  late String patientNr;
  late String birthDate;

  @override
  void initState() {
    super.initState();
    username = widget.initUsername;
    email = widget.initEmail;
    role = widget.initRole;
    patientNr = widget.initPatientNr;
    birthDate = widget.initBirthDate;
  }

  Future<void> deleteAccount() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .delete();
      await user.delete();
      if (mounted) Navigator.popUntil(context, (route) => route.isFirst);
    } catch (e) {
      print('Error during account deletion: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Perfil'),
        actions: [
          TextButton(
            onPressed: deleteAccount,
            child: Text(
              'Apagar',
              style: TextStyle(color: colorScheme.error),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProfileInfoBox(
                label: 'Nome',
                initialValue: username,
                onChanged: (value) => setState(() => username = value!),
                isTextField: true,
              ),
              const SizedBox(height: 16),
              ProfileInfoBox(
                label: 'Número Utente',
                initialValue: patientNr,
                onChanged: (value) => setState(() => patientNr = value!),
                isTextField: true,
              ),
              const SizedBox(height: 16),
              ProfileInfoBox(
                label: 'Função',
                initialValue: role,
                onChanged: (value) => setState(() => role = value ?? role),
                isDropdown: true,
              ),
              const SizedBox(height: 16),
              ProfileInfoBox(
                label: 'Data de Nascimento',
                initialValue: birthDate,
                onChanged: (value) =>
                    setState(() => birthDate = value ?? birthDate),
              ),
              const SizedBox(height: 16),
              ProfileInfoBox(
                label: 'Email',
                initialValue: email,
                onChanged: (value) => setState(() => email = value!),
                isTextField: true,
              ),
              const SizedBox(height: 16),
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancelar'),
                ),
                const SizedBox(width: 16),
                FilledButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      widget.saveUserData(
                          username: username,
                          email: email,
                          role: role,
                          patientNr: patientNr,
                          birthDate: birthDate);
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Guardar Alterações'),
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
