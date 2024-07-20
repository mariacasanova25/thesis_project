import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:thesis_project/medications/prescribed_meds_day.dart';

class PrescribedMedsScreen extends StatefulWidget {
  const PrescribedMedsScreen({super.key});

  @override
  State<PrescribedMedsScreen> createState() => _PrescribedMedsScreenState();
}

class _PrescribedMedsScreenState extends State<PrescribedMedsScreen> {
  final pageController = PageController(initialPage: 2);
  late int currentPage = pageController.initialPage;

  DateTime get selectedDay => daysList[currentPage];

  void selectDay(int index) {
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
  }

  List<DateTime> daysList = [
    for (int i = 2; i > 0; i--) DateTime.now().subtract(Duration(days: i)),
    DateTime.now(),
    for (int i = 1; i <= 5; i++) DateTime.now().add(Duration(days: i)),
  ];

  final List<String> weekdays = [
    'Seg',
    'Ter',
    'Qua',
    'Qui',
    'Sex',
    'Sáb',
    'Dom',
  ];

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    FirebaseFirestore.instance
        .collection("medications")
        .snapshots(includeMetadataChanges: true)
        .listen((querySnapshot) {
      for (var change in querySnapshot.docChanges) {
        if (change.type == DocumentChangeType.added) {
          final source =
              (querySnapshot.metadata.isFromCache) ? "local cache" : "server";
          print('DATA ${querySnapshot.docs.first['name']}');
          print("Data fetched from $source}");
        }
      }
    });

    return Column(
      children: [
        //Card(child: Text(_lastMessage)),
        ClipRRect(
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(24),
          ),
          child: Container(
            height: 70,
            color: colorScheme.surface,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              scrollDirection: Axis.horizontal,
              itemCount: daysList.length,
              separatorBuilder: (context, index) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final day = daysList[index];
                return ChoiceChip(
                  selectedColor: colorScheme.primary,
                  labelStyle: TextStyle(
                    color: selectedDay.day == day.day
                        ? colorScheme.onPrimary
                        : null,
                  ),
                  side: BorderSide.none,
                  showCheckmark: false,
                  labelPadding: const EdgeInsets.symmetric(horizontal: 2),
                  label: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(weekdays[day.weekday - 1]),
                      Text(day.day.toString()),
                    ],
                  ),
                  selected: selectedDay.day == day.day,
                  onSelected: (_) => selectDay(index),
                );
              },
            ),
          ),
        ),

        Expanded(
          child: PageView.builder(
            controller: pageController,
            itemCount: daysList.length,
            onPageChanged: (page) => setState(() => currentPage = page),
            itemBuilder: (context, index) {
              final day = daysList[index];
              return PrescribedMedsDay(
                selectedDate: DateTime(day.year, day.month, day.day),
              );
            },
          ),
        ),
      ],
    );
  }
}
