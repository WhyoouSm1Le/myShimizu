// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'water_level_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(RealtimeWaterLevel)
const realtimeWaterLevelProvider = RealtimeWaterLevelProvider._();

final class RealtimeWaterLevelProvider
    extends $AsyncNotifierProvider<RealtimeWaterLevel, WaterLevelModel> {
  const RealtimeWaterLevelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'realtimeWaterLevelProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$realtimeWaterLevelHash();

  @$internal
  @override
  RealtimeWaterLevel create() => RealtimeWaterLevel();
}

String _$realtimeWaterLevelHash() =>
    r'36fb100ff411a580efed073c64ab841515f3942a';

abstract class _$RealtimeWaterLevel extends $AsyncNotifier<WaterLevelModel> {
  FutureOr<WaterLevelModel> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<WaterLevelModel>, WaterLevelModel>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<WaterLevelModel>, WaterLevelModel>,
              AsyncValue<WaterLevelModel>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
