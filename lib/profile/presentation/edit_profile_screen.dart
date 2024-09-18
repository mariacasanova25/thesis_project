import 'package:flutter/material.dart';
import 'package:thesis_project/profile/presentation/profile_info_box.dart';

class EditProfileScreen extends StatefulWidget {
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
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
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

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Perfil'),
        actions: [
          TextButton(
            onPressed: () {},
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
