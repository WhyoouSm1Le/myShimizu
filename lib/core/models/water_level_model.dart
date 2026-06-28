class WaterLevelModel {
  final double currentDistance;
  final double waterHeight;
  final double percentage;
  final double volumeLiters;
  final String status;
  final int timestamp;

  WaterLevelModel({
    required this.currentDistance,
    required this.waterHeight,
    required this.percentage,
    required this.volumeLiters,
    required this.status,
    required this.timestamp,
  });

  factory WaterLevelModel.fromMap(Map<dynamic, dynamic> map) {
    return WaterLevelModel(
      currentDistance: (map['current_distance'] ?? 0.0).toDouble(),
      waterHeight: (map['water_height'] ?? 0.0).toDouble(),
      percentage: (map['percentage'] ?? 0.0).toDouble(),
      volumeLiters: (map['volume_liters'] ?? 0.0).toDouble(),
      status: map['status'] ?? 'Unknown',
      timestamp: map['timestamp'] ?? 0,
    );
  }

  factory WaterLevelModel.empty() {
    return WaterLevelModel(
      currentDistance: 0.0,
      waterHeight: 0.0,
      percentage: 0.0,
      volumeLiters: 0.0,
      status: 'Loading...',
      timestamp: 0,
    );
  }
}