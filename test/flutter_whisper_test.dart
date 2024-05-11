import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_whisper/flutter_whisper.dart';
import 'package:flutter_whisper/flutter_whisper_platform_interface.dart';
import 'package:flutter_whisper/flutter_whisper_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterWhisperPlatform
    with MockPlatformInterfaceMixin
    implements FlutterWhisperPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlutterWhisperPlatform initialPlatform = FlutterWhisperPlatform.instance;

  test('$MethodChannelFlutterWhisper is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterWhisper>());
  });

  test('getPlatformVersion', () async {
    FlutterWhisper flutterWhisperPlugin = FlutterWhisper();
    MockFlutterWhisperPlatform fakePlatform = MockFlutterWhisperPlatform();
    FlutterWhisperPlatform.instance = fakePlatform;

    expect(await flutterWhisperPlugin.getPlatformVersion(), '42');
  });
}
