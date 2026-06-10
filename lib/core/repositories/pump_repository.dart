import 'package:firebase_database/firebase_database.dart';

class PumpRepository {
  final _dbRef = FirebaseDatabase.instance.ref("DataControl");

  Stream<bool> streamPumpStatus() {
    return _dbRef.onValue.map((event) {
      return event.snapshot.value == true;
    });
  }

  Future<void> setPumpStatus(bool value) async {
    await _dbRef.set(value);
  }
}