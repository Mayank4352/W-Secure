// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../home_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$homeViewModelHash() => r'916969766aeefdb220e7f6b21af7ec35e3d8ff3f';

/// Drives the SOS home actions. State is the current recording flag; the
/// camera controller and emergency timer are internal. Kept alive so an
/// in-progress recording or active emergency survives navigation.
///
/// Copied from [HomeViewModel].
@ProviderFor(HomeViewModel)
final homeViewModelProvider = NotifierProvider<HomeViewModel, bool>.internal(
  HomeViewModel.new,
  name: r'homeViewModelProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$homeViewModelHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$HomeViewModel = Notifier<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
