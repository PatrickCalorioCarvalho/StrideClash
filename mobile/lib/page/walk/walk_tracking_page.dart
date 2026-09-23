import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../../auth/auth_storage.dart';
import '../../grpc_client.dart';
import '../../generated/championship.pb.dart';
import '../../generated/championship.pbgrpc.dart';
import '../../model/walk_models.dart';
import '../../services/walk_tracking_service.dart';
import '../../widgets/dark_map_layers.dart';

class WalkTrackingPage extends StatefulWidget {
  const WalkTrackingPage({super.key});

  @override
  State<WalkTrackingPage> createState() => WalkTrackingPageState();
}

class WalkTrackingPageState extends State<WalkTrackingPage>
    with WidgetsBindingObserver {
  final _service = WalkTrackingService();
  final _grpcClient = GrpcClient();
  final _authStorage = AuthStorage();
  final _mapController = MapController();
  bool _tracking = false;
  bool _busy = false;
  Timer? _uiTimer;
  Timer? _preStartLocationTimer;
  LatLng? _currentCenter;
  List<Championship> _championships = [];
  String? _selectedChampionshipId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _service.init().then((_) =>
        setState(() {
          _currentCenter = _service.defaultCenter;
        }));
    _loadChampionships();
    _uiTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) {
        if (!mounted) return;
        setState(() {});
        _followCurrentPosition();
      },
    );
    // Antes de iniciar, o único jeito de saber onde a caminhada vai começar
    // era o mapa centrado numa localização já meio velha — sem um "você
    // está aqui" visível, ficava difícil saber de onde exatamente ia
    // partir. Atualiza a posição atual periodicamente enquanto não está
    // rastreando, pra mostrar isso com um marcador.
    _preStartLocationTimer = Timer.periodic(
      const Duration(seconds: 4),
      (_) => _refreshCurrentLocation(),
    );
  }

  Future<void> _refreshCurrentLocation() async {
    if (_tracking) return;
    try {
      final position = await Geolocator.getCurrentPosition();
      if (!mounted || _tracking) return;
      setState(() {
        _currentCenter = LatLng(position.latitude, position.longitude);
      });
    } catch (e) {
      debugPrint('getCurrentPosition (pré-início) falhou: $e');
    }
  }

  // The map only centers on `initialCenter` once — it never follows the
  // walker (or the "você está aqui" marker before starting) on its own, so
  // without this it looks "stuck" wherever it was last centered (very
  // noticeable after unlocking the phone mid-walk).
  void _followCurrentPosition() {
    LatLng? target;
    if (_tracking) {
      final pts = _service.points;
      if (pts.isNotEmpty) target = LatLng(pts.last.latitude, pts.last.longitude);
    } else {
      target = _currentCenter;
    }
    if (target == null) return;

    try {
      final zoom = _mapController.camera.zoom;
      _mapController.move(target, zoom);
    } catch (_) {
      // Map not attached yet — the next tick will retry.
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Snap to the current position right away instead of waiting for the
      // next 1s tick — this is exactly the "unlocked and the map is stuck"
      // moment.
      _followCurrentPosition();
    }
  }

  /// Called by [MainTabsPage] whenever this tab becomes visible again, since
  /// championships created/joined from the other tab wouldn't otherwise be
  /// picked up here (this page is kept alive by an IndexedStack, so its
  /// initState only runs once per app session).
  Future<void> refreshChampionships() => _loadChampionships();

  Future<void> _loadChampionships() async {
    final userId = await _authStorage.userId;
    if (userId == null) return;

    List<Championship> championships;
    try {
      final response = await _grpcClient.championship.listChampionships(
        ListChampionshipsRequest()..userId = userId,
      );
      championships = response.championships;
      await _service.cacheChampionships(championships);
    } catch (e) {
      // Offline (or the server's unreachable) — fall back to whatever we
      // last managed to fetch, so the picker still works.
      debugPrint('listChampionships failed, using cache: $e');
      championships = await _service.getCachedChampionships();
    }

    if (!mounted) return;
    setState(() => _championships = championships);

    if (_selectedChampionshipId == null) {
      final lastId = await _service.getLastSelectedChampionship();
      if (lastId != null &&
          _championships.any((c) => c.id == lastId) &&
          mounted) {
        setState(() => _selectedChampionshipId = lastId);
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _uiTimer?.cancel();
    _preStartLocationTimer?.cancel();
    if (_tracking) {
      _service.stopWalk().catchError((_) => null);
    }
    super.dispose();
  }

  // Precisa bater com maxClosingGapMeters em backend/services/walk.go — além
  // dessa distância do ponto inicial, o servidor descarta o polígono (a
  // caminhada é salva, mas não conta território).
  static const _maxClosingGapMeters = 50.0;

  void _start() async {
    setState(() => _busy = true);
    try {
      await _service.startWalk(championshipId: _selectedChampionshipId);
      setState(() => _tracking = true);
      _showInfo(
        'Pra fechar território, volte a até ${_maxClosingGapMeters.toStringAsFixed(0)} m '
        'de onde você começou antes de finalizar.',
        duration: const Duration(seconds: 5),
      );
    } catch (e, st) {
      debugPrint('startWalk failed: $e\n$st');
      _showError('Não foi possível iniciar a caminhada: $e');
    } finally {
      setState(() => _busy = false);
    }
  }

  double? _distanceToStartMeters() {
    final pts = _service.points;
    if (pts.length < 2) return null;
    return Geolocator.distanceBetween(
      pts.first.latitude,
      pts.first.longitude,
      pts.last.latitude,
      pts.last.longitude,
    );
  }

  Future<bool> _confirmFarFromStart(double distance) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Você está longe do início'),
        content: Text(
          'Você está a ${distance.toStringAsFixed(0)} m de onde começou. '
          'Pra fechar território, precisa estar a até '
          '${_maxClosingGapMeters.toStringAsFixed(0)} m. Se finalizar agora, '
          'a caminhada é salva mas não conta área.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Continuar caminhando'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Finalizar mesmo assim'),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  void _stop() async {
    final distance = _distanceToStartMeters();
    if (distance != null && distance > _maxClosingGapMeters) {
      final proceed = await _confirmFarFromStart(distance);
      if (!proceed) return;
    }

    setState(() => _busy = true);
    try {
      final walk = await _service.stopWalk();
      setState(() => _tracking = false);

      if (walk?.status == WalkStatus.pendingSync) {
        _showError(
          'Caminhada salva no celular — vai sincronizar sozinha assim que tiver internet.',
        );
      }
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

  void _showInfo(String message, {Duration? duration}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration ?? const Duration(seconds: 4),
      ),
    );
  }

  String get _selectedChampionshipName {
    final match = _championships.where((c) => c.id == _selectedChampionshipId);
    return match.isEmpty ? 'Sem campeonato' : match.first.name;
  }

  Widget _buildDistanceToStartCard() {
    final distance = _distanceToStartMeters();
    final closed = distance != null && distance <= _maxClosingGapMeters;

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            Icon(
              closed ? Icons.check_circle_outline : Icons.social_distance,
              size: 18,
              color: closed ? Colors.green : null,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                distance == null
                    ? 'Comece a andar pra ver a distância até o início'
                    : closed
                        ? 'Perto do início — território pronto pra fechar'
                        : 'A ${distance.toStringAsFixed(0)} m do início',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChampionshipCard() {
    if (_tracking) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(
            children: [
              const Icon(Icons.emoji_events_outlined, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Valendo pra: $_selectedChampionshipName',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String?>(
            isExpanded: true,
            hint: const Text('Sem campeonato'),
            value: _selectedChampionshipId,
            items: [
              const DropdownMenuItem<String?>(
                value: null,
                child: Text('Sem campeonato'),
              ),
              ..._championships.map((c) => DropdownMenuItem<String?>(
                    value: c.id,
                    child: Text(c.name),
                  )),
            ],
            onChanged: (value) {
              setState(() => _selectedChampionshipId = value);
              _service.setLastSelectedChampionship(value);
            },
          ),
        ),
      ),
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
            mapController: _mapController,
            options: MapOptions(
              initialCenter: points.isNotEmpty
                  ? points.last
                  : _currentCenter!,
              initialZoom: 16,
            ),
            children: [
              buildDarkTileLayer(),
              buildMapAttribution(),
              if (!_tracking && _currentCenter != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _currentCenter!,
                      width: 44,
                      height: 44,
                      alignment: Alignment.topCenter,
                      child: const Icon(
                        Icons.location_pin,
                        color: Colors.redAccent,
                        size: 44,
                      ),
                    ),
                  ],
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

          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Column(
              children: [
                _buildChampionshipCard(),
                if (_tracking) ...[
                  const SizedBox(height: 8),
                  _buildDistanceToStartCard(),
                ],
                if (showPolygon) ...[
                  const SizedBox(height: 8),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        finishedWalk.status == WalkStatus.pendingSync
                            ? 'Aguardando internet pra sincronizar...'
                            : 'Área capturada: ${finishedWalk.areaM2?.toStringAsFixed(0) ?? '0'} m²',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ],
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
