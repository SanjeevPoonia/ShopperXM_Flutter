package com.qdegrees.shopperxm.shopperxm_flutter.recording

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service.START_STICKY
import android.app.Service.STOP_FOREGROUND_REMOVE
import android.content.ContentValues
import android.content.Intent
import android.content.pm.ServiceInfo
import android.media.MediaMetadataRetriever
import android.net.Uri
import android.os.Binder
import android.os.Build
import android.os.IBinder
import android.os.PowerManager
import android.provider.MediaStore
import android.util.Log

import androidx.camera.core.CameraSelector
import androidx.camera.lifecycle.ProcessCameraProvider
import androidx.camera.video.FallbackStrategy
import androidx.camera.video.MediaStoreOutputOptions
import androidx.camera.video.Quality
import androidx.camera.video.QualitySelector
import androidx.camera.video.Recorder
import androidx.camera.video.Recording
import androidx.camera.video.VideoCapture
import androidx.camera.video.VideoRecordEvent

import androidx.core.app.NotificationCompat
import androidx.core.content.ContextCompat
import androidx.lifecycle.LifecycleService

import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale
import java.util.concurrent.ExecutorService
import java.util.concurrent.Executors


class VideoRecordingService : LifecycleService() {

    companion object {

        private const val TAG =
            "VideoRecordingService"

        const val CHANNEL_ID =
            "ShopperXM_VideoRecordingChannel"

        const val NOTIFICATION_ID =
            1001

        const val ACTION_START_RECORDING =
            "com.qdegrees.shopperxm.START_RECORDING"

        const val ACTION_STOP_RECORDING =
            "com.qdegrees.shopperxm.STOP_RECORDING"

        const val EXTRA_BEATPLAN_ID =
            "beatplan_id"

        const val EXTRA_FILE_NAME =
            "file_name"

        const val EXTRA_USER_ID =
            "user_id"

        const val EXTRA_STORE_ID =
            "store_id"

        const val EXTRA_AUTH_KEY =
            "authKey"

        const val EXTRA_CAMERA =
            "button"

        const val EXTRA_QUALITY =
            "quality"

        private const val VIDEO_BITRATE =
            2_000_000

        private const val WAKELOCK_TIMEOUT =
            80 * 60 * 1000L
    }


    // ------------------------------------------------------------
    // Binder
    // ------------------------------------------------------------

    inner class LocalBinder : Binder() {

        fun getService():
                VideoRecordingService {
            return this@VideoRecordingService
        }
    }

    private val binder =
        LocalBinder()


    // ------------------------------------------------------------
    // Camera / Recording
    // ------------------------------------------------------------

    private val cameraExecutor:
            ExecutorService =
        Executors.newSingleThreadExecutor()

    private var videoCapture:
            VideoCapture<Recorder>? = null

    private var currentRecording:
            Recording? = null

    private var cameraProvider:
            ProcessCameraProvider? = null


    // ------------------------------------------------------------
    // WakeLock
    // ------------------------------------------------------------

    private var wakeLock:
            PowerManager.WakeLock? = null


    // ------------------------------------------------------------
    // State
    // ------------------------------------------------------------

    @Volatile
    var isRecording: Boolean = false
        private set

    @Volatile
    private var isStopping: Boolean = false


    // ------------------------------------------------------------
    // Recording Data
    // ------------------------------------------------------------

    private var beatPlanId = ""

    private var storeId = ""

    private var userId = ""

    private var authKey = ""

    private var fileName = ""

    private var quality = "Low"

    private var camera = 1


    // ------------------------------------------------------------
    // MediaStore
    // ------------------------------------------------------------

    private var currentContentValues:
            ContentValues? = null


    // ------------------------------------------------------------
    // Lifecycle
    // ------------------------------------------------------------

    override fun onCreate() {

        super.onCreate()

        Log.d(
            TAG,
            "VideoRecordingService created"
        )

        createNotificationChannel()
    }


    // ------------------------------------------------------------
    // Binder
    // ------------------------------------------------------------

    override fun onBind(
        intent: Intent
    ): IBinder {

        super.onBind(intent)

        return binder
    }


    // ------------------------------------------------------------
    // Start Command
    // ------------------------------------------------------------

