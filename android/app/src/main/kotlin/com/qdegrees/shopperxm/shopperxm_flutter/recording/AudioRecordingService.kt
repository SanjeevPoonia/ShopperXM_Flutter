package com.qdegrees.shopperxm.shopperxm_flutter.recording

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.Service
import android.content.ContentValues
import android.content.Context
import android.content.Intent
import android.media.MediaRecorder
import android.net.Uri
import android.os.Build
import android.os.IBinder
import android.provider.MediaStore
import android.util.Log
import androidx.annotation.RequiresApi
import java.io.File

class AudioRecordingService : Service() {

    companion object {

        private const val TAG = "AudioRecordingService"

        const val ACTION_START = "ACTION_START_AUDIO_RECORDING"
        const val ACTION_STOP = "ACTION_STOP_AUDIO_RECORDING"

        const val EXTRA_FILE_PATH = "file_path"
        const val EXTRA_AUDIT_ID = "audit_id"
        const val EXTRA_STORE_CODE = "store_code"

        private const val NOTIFICATION_CHANNEL_ID = "audio_recording_channel"
        private const val NOTIFICATION_ID = 2001

        private const val PREF_NAME = "audio_recording_prefs"

        private const val KEY_IS_RECORDING = "is_recording"
        private const val KEY_FILE_PATH = "file_path"
        private const val KEY_FILE_URI = "file_uri"
        private const val KEY_AUDIT_ID = "audit_id"
        private const val KEY_STORE_CODE = "store_code"

        fun isRecording(context: Context): Boolean {
            return context
                .getSharedPreferences(PREF_NAME, Context.MODE_PRIVATE)
                .getBoolean(KEY_IS_RECORDING, false)
        }

        fun getRecordingFilePath(context: Context): String? {
            return context
                .getSharedPreferences(PREF_NAME, Context.MODE_PRIVATE)
                .getString(KEY_FILE_PATH, null)
        }

        fun getRecordingFileUri(context: Context): String? {
            return context
                .getSharedPreferences(PREF_NAME, Context.MODE_PRIVATE)
                .getString(KEY_FILE_URI, null)
        }

        fun getAuditId(context: Context): String? {
            return context
                .getSharedPreferences(PREF_NAME, Context.MODE_PRIVATE)
                .getString(KEY_AUDIT_ID, null)
        }

        fun getStoreCode(context: Context): String? {
            return context
                .getSharedPreferences(PREF_NAME, Context.MODE_PRIVATE)
                .getString(KEY_STORE_CODE, null)
        }
    }

    private var mediaRecorder: MediaRecorder? = null

    private var currentFileUri: Uri? = null
    private var currentFilePath: String? = null

    override fun onCreate() {
        super.onCreate()

        Log.d(TAG, "AudioRecordingService created")

        createNotificationChannel()
    }

    override fun onStartCommand(
        intent: Intent?,
        flags: Int,
        startId: Int
    ): Int {

        when (intent?.action) {

            ACTION_START -> {

                val auditId = intent.getStringExtra(EXTRA_AUDIT_ID)
                val storeCode = intent.getStringExtra(EXTRA_STORE_CODE)

                startAudioRecording(
                    auditId = auditId,
                    storeCode = storeCode
                )
            }

            ACTION_STOP -> {
                stopAudioRecording()
            }
        }

        return START_STICKY
    }

