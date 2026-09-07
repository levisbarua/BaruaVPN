import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../models/speed_test_model.dart';
import '../../providers/speed_test_provider.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/speed_gauge.dart';

class SpeedTestScreen extends ConsumerWidget {
  const SpeedTestScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final speedTest = ref.watch(speedTestProvider);
    final isTesting = speedTest.stage == SpeedTestStage.measuringPing ||
        speedTest.stage == SpeedTestStage.measuringDownload ||
        speedTest.stage == SpeedTestStage.measuringUpload;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Internet Speed Test'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              children: [
                const SizedBox(height: 10),

                // Latency and Jitter Glass Card
                Row(
                  children: [
                    Expanded(
                      child: GlassCard(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        borderRadius: 18,
                        child: Column(
                          children: [
                            const Text(
                              'PING',
                              style: TextStyle(
                                color: AppColors.textMuted,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.8,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${speedTest.pingMs} ms',
                              style: const TextStyle(
                                color: AppColors.primaryCyan,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GlassCard(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        borderRadius: 18,
                        child: Column(
                          children: [
                            const Text(
                              'JITTER',
                              style: TextStyle(
                                color: AppColors.textMuted,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.8,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${speedTest.jitterMs} ms',
                              style: const TextStyle(
                                color: AppColors.softBlue,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const Spacer(),

                // Animated Gauge
                SpeedGauge(
                  value: speedTest.currentGaugeValue,
                  label: speedTest.stage.label,
                ),

                const Spacer(),

                // Download & Upload Summary Cards
                Row(
                  children: [
                    Expanded(
                      child: GlassCard(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        borderRadius: 18,
                        borderColor: speedTest.stage == SpeedTestStage.measuringDownload
                            ? AppColors.primaryCyan
                            : AppColors.glassBorder,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: const [
                                Icon(Icons.arrow_downward_rounded, color: AppColors.primaryCyan, size: 16),
                                SizedBox(width: 6),
                                Text(
                                  'DOWNLOAD',
                                  style: TextStyle(color: AppColors.textMuted, fontSize: 11, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '${speedTest.downloadMbps} Mbps',
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GlassCard(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        borderRadius: 18,
                        borderColor: speedTest.stage == SpeedTestStage.measuringUpload
                            ? AppColors.connectedGreen
                            : AppColors.glassBorder,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: const [
                                Icon(Icons.arrow_upward_rounded, color: AppColors.connectedGreen, size: 16),
                                SizedBox(width: 6),
                                Text(
                                  'UPLOAD',
                                  style: TextStyle(color: AppColors.textMuted, fontSize: 11, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '${speedTest.uploadMbps} Mbps',
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Start / Retest Action Button
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: isTesting
                        ? null
                        : () => ref.read(speedTestProvider.notifier).startTest(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: Text(
                      isTesting
                          ? 'TESTING...'
                          : (speedTest.stage == SpeedTestStage.completed ? 'RETEST SPEED' : 'START TEST'),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
