// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medication_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$medicationRepositoryHash() =>
    r'f80b57149e404b590cde95808d3287efa00b9335';

/// See also [medicationRepository].
@ProviderFor(medicationRepository)
final medicationRepositoryProvider =
    AutoDisposeProvider<MedicationsRepository>.internal(
  medicationRepository,
  name: r'medicationRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$medicationRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef MedicationRepositoryRef = AutoDisposeProviderRef<MedicationsRepository>;
String _$fetchMedicationHash() => r'3bbd2fe8ecfaec435add78d67675092926a06d00';

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

/// See also [fetchMedication].
@ProviderFor(fetchMedication)
const fetchMedicationProvider = FetchMedicationFamily();

/// See also [fetchMedication].
class FetchMedicationFamily extends Family<AsyncValue<Medication>> {
  /// See also [fetchMedication].
  const FetchMedicationFamily();

  /// See also [fetchMedication].
  FetchMedicationProvider call(
    String medicationId,
  ) {
    return FetchMedicationProvider(
      medicationId,
    );
  }

  @override
  FetchMedicationProvider getProviderOverride(
    covariant FetchMedicationProvider provider,
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
  String? get name => r'fetchMedicationProvider';
}

/// See also [fetchMedication].
class FetchMedicationProvider extends AutoDisposeFutureProvider<Medication> {
  /// See also [fetchMedication].
  FetchMedicationProvider(
    String medicationId,
  ) : this._internal(
          (ref) => fetchMedication(
            ref as FetchMedicationRef,
            medicationId,
          ),
          from: fetchMedicationProvider,
          name: r'fetchMedicationProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$fetchMedicationHash,
          dependencies: FetchMedicationFamily._dependencies,
          allTransitiveDependencies:
              FetchMedicationFamily._allTransitiveDependencies,
          medicationId: medicationId,
        );

  FetchMedicationProvider._internal(
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
    FutureOr<Medication> Function(FetchMedicationRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FetchMedicationProvider._internal(
        (ref) => create(ref as FetchMedicationRef),
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
  AutoDisposeFutureProviderElement<Medication> createElement() {
    return _FetchMedicationProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchMedicationProvider &&
        other.medicationId == medicationId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, medicationId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin FetchMedicationRef on AutoDisposeFutureProviderRef<Medication> {
  /// The parameter `medicationId` of this provider.
  String get medicationId;
}

class _FetchMedicationProviderElement
    extends AutoDisposeFutureProviderElement<Medication>
    with FetchMedicationRef {
  _FetchMedicationProviderElement(super.provider);

  @override
  String get medicationId => (origin as FetchMedicationProvider).medicationId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
