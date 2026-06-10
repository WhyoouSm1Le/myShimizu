import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart' as http;
import 'package:shimizu_app/core/models/energy_model.dart';

class EnergyRepository {
  final _dbRef = FirebaseDatabase.instance.ref("PZEM_DATA");
  
  final String _historyUrl = 'https://timescale-db.rizkyanugrah.my.id/api/history';

  Stream<EnergyModel> streamEnergyData() {
    return _dbRef.onValue.map((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;

      if (data == null) return EnergyModel();

      final dynamic rawTimestamp = data['timestamp'];
      final int? firebaseTimestamp = rawTimestamp != null ? (rawTimestamp as num).toInt() : null;

      final DateTime? parsedTime = firebaseTimestamp != null
          ? DateTime.fromMillisecondsSinceEpoch(firebaseTimestamp)
          : null;

      return EnergyModel(
        time: parsedTime,
        voltage: (data['voltage'] ?? 0.0).toDouble(),
        current: (data['current'] ?? 0.0).toDouble(),
        power: (data['power'] ?? 0.0).toDouble(),
        energy: (data['energy'] ?? 0.0).toDouble(),
      );
    });
  }

  Future<List<EnergyModel>> fetchEnergyHistory() async {
    try {
      final response = await http.get(Uri.parse(_historyUrl));

      if (response.statusCode == 200) {
        final List<dynamic> decodedData = json.decode(response.body);
        
        return decodedData.map((item) => EnergyModel.fromJson(item)).toList();
      } else {
        throw Exception('Gagal narik history. Status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Gagal konek ke server Proxmox: $e');
    }
  }
}