// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'aiml_chat_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$aimlApiServiceHash() => r'1a515e3dc5dd08a2e0a82cead039ab7563d60b0b';

/// See also [aimlApiService].
@ProviderFor(aimlApiService)
final aimlApiServiceProvider = AutoDisposeProvider<AimlApiService>.internal(
  aimlApiService,
  name: r'aimlApiServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$aimlApiServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AimlApiServiceRef = AutoDisposeProviderRef<AimlApiService>;
String _$chatTypingHash() => r'a3bf4660eff948d50e1c35322674dbde844dc7d8';

/// See also [ChatTyping].
@ProviderFor(ChatTyping)
final chatTypingProvider =
    AutoDisposeNotifierProvider<ChatTyping, bool>.internal(
  ChatTyping.new,
  name: r'chatTypingProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$chatTypingHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ChatTyping = AutoDisposeNotifier<bool>;
String _$aimlChatMessagesHash() => r'7d82de2da6c3fd39f4c2d988674c40c0e2d4bb63';

/// See also [AimlChatMessages].
@ProviderFor(AimlChatMessages)
final aimlChatMessagesProvider =
    AutoDisposeNotifierProvider<AimlChatMessages, List<types.Message>>.internal(
  AimlChatMessages.new,
  name: r'aimlChatMessagesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$aimlChatMessagesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AimlChatMessages = AutoDisposeNotifier<List<types.Message>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
