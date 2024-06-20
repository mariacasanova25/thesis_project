// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discussions_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$discussionsRepositoryHash() =>
    r'8abd458688b9e26ad27d2914707c8cec00bd9375';

/// See also [discussionsRepository].
@ProviderFor(discussionsRepository)
final discussionsRepositoryProvider =
    AutoDisposeProvider<DiscussionsRepository>.internal(
  discussionsRepository,
  name: r'discussionsRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$discussionsRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef DiscussionsRepositoryRef
    = AutoDisposeProviderRef<DiscussionsRepository>;
String _$watchDiscussionsHash() => r'f4c0e6ef7c90514f638e8a5d6d77219dc588c11d';

/// See also [watchDiscussions].
@ProviderFor(watchDiscussions)
final watchDiscussionsProvider =
    AutoDisposeStreamProvider<List<Discussion>>.internal(
  watchDiscussions,
  name: r'watchDiscussionsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$watchDiscussionsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef WatchDiscussionsRef = AutoDisposeStreamProviderRef<List<Discussion>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
