import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shimizu_app/core/models/cost_estimation_model.dart';

class CostEstimationRepository {
  final http.Client _client;

  CostEstimationRepository({http.Client? client}) : _client = client ?? http.Client();

  Future<CostEstimation> fetchCostPrediction() async {
    const String url = 'https://timescale-db.rizkyanugrah.my.id/api/predict-cost';

    try {
      final response = await _client.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> decodedData = jsonDecode(response.body);
        return CostEstimation.fromJson(decodedData);
      } else {
        throw Exception('Server Node.js merespon dengan kode: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Gagal terhubung ke backend Shimizu: $e');
    }
  }
}