import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  static const String id = 'HomePage';
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Social Swap'), centerTitle: true),
      body: const Center(
        child: Text(
          'Welcome to Social Swap!',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
