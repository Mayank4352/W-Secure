// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../safe_spots_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$safeSpotsViewModelHash() =>
    r'ff0d541afe68b97e8cfdc5620574b9ed96ca8edd';

/// Kept alive for the life of the app so navigating away and back does not
/// cost a fresh GPS fix. The lookup itself is cached on disk and only re-runs
/// once the user has moved more than a kilometre; pull to refresh overrides
/// that and always re-queries.
///
/// Copied from [SafeSpotsViewModel].
@ProviderFor(SafeSpotsViewModel)
final safeSpotsViewModelProvider =
    AsyncNotifierProvider<SafeSpotsViewModel, List<SafeSpot>>.internal(
  SafeSpotsViewModel.new,
  name: r'safeSpotsViewModelProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$safeSpotsViewModelHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SafeSpotsViewModel = AsyncNotifier<List<SafeSpot>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
