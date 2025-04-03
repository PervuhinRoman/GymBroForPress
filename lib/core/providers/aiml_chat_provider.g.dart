// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'aiml_chat_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$aimlApiServiceHash() => r'56f372f63e8c3aa553d0e525feb3a1c116b11579';

/// See also [aimlApiService].
@ProviderFor(aimlApiService)
final aimlApiServiceProvider = Provider<AimlApiService>.internal(
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
typedef AimlApiServiceRef = ProviderRef<AimlApiService>;
String _$chatTypingHash() => r'c4a9755fbfd3152c21065ec362a62978e3f539db';

/// See also [ChatTyping].
@ProviderFor(ChatTyping)
final chatTypingProvider = NotifierProvider<ChatTyping, bool>.internal(
  ChatTyping.new,
  name: r'chatTypingProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$chatTypingHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ChatTyping = Notifier<bool>;
String _$aimlChatMessagesHash() => r'e6038314ff86c36106a10913e3e75420fd8e7b42';

/// See also [AimlChatMessages].
@ProviderFor(AimlChatMessages)
final aimlChatMessagesProvider =
    NotifierProvider<AimlChatMessages, List<types.Message>>.internal(
  AimlChatMessages.new,
  name: r'aimlChatMessagesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$aimlChatMessagesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AimlChatMessages = Notifier<List<types.Message>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
