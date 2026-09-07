import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/utils/formatters.dart';

class TrafficStatBadge extends StatelessWidget {
  final double downloadSpeed;
  final double uploadSpeed;

  const TrafficStatBadge({
    super.key,
    required this.downloadSpeed,
    required this.uploadSpeed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildStatItem(
          icon: Icons.arrow_downward_rounded,
          iconColor: AppColors.primaryCyan,
          label: 'DOWNLOAD',
          speed: Formatters.formatSpeed(downloadSpeed),
        ),
        Container(
          height: 36,
          width: 1,
          color: AppColors.glassBorder,
        ),
        _buildStatItem(
          icon: Icons.arrow_upward_rounded,
          iconColor: AppColors.connectedGreen,
          label: 'UPLOAD',
          speed: Formatters.formatSpeed(uploadSpeed),
        ),
      ],
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String speed,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor, size: 16),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: AppColors.textMuted,
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              speed,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
