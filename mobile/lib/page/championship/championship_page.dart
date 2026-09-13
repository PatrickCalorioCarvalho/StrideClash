import 'package:flutter/material.dart';
import 'package:protobuf/well_known_types/google/protobuf/timestamp.pb.dart';
import 'package:share_plus/share_plus.dart';

import '../../auth/auth_storage.dart';
import '../../grpc_client.dart';
import '../../generated/championship.pb.dart';
import '../../generated/championship.pbgrpc.dart';
import 'championship_ranking_page.dart';

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
  late Future<List<Championship>> _championshipsFuture;

  @override
  void initState() {
    super.initState();
    _championshipsFuture = _init();
  }

  Future<List<Championship>> _init() async {
    _userId = await _authStorage.userId;
    return _loadChampionships();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _joinCodeController.dispose();
    super.dispose();
  }

  Future<List<Championship>> _loadChampionships() async {
    final response = await _client.championship.listChampionships(
      ListChampionshipsRequest()..userId = _userId!,
    );

    return response.championships;
  }

  Future<void> _createChampionship() async {
    if (_nameController.text.isEmpty || _userId == null) return;

    await _client.championship.createChampionship(
      CreateChampionshipRequest()
        ..name = _nameController.text
        ..startAt = Timestamp.fromDateTime(_startDate)
        ..endAt = Timestamp.fromDateTime(_endDate)
        ..userId = _userId!,
    );

    _nameController.clear();

    setState(() {
      _championshipsFuture = _loadChampionships();
    });
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
      setState(() {
        _championshipsFuture = _loadChampionships();
      });
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

    setState(() {
      _championshipsFuture = _loadChampionships();
    });
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

    setState(() {
      _championshipsFuture = _loadChampionships();
    });
  }

  void _shareJoinCode(Championship c) {
    SharePlus.instance.share(ShareParams(
      text: 'Entra no meu campeonato "${c.name}" no StrideClash! '
          'Usa o código: ${c.joinCode}',
    ));
  }

  Future<void> _pickDate({
    required DateTime initial,
    required ValueChanged<DateTime> onSelected,
  }) async {
    final date = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );

    if (date != null) {
      onSelected(date);
    }
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
            _buildJoinForm(),
            const SizedBox(height: 16),
            _buildCreateForm(),
            const SizedBox(height: 16),
            Expanded(child: _buildChampionshipList()),
          ],
        ),
      ),
    );
  }

  Widget _buildJoinForm() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _joinCodeController,
                textCapitalization: TextCapitalization.characters,
                decoration: const InputDecoration(
                  labelText: 'Código de um amigo',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: _joinChampionship,
              child: const Text('Entrar'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreateForm() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nome do campeonato',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _pickDate(
                      initial: _startDate,
                      onSelected: (d) =>
                          setState(() => _startDate = d),
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
                      initial: _endDate,
                      onSelected: (d) =>
                          setState(() => _endDate = d),
                    ),
                    child: Text(
                      'Fim: ${_endDate.toLocal().toString().split(' ')[0]}',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _createChampionship,
              child: const Text('Criar Campeonato'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChampionshipList() {
    return FutureBuilder<List<Championship>>(
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
            final c = items[index];
            final isOwner = c.createdBy == _userId;

            return ListTile(
              leading: const Icon(Icons.flag),
              title: Text(c.name),
              subtitle: Text(
                '${c.startAt.toDateTime().toLocal().toString().split(' ')[0]}'
                ' → '
                '${c.endAt.toDateTime().toLocal().toString().split(' ')[0]}'
                '\nCódigo: ${c.joinCode}',
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
