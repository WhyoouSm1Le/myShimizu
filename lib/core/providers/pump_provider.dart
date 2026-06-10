import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../repositories/pump_repository.dart';

part 'pump_provider.g.dart';

@Riverpod(keepAlive: true)
class PumpControl extends _$PumpControl {
  final PumpRepository _repository = PumpRepository();
  StreamSubscription<bool>? _subscription;
  StreamSubscription<List<ConnectivityResult>>? _networkSubscription;

  @override
  FutureOr<bool> build() async {
    ref.onDispose(() {
      _subscription?.cancel();
      _networkSubscription?.cancel();
    });

    _subscription = _repository.streamPumpStatus().listen(
      (status) {
        state = AsyncData(status);
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
            state = const AsyncLoading<bool>();
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
      state = const AsyncLoading<bool>();

      await _repository.setPumpStatus(targetState);
    } catch (err, stack) {
      state = AsyncError(err, stack);
    }
  }
}
