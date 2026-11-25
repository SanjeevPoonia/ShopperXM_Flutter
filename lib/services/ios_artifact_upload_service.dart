
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:shopperxm_flutter/network/constants.dart';

class IOSArtifactUploadService {
  static const MethodChannel _channel = MethodChannel(
    'com.qdegrees.shopperxm/ios_background_upload',
  );

  static Future<int> startUpload({
    required List<Map<String, dynamic>> artifacts,
    required String beatID,
    required String storeID,
    required String userID,
    required String token,
  }) async {
    if (!Platform.isIOS) {
      throw UnsupportedError('This upload service is only for iOS.');
    }

    final result = await _channel.invokeMethod<Map<dynamic, dynamic>>(
      'startBackgroundUpload',
      {
        'artifacts': artifacts,
        'presignedApiUrl':
        '${AppConstant.appBaseURL}s3/get/presigned/upload/url',
        'saveApiUrl':
        '${AppConstant.appBaseURL}save-multiple-overall-video',
        'beat_id': beatID,
        'store_id': storeID,
        'user_id': userID,
        'token': token,
        'device_id': 'flutter_app',
      },
    );

    if (result == null || result['success'] != true) {
      throw Exception('Unable to start iOS background upload.');
    }

    return (result['count'] as num).toInt();
  }
}
