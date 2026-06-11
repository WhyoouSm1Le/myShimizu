// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pump_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PumpControl)
const pumpControlProvider = PumpControlProvider._();

final class PumpControlProvider
    extends $AsyncNotifierProvider<PumpControl, PumpModel> {
  const PumpControlProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pumpControlProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pumpControlHash();

  @$internal
  @override
  PumpControl create() => PumpControl();
}

String _$pumpControlHash() => r'3e82be8bf8c72d5948fc8fe01ebc67c266cbc20e';

abstract class _$PumpControl extends $AsyncNotifier<PumpModel> {
  FutureOr<PumpModel> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<PumpModel>, PumpModel>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<PumpModel>, PumpModel>,
              AsyncValue<PumpModel>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
