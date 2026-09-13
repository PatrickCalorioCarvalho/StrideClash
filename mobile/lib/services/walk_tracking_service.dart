import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:protobuf/well_known_types/google/protobuf/timestamp.pb.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:uuid/uuid.dart';

import '../auth/auth_storage.dart';
import '../grpc_client.dart';
import '../generated/walk.pbgrpc.dart' as pb;
import '../model/walk_models.dart';

class WalkTrackingService {
  static final WalkTrackingService _instance =
      WalkTrackingService._internal();

  factory WalkTrackingService() => _instance;

  WalkTrackingService._internal();

  final _uuid = const Uuid();
  final _authStorage = AuthStorage();
  final _grpcClient = GrpcClient();
  Database? _db;
  StreamSubscription<Position>? _positionSub;

  Walk? _currentWalk;
  Walk? _lastFinishedWalk;
  final List<WalkPoint> _points = [];

  LatLng _defaultCenter = LatLng(-23.5505, -46.6333);

  // ---------- DB ----------
  Future<void> init() async {

    final path = join(await getDatabasesPath(), 'walks.db');

    _db = await openDatabase(
      path,
      version: 2,
      onCreate: (db, _) async {
        await db.execute('''
          CREATE TABLE walks (
            id TEXT PRIMARY KEY,
            start_time TEXT,
            end_time TEXT,
            distance REAL,
            polygon_wkt TEXT,
            area_m2 REAL
          )
        ''');

        await db.execute('''
          CREATE TABLE walk_points (
            id TEXT PRIMARY KEY,
            walk_id TEXT,
            lat REAL,
            lng REAL,
            speed REAL,
            timestamp TEXT
          )
        ''');
      },
      onUpgrade: (db, oldVersion, _) async {
        if (oldVersion < 2) {
          await db.execute('ALTER TABLE walks ADD COLUMN polygon_wkt TEXT');
          await db.execute('ALTER TABLE walks ADD COLUMN area_m2 REAL');
          await db.execute(
            'ALTER TABLE walk_points ADD COLUMN speed REAL NOT NULL DEFAULT 0',
          );
        }
      },
    );
    await _ensurePermission();
    final position = await Geolocator.getCurrentPosition();
    _defaultCenter = LatLng(position.latitude, position.longitude);
  }

    Future<bool> _ensurePermission() async {
    if (!await Geolocator.isLocationServiceEnabled()) return false;

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  // ---------- WALK ----------
  Future<Walk> startWalk({String? championshipId}) async {
    final userId = await _authStorage.userId;
    if (userId == null) {
      throw StateError('usuário não autenticado');
    }

    final request = pb.StartWalkRequest()..userId = userId;
    if (championshipId != null && championshipId.isNotEmpty) {
      request.championshipId = championshipId;
    }

    final response = await _grpcClient.walk.startWalk(request);

    final walk = Walk(
      id: response.walkId,
      startTime: response.startedAt.toDateTime(),
    );

    await _db!.insert('walks', walk.toMap());
    _currentWalk = walk;
    _lastFinishedWalk = null;
    _points.clear();

    _positionSub = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 5,
      ),
    ).listen(_onPosition);

    return walk;
  }

  Future<Walk?> stopWalk() async {
    final walk = _currentWalk;
    if (walk == null) return null;

    await _positionSub?.cancel();
    _currentWalk = null;

    walk.endTime = DateTime.now();
    walk.distance = _calculateDistance();

    final response = await _grpcClient.walk.finishWalk(
      pb.FinishWalkRequest()
        ..walkId = walk.id
        ..points.addAll(_points.map((p) => pb.WalkPoint()
          ..lat = p.latitude
          ..lng = p.longitude
          ..speed = p.speed
          ..timestamp = Timestamp.fromDateTime(p.timestamp))),
    );

    walk.polygonWkt = response.polygonWkt;
    walk.areaM2 = response.areaM2;

    await _db!.update(
      'walks',
      walk.toMap(),
      where: 'id = ?',
      whereArgs: [walk.id],
    );

    _lastFinishedWalk = walk;
    return walk;
  }

  // ---------- GPS ----------
  // Fixes worse than this are common noise (indoors, urban canyon) and would
  // otherwise register as movement even while standing still.
  static const _maxAcceptableAccuracyMeters = 20.0;

  Future<void> _onPosition(Position p) async {
    if (_currentWalk == null) return;
    if (p.accuracy > _maxAcceptableAccuracyMeters) return;

    final point = WalkPoint(
      id: _uuid.v4(),
      walkId: _currentWalk!.id,
      latitude: p.latitude,
      longitude: p.longitude,
      speed: p.speed,
      timestamp: DateTime.now(),
    );

    _points.add(point);
    await _db!.insert('walk_points', point.toMap());
  }

  double _calculateDistance() {
    double total = 0;

    for (int i = 1; i < _points.length; i++) {
      total += Geolocator.distanceBetween(
        _points[i - 1].latitude,
        _points[i - 1].longitude,
        _points[i].latitude,
        _points[i].longitude,
      );
    }

    return total;
  }

  LatLng get defaultCenter => _defaultCenter;

  List<WalkPoint> get points => List.unmodifiable(_points);

  Walk? get lastFinishedWalk => _lastFinishedWalk;

  bool get isTracking => _currentWalk != null;
}
