import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart' show GoogleAuthProvider;

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  final _localAuth = LocalAuthentication();

  Future<void> _login() async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Logged in!')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> _biometricAuth() async {
    bool authenticated = await _localAuth.authenticate(localizedReason: 'Unlock app');
    if (authenticated) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Biometric success!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _emailController, decoration: const InputDecoration(labelText: 'Email')),
            TextField(controller: _passwordController, decoration: const InputDecoration(labelText: 'Password'), obscureText: true),
            ElevatedButton(onPressed: _login, child: const Text('Login')),
            ElevatedButton(onPressed: _biometricAuth, child: const Text('Biometric Unlock')),
            ElevatedButton(
              onPressed: () async {
                GoogleAuthProvider googleProvider = GoogleAuthProvider();
                await _auth.signInWithProvider(googleProvider);
              },
              child: const Text('Google Login'),
            ),
          ],
        )
      ),
    );
  }
}