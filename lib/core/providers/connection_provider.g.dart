// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connection_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(internetConnection)
const internetConnectionProvider = InternetConnectionProvider._();

final class InternetConnectionProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, Stream<bool>>
    with $FutureModifier<bool>, $StreamProvider<bool> {
  const InternetConnectionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'internetConnectionProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$internetConnectionHash();

  @$internal
  @override
  $StreamProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<bool> create(Ref ref) {
    return internetConnection(ref);
  }
}

String _$internetConnectionHash() =>
    r'8f9e09461faa61bb6857976c2b6fcc1377f9b985';
