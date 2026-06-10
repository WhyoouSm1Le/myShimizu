import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shimizu_app/core/models/panel_model.dart';

final panelServiceProvider = StateNotifierProvider<PanelService, PanelData>((ref) {
  return PanelService();
});

class PanelService extends StateNotifier<PanelData> {
  PanelService() : super(PanelData()) {
    _initPanelListener();
  }

  final _dbRef = FirebaseDatabase.instance.ref("PANEL_DATA");
  StreamSubscription? _subscription;

  void _initPanelListener() {
    _subscription = _dbRef.onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;

      if (data != null) {
        final double temp = (data['temperature'] ?? 0.0).toDouble();

        String status = "OFF";
        if (temp > 30) {
          status = "HIGH";
        } else if (temp > 25) {
          status = "LOW";
        }

        state = PanelData(
          temperature: temp,
          humidity: (data['humidity'] ?? 0.0).toDouble(),
          fanStatus: status,
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