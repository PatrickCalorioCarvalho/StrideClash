class Walk {
  final String id;
  final DateTime startTime;
  DateTime? endTime;
  double distance;
  String? polygonWkt;
  double? areaM2;

  Walk({
    required this.id,
    required this.startTime,
    this.endTime,
    this.distance = 0,
    this.polygonWkt,
    this.areaM2,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'start_time': startTime.toIso8601String(),
        'end_time': endTime?.toIso8601String(),
        'distance': distance,
        'polygon_wkt': polygonWkt,
        'area_m2': areaM2,
      };

  factory Walk.fromMap(Map<String, dynamic> map) => Walk(
        id: map['id'],
        startTime: DateTime.parse(map['start_time']),
        endTime:
            map['end_time'] != null ? DateTime.parse(map['end_time']) : null,
        distance: (map['distance'] as num).toDouble(),
        polygonWkt: map['polygon_wkt'] as String?,
        areaM2: (map['area_m2'] as num?)?.toDouble(),
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
