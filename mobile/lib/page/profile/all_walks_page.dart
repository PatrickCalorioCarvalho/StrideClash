import 'package:flutter/material.dart';

import '../../auth/auth_storage.dart';
import '../../generated/walk.pbgrpc.dart';
import '../../grpc_client.dart';

/// Histórico completo das caminhadas do usuário — ao contrário da lista por
/// campeonato (que só mostra capturas válidas), essa inclui as invalidadas,
/// com pace/velocidade média, pra dar pra entender por que uma não contou.
class AllWalksPage extends StatefulWidget {
  const AllWalksPage({super.key});

  @override
  State<AllWalksPage> createState() => _AllWalksPageState();
}

class _AllWalksPageState extends State<AllWalksPage> {
  final _storage = AuthStorage();
  final _grpcClient = GrpcClient();
  List<WalkDetail>? _walks;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);

    final userId = await _storage.userId;
    if (userId == null) {
      setState(() {
        _walks = [];
        _loading = false;
      });
      return;
    }

    try {
      final response = await _grpcClient.walk.listAllMyWalks(
        ListAllMyWalksRequest()..userId = userId,
      );
      if (!mounted) return;
      setState(() {
        _walks = response.walks;
        _loading = false;
      });
    } catch (e) {
      debugPrint('listAllMyWalks failed: $e');
      if (!mounted) return;
      setState(() {
        _walks = [];
        _loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível carregar o histórico.')),
      );
    }
  }

  String _formatDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  String _formatDuration(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes.remainder(60);
    if (h > 0) return '${h}h${m.toString().padLeft(2, '0')}min';
    return '${m}min';
  }

  Widget _buildTile(WalkDetail walk) {
    final duration = walk.finishedAt.toDateTime().difference(walk.startedAt.toDateTime());
    final speedKmh = walk.avgSpeedMps * 3.6;
    final championshipLabel =
        walk.championshipId.isEmpty ? 'Sem campeonato' : walk.championshipName;

    final details =
        '${walk.distanceM.toStringAsFixed(0)} m · ${_formatDuration(duration)} · '
        '${speedKmh.toStringAsFixed(1)} km/h';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              walk.valid ? Icons.check_circle_outline : Icons.warning_amber_rounded,
              color: walk.valid ? Colors.green : Colors.orangeAccent,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${_formatDate(walk.finishedAt.toDateTime())} · $championshipLabel',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                        walk.valid ? '${walk.areaM2.toStringAsFixed(0)} m²' : '—',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(details, style: const TextStyle(color: Colors.grey, fontSize: 13)),
                  if (!walk.valid) ...[
                    const SizedBox(height: 4),
                    Text(
                      walk.invalidReason.isEmpty
                          ? 'Não contou território.'
                          : walk.invalidReason,
                      style: const TextStyle(color: Colors.orangeAccent, fontSize: 13),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Minhas caminhadas')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : (_walks == null || _walks!.isEmpty)
              ? const Center(child: Text('Nenhuma caminhada ainda.'))
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: _walks!.length,
                  itemBuilder: (context, i) => _buildTile(_walks![i]),
                ),
    );
  }
}