    override fun onStartCommand(
        intent: Intent?,
        flags: Int,
        startId: Int
    ): Int {

        super.onStartCommand(
            intent,
            flags,
            startId
        )

        when (intent?.action) {

            ACTION_START_RECORDING -> {

                handleStartRecording(intent)
            }

            ACTION_STOP_RECORDING -> {

                handleStopRecording()
            }

            else -> {

                Log.d(
                    TAG,
                    "Ignoring unknown/null service action"
                )
            }
        }

        return START_STICKY
    }


    // ------------------------------------------------------------
    // Start Recording
    // ------------------------------------------------------------

    private fun handleStartRecording(
        intent: Intent
    ) {

        if (
            isRecording ||
            currentRecording != null
        ) {

            Log.d(
                TAG,
                "Recording already active"
            )

            return
        }

        if (isStopping) {

            Log.d(
                TAG,
                "Service is stopping; ignoring start"
            )

            return
        }


        isStopping = false


        // --------------------------------------------------------
        // Read Intent Data
        // --------------------------------------------------------

        beatPlanId =
            intent.getStringExtra(
                EXTRA_BEATPLAN_ID
            ) ?: ""

        storeId =
            intent.getStringExtra(
                EXTRA_STORE_ID
            ) ?: ""

        userId =
            intent.getStringExtra(
                EXTRA_USER_ID
            ) ?: ""

        authKey =
            intent.getStringExtra(
                EXTRA_AUTH_KEY
            ) ?: ""

        fileName =
            intent.getStringExtra(
                EXTRA_FILE_NAME
            ) ?: ""

        quality =
            intent.getStringExtra(
                EXTRA_QUALITY
            ) ?: "Low"

        camera =
            intent.getIntExtra(
                EXTRA_CAMERA,
                1
            )


        Log.d(
            TAG,
            """
            Starting recording
            beatPlanId=$beatPlanId
            storeId=$storeId
            userId=$userId
            fileName=$fileName
            quality=$quality
            camera=$camera
            """.trimIndent()
        )


        // --------------------------------------------------------
        // Foreground Service
        // --------------------------------------------------------

        startForegroundWithNotification()


        // --------------------------------------------------------
        // WakeLock
        // --------------------------------------------------------

        acquireWakeLock()


        // --------------------------------------------------------
        // CameraX
        // --------------------------------------------------------

        initCameraAndStartRecording()
    }


    // ------------------------------------------------------------
    // Stop Recording
    // ------------------------------------------------------------

    private fun handleStopRecording() {

        Log.d(
            TAG,
            "Stop recording requested"
        )


        if (
            !isRecording &&
            currentRecording == null
        ) {

            Log.d(
                TAG,
                "No active recording"
            )

            stopServiceCompletely()

            return
        }


        stopRecording()
    }


    // ------------------------------------------------------------
    // Foreground Notification
    // ------------------------------------------------------------

    private fun startForegroundWithNotification() {

        val stopIntent =
            Intent(
                this,
                VideoRecordingService::class.java
            ).apply {

                action =
                    ACTION_STOP_RECORDING
            }


        val stopPendingIntent =
            PendingIntent.getService(
                this,
                1002,
                stopIntent,
                PendingIntent.FLAG_UPDATE_CURRENT or
                        PendingIntent.FLAG_IMMUTABLE
            )


        val launchIntent =
            packageManager.getLaunchIntentForPackage(
                packageName
            )


        val openAppPendingIntent =
            launchIntent?.let {

                it.flags =
                    Intent.FLAG_ACTIVITY_SINGLE_TOP or
                            Intent.FLAG_ACTIVITY_CLEAR_TOP

                PendingIntent.getActivity(
                    this,
                    1003,
                    it,
                    PendingIntent.FLAG_UPDATE_CURRENT or
                            PendingIntent.FLAG_IMMUTABLE
                )
            }


        val notificationBuilder =
            NotificationCompat.Builder(
                this,
                CHANNEL_ID
            )
                .setContentTitle(
                    "Recording in Progress"
                )
                .setContentText(
                    "Video is being recorded in background"
                )
                .setSmallIcon(
                    android.R.drawable.ic_menu_camera
                )
                .setOngoing(true)
                .setPriority(
                    NotificationCompat.PRIORITY_HIGH
                )
                .setCategory(
                    NotificationCompat.CATEGORY_SERVICE
                )
                .setVisibility(
                    NotificationCompat.VISIBILITY_PUBLIC
                )
                .addAction(
                    android.R.drawable.ic_menu_close_clear_cancel,
                    "Stop Recording",
                    stopPendingIntent
                )


        if (
            openAppPendingIntent != null
        ) {

            notificationBuilder
                .setContentIntent(
                    openAppPendingIntent
                )
        }


        val notification =
            notificationBuilder.build()


        if (
            Build.VERSION.SDK_INT >=
            Build.VERSION_CODES.Q
        ) {

            startForeground(
                NOTIFICATION_ID,
                notification,
                ServiceInfo.FOREGROUND_SERVICE_TYPE_CAMERA or
                        ServiceInfo.FOREGROUND_SERVICE_TYPE_MICROPHONE
            )

        } else {

            startForeground(
                NOTIFICATION_ID,
                notification
            )
        }
    }


