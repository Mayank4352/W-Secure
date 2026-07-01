import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/data/asset_json.dart';
import '../../../core/error/app_exception.dart';
import '../../../core/providers/firebase_providers.dart';
import '../model/nearby_alert.dart';

part 'generated/alerts_repository.g.dart';

class AlertsRepository {
  AlertsRepository({
    required AssetBundle bundle,
    required FirebaseAuth auth,
    required FirebaseFirestore firestore,
  })  : _bundle = bundle,
        _auth = auth,
        _firestore = firestore;

  final AssetBundle _bundle;
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  // Static seed data; will be replaced by a live API once access is granted.
  Future<List<NearbyAlert>> fetchNearby() async {
    final rows = await loadJsonArray(_bundle, 'assets/data/nearby_alerts.json');
    return rows.map(NearbyAlert.fromJson).toList();
  }

  Future<void> saveAlert({
    required String location,
    required String timeFrom,
    required String timeTo,
    required String message,
  }) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw const AppException('You must be signed in to post an alert.');
    }

    final response = await http.get(
      Uri.parse(
        'https://nominatim.openstreetmap.org/search'
        '?q=${Uri.encodeComponent(location)}&format=json&limit=1',
      ),
      headers: {'User-Agent': 'w_secure_app/1.0'},
    );
    if (response.statusCode != 200) {
      throw const AppException('Could not resolve that location.');
    }

    final results = json.decode(response.body) as List<dynamic>;
    if (results.isEmpty) {
      throw const AppException('No results found for that location.');
    }

    final match = results.first as Map<String, dynamic>;
    await _firestore.collection('alerts').doc(user.uid).set({
      'Location': GeoPoint(
        double.parse(match['lat'] as String),
        double.parse(match['lon'] as String),
      ),
      'TimeFrom': Timestamp.fromDate(DateTime.parse(timeFrom)),
      'TimeTo': Timestamp.fromDate(DateTime.parse(timeTo)),
      'Message': message,
    }, SetOptions(merge: true));
  }
}

@riverpod
AlertsRepository alertsRepository(Ref ref) => AlertsRepository(
      bundle: rootBundle,
      auth: ref.watch(firebaseAuthProvider),
      firestore: ref.watch(firestoreProvider),
    );
