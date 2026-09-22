import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../models/vpn_state_model.dart';
import '../../providers/core_providers.dart';
import '../../providers/server_provider.dart';
import '../../providers/vpn_provider.dart';
import '../../services/update_service.dart';
import '../../widgets/animated_connect_button.dart';
import '../../widgets/connection_timer.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/traffic_stat_badge.dart';
import '../../widgets/ad_banner.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      UpdateService.checkForUpdates(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final vpnState = ref.watch(vpnControllerProvider);
    final selectedServer = ref.watch(selectedServerProvider);
    final trafficStatsAsync = ref.watch(trafficStatsStreamProvider);
    final durationAsync = ref.watch(vpnDurationProvider);

    final isConnected = vpnState.status == VpnStatus.connected;
    final isConnecting = vpnState.status == VpnStatus.connecting;

    final trafficStats = trafficStatsAsync.value;
    final duration = durationAsync.value ?? Duration.zero;
    final isPremium = true;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Background subtle world map network dots
          Positioned.fill(
            child: SvgPicture.asset(
              'assets/images/world_map_dots.svg',
              fit: BoxFit.cover,
            ),
          ),

          // Glowing background radial lights
          Positioned(
            top: -60,
            right: -60,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isConnected
                    ? AppColors.connectedGreen.withOpacity(0.12)
                    : AppColors.primaryCyan.withOpacity(0.12),
                boxShadow: [
                  BoxShadow(
                    color: isConnected
                        ? AppColors.connectedGreen.withOpacity(0.2)
                        : AppColors.primaryCyan.withOpacity(0.2),
                    blurRadius: 80,
                    spreadRadius: 40,
                  ),
                ],
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // Top App Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    children: [
                      // App Icon & Name
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.primaryCyan.withOpacity(0.5)),
                        ),
                        child: ClipOval(
                          child: SvgPicture.asset('assets/icons/app_logo.svg'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            AppConstants.appName,
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5,
                            ),
                          ),
                          Row(
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isConnected
                                      ? AppColors.connectedGreen
                                      : (isConnecting ? AppColors.connectingAmber : AppColors.disconnectedGray),
                                ),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                vpnState.status.label,
                                style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Spacer(),

                      // Speed Test Shortcut
                      IconButton(
                        icon: const Icon(Icons.speed_rounded, color: AppColors.primaryCyan, size: 22),
                        tooltip: 'Speed Test',
                        onPressed: () => context.push('/speed-test'),
                      ),

                      const SizedBox(width: 6),


                      IconButton(
                        icon: const Icon(Icons.settings_outlined, color: AppColors.textSecondary, size: 22),
                        onPressed: () => context.push('/settings'),
                      ),
                    ],
                  ),
                ),

                // Live Connection Timer & Status Pill
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ConnectionTimerWidget(
                        duration: duration,
                        isConnected: isConnected,
                      ),
                      if (isConnected) ...[
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: () => context.push('/connection-details'),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceDark.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: AppColors.primaryCyan.withOpacity(0.3)),
                            ),
                            child: Row(
                              children: const [
                                Icon(Icons.info_outline_rounded, color: AppColors.primaryCyan, size: 14),
                                SizedBox(width: 4),
                                Text(
                                  'Details',
                                  style: TextStyle(
                                    color: AppColors.primaryCyan,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                const Spacer(flex: 1),

                // Large Animated Connect Button
                AnimatedConnectButton(
                  status: vpnState.status,
                  onTap: () {
                    ref.read(vpnControllerProvider.notifier).toggleConnection();
                  },
                ),

                const Spacer(flex: 1),

                // Public IP Display & Security Banner
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
                  child: GlassCard(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    borderRadius: 16,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          isConnected ? Icons.shield_rounded : Icons.shield_outlined,
                          size: 18,
                          color: isConnected ? AppColors.connectedGreen : AppColors.textMuted,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          isConnected ? 'IP Protected: ' : 'Your Real IP: ',
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          trafficStats?.publicIp ?? (isConnected ? '197.248.1.10' : '102.214.120.4'),
                          style: TextStyle(
                            color: isConnected ? AppColors.connectedGreen : AppColors.textPrimary,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            fontFeatures: const [FontFeature.tabularFigures()],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Real-time Upload & Download Traffic Stat
                if (isConnected)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                    child: GlassCard(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      borderRadius: 18,
                      child: TrafficStatBadge(
                        downloadSpeed: trafficStats?.downloadSpeedBytesPerSec ?? 0.0,
                        uploadSpeed: trafficStats?.uploadSpeedBytesPerSec ?? 0.0,
                      ),
                    ),
                  ),

                // Selected Server Card
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  child: GlassCard(
                    onTap: () => context.push('/servers'),
                    borderRadius: 20,
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: AppColors.surfaceDark,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.glassBorder),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            selectedServer?.flagEmoji ?? '🇰🇪',
                            style: const TextStyle(fontSize: 26),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                selectedServer?.country ?? 'Kenya',
                                style: const TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${selectedServer?.city ?? 'Nairobi'} • ${selectedServer?.pingMs ?? 18} ms',
                                style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.primaryBlue.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.primaryBlue.withOpacity(0.3)),
                          ),
                          child: Row(
                            children: const [
                              Text(
                                'CHANGE',
                                style: TextStyle(
                                  color: AppColors.primaryCyan,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.8,
                                ),
                              ),
                              SizedBox(width: 4),
                              Icon(Icons.chevron_right_rounded, color: AppColors.primaryCyan, size: 16),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 12),
                
                // Show Banner Ad for Free Users
                if (!isPremium)
                  const Padding(
                    padding: EdgeInsets.only(bottom: 8.0),
                    child: AdBannerWidget(),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
