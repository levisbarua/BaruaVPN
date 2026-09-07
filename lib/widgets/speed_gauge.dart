import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

class SpeedGauge extends StatelessWidget {
  final double value; // 0 to 100 Mbps
  final double maxValue;
  final String label;

  const SpeedGauge({
    super.key,
    required this.value,
    this.maxValue = 100.0,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 260,
      height: 260,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size(260, 260),
            painter: _SpeedometerPainter(
              progress: (value / maxValue).clamp(0.0, 1.0),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
              Text(
                value.toStringAsFixed(1),
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 48,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -1,
                ),
              ),
              const Text(
                'Mbps',
                style: TextStyle(
                  color: AppColors.primaryCyan,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SpeedometerPainter extends CustomPainter {
  final double progress; // 0.0 to 1.0

  _SpeedometerPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.42;

    const startAngle = 135 * (math.pi / 180);
    const sweepAngle = 270 * (math.pi / 180);

    // Background track arc
    final trackPaint = Paint()
      ..color = AppColors.surfaceDark.withOpacity(0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      trackPaint,
    );

    // Active progress arc with gradient
    if (progress > 0) {
      final activePaint = Paint()
        ..shader = const SweepGradient(
          startAngle: startAngle,
          endAngle: startAngle + sweepAngle,
          colors: [
            AppColors.primaryCyan,
            AppColors.softBlue,
            AppColors.primaryBlue,
            AppColors.electricViolet,
          ],
        ).createShader(Rect.fromCircle(center: center, radius: radius))
        ..style = PaintingStyle.stroke
        ..strokeWidth = 14
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle * progress,
        false,
        activePaint,
      );

      // Indicator tip dot
      final currentAngle = startAngle + (sweepAngle * progress);
      final tipX = center.dx + radius * math.cos(currentAngle);
      final tipY = center.dy + radius * math.sin(currentAngle);

      final glowPaint = Paint()
        ..color = AppColors.primaryCyan
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
      canvas.drawCircle(Offset(tipX, tipY), 8, glowPaint);

      final dotPaint = Paint()..color = Colors.white;
      canvas.drawCircle(Offset(tipX, tipY), 5, dotPaint);
    }

    // Ticks around dial
    final tickPaint = Paint()
      ..color = AppColors.textMuted.withOpacity(0.3)
      ..strokeWidth = 1.5;

    for (int i = 0; i <= 10; i++) {
      final tickAngle = startAngle + (sweepAngle * (i / 10));
      final innerRadius = radius - 18;
      final outerRadius = radius - 12;

      final p1 = Offset(
        center.dx + innerRadius * math.cos(tickAngle),
        center.dy + innerRadius * math.sin(tickAngle),
      );
      final p2 = Offset(
        center.dx + outerRadius * math.cos(tickAngle),
        center.dy + outerRadius * math.sin(tickAngle),
      );
      canvas.drawLine(p1, p2, tickPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _SpeedometerPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
