import 'package:firebase_database/firebase_database.dart';
import 'package:shimizu_app/core/models/pump_model.dart';
class PumpRepository {
  final _dbRef = FirebaseDatabase.instance.ref("PUMP_DATA");

  Stream<PumpModel> streamPumpStatus() {
    return _dbRef.onValue.map((event) {
      final value = event.snapshot.value;
      if (value == null || value is! Map) {
        return PumpModel.empty();
      }
      return PumpModel.fromMap(value);
    });
  }

  Future<void> setPumpStatus(bool value) async {
    await _dbRef.set({
      "status": value,
      "updateAt": ServerValue.timestamp,
    });
  }
}