import 'package:flutter/material.dart';
import 'package:thesis_project/screens/adherence.dart';
import 'package:thesis_project/screens/calendar.dart';
import 'package:thesis_project/screens/community_forum.dart';
import 'package:thesis_project/screens/medication.dart';

class TabsScreen extends StatefulWidget {
  @override
  State<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget activePage = const CalendarScreen();
    var activePageTitle = 'Os Meus Medicamentos';

    if (_selectedPageIndex == 1) {
      activePage = const CommunityForumScreen();
      activePageTitle = 'Fórum Comunitário';
    }
    if (_selectedPageIndex == 2) {
      activePage = const AdherenceScreen();
      activePageTitle = 'Adesão';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(activePageTitle),
      ),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        currentIndex: _selectedPageIndex,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.medication_outlined), label: 'Medicamentos'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Fórum'),
          BottomNavigationBarItem(
              icon: Icon(Icons.multiline_chart), label: 'Adesão'),
        ],
      ),
    );
  }
}
