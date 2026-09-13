import 'package:flutter/material.dart';

import '../profile/profile_page.dart';
import '../walk/walk_tracking_page.dart';
import '../championship/championship_page.dart';

class MainTabsPage extends StatefulWidget {
  const MainTabsPage({super.key});

  @override
  State<MainTabsPage> createState() => _MainTabsPageState();
}

class _MainTabsPageState extends State<MainTabsPage> {
  // Caminhada é a aba central e a que abre por padrão — Perfil e
  // Campeonato ficam de cada lado dela na barra inferior.
  int _index = 1;

  final _pages = const [
    ProfilePage(),
    WalkTrackingPage(),
    ChampionshipPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_walk),
            label: 'Caminhada',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.flag),
            label: 'Campeonato',
          ),
        ],
      ),
    );
  }
}
