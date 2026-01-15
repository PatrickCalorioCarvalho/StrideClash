import 'package:flutter/material.dart';
import 'package:mobile/auth/auth_storage.dart';
import 'package:mobile/page/auth/login_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mobile/page/tabs/main_tabs_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
    final storage = AuthStorage();
  final userId = await storage.userId;
  runApp(StrideClashApp(isLogged: userId != null));

}

class StrideClashApp extends StatelessWidget {
  final bool isLogged;
  const StrideClashApp({super.key, required this.isLogged});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StrideClash',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: isLogged ? const MainTabsPage() : LoginPage(),
    );
  }
}
