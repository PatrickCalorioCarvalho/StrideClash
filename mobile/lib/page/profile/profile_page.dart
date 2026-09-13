import 'package:flutter/material.dart';

import '../../auth/auth_storage.dart';
import '../../grpc_client.dart';
import '../../generated/walk.pbgrpc.dart';
import '../auth/login_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _storage = AuthStorage();
  final _grpcClient = GrpcClient();
  bool _photoFailed = false;

  Future<void> _logout() async {
    await _storage.logout();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => LoginPage()),
      (route) => false,
    );
  }

  Future<GetUserStatsResponse?> _loadStats() async {
    final userId = await _storage.userId;
    if (userId == null) return null;

    try {
      return await _grpcClient.walk.getUserStats(
        GetUserStatsRequest()..userId = userId,
      );
    } catch (e) {
      debugPrint('getUserStats failed: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sair',
            onPressed: _logout,
          ),
        ],
      ),
      body: FutureBuilder(
        future: Future.wait([
          _storage.name,
          _storage.email,
          _storage.photoUrl,
          _loadStats(),
        ]),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final name = snapshot.data![0] as String?;
          final email = snapshot.data![1] as String?;
          final photoUrl = snapshot.data![2] as String?;
          final stats = snapshot.data![3] as GetUserStatsResponse?;
          final showPhoto = photoUrl != null && !_photoFailed;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 16),
                CircleAvatar(
                  radius: 48,
                  backgroundImage: showPhoto ? NetworkImage(photoUrl) : null,
                  onBackgroundImageError: showPhoto
                      ? (_, _) => setState(() => _photoFailed = true)
                      : null,
                  child: showPhoto ? null : const Icon(Icons.person, size: 48),
                ),
                const SizedBox(height: 16),
                Text(
                  name ?? 'Jogador',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (email != null) ...[
                  const SizedBox(height: 4),
                  Text(email, style: const TextStyle(color: Colors.grey)),
                ],
                const SizedBox(height: 24),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStat(
                          Icons.map,
                          '${(stats?.totalAreaM2 ?? 0).toStringAsFixed(0)} m²',
                          'Área total capturada',
                        ),
                        _buildStat(
                          Icons.directions_walk,
                          '${stats?.walkCount ?? 0}',
                          'Caminhadas concluídas',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStat(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12), textAlign: TextAlign.center),
      ],
    );
  }
}
