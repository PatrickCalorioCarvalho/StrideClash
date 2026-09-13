import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../grpc_client.dart';
import '../../generated/championship.pb.dart';
import '../../generated/championship.pbgrpc.dart';
import '../../widgets/dark_map_layers.dart';

const _kEntryColors = [
  Colors.red,
  Colors.blue,
  Colors.green,
  Colors.orange,
  Colors.purple,
  Colors.teal,
  Colors.pink,
  Colors.brown,
];

class ChampionshipRankingPage extends StatefulWidget {
  final String championshipId;
  final String championshipName;

  const ChampionshipRankingPage({
    super.key,
    required this.championshipId,
    required this.championshipName,
  });

  @override
  State<ChampionshipRankingPage> createState() =>
      _ChampionshipRankingPageState();
}

class _ChampionshipRankingPageState extends State<ChampionshipRankingPage> {
  final _client = GrpcClient();
  late Future<List<ChampionshipRankingEntry>> _rankingFuture;

  @override
  void initState() {
    super.initState();
    _rankingFuture = _loadRanking();
  }

  Future<List<ChampionshipRankingEntry>> _loadRanking() async {
    final response = await _client.championship.getChampionshipRanking(
      GetChampionshipRankingRequest()..championshipId = widget.championshipId,
    );
    return response.entries;
  }

  List<LatLng> _parseWktPolygon(String wkt) {
    final match = RegExp(r'POLYGON\(\((.*)\)\)').firstMatch(wkt);
    if (match == null) return [];

    return match.group(1)!.split(',').map((pair) {
      final parts = pair.trim().split(' ');
      return LatLng(double.parse(parts[1]), double.parse(parts[0]));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.championshipName)),
      body: FutureBuilder<List<ChampionshipRankingEntry>>(
        future: _rankingFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar ranking: ${snapshot.error}'));
          }

          final entries = snapshot.data ?? [];

          if (entries.isEmpty) {
            return const Center(
              child: Text('Ninguém capturou território neste campeonato ainda.'),
            );
          }

          final allPolygons = <Polygon>[];
          for (var i = 0; i < entries.length; i++) {
            final color = _kEntryColors[i % _kEntryColors.length];
            for (final wkt in entries[i].polygonsWkt) {
              final points = _parseWktPolygon(wkt);
              if (points.length < 3) continue;
              allPolygons.add(Polygon(
                points: points,
                color: color.withValues(alpha: 0.35),
                borderColor: color,
                borderStrokeWidth: 2,
              ));
            }
          }

          final center = allPolygons.isNotEmpty
              ? allPolygons.first.points.first
              : const LatLng(-23.5505, -46.6333);

          return Column(
            children: [
              SizedBox(
                height: 260,
                child: FlutterMap(
                  options: MapOptions(initialCenter: center, initialZoom: 15),
                  children: [
                    buildDarkTileLayer(),
                    buildMapAttribution(),
                    PolygonLayer(polygons: allPolygons),
                  ],
                ),
              ),
              Expanded(
                child: ListView.separated(
                  itemCount: entries.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final entry = entries[index];
                    final color = _kEntryColors[index % _kEntryColors.length];

                    return ListTile(
                      leading: Stack(
                        children: [
                          CircleAvatar(
                            backgroundImage: entry.userPictureUrl.isNotEmpty
                                ? NetworkImage(entry.userPictureUrl)
                                : null,
                            child: entry.userPictureUrl.isEmpty
                                ? const Icon(Icons.person)
                                : null,
                          ),
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: color,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 1.5),
                              ),
                            ),
                          ),
                        ],
                      ),
                      title: Text('${index + 1}º  ${entry.userName}'),
                      trailing: Text(
                        '${entry.totalAreaM2.toStringAsFixed(0)} m²',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
