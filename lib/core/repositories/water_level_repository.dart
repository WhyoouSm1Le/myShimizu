import 'package:firebase_database/firebase_database.dart';
import 'package:shimizu_app/core/models/water_level_model.dart';

class WaterLevelRepository {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref('WATER_DATA');

  Stream<WaterLevelModel> streamWaterLevelData() {
    return _dbRef.onValue.map((event) {
      final snapshot = event.snapshot;
      if (snapshot.value != null && snapshot.value is Map) {
        final data = snapshot.value as Map<dynamic, dynamic>;
        return WaterLevelModel.fromMap(data);
      }
      return WaterLevelModel.empty();
    });
  }
}