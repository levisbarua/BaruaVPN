import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/utils/formatters.dart';
import '../models/server_model.dart';
import 'glass_card.dart';

class ServerCard extends StatelessWidget {
  final ServerModel server;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onFavoriteToggle;

  const ServerCard({
    super.key,
    required this.server,
    required this.isSelected,
    required this.onTap,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    final pingColor = Formatters.getPingColor(server.pingMs);
    final loadColor = Formatters.getLoadColor(server.loadPercent);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: GlassCard(
        onTap: onTap,
        borderRadius: 20,
        borderColor: isSelected ? AppColors.primaryCyan : AppColors.glassBorder,
        color: isSelected ? AppColors.primaryCyan.withOpacity(0.08) : null,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            // Flag Emoji Badge
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: AppColors.surfaceDark.withOpacity(0.8),
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.primaryCyan.withOpacity(0.6) : AppColors.glassBorder,
                  width: 1.5,
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                server.flagEmoji,
                style: const TextStyle(fontSize: 24),
              ),
            ),
            const SizedBox(width: 14),

            // Country & City Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          server.country,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (server.isPremium) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFFB300), Color(0xFFFF8F00)],
                            ),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'PRO',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 9,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    server.city,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            // Ping & Load Metrics
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: pingColor,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      Formatters.formatPing(server.pingMs),
                      style: TextStyle(
                        color: pingColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Load: ${server.loadPercent}%',
                      style: TextStyle(
                        color: loadColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(width: 10),

            // Favorite star button
            IconButton(
              icon: Icon(
                server.isFavorite ? Icons.star_rounded : Icons.star_outline_rounded,
                color: server.isFavorite ? const Color(0xFFFFD700) : AppColors.textMuted,
                size: 22,
              ),
              onPressed: onFavoriteToggle,
              splashRadius: 18,
            ),
          ],
        ),
      ),
    );
  }
}
