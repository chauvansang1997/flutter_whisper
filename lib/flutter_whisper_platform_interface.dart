import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_whisper_method_channel.dart';

abstract class FlutterWhisperPlatform extends PlatformInterface {
  /// Constructs a FlutterWhisperPlatform.
  FlutterWhisperPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterWhisperPlatform _instance = MethodChannelFlutterWhisper();

  /// The default instance of [FlutterWhisperPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterWhisper].
  static FlutterWhisperPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterWhisperPlatform] when
  /// they register themselves.
  static set instance(FlutterWhisperPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
