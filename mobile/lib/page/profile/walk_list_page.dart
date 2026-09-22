import 'package:flutter/material.dart';

import '../../auth/auth_storage.dart';
import '../../generated/walk.pbgrpc.dart';
import '../../grpc_client.dart';

/// Drills into one of Profile's "por campeonato" groups — championshipId
/// empty shows the "sem campeonato" group — listing each individual walk so
/// the user can see what's behind the number and delete one if they want.
class WalkListPage extends StatefulWidget {
  final String championshipId;
  final String championshipName;

  const WalkListPage({
    super.key,
    required this.championshipId,
    required this.championshipName,
  });

  @override
  State<WalkListPage> createState() => _WalkListPageState();
}

class _WalkListPageState extends State<WalkListPage> {
  final _storage = AuthStorage();
  final _grpcClient = GrpcClient();
  List<WalkSummary>? _walks;
  bool _loading = true;
  bool _changed = false;

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
      final response = await _grpcClient.walk.listMyWalks(
        ListMyWalksRequest()
          ..userId = userId
          ..championshipId = widget.championshipId,
      );
      if (!mounted) return;
      setState(() {
        _walks = response.walks;
        _loading = false;
      });
    } catch (e) {
      debugPrint('listMyWalks failed: $e');
      if (!mounted) return;
      setState(() {
        _walks = [];
        _loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível carregar as caminhadas.')),
      );
    }
  }

  Future<void> _delete(WalkSummary walk) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Apagar caminhada?'),
        content: Text(
          'Isso remove ${walk.areaM2.toStringAsFixed(0)} m² capturados em '
          '${_formatDate(walk.finishedAt.toDateTime())} — não dá pra desfazer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Apagar'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    final userId = await _storage.userId;
    if (userId == null) return;

    try {
      await _grpcClient.walk.deleteWalk(
        DeleteWalkRequest()
          ..walkId = walk.id
          ..userId = userId,
      );
      if (!mounted) return;
      setState(() {
        _walks = _walks?.where((w) => w.id != walk.id).toList();
        _changed = true;
      });
    } catch (e) {
      debugPrint('deleteWalk failed: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível apagar essa caminhada.')),
      );
    }
  }

  String _formatDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Navigator.pop(context, _changed);
      },
      child: Scaffold(
        appBar: AppBar(title: Text(widget.championshipName)),
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : (_walks == null || _walks!.isEmpty)
                ? const Center(child: Text('Nenhuma caminhada aqui.'))
                : ListView.builder(
                    itemCount: _walks!.length,
                    itemBuilder: (context, i) {
                      final walk = _walks![i];
                      return ListTile(
                        leading: const Icon(Icons.directions_walk),
                        title: Text('${walk.areaM2.toStringAsFixed(0)} m²'),
                        subtitle: Text(_formatDate(walk.finishedAt.toDateTime())),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline),
                          tooltip: 'Apagar',
                          onPressed: () => _delete(walk),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
