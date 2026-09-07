class TrafficStatsModel {
  final int bytesIn;
  final int bytesOut;
  final double downloadSpeedBytesPerSec;
  final double uploadSpeedBytesPerSec;
  final String publicIp;
  final String virtualIp;

  const TrafficStatsModel({
    this.bytesIn = 0,
    this.bytesOut = 0,
    this.downloadSpeedBytesPerSec = 0.0,
    this.uploadSpeedBytesPerSec = 0.0,
    this.publicIp = '102.214.120.4',
    this.virtualIp = '10.8.0.2',
  });

  int get totalBytes => bytesIn + bytesOut;

  TrafficStatsModel copyWith({
    int? bytesIn,
    int? bytesOut,
    double? downloadSpeedBytesPerSec,
    double? uploadSpeedBytesPerSec,
    String? publicIp,
    String? virtualIp,
  }) {
    return TrafficStatsModel(
      bytesIn: bytesIn ?? this.bytesIn,
      bytesOut: bytesOut ?? this.bytesOut,
      downloadSpeedBytesPerSec: downloadSpeedBytesPerSec ?? this.downloadSpeedBytesPerSec,
      uploadSpeedBytesPerSec: uploadSpeedBytesPerSec ?? this.uploadSpeedBytesPerSec,
      publicIp: publicIp ?? this.publicIp,
      virtualIp: virtualIp ?? this.virtualIp,
    );
  }
}