    // ------------------------------------------------------------
    // Notification Channel
    // ------------------------------------------------------------

    private fun createNotificationChannel() {

        if (
            Build.VERSION.SDK_INT <
            Build.VERSION_CODES.O
        ) {

            return
        }


        val channel =
            NotificationChannel(
                CHANNEL_ID,
                "Video Recording",
                NotificationManager.IMPORTANCE_HIGH
            ).apply {

                description =
                    "Shows when ShopperXM is recording video"

                setSound(
                    null,
                    null
                )

                enableVibration(false)

                lockscreenVisibility =
                    Notification.VISIBILITY_PUBLIC
            }


        val manager =
            getSystemService(
                NotificationManager::class.java
            )


        manager.createNotificationChannel(
            channel
        )
    }


    // ------------------------------------------------------------
    // Camera Setup
    // ------------------------------------------------------------

    private fun initCameraAndStartRecording() {

        val cameraProviderFuture =
            ProcessCameraProvider.getInstance(
                applicationContext
            )

        cameraProviderFuture.addListener(
            {

                try {

                    val provider: ProcessCameraProvider =
                        cameraProviderFuture.get()

                    cameraProvider = provider

                    val cameraSelector =
                        getCameraSelector()

                    val qualitySelector =
                        getQualitySelector()

                    val recorder =
                        Recorder.Builder()
                            .setExecutor(cameraExecutor)
                            .setQualitySelector(qualitySelector)
                            .setTargetVideoEncodingBitRate(
                                VIDEO_BITRATE
                            )
                            .build()

                    videoCapture =
                        VideoCapture.withOutput(
                            recorder
                        )

                    provider.unbindAll()

                    provider.bindToLifecycle(
                        this@VideoRecordingService,
                        cameraSelector,
                        videoCapture
                    )

                    Log.d(
                        TAG,
                        "CameraX successfully bound"
                    )

                    startRecordingToMediaStore()

                } catch (e: Exception) {

                    Log.e(
                        TAG,
                        "Camera initialization failed",
                        e
                    )

                    sendRecordingError(
                        "CAMERA_INIT_FAILED",
                        e.message
                            ?: "Camera initialization failed"
                    )

                    stopServiceCompletely()
                }
            },
            ContextCompat.getMainExecutor(
                applicationContext
            )
        )
    }


    // ------------------------------------------------------------
    // Camera Selector
    // ------------------------------------------------------------

    private fun getCameraSelector():
            CameraSelector {

        /*
         * IMPORTANT:
         *
         * Keep this mapping consistent with
         * the value sent from Flutter.
         *
         * Current mapping:
         *
         * camera = 1 -> rear camera
         * camera = 2 -> front camera
         *
         * If your existing native application
         * uses a different mapping, change ONLY
         * this method.
         */

        return when (camera) {

            2 ->
                CameraSelector.DEFAULT_FRONT_CAMERA

            else ->
                CameraSelector.DEFAULT_BACK_CAMERA
        }
    }


    // ------------------------------------------------------------
    // Quality Selector
    // ------------------------------------------------------------

