import 'package:firebase_database/firebase_database.dart';

class EspRepository {
  final _dbRef = FirebaseDatabase.instance.ref("esp_status/last_seen");

  Stream<bool> streamEspStatus() {
    return _dbRef.onValue.map((event) {
      if (event.snapshot.value == null) return false;

      int lastSeen = event.snapshot.value as int;
      int serverTimeEstimated = DateTime.now().millisecondsSinceEpoch;
      
      return (serverTimeEstimated - lastSeen).abs() < 15000;
    });
  }
}