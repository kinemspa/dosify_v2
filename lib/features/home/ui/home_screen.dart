import 'package:flutter/material.dart';
import 'package:dosify_v2/features/medication/ui/medication_list_screen.dart';
import 'package:dosify_v2/features/scheduling/ui/dose_screen.dart';
import 'package:dosify_v2/features/logs/ui/log_screen.dart';
import 'package:dosify_v2/features/scheduling/ui/calendar_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dosify.v2 Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Welcome! You are logged in.'),
            ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const MedicationListScreen())),
              child: const Text('Go to Medications'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const DoseScreen())),
              child: const Text('Go to Schedule'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const LogScreen())),
              child: const Text('Go to Logs'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CalendarScreen())),
              child: const Text('Go to Calendar'),
            ),
          ],
        ),
      ),
    );
  }
}