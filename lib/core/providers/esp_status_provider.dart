import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../repositories/esp_repository.dart'; // Sesuaikan path repo lo

part 'esp_status_provider.g.dart';

@Riverpod(keepAlive: true)
class EspStatusControl extends _$EspStatusControl {
  final EspRepository _repository = EspRepository();
  StreamSubscription<bool>? _subscription;
  StreamSubscription<List<ConnectivityResult>>? _networkSubscription;

  @override
  FutureOr<bool> build() async {
    ref.onDispose(() {
      _subscription?.cancel();
      _networkSubscription?.cancel();
    });

    _subscription = _repository.streamEspStatus().listen(
      (isOnline) {
        state = AsyncData(isOnline);
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
            final freshStatus = await _repository.streamEspStatus().first;
            state = AsyncData(freshStatus);
          } catch (err, stack) {
            state = AsyncError(err, stack);
          }
        }
      }
    });

    return _repository.streamEspStatus().first;
  }
}
