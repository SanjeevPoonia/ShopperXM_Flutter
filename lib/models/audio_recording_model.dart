
class AudioRecordingModel {
  final String recordingId;
  final String beatplanId;
  final String storeId;
  final String storeName;
  final String auditDate;
  final String fileName;
  final String? filePath;
  final String status;
  final DateTime startedAt;

  const AudioRecordingModel({
    required this.recordingId,
    required this.beatplanId,
    required this.storeId,
    required this.storeName,
    required this.auditDate,
    required this.fileName,
    this.filePath,
    required this.status,
    required this.startedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'recordingId': recordingId,
      'beatplanId': beatplanId,
      'storeId': storeId,
      'storeName': storeName,
      'auditDate': auditDate,
      'fileName': fileName,
      'filePath': filePath,
      'status': status,
      'startedAt': startedAt.toIso8601String(),
    };
  }

  factory AudioRecordingModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return AudioRecordingModel(
      recordingId: json['recordingId'] ?? '',
      beatplanId: json['beatplanId'] ?? '',
      storeId: json['storeId'] ?? '',
      storeName: json['storeName'] ?? '',
      auditDate: json['auditDate'] ?? '',
      fileName: json['fileName'] ?? '',
      filePath: json['filePath'],
      status: json['status'] ?? 'stopped',
      startedAt: DateTime.parse(json['startedAt']),
    );
  }
}
