import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class Formatters {
  /// Formats raw byte count into human-readable string: B, KB, MB, GB
  static String formatBytes(int bytes, {int decimals = 1}) {
    if (bytes <= 0) return '0 B';
    const suffixes = ['B', 'KB', 'MB', 'GB', 'TB'];
    final i = (log(bytes) / log(1024)).floor();
    final clampedIndex = i.clamp(0, suffixes.length - 1);
    final size = bytes / pow(1024, clampedIndex);
    return '${size.toStringAsFixed(decimals)} ${suffixes[clampedIndex]}';
  }

  /// Formats speed rate in bytes/sec into Kbps or Mbps
  static String formatSpeed(double bytesPerSec) {
    if (bytesPerSec <= 0) return '0.0 KB/s';
    if (bytesPerSec < 1024) {
      return '${bytesPerSec.toStringAsFixed(0)} B/s';
    } else if (bytesPerSec < 1024 * 1024) {
      return '${(bytesPerSec / 1024).toStringAsFixed(1)} KB/s';
    } else {
      return '${(bytesPerSec / (1024 * 1024)).toStringAsFixed(2)} MB/s';
    }
  }

  /// Formats duration into HH:MM:SS or MM:SS
  static String formatDuration(Duration duration) {
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    if (duration.inHours > 0) {
      return '$hours:$minutes:$seconds';
    }
    return '$minutes:$seconds';
  }

  /// Formats ping latency with ms unit
  static String formatPing(int pingMs) {
    return '$pingMs ms';
  }

  /// Color for ping latency indicator
  static Color getPingColor(int pingMs) {
    if (pingMs <= 60) return AppColors.connectedGreen;
    if (pingMs <= 150) return AppColors.connectingAmber;
    return AppColors.errorRed;
  }

  /// Color for server load percentage
  static Color getLoadColor(int loadPercent) {
    if (loadPercent <= 50) return AppColors.connectedGreen;
    if (loadPercent <= 80) return AppColors.connectingAmber;
    return AppColors.errorRed;
  }
}
