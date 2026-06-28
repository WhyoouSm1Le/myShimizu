import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shimizu_app/core/models/water_level_model.dart';
import 'package:shimizu_app/core/repositories/water_level_repository.dart';

part 'water_level_provider.g.dart';

@Riverpod(keepAlive: true)
class RealtimeWaterLevel extends _$RealtimeWaterLevel {
  final WaterLevelRepository _repository = WaterLevelRepository();
  StreamSubscription<WaterLevelModel>? _subscription;
  StreamSubscription<List<ConnectivityResult>>? _networkSubscription;

  @override
  FutureOr<WaterLevelModel> build() async {
    ref.onDispose(() {
      _subscription?.cancel();
      _networkSubscription?.cancel();
    });

    _subscription = _repository.streamWaterLevelData().listen(
      (waterData) {
        state = AsyncData(waterData);
      },
      onError: (err, stack) {
        state = AsyncError(err, stack);
      },
    );

    _networkSubscription = Connectivity().onConnectivityChanged.listen((
      results,
    ) async {
      if (results.contains(ConnectivityResult.mobile) ||
          results.contains(ConnectivityResult.wifi)) {
        if (state.hasError || (state.isLoading && !state.hasValue)) {
          try {
            state = const AsyncLoading<WaterLevelModel>();
            final freshData = await _repository.streamWaterLevelData().first;
            state = AsyncData(freshData);
          } catch (err, stack) {
            state = AsyncError(err, stack);
          }
        }
      }
    });

    return _repository.streamWaterLevelData().first;
  }
}