import 'package:flutter/material.dart';
import 'package:dosify_v2/features/medication/ui/medication_screen.dart';  // Import for navigation

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
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const MedicationScreen())),
              child: const Text('Go to Medications'),
            ),
          ],
        ),
      ),
    );
  }
}