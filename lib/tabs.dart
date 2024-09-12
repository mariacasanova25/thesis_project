import 'package:flutter/material.dart';
import 'package:thesis_project/adherenceStatistics/adherence_screen.dart';
import 'package:thesis_project/communityForum/presentation/community_forum.dart';
import 'package:thesis_project/medications/presentation/prescribed_meds_screen.dart';
import 'package:thesis_project/profile/presentation/profile_screen.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  final pageController = PageController(initialPage: 1);
  late int currentPage = pageController.initialPage;

  void selectPage(int index) {
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
  }

  String get activePageTitle => switch (currentPage) {
        0 => 'Fórum Comunitário',
        1 => 'Os Meus Medicamentos',
        2 => 'A Minha Adesão',
        _ => '',
      };

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(activePageTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfileScreen(),
                ),
              );
            },
          )
        ],
      ),
      body: PageView(
        controller: pageController,
        onPageChanged: (page) => setState(() => currentPage = page),
        children: const [
          CommunityForumScreen(),
          PrescribedMedsScreen(),
          AdherenceScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        onTap: selectPage,
        currentIndex: currentPage,
        items: const [
          BottomNavigationBarItem(
            // icon: Icon(Icons.people_outline),
            icon: Icon(Icons.people),
            label: 'Fórum',
          ),
          BottomNavigationBarItem(
            // icon: Icon(Icons.medication_outlined),
            icon: Icon(Icons.medication),
            label: 'Medicamentos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.multiline_chart),
            label: 'Adesão',
          ),
        ],
      ),
    );
  }
}
