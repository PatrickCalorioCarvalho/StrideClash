// A walk is recorded entirely offline first; `status` tracks whether it
// still needs to reach the server.
abstract class WalkStatus {
  static const recording = 'recording';
  static const pendingSync = 'pending_sync';
  static const synced = 'synced';
}

class Walk {
  final String id;
  final String userId;
  final String? championshipId;
  final DateTime startTime;
  DateTime? endTime;
  double distance;
  String? polygonWkt;
  double? areaM2;
  String status;

  Walk({
    required this.id,
    required this.userId,
    this.championshipId,
    required this.startTime,
    this.endTime,
    this.distance = 0,
    this.polygonWkt,
    this.areaM2,
    this.status = WalkStatus.recording,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'user_id': userId,
        'championship_id': championshipId,
        'start_time': startTime.toIso8601String(),
        'end_time': endTime?.toIso8601String(),
        'distance': distance,
        'polygon_wkt': polygonWkt,
        'area_m2': areaM2,
        'status': status,
      };

  factory Walk.fromMap(Map<String, dynamic> map) => Walk(
        id: map['id'],
        userId: map['user_id'],
        championshipId: map['championship_id'] as String?,
        startTime: DateTime.parse(map['start_time']),
        endTime:
            map['end_time'] != null ? DateTime.parse(map['end_time']) : null,
        distance: (map['distance'] as num).toDouble(),
        polygonWkt: map['polygon_wkt'] as String?,
        areaM2: (map['area_m2'] as num?)?.toDouble(),
        status: map['status'] as String? ?? WalkStatus.recording,
      );
}

class WalkPoint {
  final String id;
  final String walkId;
  final double latitude;
  final double longitude;
  final double speed;
  final DateTime timestamp;

  WalkPoint({
    required this.id,
    required this.walkId,
    required this.latitude,
    required this.longitude,
    this.speed = 0,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'walk_id': walkId,
        'lat': latitude,
        'lng': longitude,
        'speed': speed,
        'timestamp': timestamp.toIso8601String(),
      };

  factory WalkPoint.fromMap(Map<String, dynamic> map) => WalkPoint(
        id: map['id'],
        walkId: map['walk_id'],
        latitude: (map['lat'] as num).toDouble(),
        longitude: (map['lng'] as num).toDouble(),
        speed: (map['speed'] as num?)?.toDouble() ?? 0,
        timestamp: DateTime.parse(map['timestamp']),
      );
}
