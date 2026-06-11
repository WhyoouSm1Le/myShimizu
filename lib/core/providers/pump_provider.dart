import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shimizu_app/core/models/pump_model.dart';
import '../repositories/pump_repository.dart';

part 'pump_provider.g.dart';

@Riverpod(keepAlive: true)
class PumpControl extends _$PumpControl {
  final PumpRepository _repository = PumpRepository();
  StreamSubscription<PumpModel>? _subscription;
  StreamSubscription<List<ConnectivityResult>>? _networkSubscription;

  @override
  FutureOr<PumpModel> build() async {
    ref.onDispose(() {
      _subscription?.cancel();
      _networkSubscription?.cancel();
    });

    _subscription = _repository.streamPumpStatus().listen(
      (pumpData) {
        state = AsyncData(pumpData); 
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
            state = const AsyncLoading<PumpModel>();
            final freshStatus = await _repository.streamPumpStatus().first;
            state = AsyncData(freshStatus);
          } catch (err, stack) {
            state = AsyncError(err, stack);
          }
        }
      }
    });

    return _repository.streamPumpStatus().first;
  }

  Future<void> togglePump(bool targetState) async {
    try {
      await _repository.setPumpStatus(targetState);
    } catch (err, stack) {
      state = AsyncError(err, stack);
    }
  }
}