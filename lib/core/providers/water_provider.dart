import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shimizu_app/core/models/water_model.dart';

final waterServiceProvider = StateNotifierProvider<WaterService, WaterData>((ref) {
  return WaterService();
});

class WaterService extends StateNotifier<WaterData> {
  WaterService() : super(WaterData()) {
    _initWaterListener();
  }

  final _dbRef = FirebaseDatabase.instance.ref("WATER_DATA");
  StreamSubscription? _subscription;

  void _initWaterListener() {
    _subscription = _dbRef.onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;

      if (data != null) {
        state = WaterData(
          flowRate: (data['flow_rate'] ?? 0.0).toDouble(),
          totalVolume: (data['total_volume'] ?? 0.0).toDouble(),
        );
      }
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}