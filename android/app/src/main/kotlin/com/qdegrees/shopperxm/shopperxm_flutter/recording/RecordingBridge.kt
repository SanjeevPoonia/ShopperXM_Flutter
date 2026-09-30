package com.qdegrees.shopperxm.shopperxm_flutter.recording

import io.flutter.plugin.common.EventChannel

object RecordingBridge : EventChannel.StreamHandler {

    @Volatile
    var isRecording: Boolean = false

    @Volatile
    var isStopping: Boolean = false

    private var eventSink: EventChannel.EventSink? = null

    override fun onListen(
        arguments: Any?,
        events: EventChannel.EventSink?
    ) {
        eventSink = events

        sendEvent(
            mapOf(
                "type" to when {
                    isStopping -> "RECORDING_STOPPING"
                    isRecording -> "RECORDING_STARTED"
                    else -> "RECORDING_IDLE"
                }
            )
        )
    }

    override fun onCancel(
        arguments: Any?
    ) {
        eventSink = null
    }

    fun sendEvent(
        event: Map<String, Any?>
    ) {
        eventSink?.success(event)
    }

    fun notifyRecordingStarted(
        fileName: String? = null,
        beatplanId: String? = null,
        storeId: String? = null
    ) {

        isRecording = true
        isStopping = false

        sendEvent(
            mapOf(
                "type" to "RECORDING_STARTED",
                "file_name" to fileName,
                "beatplan_id" to beatplanId,
                "store_id" to storeId
            )
        )
    }

    fun notifyRecordingStopping() {

        isStopping = true

        sendEvent(
            mapOf(
                "type" to "RECORDING_STOPPING"
            )
        )
    }

    fun notifyRecordingStopped(
        fileName: String?,
        uri: String?,
        path: String?,
        beatplanId: String?,
        storeId: String?
    ) {

        isRecording = false
        isStopping = false

        sendEvent(
            mapOf(
                "type" to "RECORDING_STOPPED",
                "file_name" to fileName,
                "uri" to uri,
                "path" to path,
                "beatplan_id" to beatplanId,
                "store_id" to storeId
            )
        )
    }

    fun sendError(
        code: String,
        message: String
    ) {

        isRecording = false
        isStopping = false

        sendEvent(
            mapOf(
                "type" to "RECORDING_ERROR",
                "code" to code,
                "message" to message
            )
        )
    }
}