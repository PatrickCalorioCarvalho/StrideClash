import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:protobuf/well_known_types/google/protobuf/timestamp.pb.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:uuid/uuid.dart';

import '../auth/auth_storage.dart';
import '../grpc_client.dart';
import '../generated/championship.pb.dart';
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
  Timer? _syncTimer;

  Walk? _currentWalk;
  Walk? _lastFinishedWalk;
  final List<WalkPoint> _points = [];

  LatLng _defaultCenter = LatLng(-23.5505, -46.6333);

  // ---------- DB ----------
  Future<void> init() async {

    final path = join(await getDatabasesPath(), 'walks.db');

    _db = await openDatabase(
      path,
      version: 4,
      onCreate: (db, _) async {
        await db.execute('''
          CREATE TABLE walks (
            id TEXT PRIMARY KEY,
            user_id TEXT NOT NULL,
            championship_id TEXT,
            start_time TEXT,
            end_time TEXT,
            distance REAL,
            polygon_wkt TEXT,
            area_m2 REAL,
            status TEXT NOT NULL DEFAULT 'recording'
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

        await _createCacheTables(db);
      },
      onUpgrade: (db, oldVersion, _) async {
        if (oldVersion < 2) {
          await db.execute('ALTER TABLE walks ADD COLUMN polygon_wkt TEXT');
          await db.execute('ALTER TABLE walks ADD COLUMN area_m2 REAL');
          await db.execute(
            'ALTER TABLE walk_points ADD COLUMN speed REAL NOT NULL DEFAULT 0',
          );
        }
        if (oldVersion < 3) {
          // Pre-existing rows only ever got here via the old server-first
          // flow, so they're already synced — default them as such.
          await db.execute(
            "ALTER TABLE walks ADD COLUMN user_id TEXT NOT NULL DEFAULT ''",
          );
          await db.execute('ALTER TABLE walks ADD COLUMN championship_id TEXT');
          await db.execute(
            "ALTER TABLE walks ADD COLUMN status TEXT NOT NULL DEFAULT 'synced'",
          );
        }
        if (oldVersion < 4) {
          await _createCacheTables(db);
        }
      },
    );
    await _ensurePermission();
    final position = await Geolocator.getCurrentPosition();
    _defaultCenter = LatLng(position.latitude, position.longitude);

    syncPendingWalks();
    _syncTimer ??= Timer.periodic(
      const Duration(seconds: 20),
      (_) => syncPendingWalks(),
    );
  }

  Future<void> _createCacheTables(Database db) async {
    await db.execute('''
      CREATE TABLE cached_championships (
        id TEXT PRIMARY KEY,
        name TEXT,
        join_code TEXT,
        created_by TEXT,
        start_at TEXT,
        end_at TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE local_prefs (
        key TEXT PRIMARY KEY,
        value TEXT
      )
    ''');
  }

  // ---------- CHAMPIONSHIP CACHE ----------
  // Lets the walk page still offer a championship picker (using whatever
  // was last fetched) even with no internet — the list itself only ever
  // comes from the server, but we don't want that to block starting a walk.
  Future<void> cacheChampionships(List<Championship> championships) async {
    final batch = _db!.batch();
    batch.delete('cached_championships');
    for (final c in championships) {
      batch.insert('cached_championships', {
        'id': c.id,
        'name': c.name,
        'join_code': c.joinCode,
        'created_by': c.createdBy,
        'start_at': c.startAt.toDateTime().toIso8601String(),
        'end_at': c.endAt.toDateTime().toIso8601String(),
      });
    }
    await batch.commit(noResult: true);
  }

  Future<List<Championship>> getCachedChampionships() async {
    final rows = await _db!.query('cached_championships');
    return rows
        .map((r) => Championship()
          ..id = r['id'] as String
          ..name = r['name'] as String
          ..joinCode = r['join_code'] as String
          ..createdBy = r['created_by'] as String
          ..startAt = Timestamp.fromDateTime(
              DateTime.parse(r['start_at'] as String))
          ..endAt = Timestamp.fromDateTime(
              DateTime.parse(r['end_at'] as String)))
        .toList();
  }

  Future<void> setLastSelectedChampionship(String? id) async {
    if (id == null) {
      await _db!.delete(
        'local_prefs',
        where: 'key = ?',
        whereArgs: ['last_championship_id'],
      );
      return;
    }

    await _db!.insert(
      'local_prefs',
      {'key': 'last_championship_id', 'value': id},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<String?> getLastSelectedChampionship() async {
    final rows = await _db!.query(
      'local_prefs',
      where: 'key = ?',
      whereArgs: ['last_championship_id'],
    );
    return rows.isEmpty ? null : rows.first['value'] as String?;
  }

    Future<bool> _ensurePermission() async {
    if (!await Geolocator.isLocationServiceEnabled()) return false;

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    // Ask for the "always" upgrade too — without it, Android throttles GPS
    // updates once the app is backgrounded or the screen locks.
    if (permission == LocationPermission.whileInUse) {
      permission = await Geolocator.requestPermission();
    }

    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  // ---------- WALK ----------
  // Starting and recording a walk never touches the network — the walk is
  // fully owned by the client (its own id, its own clock) until it's synced.
  Future<Walk> startWalk({String? championshipId}) async {
    final userId = await _authStorage.userId;
    if (userId == null) {
      throw StateError('usuário não autenticado');
    }

    final walk = Walk(
      id: _uuid.v4(),
      userId: userId,
      championshipId:
          (championshipId != null && championshipId.isNotEmpty) ? championshipId : null,
      startTime: DateTime.now(),
      status: WalkStatus.recording,
    );

    await _db!.insert('walks', walk.toMap());
    _currentWalk = walk;
    _lastFinishedWalk = null;
    _points.clear();

    // On Android, run as a foreground service (with a persistent
    // notification) and hold a wakelock — otherwise the OS stops delivering
    // GPS updates within minutes of the screen locking or the app going to
    // the background, and the trail jumps straight from the last point to
    // wherever the walker is when they reopen the app.
    final locationSettings = Platform.isAndroid
        ? AndroidSettings(
            accuracy: LocationAccuracy.best,
            distanceFilter: 5,
            foregroundNotificationConfig: const ForegroundNotificationConfig(
              notificationTitle: 'StrideClash',
              notificationText: 'Registrando sua caminhada...',
              enableWakeLock: true,
            ),
          )
        : const LocationSettings(
            accuracy: LocationAccuracy.best,
            distanceFilter: 5,
          );

    _positionSub = Geolocator.getPositionStream(
      locationSettings: locationSettings,
    ).listen(_onPosition);

    return walk;
  }

  // Stopping never throws on a network failure — the walk (and every point)
  // is already safely on disk. It just stays "pending_sync" and the
  // background retry loop (or the next syncPendingWalks() call) picks it up
  // whenever the server is reachable.
  Future<Walk?> stopWalk() async {
    final walk = _currentWalk;
    if (walk == null) return null;

    await _positionSub?.cancel();
    _currentWalk = null;

    walk.endTime = DateTime.now();
    walk.distance = _calculateDistance();
    walk.status = WalkStatus.pendingSync;

    await _db!.update(
      'walks',
      walk.toMap(),
      where: 'id = ?',
      whereArgs: [walk.id],
    );

    await _syncOne(walk, List.unmodifiable(_points));

    _lastFinishedWalk = walk;
    return walk;
  }

  // ---------- SYNC ----------
  /// Uploads every locally-recorded walk still waiting to reach the server.
  /// Safe to call anytime (app start, periodic timer, pull-to-refresh) —
  /// walks already synced are simply skipped.
  Future<void> syncPendingWalks() async {
    if (_db == null) return;

    final rows = await _db!.query(
      'walks',
      where: 'status = ?',
      whereArgs: [WalkStatus.pendingSync],
    );

    for (final row in rows) {
      final walk = Walk.fromMap(row);

      final pointRows = await _db!.query(
        'walk_points',
        where: 'walk_id = ?',
        whereArgs: [walk.id],
        orderBy: 'timestamp ASC',
      );
      final points = pointRows.map(WalkPoint.fromMap).toList();

      await _syncOne(walk, points);
    }
  }

  Future<bool> _syncOne(Walk walk, List<WalkPoint> points) async {
    // If this is the walk currently shown on the tracking page, mutate that
    // exact object too — otherwise the UI keeps pointing at the stale copy
    // it already has and never notices the retry succeeded.
    void updateLastFinishedIfSame() {
      if (_lastFinishedWalk?.id == walk.id) _lastFinishedWalk = walk;
    }

    // Too few points to ever form a polygon — don't keep retrying forever,
    // just mark it done locally with no capture.
    if (points.length < 3) {
      walk.status = WalkStatus.synced;
      walk.areaM2 = 0;
      await _db!.update(
        'walks',
        walk.toMap(),
        where: 'id = ?',
        whereArgs: [walk.id],
      );
      updateLastFinishedIfSame();
      return true;
    }

    try {
      final response = await _grpcClient.walk.syncWalk(
        pb.SyncWalkRequest()
          ..clientWalkId = walk.id
          ..userId = walk.userId
          ..championshipId = walk.championshipId ?? ''
          ..startedAt = Timestamp.fromDateTime(walk.startTime)
          ..finishedAt = Timestamp.fromDateTime(walk.endTime ?? DateTime.now())
          ..points.addAll(points.map((p) => pb.WalkPoint()
            ..lat = p.latitude
            ..lng = p.longitude
            ..speed = p.speed
            ..timestamp = Timestamp.fromDateTime(p.timestamp))),
      );

      walk.polygonWkt = response.polygonWkt;
      walk.areaM2 = response.areaM2;
      walk.status = WalkStatus.synced;

      await _db!.update(
        'walks',
        walk.toMap(),
        where: 'id = ?',
        whereArgs: [walk.id],
      );
      updateLastFinishedIfSame();

      return true;
    } catch (e) {
      debugPrint('syncWalk failed for ${walk.id}, will retry later: $e');
      return false;
    }
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
