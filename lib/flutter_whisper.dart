import 'package:flutter_whisper/models/whisper_language.dart';
import 'flutter_whisper_platform_interface.dart';
export 'models/whisper_language.dart';

class FlutterWhisper {
  Future<void> loadModel({required String modelPath, bool isAsset = true}) {
    return FlutterWhisperPlatform.instance
        .loadModel(modelPath: modelPath, isAsset: isAsset);
  }

  Future<WhisperLanguage?> detectLanguageAudio({required String audioPath}) {
    return FlutterWhisperPlatform.instance
        .detectLanguageAudio(audioPath: audioPath);
  }

  Future<String?> transcribeAudio(
      {required String audioPath, String? language}) {
    return FlutterWhisperPlatform.instance
        .transcribeAudio(audioPath: audioPath, language: language);
  }
}