    private fun getQualitySelector():
            QualitySelector {

        return when (
            quality.trim().lowercase(
                Locale.US
            )
        ) {

            "high" -> {

                QualitySelector.fromOrderedList(
                    listOf(
                        Quality.FHD,
                        Quality.HD,
                        Quality.SD
                    ),
                    FallbackStrategy
                        .lowerQualityOrHigherThan(
                            Quality.SD
                        )
                )
            }

            "medium" -> {

                QualitySelector.fromOrderedList(
                    listOf(
                        Quality.HD,
                        Quality.SD
                    ),
                    FallbackStrategy
                        .lowerQualityOrHigherThan(
                            Quality.SD
                        )
                )
            }

            "low" -> {

                QualitySelector.fromOrderedList(
                    listOf(
                        Quality.SD
                    ),
                    FallbackStrategy
                        .lowerQualityOrHigherThan(
                            Quality.SD
                        )
                )
            }

            else -> {

                QualitySelector.fromOrderedList(
                    listOf(
                        Quality.HD,
                        Quality.SD
                    ),
                    FallbackStrategy
                        .lowerQualityOrHigherThan(
                            Quality.SD
                        )
                )
            }
        }
    }


    // ------------------------------------------------------------
    // MediaStore Recording
    // ------------------------------------------------------------

    private fun startRecordingToMediaStore() {

        val capture =
            videoCapture
                ?: run {

                    sendRecordingError(
                        "VIDEO_CAPTURE_NULL",
                        "VideoCapture is not initialized"
                    )

                    return
                }


        val timestamp =
            SimpleDateFormat(
                "yyyyMMdd_HHmmss",
                Locale.US
            ).format(Date())


        var finalFileName =
            fileName.trim()


        if (
            finalFileName.isEmpty()
        ) {

            finalFileName =
                "VID_$timestamp.mp4"
        }


        if (
            !finalFileName
                .lowercase(Locale.US)
                .endsWith(".mp4")
        ) {

            finalFileName += ".mp4"
        }


        val contentValues =
            ContentValues().apply {

                put(
                    MediaStore.MediaColumns.DISPLAY_NAME,
                    finalFileName
                )

                put(
                    MediaStore.MediaColumns.MIME_TYPE,
                    "video/mp4"
                )


                if (
                    Build.VERSION.SDK_INT >=
                    Build.VERSION_CODES.Q
                ) {

                    put(
                        MediaStore.Video.Media.RELATIVE_PATH,
                        "Movies/RetailIQ/$beatPlanId"
                    )

                    put(
                        MediaStore.Video.Media.IS_PENDING,
                        1
                    )
                }
            }


        currentContentValues =
            contentValues


        val outputOptions =
            MediaStoreOutputOptions.Builder(
                contentResolver,
                MediaStore.Video.Media.EXTERNAL_CONTENT_URI
            )
                .setContentValues(
                    contentValues
                )
                .build()


        try {

            currentRecording =
                capture.output
                    .prepareRecording(
                        this,
                        outputOptions
                    )
                    .withAudioEnabled()
                    .start(
                        ContextCompat.getMainExecutor(
                            this
                        )
                    ) { event ->

                        handleRecordingEvent(
                            event,
                            contentValues
                        )
                    }


            Log.d(
                TAG,
                "CameraX recording request submitted"
            )

        } catch (e: SecurityException) {

            Log.e(
                TAG,
                "Camera/audio permission error",
                e
            )


            sendRecordingError(
                "PERMISSION_ERROR",
                "Camera and microphone permissions are required"
            )


            stopServiceCompletely()

        } catch (e: Exception) {

            Log.e(
                TAG,
                "Unable to start recording",
                e
            )


            sendRecordingError(
                "RECORDING_START_FAILED",
                e.message
                    ?: "Unable to start recording"
            )


            stopServiceCompletely()
        }
    }


    // ------------------------------------------------------------
    // Recording Events
    // ------------------------------------------------------------

