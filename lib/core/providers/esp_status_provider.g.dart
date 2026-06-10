// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'esp_status_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(EspStatusControl)
const espStatusControlProvider = EspStatusControlProvider._();

final class EspStatusControlProvider
    extends $AsyncNotifierProvider<EspStatusControl, bool> {
  const EspStatusControlProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'espStatusControlProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$espStatusControlHash();

  @$internal
  @override
  EspStatusControl create() => EspStatusControl();
}

String _$espStatusControlHash() => r'a42c73d895d7749c9bbda96ce7bbbf242e701b74';

abstract class _$EspStatusControl extends $AsyncNotifier<bool> {
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
