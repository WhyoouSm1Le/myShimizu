import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shimizu_app/core/models/energy_model.dart';
import 'package:shimizu_app/core/repositories/energy_repository.dart';

part 'energy_history_provider.g.dart';

@Riverpod(keepAlive: true)
class EnergyHistory extends _$EnergyHistory {
  final EnergyRepository _repository = EnergyRepository();
  StreamSubscription<List<ConnectivityResult>>? _networkSubscription;

  @override
  FutureOr<List<EnergyModel>> build() async {
    ref.onDispose(() {
      _networkSubscription?.cancel();
    });

    _networkSubscription = Connectivity().onConnectivityChanged.listen((results) async {
      if (results.contains(ConnectivityResult.mobile) ||
          results.contains(ConnectivityResult.wifi)) {
        
        if (state.hasError || (state.isLoading && !state.hasValue)) {
          try {
            state = const AsyncLoading<List<EnergyModel>>();
            final freshHistory = await _repository.fetchEnergyHistory();
            state = AsyncData(freshHistory);
          } catch (err, stack) {
            state = AsyncError(err, stack);
          }
        }
      }
    });

    return await _repository.fetchEnergyHistory();
  }

  Future<void> refreshHistory() async {
    state = const AsyncLoading<List<EnergyModel>>();
    try {
      final freshHistory = await _repository.fetchEnergyHistory();
      state = AsyncData(freshHistory);
    } catch (err, stack) {
      state = AsyncError(err, stack);
    }
  }
}