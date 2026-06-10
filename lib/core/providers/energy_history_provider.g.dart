// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'energy_history_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(EnergyHistory)
const energyHistoryProvider = EnergyHistoryProvider._();

final class EnergyHistoryProvider
    extends $AsyncNotifierProvider<EnergyHistory, List<EnergyModel>> {
  const EnergyHistoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'energyHistoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$energyHistoryHash();

  @$internal
  @override
  EnergyHistory create() => EnergyHistory();
}

String _$energyHistoryHash() => r'b12e51fe281aee3874de55a36a7a170b1e40948f';

abstract class _$EnergyHistory extends $AsyncNotifier<List<EnergyModel>> {
  FutureOr<List<EnergyModel>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<AsyncValue<List<EnergyModel>>, List<EnergyModel>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<EnergyModel>>, List<EnergyModel>>,
              AsyncValue<List<EnergyModel>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
