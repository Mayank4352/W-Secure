// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../http_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$httpClientHash() => r'7ec49beae0f15115de79f9aa98dbd250130e26d8';

/// One client for the whole app so connections are reused across requests.
///
/// Copied from [httpClient].
@ProviderFor(httpClient)
final httpClientProvider = Provider<http.Client>.internal(
  httpClient,
  name: r'httpClientProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$httpClientHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef HttpClientRef = ProviderRef<http.Client>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
