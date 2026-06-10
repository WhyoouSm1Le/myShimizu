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
    extends $AsyncNotifierProvider<PumpControl, bool> {
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

String _$pumpControlHash() => r'33404d5f42b7aa88b08e50bf0fcb90c57c9af3de';

abstract class _$PumpControl extends $AsyncNotifier<bool> {
  FutureOr<bool> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<bool>, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<bool>, bool>,
              AsyncValue<bool>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