    private fun startAudioRecording(
        auditId: String?,
        storeCode: String?
    ) {

        if (mediaRecorder != null) {
            Log.d(TAG, "Audio recording is already running")
            return
        }

        try {

            val safeStoreCode = sanitizeFileName(
                storeCode?.trim().takeUnless { it.isNullOrEmpty() }
                    ?: "UnknownStore"
            )

            val safeAuditId = sanitizeFileName(
                auditId?.trim().takeUnless { it.isNullOrEmpty() }
                    ?: "UnknownAudit"
            )

            val timestamp = System.currentTimeMillis()

            val fileName =
                "audio_${safeAuditId}_$timestamp.m4a"

            /*
             * Create public file:
             *
             * Movies/RetailIQ/<StoreCode>/Audio/
             */
            val uri = createPublicAudioFile(
                storeCode = safeStoreCode,
                fileName = fileName
            )

            if (uri == null) {
                Log.e(TAG, "Unable to create public audio file")
                return
            }

            currentFileUri = uri

            /*
             * MediaRecorder needs an actual writable file descriptor.
             */
            val parcelFileDescriptor =
                contentResolver.openFileDescriptor(uri, "w")

            if (parcelFileDescriptor == null) {
                Log.e(TAG, "Unable to open file descriptor for audio URI")

                deleteMediaStoreFile(uri)

                currentFileUri = null

                return
            }

            val recorder = MediaRecorder()

            recorder.setAudioSource(
                MediaRecorder.AudioSource.MIC
            )

            recorder.setOutputFormat(
                MediaRecorder.OutputFormat.MPEG_4
            )

            recorder.setAudioEncoder(
                MediaRecorder.AudioEncoder.AAC
            )

            recorder.setAudioEncodingBitRate(
                128000
            )

            recorder.setAudioSamplingRate(
                44100
            )

            recorder.setOutputFile(
                parcelFileDescriptor.fileDescriptor
            )

            recorder.prepare()

            recorder.start()

            /*
             * IMPORTANT:
             * Keep the ParcelFileDescriptor open while MediaRecorder
             * is using it.
             */
            currentParcelFileDescriptor = parcelFileDescriptor

            mediaRecorder = recorder

            currentFilePath =
                buildDisplayPath(
                    storeCode = safeStoreCode,
                    fileName = fileName
                )

            saveRecordingState(
                isRecording = true,
                filePath = currentFilePath,
                fileUri = uri.toString(),
                auditId = auditId,
                storeCode = storeCode
            )

            startForeground(
                NOTIFICATION_ID,
                createNotification()
            )

            Log.d(TAG, "Audio recording started")
            Log.d(TAG, "Store Code: $storeCode")
            Log.d(TAG, "Audit ID: $auditId")
            Log.d(TAG, "Public URI: $uri")
            Log.d(TAG, "Display path: $currentFilePath")

        } catch (e: Exception) {

            Log.e(
                TAG,
                "Failed to start audio recording",
                e
            )

            mediaRecorder?.let {
                try {
                    it.reset()
                } catch (_: Exception) {
                }

                try {
                    it.release()
                } catch (_: Exception) {
                }
            }

            mediaRecorder = null

            try {
                currentParcelFileDescriptor?.close()
            } catch (_: Exception) {
            }

            currentParcelFileDescriptor = null

            currentFileUri?.let {
                deleteMediaStoreFile(it)
            }

            currentFileUri = null
            currentFilePath = null
        }
    }

    private var currentParcelFileDescriptor:
            android.os.ParcelFileDescriptor? = null

