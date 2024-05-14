package com.plugin.whisper.flutter_whisper

import android.app.Activity
import android.content.Context
import android.content.res.AssetManager
import android.util.Log
import androidx.annotation.NonNull
import io.flutter.embedding.engine.loader.FlutterLoader

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.view.FlutterMain
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch
import java.io.File

/** FlutterWhisperPlugin */
class FlutterWhisperPlugin : FlutterPlugin, MethodCallHandler,
    ActivityAware {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private var assetManager: AssetManager? = null

    //    private var audioRecognitionChannel: EventChannel? = null
    private var applicationContext: Context? = null
    private var activity: Activity? = null
    private var whisperService: WhisperService? = null
    private var events: EventChannel.EventSink? = null
//    private val _mainScope = CoroutineScope(Dispatchers.Main)

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        onAttachedToEngine(
            flutterPluginBinding.applicationContext,
            flutterPluginBinding.binaryMessenger
        )
//    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_whisper")
//    channel.setMethodCallHandler(this)
    }

    private fun onAttachedToEngine(applicationContext: Context, messenger: BinaryMessenger) {
        this.applicationContext = applicationContext
        assetManager = applicationContext.assets
        channel = MethodChannel(messenger, "flutter_whisper")
        channel.setMethodCallHandler(this)

//        audioRecognitionChannel = EventChannel(messenger, "AudioRecognitionStream")
//        audioRecognitionChannel?.setStreamHandler(this)

    }
//  override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
//    onAttachedToEngine(binding.applicationContext, binding.binaryMessenger)
//  }


    override fun onMethodCall(call: MethodCall, result: Result) {
        val arguments = call.arguments as HashMap<*, *>
        when (call.method) {
            "loadModel" -> {
                val modelPath = arguments["modelPath"] as String? ?: return
                applicationContext?.let {
                    whisperService = WhisperService(it)
                    val key = FlutterMain.getLookupKeyForAsset(modelPath)
                    whisperService?.loadModel(key)
                }

                result.success(null)
            }

            "detectLanguage" -> {
                val audioPath = arguments["audioPath"] as String? ?: return

                activity?.run {
                    val languageCombine = whisperService?.detectLanguageAudio(File(audioPath))
                    val combines = languageCombine?.split(",")

                    if(combines.isNullOrEmpty()){
                        result.success(null)
                        return@run
                    }

                    this.runOnUiThread {
                        result.success(mapOf(
                            "languageCode" to combines.first(),
                            "languageName" to combines.last()
                        ))
                    }
                }

            }

            "transcribeAudio" -> {
                val audioPath = arguments["audioPath"] as String? ?: return
                val language = arguments["language"] as String?

                activity?.run {
                    val text = whisperService?.transcribeAudio(File(audioPath), language)

                    this.runOnUiThread {
                        result.success(text)
                    }
                }
            }
        }

//        if (call.method == "getPlatformVersion") {
//            result.success("Android ${android.os.Build.VERSION.RELEASE}")
//        } else {
//            result.notImplemented()
//        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
//
//    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
//        val arguments = arguments as HashMap<*, *>
//        this.events = events
//        Log.d(
//            LOG_TAG,
//            "Parameters: $arguments"
//        )
//        when (arguments["method"] as String?) {
//            "setAudioRecognitionStream" -> {
//
//            }
//
//            "setFileRecognitionStream" -> {
//
//            }
//
//            else -> throw AssertionError("Error with listening to stream.")
//        }
//
//    }
//
//    override fun onCancel(arguments: Any?) {
//        TODO("Not yet implemented")
//    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivity() {
        activity = null
    }

    companion object {
        // ui elements
        private const val LOG_TAG = "FlutterWhisper"
        private const val REQUEST_RECORD_AUDIO = 13
        private const val REQUEST_READ_EXTERNAL_STORAGE = 1
//        private var instance: TfliteAudioPlugin

        // Used to extract raw audio data
        // private MediaCodec mediaCodec;
        // MediaCodec.BufferInfo bufferInfo = new MediaCodec.BufferInfo();

    }
}
