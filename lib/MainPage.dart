import 'package:flutter/material.dart';
import 'package:visto_mobile/AllLeaves.dart';
import 'package:visto_mobile/Calendar.dart';
import 'package:visto_mobile/CurvedNavigationBar.dart'; // Adjust the import as needed
import 'package:visto_mobile/DashboardPage.dart';
import 'package:visto_mobile/Profile.dart'; // Adjust the import as needed
import 'package:visto_mobile/Leaverequest.dart'; // Import the Leaverequest page

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    DashboardPage(),
   LeaveListPage(),
    Leaverequest(), // Add the Leaverequest page
    ScrollingCalendarPage(), // Add the ScrollingCalendarPage
     ProfilePage(), // Add the ProfilePage
  ];

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: CurvedNavigationBar(
        items: [
          CurvedNavigationBarItem(iconData: Icons.dashboard), // Changed to dashboard icon
          CurvedNavigationBarItem(iconData: Icons.history), // Changed to historique icon
          CurvedNavigationBarItem(iconData: Icons.add),
          CurvedNavigationBarItem(iconData: Icons.calendar_today), // Changed to calendar icon
          CurvedNavigationBarItem(iconData: Icons.person),
        ],
        onTap: _onTap,
        currentIndex: _currentIndex,
      ),
    );
  }
}
