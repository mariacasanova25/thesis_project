import 'package:flutter/material.dart';

class MedicationInfoCard extends StatelessWidget {
  const MedicationInfoCard(
      {super.key, required this.title, required this.content});

  final String title;
  final List<String> content;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SizedBox(
        width: 300,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    title,
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ), //for info's title
                const SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: content.map((e) => Text(e.trim())).toList(),
                ) //for information content
              ],
            ),
          ),
        ),
      ),
      const SizedBox(height: 16)
    ]);
  }
}
