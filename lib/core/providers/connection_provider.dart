import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'connection_provider.g.dart';

@Riverpod(keepAlive: true)
Stream<bool> internetConnection(Ref ref) {
  return Connectivity().onConnectivityChanged.map((results) {
    return results.contains(ConnectivityResult.mobile) ||
        results.contains(ConnectivityResult.wifi);
  });
}
