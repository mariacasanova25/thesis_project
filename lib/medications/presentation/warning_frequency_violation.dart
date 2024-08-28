import 'package:flutter/material.dart';
import 'package:thesis_project/medications/domain/prescription.dart';

class WarningFrequencyViolation extends StatelessWidget {
  const WarningFrequencyViolation({super.key, required this.prescription});
  final Prescription prescription;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: Row(
        children: [
          Icon(Icons.warning, color: Theme.of(context).colorScheme.onSurface),
          const SizedBox(width: 4),
          Text(
              'Perigo! Intervalo menor que ${prescription.frequency} horas. Edite o horário.'),
        ],
      ),
    );
  }
}
