package com.qdegrees.shopperxm.shopperxm_flutter

import android.content.Intent
import android.os.Build
import android.util.Log

import androidx.annotation.NonNull

import com.qdegrees.shopperxm.shopperxm_flutter.recording.RecordingBridge

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

import com.qdegrees.shopperxm.shopperxm_flutter.recording.VideoRecordingService
import com.qdegrees.shopperxm.shopperxm_flutter.recording.AudioRecordingService


class MainActivity : FlutterActivity() {

    companion object {

        private const val TAG =
            "ShopperXM_MainActivity"

        private const val METHOD_CHANNEL =
            "retailiq/recording"

        private const val EVENT_CHANNEL =
            "retailiq/recording_events"

        private const val AUDIO_CHANNEL =
            "com.qdegrees.shopperxm/audio_recording"
    }


    // ============================================================
    // Flutter Engine
    // ============================================================

    override fun configureFlutterEngine(
        @NonNull flutterEngine: FlutterEngine
    ) {

        super.configureFlutterEngine(
            flutterEngine
        )


        // ========================================================
        // MethodChannel
        // ========================================================

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            METHOD_CHANNEL
        ).setMethodCallHandler { call, result ->

            when (call.method) {

                // ------------------------------------------------
                // START
                // ------------------------------------------------

                "startRecording" -> {

                    try {

                        val userId =
                            call.argument<String>(
                                "user_id"
                            ).orEmpty()

                        val storeId =
                            call.argument<String>(
                                "store_id"
                            ).orEmpty()

                        val beatplanId =
                            call.argument<String>(
                                "beatplan_id"
                            ).orEmpty()

                        val authKey =
                            call.argument<String>(
                                "authKey"
                            ).orEmpty()

                        val fileName =
                            call.argument<String>(
                                "file_name"
                            ).orEmpty()

                        val quality =
                            call.argument<String>(
                                "quality"
                            ) ?: "Low"

                        val camera =
                            call.argument<Int>(
                                "camera"
                            ) ?: 1


                        // ----------------------------------------
                        // Validation
                        // ----------------------------------------

                        if (userId.isBlank()) {

                            result.error(
                                "INVALID_USER_ID",
                                "user_id is required.",
                                null
                            )

                            return@setMethodCallHandler
                        }

                        if (storeId.isBlank()) {

                            result.error(
                                "INVALID_STORE_ID",
                                "store_id is required.",
                                null
                            )

                            return@setMethodCallHandler
                        }

                        if (beatplanId.isBlank()) {

                            result.error(
                                "INVALID_BEATPLAN_ID",
                                "beatplan_id is required.",
                                null
                            )

                            return@setMethodCallHandler
                        }

                        if (authKey.isBlank()) {

                            result.error(
                                "INVALID_AUTH_KEY",
                                "authKey is required.",
                                null
                            )

                            return@setMethodCallHandler
                        }

                        if (fileName.isBlank()) {

                            result.error(
                                "INVALID_FILE_NAME",
                                "file_name is required.",
                                null
                            )

                            return@setMethodCallHandler
                        }


                        // ----------------------------------------
                        // Prevent duplicate recording
                        // ----------------------------------------

                        if (RecordingBridge.isRecording) {

                            result.error(
                                "ALREADY_RECORDING",
                                "A recording is already active.",
                                null
                            )

                            return@setMethodCallHandler
                        }


                        startNativeRecording(
                            userId = userId,
                            storeId = storeId,
                            beatplanId = beatplanId,
                            authKey = authKey,
                            fileName = fileName,
                            quality = quality,
                            camera = camera
                        )

                        result.success(true)

                    } catch (e: Exception) {

                        Log.e(
                            TAG,
                            "Unable to start recording",
                            e
                        )

                        result.error(
                            "START_RECORDING_ERROR",
                            e.message
                                ?: "Unable to start recording.",
                            null
                        )
                    }
                }


                // ------------------------------------------------
                // STOP
                // ------------------------------------------------

                "stopRecording" -> {

                    try {

                        if (!RecordingBridge.isRecording) {

                            result.error(
                                "NOT_RECORDING",
                                "No active recording found.",
                                null
                            )

                            return@setMethodCallHandler
                        }

                        stopNativeRecording()

                        result.success(true)

                    } catch (e: Exception) {

                        Log.e(
                            TAG,
                            "Unable to stop recording",
                            e
                        )

                        result.error(
                            "STOP_RECORDING_ERROR",
                            e.message
                                ?: "Unable to stop recording.",
                            null
                        )
                    }
                }


                // ------------------------------------------------
                // IS RECORDING
                // ------------------------------------------------

                "isRecording" -> {

                    result.success(
                        RecordingBridge.isRecording
                    )
                }


                // ------------------------------------------------
                // UNKNOWN
                // ------------------------------------------------

                else -> {

                    result.notImplemented()
                }
            }
        }

