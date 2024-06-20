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
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
