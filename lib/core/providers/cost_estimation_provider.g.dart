// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cost_estimation_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CostEstimationNotifier)
const costEstimationProvider = CostEstimationNotifierProvider._();

final class CostEstimationNotifierProvider
    extends $AsyncNotifierProvider<CostEstimationNotifier, CostEstimation> {
  const CostEstimationNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'costEstimationProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$costEstimationNotifierHash();

  @$internal
  @override
  CostEstimationNotifier create() => CostEstimationNotifier();
}

String _$costEstimationNotifierHash() =>
    r'913969586893b46076be591f91d37120e8785a8e';

abstract class _$CostEstimationNotifier extends $AsyncNotifier<CostEstimation> {
  FutureOr<CostEstimation> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<CostEstimation>, CostEstimation>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<CostEstimation>, CostEstimation>,
              AsyncValue<CostEstimation>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
