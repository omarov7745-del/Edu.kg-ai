import 'package:flutter/material.dart';

import 'screens/home_screen.dart';

void main() {
  runApp(const EduKgApp());
}

class EduKgApp extends StatelessWidget {
  const EduKgApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EduKG AI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFFD32F2F),
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
      ),
      home: const HomeScreen(),
    );
  }
}
