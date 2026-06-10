class CostEstimation {
  final String status;
  final int predictionDays;
  final double estimatedKwh;
  final int estimatedCost;
  final String message;

  CostEstimation({
    required this.status,
    required this.predictionDays,
    required this.estimatedKwh,
    required this.estimatedCost,
    required this.message,
  });

  factory CostEstimation.fromJson(Map<String, dynamic> json) {
    return CostEstimation(
      status: json['status'] ?? '',
      predictionDays: json['prediction_days'] ?? 30,
      estimatedKwh: (json['estimated_kwh'] as num?)?.toDouble() ?? 0.0,
      estimatedCost: json['estimated_cost'] ?? 0,
      message: json['message'] ?? '',
    );
  }
}