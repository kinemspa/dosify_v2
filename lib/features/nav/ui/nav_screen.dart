import 'package:flutter/material.dart';
import 'package:dosify_v2/features/home/ui/home_screen.dart';
import 'package:dosify_v2/features/medication/ui/medication_list_screen.dart';
import 'package:dosify_v2/features/scheduling/ui/dose_screen.dart';
import 'package:dosify_v2/features/logs/ui/log_screen.dart';
import 'package:dosify_v2/features/scheduling/ui/calendar_screen.dart';
import 'package:logger/logger.dart';

class NavScreen extends StatefulWidget {
  const NavScreen({super.key});

  @override
  State<NavScreen> createState() => _NavScreenState();
}

class _NavScreenState extends State<NavScreen> {
  int _selectedIndex = 0;
  final _logger = Logger();

  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    MedicationListScreen(),
    DoseScreen(),
    LogScreen(),
    CalendarScreen(),
  ];

  void _onItemTapped(int index) {
    _logger.d('Nav bar tapped: index $index');
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    _logger.d('Building NavScreen with selectedIndex: $_selectedIndex');
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex), // Simplified to ensure rebuild
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.medical_services),
            label: 'Meds',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.schedule),
            label: 'Schedule',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Logs',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Calendar',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        backgroundColor: Colors.blue,
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
      ),
    );
  }
}