// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$userRepositoryHash() => r'169689c85de76a465e0d278ceedc030b578cb990';

/// See also [userRepository].
@ProviderFor(userRepository)
final userRepositoryProvider = AutoDisposeProvider<UserRepository>.internal(
  userRepository,
  name: r'userRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$userRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef UserRepositoryRef = AutoDisposeProviderRef<UserRepository>;
String _$watchUserHash() => r'6e14d77bee30054ffc8d886dcd4efdedc0490d2d';

/// See also [watchUser].
@ProviderFor(watchUser)
final watchUserProvider = AutoDisposeStreamProvider<UserData>.internal(
  watchUser,
  name: r'watchUserProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$watchUserHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef WatchUserRef = AutoDisposeStreamProviderRef<UserData>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
