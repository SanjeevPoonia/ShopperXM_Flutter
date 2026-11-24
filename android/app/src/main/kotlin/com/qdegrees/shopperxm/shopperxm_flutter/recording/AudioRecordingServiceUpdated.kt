package com.qdegrees.shopperxm.shopperxm_flutter.recording
import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.Service
import android.content.ContentValues
import android.content.Intent
import android.media.MediaRecorder
import android.net.Uri
import android.os.Build
import android.os.IBinder
import android.provider.MediaStore
import android.content.pm.ServiceInfo
import android.util.Log
import androidx.core.app.NotificationCompat
import java.io.File
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale
import java.util.UUID

class AudioRecordingServiceUpdated : Service() {

    companion object {
        const val ACTION_START = "SHOPPERXM_AUDIO_START"
        const val ACTION_STOP = "SHOPPERXM_AUDIO_STOP"

        const val CHANNEL_ID = "shopperxm_audio_recording"
        const val NOTIFICATION_ID = 7101

        const val PREFS_NAME = "shopperxm_audio_prefs"

        @Volatile
        var isRecording = false
            private set
    }

    private var recorder: MediaRecorder? = null
    private var outputUri: Uri? = null
    private var outputDescriptor: android.os.ParcelFileDescriptor? = null

    private val prefs by lazy {
        getSharedPreferences(PREFS_NAME, MODE_PRIVATE)
    }

    override fun onCreate() {
        super.onCreate()
        createNotificationChannel()
    }

    override fun onStartCommand(
        intent: Intent?,
        flags: Int,
        startId: Int
    ): Int {

        when (intent?.action) {

            ACTION_START -> {
                if (!isRecording) {
                    startRecording(intent)
                }
            }

            ACTION_STOP -> {
                stopRecording()
            }
        }

        return START_STICKY
    }

    private fun startRecording(intent: Intent) {

        try {
            val recordingId =
                intent.getStringExtra("recordingId")
                    ?: UUID.randomUUID().toString()

            val storeName =
                intent.getStringExtra("storeName") ?: "Store"

            val beatplanId =
                intent.getStringExtra("beatplanId") ?: ""

            val storeId =
                intent.getStringExtra("storeId") ?: ""

            val auditDate =
                intent.getStringExtra("auditDate") ?: ""

            // Create the foreground notification before recording.
            val notification = buildNotification()

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                startForeground(
                    NOTIFICATION_ID,
                    notification,
                    ServiceInfo.FOREGROUND_SERVICE_TYPE_MICROPHONE
                )
            } else {
                startForeground(
                    NOTIFICATION_ID,
                    notification
                )
            }

            val fileName = createFileName(
                storeName,
                recordingId
            )

            val values = ContentValues().apply {
                put(MediaStore.Audio.Media.DISPLAY_NAME, fileName)
                put(MediaStore.Audio.Media.MIME_TYPE, "audio/mp4")

                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                    put(
                        MediaStore.Audio.Media.RELATIVE_PATH,
                        "Music/ShopperXM"
                    )
                    put(
                        MediaStore.Audio.Media.IS_PENDING,
                        1
                    )
                }
            }

            val collection =
                MediaStore.Audio.Media.getContentUri(
                    MediaStore.VOLUME_EXTERNAL_PRIMARY
                )

            val uri = contentResolver.insert(
                collection,
                values
            ) ?: throw IllegalStateException(
                "Unable to create audio file"
            )

            outputUri = uri

            val descriptor = contentResolver.openFileDescriptor(
                uri,
                "w"
            ) ?: throw IllegalStateException(
                "Unable to open audio file"
            )

            outputDescriptor = descriptor

            val audioRecorder = if (
                Build.VERSION.SDK_INT >= Build.VERSION_CODES.S
            ) {
                MediaRecorder(this)
            } else {
                @Suppress("DEPRECATION")
                MediaRecorder()
            }

            recorder = audioRecorder

