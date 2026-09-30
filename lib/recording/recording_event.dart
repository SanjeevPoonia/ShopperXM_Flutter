class RecordingEvent {
  final RecordingEventType type;
  final String? code;
  final String? message;
  final String? fileName;
  final String? uri;
  final String? path;

  const RecordingEvent({
    required this.type,
    this.code,
    this.message,
    this.fileName,
    this.uri,
    this.path,
  });

  factory RecordingEvent.fromMap(
      Map<String, dynamic> map,
      ) {
    return RecordingEvent(
      type: _parseType(
        map['type']?.toString(),
      ),
      code: map['code']?.toString(),
      message: map['message']?.toString(),
      fileName: map['file_name']?.toString(),
      uri: map['uri']?.toString(),
      path: map['path']?.toString(),
    );
  }

  static RecordingEventType _parseType(
      String? value,
      ) {
    switch (value) {
      case 'RECORDING_STARTED':
        return RecordingEventType.started;

      case 'RECORDING_STOPPING':
        return RecordingEventType.stopping;

      case 'RECORDING_STOPPED':
        return RecordingEventType.stopped;

      case 'RECORDING_ERROR':
        return RecordingEventType.error;

      case 'RECORDING_IDLE':
        return RecordingEventType.idle;

      default:
        return RecordingEventType.unknown;
    }
  }
}


enum RecordingEventType {
  started,
  stopping,
  stopped,
  error,
  idle,
  unknown,
}