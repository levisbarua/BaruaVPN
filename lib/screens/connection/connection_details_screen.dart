import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/formatters.dart';
import '../../models/vpn_state_model.dart';
import '../../providers/vpn_provider.dart';
import '../../widgets/glass_card.dart';

class ConnectionDetailsScreen extends ConsumerWidget {
  const ConnectionDetailsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vpnState = ref.watch(vpnControllerProvider);
    final trafficStatsAsync = ref.watch(trafficStatsStreamProvider);
    final durationAsync = ref.watch(vpnDurationProvider);

    final isConnected = vpnState.status == VpnStatus.connected;
    final trafficStats = trafficStatsAsync.value;
    final duration = durationAsync.value ?? Duration.zero;
    final server = vpnState.activeServer;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Tunnel Diagnostics'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Status Header Card
                GlassCard(
                  padding: const EdgeInsets.all(20),
                  borderRadius: 24,
                  borderColor: isConnected ? AppColors.connectedGreen.withOpacity(0.5) : AppColors.glassBorder,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: (isConnected ? AppColors.connectedGreen : AppColors.errorRed).withOpacity(0.15),
                        ),
                        child: Icon(
                          isConnected ? Icons.lock_rounded : Icons.lock_open_rounded,
                          size: 36,
                          color: isConnected ? AppColors.connectedGreen : AppColors.errorRed,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        isConnected ? 'WireGuard Tunnel Active' : 'Tunnel Disconnected',
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        isConnected
                            ? 'Encrypted with ChaCha20-Poly1305'
                            : 'Traffic is currently unencrypted',
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),

                // Connection Metrics Card
                GlassCard(
                  padding: const EdgeInsets.all(18),
                  borderRadius: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'NETWORK METRICS',
                        style: TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.0,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildMetricRow('Server Node', '${server?.country ?? 'Kenya'} (${server?.city ?? 'Nairobi'})'),
                      const Divider(color: AppColors.glassBorder, height: 24),
                      _buildMetricRow('Server Endpoint', server?.endpoint ?? '197.248.1.10:51820'),
                      const Divider(color: AppColors.glassBorder, height: 24),
                      _buildMetricRow('Virtual Assigned IP', trafficStats?.virtualIp ?? '10.8.0.2'),
                      const Divider(color: AppColors.glassBorder, height: 24),
                      _buildMetricRow('Public IP Obfuscated', trafficStats?.publicIp ?? '197.248.1.10'),
                      const Divider(color: AppColors.glassBorder, height: 24),
                      _buildMetricRow('VPN Protocol', 'WireGuard Modern UDP'),
                      const Divider(color: AppColors.glassBorder, height: 24),
                      _buildMetricRow('Session Duration', isConnected ? Formatters.formatDuration(duration) : '00:00:00'),
                      const Divider(color: AppColors.glassBorder, height: 24),
                      _buildMetricRow('Data Downloaded', Formatters.formatBytes(trafficStats?.bytesIn ?? 0)),
                      const Divider(color: AppColors.glassBorder, height: 24),
                      _buildMetricRow('Data Uploaded', Formatters.formatBytes(trafficStats?.bytesOut ?? 0)),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                if (isConnected)
                  SizedBox(
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        await ref.read(vpnControllerProvider.notifier).disconnect();
                        if (context.mounted) context.pop();
                      },
                      icon: const Icon(Icons.power_settings_new_rounded),
                      label: const Text('DISCONNECT TUNNEL'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.errorRed,
                        foregroundColor: Colors.white,
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

  Widget _buildMetricRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
        ),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
