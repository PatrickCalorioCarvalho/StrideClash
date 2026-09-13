import 'package:flutter/material.dart';
import 'package:protobuf/well_known_types/google/protobuf/timestamp.pb.dart';
import 'package:share_plus/share_plus.dart';

import '../../auth/auth_storage.dart';
import '../../grpc_client.dart';
import '../../generated/championship.pb.dart';
import '../../generated/championship.pbgrpc.dart';
import 'championship_ranking_page.dart';

class _ChampionshipWithStats {
  final Championship championship;
  final double? myAreaM2;
  final int? myRank;

  _ChampionshipWithStats(this.championship, this.myAreaM2, this.myRank);
}

class ChampionshipPage extends StatefulWidget {
  const ChampionshipPage({super.key});

  @override
  State<ChampionshipPage> createState() => _ChampionshipsPageState();
}

class _ChampionshipsPageState extends State<ChampionshipPage> {
  final _nameController = TextEditingController();
  final _joinCodeController = TextEditingController();

  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 7));

  final _client = GrpcClient();
  final _authStorage = AuthStorage();

  String? _userId;
  late Future<List<_ChampionshipWithStats>> _championshipsFuture;

  @override
  void initState() {
    super.initState();
    _championshipsFuture = _init();
  }

  Future<List<_ChampionshipWithStats>> _init() async {
    _userId = await _authStorage.userId;
    return _loadChampionships();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _joinCodeController.dispose();
    super.dispose();
  }

  Future<List<_ChampionshipWithStats>> _loadChampionships() async {
    final response = await _client.championship.listChampionships(
      ListChampionshipsRequest()..userId = _userId!,
    );

    final result = <_ChampionshipWithStats>[];
    for (final c in response.championships) {
      try {
        final ranking = await _client.championship.getChampionshipRanking(
          GetChampionshipRankingRequest()..championshipId = c.id,
        );
        final myIndex = ranking.entries.indexWhere((e) => e.userId == _userId);
        result.add(_ChampionshipWithStats(
          c,
          myIndex >= 0 ? ranking.entries[myIndex].totalAreaM2 : null,
          myIndex >= 0 ? myIndex + 1 : null,
        ));
      } catch (e) {
        debugPrint('getChampionshipRanking failed for ${c.id}: $e');
        result.add(_ChampionshipWithStats(c, null, null));
      }
    }
    return result;
  }

  void _refresh() {
    setState(() {
      _championshipsFuture = _loadChampionships();
    });
  }

  Future<Championship?> _createChampionship() async {
    if (_nameController.text.isEmpty || _userId == null) return null;

    final response = await _client.championship.createChampionship(
      CreateChampionshipRequest()
        ..name = _nameController.text
        ..startAt = Timestamp.fromDateTime(_startDate)
        ..endAt = Timestamp.fromDateTime(_endDate)
        ..userId = _userId!,
    );

    _nameController.clear();
    _refresh();
    return response.championship;
  }

  Future<void> _joinChampionship() async {
    final code = _joinCodeController.text.trim().toUpperCase();
    if (code.isEmpty || _userId == null) return;

    try {
      await _client.championship.joinChampionship(
        JoinChampionshipRequest()
          ..userId = _userId!
          ..joinCode = code,
      );
      _joinCodeController.clear();
      if (mounted) Navigator.of(context).pop();
      _refresh();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Não foi possível entrar: $e')),
      );
    }
  }

  Future<void> _deleteChampionship(String id) async {
    if (_userId == null) return;

    await _client.championship.deleteChampionship(
      DeleteChampionshipRequest()
        ..id = id
        ..userId = _userId!,
    );

    _refresh();
  }

  Future<void> _extendChampionship(Championship c) async {
    if (_userId == null) return;

    final newDate = await showDatePicker(
      context: context,
      initialDate: c.endAt.toDateTime(),
      firstDate: DateTime.now().add(const Duration(days: 1)),
      lastDate: DateTime(2035),
    );

    if (newDate == null) return;

    await _client.championship.updateChampionshipEndDate(
      UpdateChampionshipEndDateRequest()
        ..id = c.id
        ..newEndAt = Timestamp.fromDateTime(newDate)
        ..userId = _userId!,
    );

    _refresh();
  }

  void _shareJoinCode(Championship c) {
    SharePlus.instance.share(ShareParams(
      text: 'Entra no meu campeonato "${c.name}" no StrideClash! '
          'Usa o código: ${c.joinCode}',
    ));
  }

  Future<void> _pickDate({
    required BuildContext dialogContext,
    required DateTime initial,
    required ValueChanged<DateTime> onSelected,
  }) async {
    final date = await showDatePicker(
      context: dialogContext,
      initialDate: initial,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );

    if (date != null) {
      onSelected(date);
    }
  }

  Future<void> _showCreateDialog() async {
    _nameController.clear();
    _startDate = DateTime.now();
    _endDate = DateTime.now().add(const Duration(days: 7));

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Criar campeonato'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nome do campeonato',
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => _pickDate(
                            dialogContext: context,
                            initial: _startDate,
                            onSelected: (d) =>
                                setDialogState(() => _startDate = d),
                          ),
                          child: Text(
                            'Início: ${_startDate.toLocal().toString().split(' ')[0]}',
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => _pickDate(
                            dialogContext: context,
                            initial: _endDate,
                            onSelected: (d) =>
                                setDialogState(() => _endDate = d),
                          ),
                          child: Text(
                            'Fim: ${_endDate.toLocal().toString().split(' ')[0]}',
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final created = await _createChampionship();
                    if (!dialogContext.mounted) return;
                    Navigator.of(dialogContext).pop();
                    if (created != null) _showShareDialog(created);
                  },
                  child: const Text('Criar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showShareDialog(Championship c) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Campeonato criado!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Compartilhe esse código com seus amigos:'),
            const SizedBox(height: 12),
            Center(
              child: Text(
                c.joinCode,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Fechar'),
          ),
          ElevatedButton.icon(
            icon: const Icon(Icons.share),
            label: const Text('Compartilhar'),
            onPressed: () {
              _shareJoinCode(c);
              Navigator.of(dialogContext).pop();
            },
          ),
        ],
      ),
    );
  }

  Future<void> _showJoinDialog() async {
    _joinCodeController.clear();

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Entrar com código'),
        content: TextField(
          controller: _joinCodeController,
          autofocus: true,
          textCapitalization: TextCapitalization.characters,
          decoration: const InputDecoration(labelText: 'Código do amigo'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: _joinChampionship,
            child: const Text('Entrar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Campeonatos'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('Criar o meu'),
                    onPressed: _showCreateDialog,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.group_add),
                    label: const Text('Entrar com código'),
                    onPressed: _showJoinDialog,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(child: _buildChampionshipList()),
          ],
        ),
      ),
    );
  }

  Widget _buildChampionshipList() {
    return FutureBuilder<List<_ChampionshipWithStats>>(
      future: _championshipsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text('Você ainda não tem campeonatos — crie um ou entre com um código.'),
          );
        }

        final items = snapshot.data!;

        return ListView.separated(
          itemCount: items.length,
          separatorBuilder: (_, _) => const Divider(),
          itemBuilder: (context, index) {
            final entry = items[index];
            final c = entry.championship;
            final isOwner = c.createdBy == _userId;

            final myStat = entry.myRank != null
                ? 'Você: ${entry.myAreaM2!.toStringAsFixed(0)} m² (${entry.myRank}º lugar)'
                : 'Você ainda não capturou nada aqui';

            return ListTile(
              leading: const Icon(Icons.flag),
              title: Text(c.name),
              subtitle: Text(
                '${c.startAt.toDateTime().toLocal().toString().split(' ')[0]}'
                ' → '
                '${c.endAt.toDateTime().toLocal().toString().split(' ')[0]}'
                '\nCódigo: ${c.joinCode}'
                '\n$myStat',
              ),
              isThreeLine: true,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChampionshipRankingPage(
                    championshipId: c.id,
                    championshipName: c.name,
                  ),
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.share),
                    onPressed: () => _shareJoinCode(c),
                  ),
                  if (isOwner)
                    PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'extend') {
                          _extendChampionship(c);
                        } else if (value == 'delete') {
                          _deleteChampionship(c.id);
                        }
                      },
                      itemBuilder: (context) => const [
                        PopupMenuItem(
                          value: 'extend',
                          child: Text('Estender data'),
                        ),
                        PopupMenuItem(
                          value: 'delete',
                          child: Text('Excluir'),
                        ),
                      ],
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
