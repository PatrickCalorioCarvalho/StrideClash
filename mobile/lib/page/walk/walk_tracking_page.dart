import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../services/walk_tracking_service.dart';

class WalkTrackingPage extends StatefulWidget {
  const WalkTrackingPage({super.key});

  @override
  State<WalkTrackingPage> createState() => _WalkTrackingPageState();
}

class _WalkTrackingPageState extends State<WalkTrackingPage> {
  final _service = WalkTrackingService();
  bool _tracking = false;
  Timer? _uiTimer;
  LatLng? _currentCenter;
  @override
  void initState() {
    super.initState();
    _service.init().then((_) =>
        setState(() {
          _currentCenter = _service.defaultCenter;
        }));
    _uiTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => mounted ? setState(() {}) : null,
    );
  }

  @override
  void dispose() {
    _uiTimer?.cancel();
    _service.stopWalk();
    super.dispose();
  }

  void _start() async {
    await _service.startWalk();
    setState(() => _tracking = true);
  }

  void _stop() async {
    await _service.stopWalk();
    setState(() => _tracking = false);
  }

  @override
  Widget build(BuildContext context) {
    final points = _service.points
        .map((p) => LatLng(p.latitude, p.longitude))
        .toList();

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
              if (points.length > 1)
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

          Positioned(
            bottom: 24,
            left: 24,
            right: 24,
            child: ElevatedButton(
              onPressed: _tracking ? _stop : _start,
              child: Text(
                _tracking ? 'Finalizar Caminhada' : 'Iniciar Caminhada',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