            audioRecorder.apply {
                setAudioSource(MediaRecorder.AudioSource.MIC)
                setOutputFormat(MediaRecorder.OutputFormat.MPEG_4)
                setAudioEncoder(MediaRecorder.AudioEncoder.AAC)
                setAudioEncodingBitRate(128000)
                setAudioSamplingRate(44100)

                setOutputFile(descriptor.fileDescriptor)

                prepare()
                start()
            }

            isRecording = true

            prefs.edit()
                .putBoolean("isRecording", true)
                .putString("recordingId", recordingId)
                .putString("storeName", storeName)
                .putString("beatplanId", beatplanId)
                .putString("storeId", storeId)
                .putString("auditDate", auditDate)
                .putString("fileName", fileName)
                .putString("fileUri", uri.toString())
                .putLong("startedAt", System.currentTimeMillis())
                .apply()

        } catch (e: Exception) {

            Log.e(
                "ShopperXM_Audio",
                "Audio recording failed to start",
                e
            )

            cleanupFailedRecording()
            stopForeground(STOP_FOREGROUND_REMOVE)
            stopSelf()
        }
    }

    private fun stopRecording() {

        try {
            recorder?.stop()
            recorder?.reset()
            recorder?.release()

            recorder = null

            outputDescriptor?.close()
            outputDescriptor = null

            outputUri?.let { uri ->

                val values = ContentValues().apply {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                        put(
                            MediaStore.Audio.Media.IS_PENDING,
                            0
                        )
                    }
                }

                contentResolver.update(
                    uri,
                    values,
                    null,
                    null
                )
            }

            prefs.edit()
                .putBoolean("isRecording", false)
                .putLong("stoppedAt", System.currentTimeMillis())
                .apply()

        } catch (e: Exception) {
            e.printStackTrace()
            cleanupFailedRecording()
        } finally {
            isRecording = false
            outputUri = null

            stopForeground(STOP_FOREGROUND_REMOVE)
            stopSelf()
        }
    }

    private fun cleanupFailedRecording() {

        try {
            recorder?.release()
        } catch (_: Exception) {}

        recorder = null

        try {
            outputDescriptor?.close()
        } catch (_: Exception) {}

        outputDescriptor = null

        outputUri?.let {
            try {
                contentResolver.delete(it, null, null)
            } catch (_: Exception) {}
        }

        outputUri = null
        isRecording = false

        prefs.edit()
            .putBoolean("isRecording", false)
            .apply()
    }

    private fun createFileName(
        storeName: String,
        recordingId: String
    ): String {

        val safeName = storeName
            .replace(Regex("[^a-zA-Z0-9_-]"), "_")
            .take(40)

        val date = SimpleDateFormat(
            "yyyyMMdd_HHmmss",
            Locale.US
        ).format(Date())

        return "${safeName}_${date}_${recordingId.take(8)}.m4a"
    }

    private fun createNotificationChannel() {

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {

            val channel = NotificationChannel(
                CHANNEL_ID,
                "Audio Recording",
                NotificationManager.IMPORTANCE_LOW
            ).apply {
                description =
                    "Notification displayed while ShopperXM records audio"
                setShowBadge(false)
            }

            getSystemService(NotificationManager::class.java)
                .createNotificationChannel(channel)
        }
    }

    private fun buildNotification(): Notification {

        return NotificationCompat.Builder(
            this,
            CHANNEL_ID
        )
            .setContentTitle("ShopperXM is recording audio")
            .setContentText("Audio recording is active")
            .setSmallIcon(android.R.drawable.ic_btn_speak_now)
            .setOngoing(true)
            .setCategory(NotificationCompat.CATEGORY_SERVICE)
            .setPriority(NotificationCompat.PRIORITY_LOW)
            .build()
    }

    override fun onDestroy() {
        // Do not silently release an active recorder here.
        // The normal stop path must finalize the file first.
        super.onDestroy()
    }

    override fun onBind(intent: Intent?): IBinder? = null
}
