import 'package:flutter/material.dart';
import 'package:protobuf/well_known_types/google/protobuf/timestamp.pb.dart';

import '../grpc_client.dart';
import '../generated/championship.pb.dart';
import '../generated/championship.pbgrpc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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

  Future<List<Championship>> _loadChampionships() async {
    final response =
        await _client.championship.listChampionships(
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
        title: const Text('StrideClash'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // FORM
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
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
            ),

            const SizedBox(height: 16),

            // LISTA
            Expanded(
              child: FutureBuilder<List<Championship>>(
                future: _championshipsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (!snapshot.hasData ||
                      snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text('Nenhum campeonato criado'),
                    );
                  }

                  final items = snapshot.data!;

                  return ListView.separated(
                    itemCount: items.length,
                    separatorBuilder: (_, __) =>
                        const Divider(),
                    itemBuilder: (context, index) {
                      final c = items[index];

                      return ListTile(
                        title: Text(c.name),
                        subtitle: Text(
                          '${c.startAt.toDateTime().toLocal().toString().split(' ')[0]}'
                          ' → '
                          '${c.endAt.toDateTime().toLocal().toString().split(' ')[0]}',
                        ),
                        leading: const Icon(Icons.flag),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
