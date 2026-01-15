class Walk {
  final String id;
  final DateTime startTime;
  DateTime? endTime;
  double distance;

  Walk({
    required this.id,
    required this.startTime,
    this.endTime,
    this.distance = 0,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'start_time': startTime.toIso8601String(),
        'end_time': endTime?.toIso8601String(),
        'distance': distance,
      };

  factory Walk.fromMap(Map<String, dynamic> map) => Walk(
        id: map['id'],
        startTime: DateTime.parse(map['start_time']),
        endTime:
            map['end_time'] != null ? DateTime.parse(map['end_time']) : null,
        distance: (map['distance'] as num).toDouble(),
      );
}

class WalkPoint {
  final String id;
  final String walkId;
  final double latitude;
  final double longitude;
  final DateTime timestamp;

  WalkPoint({
    required this.id,
    required this.walkId,
    required this.latitude,
    required this.longitude,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'walk_id': walkId,
        'lat': latitude,
        'lng': longitude,
        'timestamp': timestamp.toIso8601String(),
      };

  factory WalkPoint.fromMap(Map<String, dynamic> map) => WalkPoint(
        id: map['id'],
        walkId: map['walk_id'],
        latitude: (map['lat'] as num).toDouble(),
        longitude: (map['lng'] as num).toDouble(),
        timestamp: DateTime.parse(map['timestamp']),
      );
}
