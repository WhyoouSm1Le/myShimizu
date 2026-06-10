import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shimizu_app/core/models/cost_estimation_model.dart';
import 'package:shimizu_app/core/repositories/cost_estimation_repository.dart';

part 'cost_estimation_provider.g.dart';

@Riverpod(keepAlive: true)
class CostEstimationNotifier extends _$CostEstimationNotifier {
  final CostEstimationRepository _repository = CostEstimationRepository();
  StreamSubscription<List<ConnectivityResult>>? _networkSubscription;

  @override
  FutureOr<CostEstimation> build() async {
    ref.onDispose(() {
      _networkSubscription?.cancel();
    });

    _networkSubscription = Connectivity().onConnectivityChanged.listen((results) async {
      if (results.contains(ConnectivityResult.mobile) ||
          results.contains(ConnectivityResult.wifi)) {
        
        if (state.hasError || (state.isLoading && !state.hasValue)) {
          try {
            state = const AsyncLoading<CostEstimation>();
            final freshPrediction = await _repository.fetchCostPrediction();
            state = AsyncData(freshPrediction);
          } catch (err, stack) {
            state = AsyncError(err, stack);
          }
        }
      }
    });

    return await _repository.fetchCostPrediction();
  }

  Future<void> retryPrediction() async {
    state = const AsyncLoading<CostEstimation>();
    try {
      final freshPrediction = await _repository.fetchCostPrediction();
      state = AsyncData(freshPrediction);
    } catch (err, stack) {
      state = AsyncError(err, stack);
    }
  }
}