import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/utils/formatters.dart';

class ConnectionTimerWidget extends StatelessWidget {
  final Duration duration;
  final bool isConnected;

  const ConnectionTimerWidget({
    super.key,
    required this.duration,
    required this.isConnected,
  });

  @override
  Widget build(BuildContext context) {
    final formatted = isConnected ? Formatters.formatDuration(duration) : '00:00:00';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark.withOpacity(0.6),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isConnected ? AppColors.connectedGreen.withOpacity(0.4) : AppColors.glassBorder,
          width: 1.2,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isConnected ? AppColors.connectedGreen : AppColors.disconnectedGray,
              boxShadow: isConnected
                  ? [
                      const BoxShadow(
                        color: AppColors.connectedGreenGlow,
                        blurRadius: 6,
                        spreadRadius: 2,
                      )
                    ]
                  : null,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            formatted,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              fontFeatures: [FontFeature.tabularFigures()],
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
