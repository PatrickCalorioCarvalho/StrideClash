import 'package:flutter/material.dart';
import 'package:protobuf/well_known_types/google/protobuf/timestamp.pb.dart';
import 'generated/championship.pbgrpc.dart';
import 'generated/championship.pb.dart';
import 'grpc_client.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<void> createChampionship() async {
    final client = GrpcClient();

    final request = CreateChampionshipRequest()
      ..name = 'Centro Histórico'
      ..startAt = Timestamp.fromDateTime(DateTime.now())
      ..endAt = Timestamp.fromDateTime(
        DateTime.now().add(const Duration(days: 7)),
      );

    final response =
        await client.championship.createChampionship(request);

    debugPrint('ID: ${response.championship.id}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('StrideClash – Teste gRPC'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: createChampionship,
          child: const Text('Criar Campeonato'),
        ),
      ),
    );
  }
}