    private fun handleRecordingEvent(
        event: VideoRecordEvent,
        contentValues: ContentValues
    ) {

        when (event) {

            is VideoRecordEvent.Start -> {

                isRecording = true
                isStopping = false


                Log.d(
                    TAG,
                    "VideoRecordEvent.Start"
                )


                RecordingBridge
                    .notifyRecordingStarted(
                        fileName = fileName,
                        beatplanId = beatPlanId,
                        storeId = storeId
                    )
            }


            is VideoRecordEvent.Finalize -> {

                handleRecordingFinalize(
                    event,
                    contentValues
                )
            }


            else -> {

                // Status events intentionally ignored.
            }
        }
    }


    // ------------------------------------------------------------
    // Finalize
    // ------------------------------------------------------------

    private fun handleRecordingFinalize(
        event: VideoRecordEvent.Finalize,
        contentValues: ContentValues
    ) {

        isRecording = false

        currentRecording = null


        val outputUri =
            event.outputResults.outputUri


        // --------------------------------------------------------
        // Error
        // --------------------------------------------------------

        if (event.hasError()) {

            val errorMessage =
                "Recording failed: ${event.error}"


            Log.e(
                TAG,
                errorMessage
            )


            Log.e(
                TAG,
                "Finalize cause=${event.cause}"
            )


            Log.e(
                TAG,
                "Output URI=$outputUri"
            )


            if (
                outputUri != Uri.EMPTY
            ) {

                try {

                    contentResolver.delete(
                        outputUri,
                        null,
                        null
                    )

                } catch (e: Exception) {

                    Log.e(
                        TAG,
                        "Unable to delete failed recording",
                        e
                    )
                }
            }


            sendRecordingError(
                "RECORDING_FINALIZE_FAILED",
                errorMessage
            )


            stopServiceCompletely()

            return
        }


        // --------------------------------------------------------
        // Successful Finalization
        // --------------------------------------------------------

        try {

            if (
                Build.VERSION.SDK_INT >=
                Build.VERSION_CODES.Q
            ) {

                val readyValues =
                    ContentValues().apply {

                        put(
                            MediaStore.Video.Media.IS_PENDING,
                            0
                        )
                    }


                contentResolver.update(
                    outputUri,
                    readyValues,
                    null,
                    null
                )
            }


            logVideoMetadata(
                outputUri
            )


            val savedPath =
                "Movies/RetailIQ/$beatPlanId"


            Log.d(
                TAG,
                "Recording saved: $outputUri"
            )


            RecordingBridge
                .notifyRecordingStopped(
                    uri = outputUri.toString(),
                    fileName = fileName,
                    path = savedPath,
                    beatplanId = beatPlanId,
                    storeId = storeId
                )


        } catch (e: Exception) {

            Log.e(
                TAG,
                "Error finalizing recording",
                e
            )


            sendRecordingError(
                "FINALIZE_PROCESSING_ERROR",
                e.message
                    ?: "Unable to finalize recording"
            )
        }


        stopServiceCompletely()
    }


    // ------------------------------------------------------------
    // Video Metadata
    // ------------------------------------------------------------

    private fun logVideoMetadata(
        uri: Uri
    ) {

        try {

            val retriever =
                MediaMetadataRetriever()


            retriever.setDataSource(
                this,
                uri
            )


            val bitrate =
                retriever.extractMetadata(
                    MediaMetadataRetriever
                        .METADATA_KEY_BITRATE
                )


            val width =
                retriever.extractMetadata(
                    MediaMetadataRetriever
                        .METADATA_KEY_VIDEO_WIDTH
                )


            val height =
                retriever.extractMetadata(
                    MediaMetadataRetriever
                        .METADATA_KEY_VIDEO_HEIGHT
                )


            val duration =
                retriever.extractMetadata(
                    MediaMetadataRetriever
                        .METADATA_KEY_DURATION
                )


            Log.d(
                TAG,
                "VIDEO_INFO: " +
                        "Resolution=${width}x${height}, " +
                        "Bitrate=$bitrate, " +
                        "Duration=${duration}ms"
            )


            retriever.release()

        } catch (e: Exception) {

            Log.e(
                TAG,
                "Unable to read video metadata",
                e
            )
        }
    }


    // ------------------------------------------------------------
    // Stop Recording
    // ------------------------------------------------------------

