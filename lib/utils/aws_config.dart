class AwsConfig {
  final String region;
  final String bucket;
  final String baseUrl;
  final String uploadPath;
  final String selfiePath;
  final String audio;
  final String video;
  final String img;
  final String transaction;
  final String key;
  final String secret;

  AwsConfig({
    required this.region,
    required this.bucket,
    required this.baseUrl,
    required this.uploadPath,
    required this.selfiePath,
    required this.audio,
    required this.video,
    required this.img,
    required this.transaction,
    required this.key,
    required this.secret,
  });

  factory AwsConfig.fromJson(Map<String, dynamic>? json) {
    return AwsConfig(
      region: json?["region"] as String? ?? "",
      bucket: json?["bucket"] as String? ?? "",
      baseUrl: json?["base_url"] as String? ?? "",
      uploadPath: json?["upload_path"] as String? ?? "",
      selfiePath: json?["selfie_path"] as String? ?? "",
      audio: json?["audio"] as String? ?? "",
      video: json?["video"] as String? ?? "",
      img: json?["img"] as String? ?? "",
      transaction: json?["transaction"] as String? ?? "",
      key: json?["key"] as String? ?? "",
      secret: json?["secret"] as String? ?? "",
    );
  }
}