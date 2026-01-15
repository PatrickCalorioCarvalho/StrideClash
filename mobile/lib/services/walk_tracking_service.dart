import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:uuid/uuid.dart';

import '../model/walk_models.dart';

class WalkTrackingService {
  static final WalkTrackingService _instance =
      WalkTrackingService._internal();

  factory WalkTrackingService() => _instance;

  WalkTrackingService._internal();

  final _uuid = const Uuid();
  Database? _db;
  StreamSubscription<Position>? _positionSub;

  Walk? _currentWalk;
  final List<WalkPoint> _points = [];

  LatLng _defaultCenter = LatLng(-23.5505, -46.6333);

  // ---------- DB ----------
  Future<void> init() async {

    final path = join(await getDatabasesPath(), 'walks.db');

    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, _) async {
        await db.execute('''
          CREATE TABLE walks (
            id TEXT PRIMARY KEY,
            start_time TEXT,
            end_time TEXT,
            distance REAL
          )
        ''');

        await db.execute('''
          CREATE TABLE walk_points (
            id TEXT PRIMARY KEY,
            walk_id TEXT,
            lat REAL,
            lng REAL,
            timestamp TEXT
          )
        ''');
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
  Future<Walk> startWalk() async {
    final walk = Walk(
      id: _uuid.v4(),
      startTime: DateTime.now(),
    );

    await _db!.insert('walks', walk.toMap());
    _currentWalk = walk;
    _points.clear();

    _positionSub = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 5,
      ),
    ).listen(_onPosition);

    return walk;
  }

  Future<void> stopWalk() async {
    if (_currentWalk == null) return;

    _positionSub?.cancel();

    _currentWalk!.endTime = DateTime.now();
    _currentWalk!.distance = _calculateDistance();

    await _db!.update(
      'walks',
      _currentWalk!.toMap(),
      where: 'id = ?',
      whereArgs: [_currentWalk!.id],
    );

    _currentWalk = null;
  }

  // ---------- GPS ----------
  Future<void> _onPosition(Position p) async {
    if (_currentWalk == null) return;

    final point = WalkPoint(
      id: _uuid.v4(),
      walkId: _currentWalk!.id,
      latitude: p.latitude,
      longitude: p.longitude,
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
}