    private fun stopAudioRecording() {

        val recorder = mediaRecorder

        if (recorder == null) {

            Log.d(
                TAG,
                "No active MediaRecorder found"
            )

            stopForeground(STOP_FOREGROUND_REMOVE)
            stopSelf()

            return
        }

        val fileUri = currentFileUri
        val filePath = currentFilePath

        var stopSuccessful = false

        try {

            recorder.stop()

            stopSuccessful = true

            Log.d(
                TAG,
                "MediaRecorder stopped successfully"
            )

        } catch (e: RuntimeException) {

            Log.e(
                TAG,
                "MediaRecorder stop failed",
                e
            )

        } finally {

            try {
                recorder.reset()
            } catch (e: Exception) {
                Log.e(
                    TAG,
                    "MediaRecorder reset failed",
                    e
                )
            }

            try {
                recorder.release()
            } catch (e: Exception) {
                Log.e(
                    TAG,
                    "MediaRecorder release failed",
                    e
                )
            }

            mediaRecorder = null

            try {
                currentParcelFileDescriptor?.close()
            } catch (e: Exception) {
                Log.e(
                    TAG,
                    "ParcelFileDescriptor close failed",
                    e
                )
            }

            currentParcelFileDescriptor = null
        }

        if (stopSuccessful && fileUri != null) {

            /*
             * Mark the MediaStore file as completed.
             */
            try {

                val values = ContentValues().apply {

                    put(
                        MediaStore.MediaColumns.IS_PENDING,
                        0
                    )
                }

                contentResolver.update(
                    fileUri,
                    values,
                    null,
                    null
                )

                Log.d(
                    TAG,
                    "Public audio file finalized"
                )

            } catch (e: Exception) {

                Log.e(
                    TAG,
                    "Unable to finalize MediaStore audio file",
                    e
                )
            }

            logFileDetails(fileUri)

        } else if (fileUri != null) {

            /*
             * Recording failed.
             * Remove incomplete public file.
             */
            deleteMediaStoreFile(fileUri)

        }

        /*
         * IMPORTANT:
         *
         * Do NOT remove file path / URI here.
         *
         * Flutter needs these values after Stop.
         */
        markRecordingStopped()

        currentFileUri = null
        currentFilePath = null

        stopForeground(STOP_FOREGROUND_REMOVE)

        stopSelf()
    }

    private fun createPublicAudioFile(
        fileName: String,
        storeCode: String
    ): Uri? {

        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.Q) {
            Log.e(
                TAG,
                "Public MediaStore audio storage requires Android 10+"
            )
            return null
        }

        // Public folder:
        // Internal Storage/Music/RetailIQ/<StoreCode>/Audio/
        val relativePath = "Music/RetailIQ/$storeCode/Audio/"

        val values = ContentValues().apply {

            put(
                MediaStore.Audio.Media.DISPLAY_NAME,
                fileName
            )

            put(
                MediaStore.Audio.Media.MIME_TYPE,
                "audio/mp4"
            )

            put(
                MediaStore.Audio.Media.RELATIVE_PATH,
                relativePath
            )

            put(
                MediaStore.Audio.Media.IS_PENDING,
                1
            )
        }

