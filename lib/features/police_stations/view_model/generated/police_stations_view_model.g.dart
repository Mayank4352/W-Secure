// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../police_stations_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$policeStationsViewModelHash() =>
    r'79290bedc7c08f9ffa2558281a569f9645f17137';

/// Kept alive for the life of the app so navigating away and back does not
/// cost a fresh GPS fix. The lookup itself is cached on disk and only re-runs
/// once the user has moved more than a kilometre; pull to refresh overrides
/// that and always re-queries.
///
/// Copied from [PoliceStationsViewModel].
@ProviderFor(PoliceStationsViewModel)
final policeStationsViewModelProvider = AsyncNotifierProvider<
    PoliceStationsViewModel, List<PoliceStation>>.internal(
  PoliceStationsViewModel.new,
  name: r'policeStationsViewModelProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$policeStationsViewModelHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PoliceStationsViewModel = AsyncNotifier<List<PoliceStation>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
