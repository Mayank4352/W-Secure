import 'package:camera/camera.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/camera_providers.g.dart';

/// Overridden in `main()` with the cameras discovered at startup.
@Riverpod(keepAlive: true)
List<CameraDescription> cameras(Ref ref) =>
    throw UnimplementedError('camerasProvider must be overridden in main()');
