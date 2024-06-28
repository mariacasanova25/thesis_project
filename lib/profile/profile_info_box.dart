import 'package:flutter/material.dart';

class ProfileInfoBox extends StatelessWidget {
  final String label;
  final String initialValue;
  final ValueChanged<String?> onChanged;
  final bool isDropdown;

  const ProfileInfoBox({
    super.key,
    required this.label,
    required this.initialValue,
    required this.onChanged,
    this.isDropdown = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.purple.shade50,
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.purple),
          ),
          const SizedBox(height: 8),
          isDropdown
              ? DropdownButtonFormField<String>(
                  items: ['Paciente', 'Cuidador']
                      .map((role) => DropdownMenuItem(
                            value: role,
                            child: Text(role),
                          ))
                      .toList(),
                  onChanged: onChanged,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor selecione a função';
                    }
                    return null;
                  },
                )
              : TextFormField(
                  initialValue: initialValue,
                  onChanged: (value) => onChanged(value),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor adicione $label';
                    }
                    return null;
                  },
                ),
        ],
      ),
    );
  }
}
