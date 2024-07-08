import 'package:flutter/material.dart';

class ProfileInfoBox extends StatefulWidget {
  final String label;
  final String initialValue;
  final ValueChanged<String?> onChanged;
  final bool isDropdown;
  final bool isTextField;

  const ProfileInfoBox({
    super.key,
    required this.label,
    required this.initialValue,
    required this.onChanged,
    this.isDropdown = false,
    this.isTextField = false,
  });

  @override
  State<ProfileInfoBox> createState() => _ProfileInfoBoxState();
}

class _ProfileInfoBoxState extends State<ProfileInfoBox> {
  DateTime? _selectedDate;

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        widget.onChanged(_selectedDate.toString());
      });
    }
  }

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
            widget.label,
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.purple),
          ),
          const SizedBox(height: 8),
          if (widget.isDropdown)
            DropdownButtonFormField<String>(
              value: widget.initialValue,
              items: ['Paciente', 'Cuidador']
                  .map((role) => DropdownMenuItem(
                        value: role,
                        child: Text(role),
                      ))
                  .toList(),
              onChanged: widget.onChanged,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor selecione a função';
                }
                return null;
              },
            )
          else if (widget.isTextField)
            TextFormField(
              initialValue: widget.initialValue,
              onChanged: (value) => widget.onChanged(value),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor adicione ${widget.label}';
                }
                return null;
              },
            )
          else
            GestureDetector(
              onTap: () => _pickDate(context),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.purple),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Text(
                  _selectedDate == null
                      ? 'Selecionar data'
                      : 'Data de nascimento: ${_selectedDate!.toLocal()}'
                          .split(' ')[0],
                  style: const TextStyle(color: Colors.purple),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
