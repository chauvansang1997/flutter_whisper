import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_whisper/models/whisper_language.dart';

import 'flutter_whisper_platform_interface.dart';

/// An implementation of [FlutterWhisperPlatform] that uses method channels.
class MethodChannelFlutterWhisper extends FlutterWhisperPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_whisper');

  ///initialize [loadModel] before calling any other streams and futures.
  @override
  Future<void> loadModel({
    required String modelPath,
    bool isAsset = true,
  }) async {
    return methodChannel.invokeMethod(
      'loadModel',
      {
        'modelPath': modelPath,
        'isAsset': isAsset,
      },
    );
  }

  @override
  Future<WhisperLanguage?> detectLanguageAudio(
      {required String audioPath}) async {
    final data = await methodChannel
        .invokeMethod('detectLanguage', {'audioPath': audioPath});

    if (data is! Map) {
      return null;
    }
    return WhisperLanguage.fromMap(Map<String, dynamic>.from(data));
  }

  @override
  Future<String?> transcribeAudio(
      {required String audioPath, String? language}) {
    return methodChannel.invokeMethod('transcribeAudio', {
      'audioPath': audioPath,
      'language': language,
    });
  }
}