        return try {

            val collection =
                MediaStore.Audio.Media.getContentUri(
                    MediaStore.VOLUME_EXTERNAL_PRIMARY
                )

            val uri = contentResolver.insert(
                collection,
                values
            )

            Log.d(
                TAG,
                "Created audio MediaStore URI: $uri"
            )

            Log.d(
                TAG,
                "Audio relative path: $relativePath"
            )

            uri

        } catch (e: Exception) {

            Log.e(
                TAG,
                "Failed to create public audio file",
                e
            )

            null
        }
    }

    private fun buildDisplayPath(
        storeCode: String,
        fileName: String
    ): String {

        return "/storage/emulated/0/Music/RetailIQ/$storeCode/Audio/$fileName"
    }

    private fun logFileDetails(uri: Uri) {

        try {

            val cursor = contentResolver.query(
                uri,
                arrayOf(
                    MediaStore.MediaColumns.DISPLAY_NAME,
                    MediaStore.MediaColumns.SIZE,
                    MediaStore.MediaColumns.RELATIVE_PATH
                ),
                null,
                null,
                null
            )

            cursor?.use {

                if (it.moveToFirst()) {

                    val nameIndex =
                        it.getColumnIndex(
                            MediaStore.MediaColumns.DISPLAY_NAME
                        )

                    val sizeIndex =
                        it.getColumnIndex(
                            MediaStore.MediaColumns.SIZE
                        )

                    val pathIndex =
                        it.getColumnIndex(
                            MediaStore.MediaColumns.RELATIVE_PATH
                        )

                    val name =
                        if (nameIndex >= 0)
                            it.getString(nameIndex)
                        else
                            "Unknown"

                    val size =
                        if (sizeIndex >= 0)
                            it.getLong(sizeIndex)
                        else
                            0L

                    val path =
                        if (pathIndex >= 0)
                            it.getString(pathIndex)
                        else
                            "Unknown"

                    Log.d(
                        TAG,
                        "Audio file name: $name"
                    )

                    Log.d(
                        TAG,
                        "Audio file size: $size bytes"
                    )

                    Log.d(
                        TAG,
                        "Audio relative path: $path"
                    )
                }
            }

        } catch (e: Exception) {

            Log.e(
                TAG,
                "Unable to read audio file details",
                e
            )
        }
    }

    private fun deleteMediaStoreFile(uri: Uri) {

        try {

            contentResolver.delete(
                uri,
                null,
                null
            )

            Log.d(
                TAG,
                "Incomplete audio file deleted: $uri"
            )

        } catch (e: Exception) {

            Log.e(
                TAG,
                "Unable to delete MediaStore file",
                e
            )
        }
    }

    private fun saveRecordingState(
        isRecording: Boolean,
        filePath: String?,
        fileUri: String?,
        auditId: String?,
        storeCode: String?
    ) {

        getSharedPreferences(
            PREF_NAME,
            Context.MODE_PRIVATE
        )
            .edit()
            .putBoolean(
                KEY_IS_RECORDING,
                isRecording
            )
            .putString(
                KEY_FILE_PATH,
                filePath
            )
            .putString(
                KEY_FILE_URI,
                fileUri
            )
            .putString(
                KEY_AUDIT_ID,
                auditId
            )
            .putString(
                KEY_STORE_CODE,
                storeCode
            )
            .apply()
    }

    private fun markRecordingStopped() {

        getSharedPreferences(
            PREF_NAME,
            Context.MODE_PRIVATE
        )
            .edit()
            .putBoolean(
                KEY_IS_RECORDING,
                false
            )
            .apply()
    }

    private fun sanitizeFileName(value: String): String {

        return value
            .replace(
                Regex("[\\\\/:*?\"<>|]"),
                "_"
            )
            .replace(
                " ",
                "_"
            )
    }

    private fun createNotificationChannel() {

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {

            val channel = NotificationChannel(
                NOTIFICATION_CHANNEL_ID,
                "Audio Recording",
                NotificationManager.IMPORTANCE_LOW
            )

            channel.description =
                "Notification shown while audio recording is active"

            val manager =
                getSystemService(
                    NotificationManager::class.java
                )

            manager.createNotificationChannel(channel)
        }
    }

    private fun createNotification(): Notification {

        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {

            Notification.Builder(
                this,
                NOTIFICATION_CHANNEL_ID
            )
                .setContentTitle(
                    "Audio recording in progress"
                )
                .setContentText(
                    "Recording audio in background"
                )
                .setSmallIcon(
                    android.R.drawable.ic_btn_speak_now
                )
                .setOngoing(true)
                .build()

        } else {

            Notification.Builder(this)
                .setContentTitle(
                    "Audio recording in progress"
                )
                .setContentText(
                    "Recording audio in background"
                )
                .setSmallIcon(
                    android.R.drawable.ic_btn_speak_now
                )
                .setOngoing(true)
                .build()
        }
    }

    override fun onBind(intent: Intent?): IBinder? {
        return null
    }

    override fun onDestroy() {

        Log.d(
            TAG,
            "AudioRecordingService destroyed"
        )

        /*
         * Safety cleanup.
         */
        mediaRecorder?.let {

            try {
                it.reset()
            } catch (_: Exception) {
            }

            try {
                it.release()
            } catch (_: Exception) {
            }
        }

        mediaRecorder = null

        try {
            currentParcelFileDescriptor?.close()
        } catch (_: Exception) {
        }

        currentParcelFileDescriptor = null

        super.onDestroy()
    }
}