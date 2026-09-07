enum SpeedTestStage {
  idle,
  measuringPing,
  measuringDownload,
  measuringUpload,
  completed,
  error;

  String get label {
    switch (this) {
      case SpeedTestStage.idle:
        return 'Ready to test';
      case SpeedTestStage.measuringPing:
        return 'Testing Latency & Jitter...';
      case SpeedTestStage.measuringDownload:
        return 'Testing Download Speed...';
      case SpeedTestStage.measuringUpload:
        return 'Testing Upload Speed...';
      case SpeedTestStage.completed:
        return 'Test Completed';
      case SpeedTestStage.error:
        return 'Speed Test Failed';
    }
  }
}

class SpeedTestResult {
  final SpeedTestStage stage;
  final int pingMs;
  final int jitterMs;
  final double downloadMbps;
  final double uploadMbps;
  final double currentGaugeValue; // Mbps or progress
  final double progress; // 0.0 to 1.0

  const SpeedTestResult({
    this.stage = SpeedTestStage.idle,
    this.pingMs = 0,
    this.jitterMs = 0,
    this.downloadMbps = 0.0,
    this.uploadMbps = 0.0,
    this.currentGaugeValue = 0.0,
    this.progress = 0.0,
  });

  SpeedTestResult copyWith({
    SpeedTestStage? stage,
    int? pingMs,
    int? jitterMs,
    double? downloadMbps,
    double? uploadMbps,
    double? currentGaugeValue,
    double? progress,
  }) {
    return SpeedTestResult(
      stage: stage ?? this.stage,
      pingMs: pingMs ?? this.pingMs,
      jitterMs: jitterMs ?? this.jitterMs,
      downloadMbps: downloadMbps ?? this.downloadMbps,
      uploadMbps: uploadMbps ?? this.uploadMbps,
      currentGaugeValue: currentGaugeValue ?? this.currentGaugeValue,
      progress: progress ?? this.progress,
    );
  }
}
