import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/formatters.dart';
import '../../providers/auth_provider.dart';
import '../../providers/settings_provider.dart';
import '../../widgets/glass_card.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(authNotifierProvider).value;
    final settings = ref.watch(settingsNotifierProvider);
    final isPremium = currentUser?.isPremium ?? false;

    final dailyUsage = settings.dailyUsageBytes;
    final maxLimit = AppConstants.freeDailyDataLimitBytes;
    final usageProgress = (dailyUsage / maxLimit).clamp(0.0, 1.0);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Account'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // User Profile Header
                Center(
                  child: Stack(
                    children: [
                      Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.surfaceDark,
                          border: Border.all(
                            color: isPremium ? const Color(0xFFFFD700) : AppColors.primaryCyan,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: (isPremium ? const Color(0xFFFFD700) : AppColors.primaryCyan).withOpacity(0.25),
                              blurRadius: 20,
                            ),
                          ],
                        ),
                        child: Icon(
                          currentUser?.isGuest == true ? Icons.person_outline_rounded : Icons.person_rounded,
                          size: 48,
                          color: AppColors.primaryCyan,
                        ),
                      ),
                      if (isPremium)
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFFFFD700),
                            ),
                            child: const Icon(Icons.star_rounded, size: 16, color: Colors.black),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                Text(
                  currentUser?.displayName ?? 'Barua User',
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  currentUser?.email ?? 'guest@baruavpn.com',
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                ),
                const SizedBox(height: 24),

                // Data Usage Card
                GlassCard(
                  padding: const EdgeInsets.all(18),
                  borderRadius: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'DAILY BANDWIDTH',
                            style: TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.8,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: isPremium ? const Color(0x33FFD700) : const Color(0x2200D2FF),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              isPremium ? 'UNLIMITED' : 'FREE TIER',
                              style: TextStyle(
                                color: isPremium ? const Color(0xFFFFD700) : AppColors.primaryCyan,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      if (isPremium)
                        const Text(
                          'No restrictions. Enjoy high-speed unmetered bandwidth on all servers.',
                          style: TextStyle(color: AppColors.textPrimary, fontSize: 14),
                        )
                      else ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              Formatters.formatBytes(dailyUsage),
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Limit: ${Formatters.formatBytes(maxLimit)}',
                              style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: LinearProgressIndicator(
                            value: usageProgress,
                            minHeight: 8,
                            backgroundColor: AppColors.surfaceDark,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              usageProgress > 0.85 ? AppColors.errorRed : AppColors.primaryCyan,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Data allowance resets daily at 00:00 UTC.',
                          style: TextStyle(color: AppColors.textMuted, fontSize: 11),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 18),

                // Upgrade Promo Card if free
                if (!isPremium)
                  GlassCard(
                    onTap: () => context.push('/premium'),
                    padding: const EdgeInsets.all(18),
                    borderRadius: 20,
                    borderColor: const Color(0x66FFD700),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0x33FFD700),
                          ),
                          child: const Icon(Icons.workspace_premium_rounded, color: Color(0xFFFFD700), size: 24),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Remove Limits with PRO',
                                style: TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Get unlimited data & access all 9+ country nodes',
                                style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right_rounded, color: Color(0xFFFFD700)),
                      ],
                    ),
                  ),

                const SizedBox(height: 24),

                // Sign Out Button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      await ref.read(authNotifierProvider.notifier).logout();
                      if (context.mounted) {
                        context.go('/login');
                      }
                    },
                    icon: const Icon(Icons.logout_rounded, color: AppColors.errorRed, size: 20),
                    label: const Text(
                      'SIGN OUT',
                      style: TextStyle(
                        color: AppColors.errorRed,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0x44FF4D6D)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
