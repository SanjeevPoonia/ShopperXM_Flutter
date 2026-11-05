import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../network/constants.dart';

class S3UploadService {
  S3UploadService._();

  static final Dio _dio = Dio();


  /// Generates a presigned URL, uploads the file, and returns its URL.
  static Future<String?> uploadFile({
    required BuildContext context,
    required File file,
    required String fileName,
    required String fileType,
    required String folder,
    required String dialogTitle,

    Map<String, dynamic>? apiHeaders,
  }) async {
    if (!await file.exists()) {
      throw Exception('Selected file does not exist.');
    }
    final String presignedApiUrl='${AppConstant.appBaseURL}s3/get/presigned/upload/url';
    print("Presigned Url: $presignedApiUrl");
    final progress = ValueNotifier<double>(0);
    final uploadTitle = ValueNotifier<String>(dialogTitle);
    var dialogVisible = false;

    try {
      // Show a reusable upload progress dialog.
      if (!context.mounted) return null;

      dialogVisible = true;

      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) {
          return PopScope(
            canPop: false,
            child: AlertDialog(
              title: ValueListenableBuilder<String>(
                valueListenable: uploadTitle,
                builder: (_, title, __) => Text(title),
              ),
              content: ValueListenableBuilder<double>(
                valueListenable: progress,
                builder: (_, value, __) {
                  final percentage = (value * 100).round();

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      LinearProgressIndicator(
                        value: value,
                        minHeight: 7,
                      ),
                      const SizedBox(height: 16),
                      Text('$percentage% uploaded'),
                    ],
                  );
                },
              ),
            ),
          );
        },
      );


      // STEP 1: Request the presigned URL from your API.
      final presignResponse = await _dio.post(
        presignedApiUrl,
        data: {
          'file_name': fileName,
          'file_type': _getContentType(fileName),
          'folder': folder,
        },
        options: Options(headers: {
          ...?apiHeaders,
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        }),
      );

      final responseData = presignResponse.data;
      print('presigned api response $responseData');
      if (responseData is! Map ||
          responseData['status'] != true ||
          responseData['data'] is! Map) {
        throw Exception('Invalid presigned URL API response: $responseData');
      }


      final data = responseData['data'] as Map;
      final uploadUrl = data['upload_url']?.toString();
      final fileUrl = data['file_url']?.toString();



      if (uploadUrl == null || uploadUrl.isEmpty ||
          fileUrl == null || fileUrl.isEmpty) {
        throw Exception('Upload URL or file URL is missing.');
      }
   

      // STEP 2: Upload the file directly to S3.
      uploadTitle.value = dialogTitle;

      final contentType = _getContentType(fileName);

      await _dio.put(
        uploadUrl,
        data: file.openRead(),
        options: Options(
          headers: {
            'Content-Type': contentType,
            'Content-Length': await file.length(),
          },
          responseType: ResponseType.plain,
          validateStatus: (status) =>
          status != null && status >= 200 && status < 300,
        ),
        onSendProgress: (sent, total) {
          if (total > 0) {
            progress.value = sent / total;
          }
        },
      );

      progress.value = 1;

      if (fileUrl == null || fileUrl.isEmpty) {
        throw Exception(
          'Upload succeeded, but the API did not return file_url. '
              'Return the final object URL from your presigned URL API.',
        );
      }

      return fileUrl;
    }on DioException catch(e){
      debugPrint('Presigned API URL: ${e.requestOptions.uri}');
      debugPrint('Request method: ${e.requestOptions.method}');
      debugPrint('Request headers: ${e.requestOptions.headers}');
      debugPrint('Request body: ${e.requestOptions.data}');
      debugPrint('Response status: ${e.response?.statusCode}');
      debugPrint('Response body: ${e.response?.data}');
      rethrow;
    } finally {
      // Close the dialog and dispose of the notifiers.
      if (dialogVisible && context.mounted) {
        Navigator.of(context, rootNavigator: true).pop();
      }

      progress.dispose();
      uploadTitle.dispose();
    }
  }

  static String _getContentType(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();

    const mimeTypes = {
      'jpg': 'image/jpeg',
      'jpeg': 'image/jpeg',
      'png': 'image/png',
      'webp': 'image/webp',
      'pdf': 'application/pdf',
      'mp4': 'video/mp4',
      'mov': 'video/quicktime',
      'mp3': 'audio/mpeg',
      'm4a': 'audio/mp4',
      'aac': 'audio/aac',
      'wav': 'audio/wav',
    };

    return mimeTypes[extension] ?? 'application/octet-stream';
  }
}