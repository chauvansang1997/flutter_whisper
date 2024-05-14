import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

import 'package:flutter_whisper/flutter_whisper.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _flutterWhisperPlugin = FlutterWhisper();
  String _transcript = '';
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    _flutterWhisperPlugin.loadModel(modelPath: 'assets/models/ggml-base.bin');
    final audioPath = await saveAssetToCache('assets/samples/jfk.wav');

    // _flutterWhisperPlugin
    //     .detectLanguageAudio(audioPath: audioPath)
    //     .then((language) {
    //   final languageCode = language?.languageCode;
    //   final languageName = language?.languageName;

    //   print('languageCode1: $languageCode, languageName1: $languageName');
    // });

    final language =
        await _flutterWhisperPlugin.detectLanguageAudio(audioPath: audioPath);
    final languageCode = language?.languageCode;
    final languageName = language?.languageName;

    print('languageCode: $languageCode, languageName: $languageName');

    if (languageCode == null) {
      return;
    }

    _transcript = await _flutterWhisperPlugin.transcribeAudio(
            audioPath: audioPath, language: languageCode) ??
        '';

    setState(() {});
    // if (!mounted) return;
  }

  Future<String> saveAssetToCache(String assetPath) async {
    try {
      // Get the directory for the cache
      Directory cacheDir = await getTemporaryDirectory();

      // Create a File instance for the destination file in the cache directory
      File destFile = File('${cacheDir.path}/jfk.wav');

      // Open the asset file
      ByteData data = await rootBundle.load(assetPath);
      List<int> bytes = data.buffer.asUint8List();

      // Write the asset data to the destination file
      await destFile.writeAsBytes(bytes);

      print('Asset saved to cache: ${destFile.path}');

      return destFile.path;
    } catch (e) {
      print('Failed to save asset to cache: $e');

      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Stack(
          children: [
            Center(
              child: Text('Running on: \n $_transcript'),
            ),
            if (_transcript.isEmpty)
              const Center(child: CircularProgressIndicator())
          ],
        ),
      ),
    );
  }
}
