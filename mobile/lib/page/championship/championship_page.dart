import 'package:flutter/material.dart';
import 'package:protobuf/well_known_types/google/protobuf/timestamp.pb.dart';

import '../../grpc_client.dart';
import '../../generated/championship.pb.dart';
import '../../generated/championship.pbgrpc.dart';

class ChampionshipPage extends StatefulWidget {
  const ChampionshipPage({super.key});

  @override
  State<ChampionshipPage> createState() => _ChampionshipsPageState();
}

class _ChampionshipsPageState extends State<ChampionshipPage> {
  final _nameController = TextEditingController();

  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 7));

  final _client = GrpcClient();

  late Future<List<Championship>> _championshipsFuture;

  @override
  void initState() {
    super.initState();
    _championshipsFuture = _loadChampionships();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<List<Championship>> _loadChampionships() async {
    final response = await _client.championship.listChampionships(
      ListChampionshipsRequest(),
    );

    return response.championships;
  }

  Future<void> _createChampionship() async {
    if (_nameController.text.isEmpty) return;

    await _client.championship.createChampionship(
      CreateChampionshipRequest()
        ..name = _nameController.text
        ..startAt = Timestamp.fromDateTime(_startDate)
        ..endAt = Timestamp.fromDateTime(_endDate),
    );

    _nameController.clear();

    setState(() {
      _championshipsFuture = _loadChampionships();
    });
  }

  Future<void> _deleteChampionship(String id) async {
    await _client.championship.deleteChampionship(
      DeleteChampionshipRequest()..id = id,
    );

    setState(() {
      _championshipsFuture = _loadChampionships();
    });
  }

  Future<void> _extendChampionship(Championship c) async {
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
        ..newEndAt = Timestamp.fromDateTime(newDate),
    );

    setState(() {
      _championshipsFuture = _loadChampionships();
    });
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
            _buildCreateForm(),
            const SizedBox(height: 16),
            Expanded(child: _buildChampionshipList()),
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
            child: Text('Nenhum campeonato criado'),
          );
        }

        final items = snapshot.data!;

        return ListView.separated(
          itemCount: items.length,
          separatorBuilder: (_, __) => const Divider(),
          itemBuilder: (context, index) {
            final c = items[index];

            return ListTile(
              leading: const Icon(Icons.flag),
              title: Text(c.name),
              subtitle: Text(
                '${c.startAt.toDateTime().toLocal().toString().split(' ')[0]}'
                ' → '
                '${c.endAt.toDateTime().toLocal().toString().split(' ')[0]}',
              ),
              trailing: PopupMenuButton<String>(
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
            );
          },
        );
      },
    );
  }
}
