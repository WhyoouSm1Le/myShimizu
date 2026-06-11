class PumpModel {
  final bool status;
  final int updatedAt;

  const PumpModel({
    required this.status,
    required this.updatedAt,
  });

  factory PumpModel.fromMap(Map<dynamic, dynamic> map) {
    return PumpModel(
      status: map['status'] as bool? ?? false,
      updatedAt: map['updateAt'] as int? ?? 0,
    );
  }

  factory PumpModel.empty() {
    return const PumpModel(status: false, updatedAt: 0);
  }
}