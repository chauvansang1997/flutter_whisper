package com.plugin.whisper.flutter_whisper

import android.app.Application
import android.content.Context
import org.intellij.lang.annotations.Language
import java.io.File

class WhisperService(private val applicationContext: Context) {
    private var whisperContext: com.whispercpp.whisper.WhisperContext? = null
    private val modelsPath = File(applicationContext.filesDir, "models")
    private var canTranscribe = false

    private val samplesPath = File(applicationContext.filesDir, "samples")
    fun loadModel(assetPath: String) {
        whisperContext = com.whispercpp.whisper.WhisperContext.createContextFromAsset(
            applicationContext.assets,
            assetPath
        )
        canTranscribe = true
    }

    fun transcribeAudio(file: File, language: String?): String? {
        if (!canTranscribe) {
            return null
        }

        canTranscribe = false

        try {
            val data = decodeWaveFile(file)

//            val start = System.currentTimeMillis()

            val text = if (language == null)
                whisperContext?.transcribeData(data)
            else
                whisperContext?.transcribeDataWithLanguage(data, language)

//            val elapsed = System.currentTimeMillis() - start
            canTranscribe = true
            return text
        } catch (e: Exception) {
//            Log.w(LOG_TAG, e)
//            printMessage("${e.localizedMessage}\n")
        }

        canTranscribe = true

        return null

    }

    fun detectLanguageAudio(file: File): String? {
        if (!canTranscribe) {
            return null
        }

        canTranscribe = false

        try {
            val data = decodeWaveFile(file)

//            val start = System.currentTimeMillis()
            val text = whisperContext?.detectLanguage(data)
//            val elapsed = System.currentTimeMillis() - start
            canTranscribe = true
            return text
        } catch (e: Exception) {
//            Log.w(LOG_TAG, e)
//            printMessage("${e.localizedMessage}\n")
        }

        canTranscribe = true

        return null

    }

}