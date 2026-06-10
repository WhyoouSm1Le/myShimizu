import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shimizu_app/core/models/cost_estimation_model.dart';

class CostEstimationRepository {
  final http.Client _client;

  CostEstimationRepository({http.Client? client}) : _client = client ?? http.Client();

  Future<CostEstimation> fetchCostPrediction() async {
    String url = dotenv.env['BACKEND_URL_2'] ?? 'https://cost-url.com';

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