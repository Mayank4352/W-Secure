import 'dart:async';
import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:location/location.dart' as loc;
import 'package:permission_handler/permission_handler.dart' as perm;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:share_plus/share_plus.dart';
import 'package:telephony/telephony.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/error/app_exception.dart';
import '../../../core/providers/camera_providers.dart';
import '../../../core/providers/firebase_providers.dart';
import '../../../core/services/location_service.dart';

part 'generated/home_view_model.g.dart';

/// Drives the SOS home actions. State is the current recording flag; the
/// camera controller and emergency timer are internal. Kept alive so an
/// in-progress recording or active emergency survives navigation.
@Riverpod(keepAlive: true)
class HomeViewModel extends _$HomeViewModel {
  CameraController? _camera;
  Timer? _emergencyTimer;

  @override
  bool build() {
    ref.onDispose(() {
      _emergencyTimer?.cancel();
      _camera?.dispose();
    });
    return false;
  }

  Future<void> makeEmergencyCall() async {
    final launched = await launchUrl(Uri(scheme: 'tel', path: '1091'));
    if (!launched) throw const AppException('Could not place the call.');
  }

  Future<void> shareLocation() async {
    final position = await ref.read(locationServiceProvider).currentPosition();
    final mapsUrl =
        'https://www.google.com/maps?q=${position.latitude},${position.longitude}';
    final whatsapp =
        Uri.parse('whatsapp://send?text=My current location: $mapsUrl');
    if (await canLaunchUrl(whatsapp)) {
      await launchUrl(whatsapp);
    } else {
      await Share.share('My current location: $mapsUrl');
    }
  }

  Future<void> toggleRecording() async {
    final camera = await perm.Permission.camera.request();
    final microphone = await perm.Permission.microphone.request();
    if (!camera.isGranted || !microphone.isGranted) {
      throw const AppException(
          'Camera and microphone permissions are required.');
    }

    await _ensureCamera();
    if (state) {
      await _camera!.stopVideoRecording();
      state = false;
    } else {
      await _camera!.startVideoRecording();
      state = true;
    }
  }

  Future<void> activateEmergencyMode() async {
    final location = loc.Location();
    if (!await location.serviceEnabled() && !await location.requestService()) {
      throw const AppException('Location services are disabled.');
    }
    var permission = await location.hasPermission();
    if (permission == loc.PermissionStatus.denied) {
      permission = await location.requestPermission();
    }
    if (permission != loc.PermissionStatus.granted) {
      throw const AppException('Location permission is required.');
    }

    final contact = await _emergencyContact();
    if (contact == null) {
      throw const AppException('No emergency contact found.');
    }

    _emergencyTimer = Timer.periodic(const Duration(seconds: 30), (_) async {
      final data = await location.getLocation();
      final message = 'Emergency! My live location is: '
          'https://www.google.com/maps?q=${data.latitude},${data.longitude}';
      try {
        await Telephony.instance.sendSms(to: contact, message: message);
        log('Location sent: $message');
      } catch (e) {
        log('Failed to send location: $e');
      }
    });
  }

  void stopEmergencyMode() {
    _emergencyTimer?.cancel();
    _emergencyTimer = null;
  }

  Future<void> _ensureCamera() async {
    if (_camera?.value.isInitialized ?? false) return;
    final cameras = ref.read(camerasProvider);
    if (cameras.isEmpty) throw const AppException('No cameras available.');
    _camera = CameraController(
      cameras.first,
      ResolutionPreset.high,
      enableAudio: true,
    );
    await _camera!.initialize();
  }

  Future<String?> _emergencyContact() async {
    final user = ref.read(firebaseAuthProvider).currentUser;
    if (user == null) return null;
    final doc = await ref
        .read(firestoreProvider)
        .collection('users')
        .doc(user.uid)
        .get();
    return doc.data()?['emergencyContact'] as String?;
  }
}
