// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'energy_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(RealtimeEnergy)
const realtimeEnergyProvider = RealtimeEnergyProvider._();

final class RealtimeEnergyProvider
    extends $AsyncNotifierProvider<RealtimeEnergy, EnergyModel> {
  const RealtimeEnergyProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'realtimeEnergyProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$realtimeEnergyHash();

  @$internal
  @override
  RealtimeEnergy create() => RealtimeEnergy();
}

String _$realtimeEnergyHash() => r'5c2d5eeccaa17c1e441d3b74e298ab93eeb8b11b';

abstract class _$RealtimeEnergy extends $AsyncNotifier<EnergyModel> {
  FutureOr<EnergyModel> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<EnergyModel>, EnergyModel>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<EnergyModel>, EnergyModel>,
              AsyncValue<EnergyModel>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
