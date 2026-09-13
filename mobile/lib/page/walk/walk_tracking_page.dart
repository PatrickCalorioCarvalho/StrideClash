import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../auth/auth_storage.dart';
import '../../grpc_client.dart';
import '../../generated/championship.pb.dart';
import '../../generated/championship.pbgrpc.dart';
import '../../services/walk_tracking_service.dart';

class WalkTrackingPage extends StatefulWidget {
  const WalkTrackingPage({super.key});

  @override
  State<WalkTrackingPage> createState() => _WalkTrackingPageState();
}

class _WalkTrackingPageState extends State<WalkTrackingPage> {
  final _service = WalkTrackingService();
  final _grpcClient = GrpcClient();
  final _authStorage = AuthStorage();
  bool _tracking = false;
  bool _busy = false;
  Timer? _uiTimer;
  LatLng? _currentCenter;
  List<Championship> _championships = [];
  String? _selectedChampionshipId;

  @override
  void initState() {
    super.initState();
    _service.init().then((_) =>
        setState(() {
          _currentCenter = _service.defaultCenter;
        }));
    _loadChampionships();
    _uiTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => mounted ? setState(() {}) : null,
    );
  }

  Future<void> _loadChampionships() async {
    final userId = await _authStorage.userId;
    if (userId == null) return;

    try {
      final response = await _grpcClient.championship.listChampionships(
        ListChampionshipsRequest()..userId = userId,
      );

      if (!mounted) return;
      setState(() => _championships = response.championships);
    } catch (e) {
      debugPrint('listChampionships failed: $e');
    }
  }

  @override
  void dispose() {
    _uiTimer?.cancel();
    if (_tracking) {
      _service.stopWalk().catchError((_) => null);
    }
    super.dispose();
  }

  void _start() async {
    setState(() => _busy = true);
    try {
      await _service.startWalk(championshipId: _selectedChampionshipId);
      setState(() => _tracking = true);
    } catch (e, st) {
      debugPrint('startWalk failed: $e\n$st');
      _showError('Não foi possível iniciar a caminhada: $e');
    } finally {
      setState(() => _busy = false);
    }
  }

  void _stop() async {
    setState(() => _busy = true);
    try {
      await _service.stopWalk();
      setState(() => _tracking = false);
    } catch (e) {
      _showError('Não foi possível fechar o polígono: $e');
    } finally {
      setState(() => _busy = false);
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final points = _service.points
        .map((p) => LatLng(p.latitude, p.longitude))
        .toList();

    final finishedWalk = _service.lastFinishedWalk;
    final showPolygon = !_tracking && finishedWalk != null && points.length > 2;

    return Scaffold(
      appBar: AppBar(title: const Text('Caminhada')),
      body: _currentCenter == null ? Center(child: CircularProgressIndicator()) :
      Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter: points.isNotEmpty
                  ? points.last
                  : _currentCenter!,
              initialZoom: 16,
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName:
                    'com.patrickcaloriocarvalho.strideclash',
              ),
              if (showPolygon)
                PolygonLayer(
                  polygons: [
                    Polygon(
                      points: points,
                      color: Colors.green.withValues(alpha: 0.35),
                      borderColor: Colors.green,
                      borderStrokeWidth: 3,
                    ),
                  ],
                )
              else if (points.length > 1)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: points,
                      strokeWidth: 5,
                      color: Colors.green,
                    ),
                  ],
                ),
            ],
          ),

          if (!_tracking && _championships.isNotEmpty)
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String?>(
                      isExpanded: true,
                      hint: const Text('Não vale campeonato'),
                      value: _selectedChampionshipId,
                      items: [
                        const DropdownMenuItem<String?>(
                          value: null,
                          child: Text('Não vale campeonato'),
                        ),
                        ..._championships.map((c) => DropdownMenuItem<String?>(
                              value: c.id,
                              child: Text(c.name),
                            )),
                      ],
                      onChanged: (value) =>
                          setState(() => _selectedChampionshipId = value),
                    ),
                  ),
                ),
              ),
            ),

          if (showPolygon && finishedWalk.areaM2 != null)
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    'Área capturada: ${finishedWalk.areaM2!.toStringAsFixed(0)} m²',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),

          Positioned(
            bottom: 24,
            left: 24,
            right: 24,
            child: ElevatedButton(
              onPressed: _busy ? null : (_tracking ? _stop : _start),
              child: _busy
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(
                      _tracking ? 'Finalizar Caminhada' : 'Iniciar Caminhada',
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
