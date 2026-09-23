import 'package:flutter/material.dart';
import 'package:mobile/auth/auth_storage.dart';
import 'package:mobile/page/auth/login_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mobile/page/tabs/main_tabs_page.dart';
import 'package:mobile/theme.dart';

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
    final colorScheme = ColorScheme.fromSeed(
      seedColor: kNeonGreen,
      brightness: Brightness.dark,
    ).copyWith(
      surface: const Color(0xFF121212),
    );

    return MaterialApp(
      title: 'StrideClash',
      theme: ThemeData(
        colorScheme: colorScheme,
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF0B0F0C),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0B0F0C),
          foregroundColor: kNeonGreen,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: kNeonGreen,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.1,
          ),
        ),
        cardTheme: CardThemeData(
          color: const Color(0xFF161B17),
          elevation: 4,
          shadowColor: kNeonGreen.withValues(alpha: 0.25),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: kNeonGreen.withValues(alpha: 0.15)),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kNeonGreen,
            foregroundColor: Colors.black,
            textStyle: const TextStyle(fontWeight: FontWeight.bold),
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF161B17),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFF0B0F0C),
          selectedItemColor: kNeonGreen,
          unselectedItemColor: Colors.white38,
        ),
      ),
      home: isLogged ? const MainTabsPage() : LoginPage(),
    );
  }
}
