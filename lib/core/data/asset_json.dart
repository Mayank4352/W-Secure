import 'dart:convert';

import 'package:flutter/services.dart';

/// Loads a bundled JSON array, with a short delay that mimics a remote
/// round-trip so callers can model these sources as asynchronous fetches.
Future<List<Map<String, dynamic>>> loadJsonArray(
  AssetBundle bundle,
  String path,
) async {
  await Future<void>.delayed(const Duration(milliseconds: 400));
  final raw = await bundle.loadString(path);
  return (json.decode(raw) as List<dynamic>).cast<Map<String, dynamic>>();
}
