import 'package:url_launcher/url_launcher.dart';

import '../error/app_exception.dart';

Future<void> launchDirections({
  required double latitude,
  required double longitude,
}) async {
  final uri = Uri.https('www.google.com', '/maps/dir/', {
    'api': '1',
    'destination': '$latitude,$longitude',
  });
  final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
  if (!launched) {
    throw const AppException('Could not open a maps app.');
  }
}
