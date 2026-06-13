import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../repositories/esp_repository.dart'; // Sesuaikan path repo lo

part 'esp_status_provider.g.dart';

@Riverpod(keepAlive: true)
class EspStatusControl extends _$EspStatusControl {
  final EspRepository _repository = EspRepository();
  StreamSubscription<List<ConnectivityResult>>? _networkSubscription;

  @override
  Stream<bool> build() {
    ref.onDispose(() {
      _networkSubscription?.cancel();
    });

    _networkSubscription = Connectivity().onConnectivityChanged.listen((results) {
      if (results.contains(ConnectivityResult.mobile) ||
          results.contains(ConnectivityResult.wifi)) {
        if (state.hasError) {
          ref.invalidateSelf();
        }
      }
    });

    return _repository.streamEspStatus();
  }
}
