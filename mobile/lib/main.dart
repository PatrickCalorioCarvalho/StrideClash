import 'package:flutter/material.dart';
import 'ui/home_page.dart';

void main() {
  runApp(const StrideClashApp());
}

class StrideClashApp extends StatelessWidget {
  const StrideClashApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StrideClash',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