        // ========================================================
        // Audio Recording MethodChannel
        // ========================================================

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            AUDIO_CHANNEL
        ).setMethodCallHandler { call, result ->

            when (call.method) {

                // ------------------------------------------------
                // START AUDIO RECORDING
                // ------------------------------------------------

                "startAudioRecording" -> {
                    try {

                        val auditId =
                            call.argument<String>("audit_id")

                        val storeCode =
                            call.argument<String>("store_code")

                        if (storeCode.isNullOrBlank()) {

                            result.error(
                                "INVALID_STORE_CODE",
                                "Store code is required to start audio recording.",
                                null
                            )

                            return@setMethodCallHandler
                        }

                        if (AudioRecordingService.isRecording(this)) {

                            result.error(
                                "AUDIO_ALREADY_RECORDING",
                                "Audio recording is already in progress.",
                                null
                            )

                            return@setMethodCallHandler
                        }

                        val intent =
                            Intent(
                                this,
                                AudioRecordingService::class.java
                            ).apply {

                                action =
                                    AudioRecordingService.ACTION_START

                                putExtra(
                                    AudioRecordingService.EXTRA_AUDIT_ID,
                                    auditId
                                )

                                putExtra(
                                    AudioRecordingService.EXTRA_STORE_CODE,
                                    storeCode
                                )
                            }

                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {

                            startForegroundService(intent)

                        } else {

                            startService(intent)
                        }

                        Log.d(
                            TAG,
                            "Audio recording start requested"
                        )

                        Log.d(
                            TAG,
                            "Audit ID: $auditId"
                        )

                        Log.d(
                            TAG,
                            "Store Code: $storeCode"
                        )

                        result.success(true)

                    } catch (e: Exception) {

                        Log.e(
                            TAG,
                            "Unable to start audio recording",
                            e
                        )

                        result.error(
                            "START_AUDIO_RECORDING_ERROR",
                            e.message
                                ?: "Unable to start audio recording.",
                            null
                        )
                    }
                }


                // ------------------------------------------------
                // STOP AUDIO RECORDING
                // ------------------------------------------------

                "stopAudioRecording" -> {

                    try {

                        if (
                            !AudioRecordingService.isRecording(
                                this
                            )
                        ) {

                            result.error(
                                "AUDIO_NOT_RECORDING",
                                "No active audio recording found.",
                                null
                            )

                            return@setMethodCallHandler
                        }

                        val intent = Intent(
                            this,
                            AudioRecordingService::class.java
                        )

                        intent.action =
                            AudioRecordingService.ACTION_STOP

                        // Recording service is already running.
                        // Send STOP action to the existing service.
                        startService(intent)

                        result.success(true)

                    } catch (e: Exception) {

                        Log.e(
                            TAG,
                            "Unable to stop audio recording",
                            e
                        )

                        result.error(
                            "STOP_AUDIO_RECORDING_ERROR",
                            e.message
                                ?: "Unable to stop audio recording.",
                            null
                        )
                    }
                }


                // ------------------------------------------------
                // IS AUDIO RECORDING
                // ------------------------------------------------

                "isAudioRecording" -> {

                    result.success(
                        AudioRecordingService.isRecording(
                            this
                        )
                    )
                }


                // ------------------------------------------------
                // GET AUDIO FILE PATH
                // ------------------------------------------------

                "getAudioRecordingFilePath" -> {

                    result.success(
                        AudioRecordingService
                            .getRecordingFilePath(this)
                    )
                }

                //----------------------------------------------
                // GET AUDIO FILE URI
                //----------------------------------------------
                "getAudioRecordingFileUri" -> {
                    result.success(
                        AudioRecordingService.getRecordingFileUri(this)
                    )
                }


                // ------------------------------------------------
                // GET AUDIO AUDIT ID
                // ------------------------------------------------

                "getAudioRecordingAuditId" -> {

                    result.success(
                        AudioRecordingService
                            .getAuditId(this)
                    )
                }
                // ------------------------------------------------
                // GET AUDIO AUDIT STORE CODE
                // ------------------------------------------------

                "getAudioRecordingStoreCode" -> {
                    result.success(
                        AudioRecordingService.getStoreCode(this)
                    )
                }


                // ------------------------------------------------
                // UNKNOWN
                // ------------------------------------------------

                else -> {

                    result.notImplemented()
                }
            }
        }


        // ========================================================
        // EventChannel
        // ========================================================

        EventChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            EVENT_CHANNEL
        ).setStreamHandler(
            RecordingBridge
        )
    }


    // ============================================================
    // Start Native Recording
    // ============================================================

    private fun startNativeRecording(
        userId: String,
        storeId: String,
        beatplanId: String,
        authKey: String,
        fileName: String,
        quality: String,
        camera: Int
    ) {

        val intent = Intent(
            this,
            VideoRecordingService::class.java
        )

        intent.action =
            VideoRecordingService.ACTION_START_RECORDING

        intent.putExtra(
            VideoRecordingService.EXTRA_CAMERA,
            camera
        )

        intent.putExtra(
            VideoRecordingService.EXTRA_BEATPLAN_ID,
            beatplanId
        )

        intent.putExtra(
            VideoRecordingService.EXTRA_FILE_NAME,
            fileName
        )

        intent.putExtra(
            VideoRecordingService.EXTRA_USER_ID,
            userId
        )

        intent.putExtra(
            VideoRecordingService.EXTRA_STORE_ID,
            storeId
        )

        intent.putExtra(
            VideoRecordingService.EXTRA_AUTH_KEY,
            authKey
        )

        intent.putExtra(
            VideoRecordingService.EXTRA_QUALITY,
            quality
        )


        if (
            Build.VERSION.SDK_INT >=
            Build.VERSION_CODES.O
        ) {

            startForegroundService(intent)

        } else {

            startService(intent)
        }
    }

    // ============================================================
    // Stop Native Recording
    // ============================================================

    private fun stopNativeRecording() {

        val intent = Intent(
            this,
            VideoRecordingService::class.java
        )

        intent.action =
            VideoRecordingService.ACTION_STOP_RECORDING


        if (
            Build.VERSION.SDK_INT >=
            Build.VERSION_CODES.O
        ) {

            startForegroundService(intent)

        } else {

            startService(intent)
        }
    }
}