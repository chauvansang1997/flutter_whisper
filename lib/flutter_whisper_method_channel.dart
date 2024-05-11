import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_whisper_platform_interface.dart';

/// An implementation of [FlutterWhisperPlatform] that uses method channels.
class MethodChannelFlutterWhisper extends FlutterWhisperPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_whisper');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
