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

  final _profilePageKey = GlobalKey<ProfilePageState>();
  final _walkPageKey = GlobalKey<WalkTrackingPageState>();

  late final _pages = [
    ProfilePage(key: _profilePageKey),
    WalkTrackingPage(key: _walkPageKey),
    const ChampionshipPage(),
  ];

  void _onTap(int index) {
    setState(() => _index = index);
    // Both tabs are kept alive by the IndexedStack below with stable widget
    // instances, so Flutter skips rebuilding them on its own when they
    // become visible again — without an explicit refresh, the profile's
    // stats and the walk tab's championship list would never update after
    // the first time each was built.
    if (index == 0) {
      _profilePageKey.currentState?.refresh();
    }
    if (index == 1) {
      _walkPageKey.currentState?.refreshChampionships();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: _onTap,
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
