// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prescriptions_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$prescriptionsRepositoryHash() =>
    r'5b06897fbf6f076dcdbc1cfc729186f63e0ff99a';

/// See also [prescriptionsRepository].
@ProviderFor(prescriptionsRepository)
final prescriptionsRepositoryProvider =
    AutoDisposeProvider<PrescriptionsRepository>.internal(
  prescriptionsRepository,
  name: r'prescriptionsRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$prescriptionsRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef PrescriptionsRepositoryRef
    = AutoDisposeProviderRef<PrescriptionsRepository>;
String _$watchUserPrescriptionsHash() =>
    r'f733322cce48fcd614cae5a7ea3ef26c6eebe508';

/// See also [watchUserPrescriptions].
@ProviderFor(watchUserPrescriptions)
final watchUserPrescriptionsProvider =
    AutoDisposeStreamProvider<List<Prescription>>.internal(
  watchUserPrescriptions,
  name: r'watchUserPrescriptionsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$watchUserPrescriptionsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef WatchUserPrescriptionsRef
    = AutoDisposeStreamProviderRef<List<Prescription>>;
String _$watchUserPrescriptionHash() =>
    r'a3dd85c506dcf44b93490144421cb6dff8a6d38b';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [watchUserPrescription].
@ProviderFor(watchUserPrescription)
const watchUserPrescriptionProvider = WatchUserPrescriptionFamily();

/// See also [watchUserPrescription].
class WatchUserPrescriptionFamily extends Family<AsyncValue<Prescription>> {
  /// See also [watchUserPrescription].
  const WatchUserPrescriptionFamily();

  /// See also [watchUserPrescription].
  WatchUserPrescriptionProvider call(
    String medicationId,
  ) {
    return WatchUserPrescriptionProvider(
      medicationId,
    );
  }

  @override
  WatchUserPrescriptionProvider getProviderOverride(
    covariant WatchUserPrescriptionProvider provider,
  ) {
    return call(
      provider.medicationId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'watchUserPrescriptionProvider';
}

/// See also [watchUserPrescription].
class WatchUserPrescriptionProvider
    extends AutoDisposeStreamProvider<Prescription> {
  /// See also [watchUserPrescription].
  WatchUserPrescriptionProvider(
    String medicationId,
  ) : this._internal(
          (ref) => watchUserPrescription(
            ref as WatchUserPrescriptionRef,
            medicationId,
          ),
          from: watchUserPrescriptionProvider,
          name: r'watchUserPrescriptionProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$watchUserPrescriptionHash,
          dependencies: WatchUserPrescriptionFamily._dependencies,
          allTransitiveDependencies:
              WatchUserPrescriptionFamily._allTransitiveDependencies,
          medicationId: medicationId,
        );

  WatchUserPrescriptionProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.medicationId,
  }) : super.internal();

  final String medicationId;

  @override
  Override overrideWith(
    Stream<Prescription> Function(WatchUserPrescriptionRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: WatchUserPrescriptionProvider._internal(
        (ref) => create(ref as WatchUserPrescriptionRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        medicationId: medicationId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<Prescription> createElement() {
    return _WatchUserPrescriptionProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is WatchUserPrescriptionProvider &&
        other.medicationId == medicationId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, medicationId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin WatchUserPrescriptionRef on AutoDisposeStreamProviderRef<Prescription> {
  /// The parameter `medicationId` of this provider.
  String get medicationId;
}

class _WatchUserPrescriptionProviderElement
    extends AutoDisposeStreamProviderElement<Prescription>
    with WatchUserPrescriptionRef {
  _WatchUserPrescriptionProviderElement(super.provider);

  @override
  String get medicationId =>
      (origin as WatchUserPrescriptionProvider).medicationId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
