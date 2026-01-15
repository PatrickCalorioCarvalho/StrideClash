import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class WalkLocalDb {
  static final WalkLocalDb _instance = WalkLocalDb._internal();
  factory WalkLocalDb() => _instance;
  WalkLocalDb._internal();

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'strideclash.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE walks (
        id TEXT PRIMARY KEY,
        championship_id TEXT,
        started_at TEXT NOT NULL,
        ended_at TEXT,
        distance_meters REAL DEFAULT 0,
        status TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE walk_points (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        walk_id TEXT NOT NULL,
        lat REAL NOT NULL,
        lng REAL NOT NULL,
        timestamp TEXT NOT NULL
      )
    ''');
  }

  Future<void> insertWalk({
    required String id,
    required String championshipId,
    required DateTime startedAt,
  }) async {
    final db = await database;

    await db.insert('walks', {
      'id': id,
      'championship_id': championshipId,
      'started_at': startedAt.toIso8601String(),
      'status': 'recording',
    });
  }

  Future<void> finishWalk({
    required String walkId,
    required DateTime endedAt,
    required double distanceMeters,
  }) async {
    final db = await database;

    await db.update(
      'walks',
      {
        'ended_at': endedAt.toIso8601String(),
        'distance_meters': distanceMeters,
        'status': 'finished',
      },
      where: 'id = ?',
      whereArgs: [walkId],
    );
  }

  Future<void> insertPoint({
    required String walkId,
    required double lat,
    required double lng,
    required double speed,
    required DateTime timestamp,
  }) async {
    final db = await database;

    await db.insert('walk_points', {
      'walk_id': walkId,
      'lat': lat,
      'lng': lng,
      'speed': speed,
      'timestamp': timestamp.toIso8601String(),
    });
  }

  Future<List<Map<String, dynamic>>> getPoints(String walkId) async {
    final db = await database;

    return db.query(
      'walk_points',
      where: 'walk_id = ?',
      whereArgs: [walkId],
      orderBy: 'timestamp ASC',
    );
  }

  Future<void> clearAll() async {
    final db = await database;
    await db.delete('walk_points');
    await db.delete('walks');
  }
}
