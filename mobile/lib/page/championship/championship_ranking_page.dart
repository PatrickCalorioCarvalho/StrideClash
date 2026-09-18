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

  // Overlap resolution (ST_Difference on the backend) can turn a plain
  // polygon into one with a hole punched out of it, or split it into a
  // MULTIPOLYGON entirely — both are valid WKT this needs to render without
  // garbling the coordinates or crashing.
  List<Polygon> _parseWktPolygons(String wkt, Color color) {
    if (wkt.startsWith('MULTIPOLYGON')) {
      final body = wkt.substring(wkt.indexOf('(') + 1, wkt.length - 1);
      return _splitTopLevelGroups(body)
          .map((g) => _polygonFromRingsGroup(g, color))
          .whereType<Polygon>()
          .toList();
    }
    if (wkt.startsWith('POLYGON')) {
      final polygon = _polygonFromRingsGroup(
        wkt.substring(wkt.indexOf('(')),
        color,
      );
      return polygon != null ? [polygon] : [];
    }
    return [];
  }

  /// Splits a string like "(A),(B),(C)" into ["(A)", "(B)", "(C)"] by
  /// tracking paren depth — used to pull each polygon out of a MULTIPOLYGON.
  List<String> _splitTopLevelGroups(String s) {
    final groups = <String>[];
    var depth = 0;
    var start = -1;
    for (var i = 0; i < s.length; i++) {
      if (s[i] == '(') {
        if (depth == 0) start = i;
        depth++;
      } else if (s[i] == ')') {
        depth--;
        if (depth == 0 && start != -1) {
          groups.add(s.substring(start, i + 1));
          start = -1;
        }
      }
    }
    return groups;
  }

  /// Parses one polygon's ring list, e.g. "((outer ring),(hole ring))" —
  /// the first ring is the outer boundary, any further rings are holes.
  Polygon? _polygonFromRingsGroup(String group, Color color) {
    final rings = <List<LatLng>>[];
    for (final m in RegExp(r'\(([^()]+)\)').allMatches(group)) {
      final coords = m.group(1)!.split(',').map((pair) {
        final parts = pair.trim().split(RegExp(r'\s+'));
        return LatLng(double.parse(parts[1]), double.parse(parts[0]));
      }).toList();
      if (coords.length >= 3) rings.add(coords);
    }
    if (rings.isEmpty) return null;

    return Polygon(
      points: rings.first,
      holePointsList: rings.length > 1 ? rings.sublist(1) : null,
      color: color.withValues(alpha: 0.35),
      borderColor: color,
      borderStrokeWidth: 2,
    );
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
              allPolygons.addAll(_parseWktPolygons(wkt, color));
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
