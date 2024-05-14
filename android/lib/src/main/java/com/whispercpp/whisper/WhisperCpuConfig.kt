package com.whispercpp.whisper


object WhisperCpuConfig {
    val preferredThreadCount: Int
        // Always use at least 2 threads:
        get() = CpuInfo.getHighPerfCpuCount().coerceAtLeast(2)
}

