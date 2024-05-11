
import 'flutter_whisper_platform_interface.dart';

class FlutterWhisper {
  Future<String?> getPlatformVersion() {
    return FlutterWhisperPlatform.instance.getPlatformVersion();
  }
}
