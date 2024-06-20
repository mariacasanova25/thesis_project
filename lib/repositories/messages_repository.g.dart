// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'messages_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$messagesRepositoryHash() =>
    r'd5e8bfb02a3f3dac5117e72c00124b8644bbedcf';

/// See also [messagesRepository].
@ProviderFor(messagesRepository)
final messagesRepositoryProvider =
    AutoDisposeProvider<MessagesRepository>.internal(
  messagesRepository,
  name: r'messagesRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$messagesRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef MessagesRepositoryRef = AutoDisposeProviderRef<MessagesRepository>;
String _$watchMessagesHash() => r'8a8c10391bfb02a5d9e4226019727c0490ed349f';

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

/// See also [watchMessages].
@ProviderFor(watchMessages)
const watchMessagesProvider = WatchMessagesFamily();

/// See also [watchMessages].
class WatchMessagesFamily extends Family<AsyncValue<List<Message>>> {
  /// See also [watchMessages].
  const WatchMessagesFamily();

  /// See also [watchMessages].
  WatchMessagesProvider call(
    String discussionId,
  ) {
    return WatchMessagesProvider(
      discussionId,
    );
  }

  @override
  WatchMessagesProvider getProviderOverride(
    covariant WatchMessagesProvider provider,
  ) {
    return call(
      provider.discussionId,
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
  String? get name => r'watchMessagesProvider';
}

/// See also [watchMessages].
class WatchMessagesProvider extends AutoDisposeStreamProvider<List<Message>> {
  /// See also [watchMessages].
  WatchMessagesProvider(
    String discussionId,
  ) : this._internal(
          (ref) => watchMessages(
            ref as WatchMessagesRef,
            discussionId,
          ),
          from: watchMessagesProvider,
          name: r'watchMessagesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$watchMessagesHash,
          dependencies: WatchMessagesFamily._dependencies,
          allTransitiveDependencies:
              WatchMessagesFamily._allTransitiveDependencies,
          discussionId: discussionId,
        );

  WatchMessagesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.discussionId,
  }) : super.internal();

  final String discussionId;

  @override
  Override overrideWith(
    Stream<List<Message>> Function(WatchMessagesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: WatchMessagesProvider._internal(
        (ref) => create(ref as WatchMessagesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        discussionId: discussionId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<Message>> createElement() {
    return _WatchMessagesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is WatchMessagesProvider && other.discussionId == discussionId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, discussionId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin WatchMessagesRef on AutoDisposeStreamProviderRef<List<Message>> {
  /// The parameter `discussionId` of this provider.
  String get discussionId;
}

class _WatchMessagesProviderElement
    extends AutoDisposeStreamProviderElement<List<Message>>
    with WatchMessagesRef {
  _WatchMessagesProviderElement(super.provider);

  @override
  String get discussionId => (origin as WatchMessagesProvider).discussionId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
