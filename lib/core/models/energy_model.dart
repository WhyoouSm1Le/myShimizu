class EnergyModel {
  final DateTime? time;
  final double voltage;
  final double current;
  final double power;
  final double energy;

  EnergyModel({
    this.time,
    this.voltage = 0.0,
    this.current = 0.0,
    this.power = 0.0,
    this.energy = 0.0,
  });

  factory EnergyModel.fromJson(Map<String, dynamic> json) {
    return EnergyModel(
      time: json['time'] != null ? DateTime.parse(json['time']) : null,
      voltage: (json['voltage'] as num).toDouble(),
      current: (json['current'] as num).toDouble(),
      power: (json['power'] as num).toDouble(),
      energy: (json['energy'] as num).toDouble(),
    );
  }
}