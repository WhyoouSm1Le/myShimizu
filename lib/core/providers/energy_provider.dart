import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shimizu_app/core/models/energy_model.dart';
import 'package:shimizu_app/core/repositories/energy_repository.dart';

part 'energy_provider.g.dart';

@Riverpod(keepAlive: true)
class RealtimeEnergy extends _$RealtimeEnergy {
  final EnergyRepository _repository = EnergyRepository();
  StreamSubscription<EnergyModel>? _subscription;
  StreamSubscription<List<ConnectivityResult>>? _networkSubscription;

  @override
  FutureOr<EnergyModel> build() async {
    ref.onDispose(() {
      _subscription?.cancel();
      _networkSubscription?.cancel();
    });

    _subscription = _repository.streamEnergyData().listen(
      (energyData) {
        state = AsyncData(energyData);
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
            state = const AsyncLoading<EnergyModel>();
            final freshData = await _repository.streamEnergyData().first;
            state = AsyncData(freshData);
          } catch (err, stack) {
            state = AsyncError(err, stack);
          }
        }
      }
    });

    return _repository.streamEnergyData().first;
  }
}