    private fun stopRecording() {

        if (isStopping) {

            Log.d(
                TAG,
                "Stop already requested"
            )

            return
        }


        val recording =
            currentRecording


        if (recording == null) {

            Log.d(
                TAG,
                "No current recording"
            )

            stopServiceCompletely()

            return
        }


        isStopping = true


        Log.d(
            TAG,
            "Stopping active recording"
        )


        RecordingBridge
            .notifyRecordingStopping()


        try {

            recording.stop()

        } catch (e: Exception) {

            Log.e(
                TAG,
                "Error stopping recording",
                e
            )


            currentRecording = null
            isRecording = false
            isStopping = false


            sendRecordingError(
                "RECORDING_STOP_FAILED",
                e.message
                    ?: "Unable to stop recording"
            )


            stopServiceCompletely()
        }
    }


    // ------------------------------------------------------------
    // Error Event
    // ------------------------------------------------------------

    private fun sendRecordingError(
        code: String,
        message: String
    ) {

        Log.e(
            TAG,
            "$code: $message"
        )


        RecordingBridge.sendError(
            code,
            message
        )
    }


    // ------------------------------------------------------------
    // WakeLock
    // ------------------------------------------------------------

    private fun acquireWakeLock() {

        try {

            val powerManager =
                getSystemService(
                    POWER_SERVICE
                ) as PowerManager


            if (
                wakeLock == null ||
                !wakeLock!!.isHeld
            ) {

                wakeLock =
                    powerManager.newWakeLock(
                        PowerManager.PARTIAL_WAKE_LOCK,
                        "ShopperXM::BackgroundVideoRecording"
                    ).apply {

                        acquire(
                            WAKELOCK_TIMEOUT
                        )
                    }


                Log.d(
                    TAG,
                    "WakeLock acquired"
                )
            }

        } catch (e: Exception) {

            Log.e(
                TAG,
                "Unable to acquire WakeLock",
                e
            )
        }
    }


    // ------------------------------------------------------------
    // Release WakeLock
    // ------------------------------------------------------------

    private fun releaseWakeLock() {

        try {

            wakeLock?.let {

                if (it.isHeld) {

                    it.release()
                }
            }

        } catch (e: Exception) {

            Log.e(
                TAG,
                "WakeLock release error",
                e
            )

        } finally {

            wakeLock = null
        }
    }


    // ------------------------------------------------------------
    // Complete Service Shutdown
    // ------------------------------------------------------------

    private fun stopServiceCompletely() {

        Log.d(
            TAG,
            "Stopping VideoRecordingService"
        )


        isRecording = false
        isStopping = false

        currentRecording = null


        try {

            cameraProvider?.unbindAll()

        } catch (e: Exception) {

            Log.e(
                TAG,
                "Camera unbind error",
                e
            )
        }


        cameraProvider = null
        videoCapture = null

        releaseWakeLock()


        try {

            if (
                Build.VERSION.SDK_INT >=
                Build.VERSION_CODES.N
            ) {

                stopForeground(
                    STOP_FOREGROUND_REMOVE
                )

            } else {

                @Suppress("DEPRECATION")
                stopForeground(true)
            }

        } catch (e: Exception) {

            Log.e(
                TAG,
                "Foreground service cleanup error",
                e
            )
        }


        stopSelf()
    }


    // ------------------------------------------------------------
    // Service Destroy
    // ------------------------------------------------------------

    override fun onDestroy() {

        Log.d(
            TAG,
            "VideoRecordingService destroyed"
        )


        try {

            currentRecording?.stop()

        } catch (e: Exception) {

            Log.e(
                TAG,
                "Destroy recording stop error",
                e
            )
        }


        try {

            cameraProvider?.unbindAll()

        } catch (e: Exception) {

            Log.e(
                TAG,
                "Destroy camera cleanup error",
                e
            )
        }


        cameraProvider = null
        videoCapture = null
        currentRecording = null

        releaseWakeLock()


        try {

            if (
                !cameraExecutor.isShutdown
            ) {

                cameraExecutor.shutdown()
            }

        } catch (e: Exception) {

            Log.e(
                TAG,
                "Executor shutdown error",
                e
            )
        }


        super.onDestroy()
    }
}