import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/settings_provider.dart';
import '../../providers/split_tunnel_provider.dart';
import '../../widgets/glass_card.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsNotifierProvider);
    final notifier = ref.read(settingsNotifierProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Settings & Security'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            children: [
              // Section: VPN Protocol & Security
              const Padding(
                padding: EdgeInsets.only(left: 4, bottom: 8),
                child: Text(
                  'VPN SECURITY',
                  style: TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
              GlassCard(
                borderRadius: 20,
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Column(
                  children: [
                    // Protocol selector
                    ListTile(
                      leading: const Icon(Icons.tune_rounded, color: AppColors.primaryCyan),
                      title: const Text('VPN Protocol', style: TextStyle(color: AppColors.textPrimary, fontSize: 15)),
                      subtitle: Text(settings.protocol, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                      trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
                      onTap: () => _showProtocolDialog(context, ref, settings.protocol),
                    ),
                    const Divider(color: AppColors.glassBorder, height: 1),

                    // Kill Switch
                    SwitchListTile(
                      secondary: const Icon(Icons.gpp_bad_rounded, color: AppColors.softBlue),
                      title: const Text('Kill Switch', style: TextStyle(color: AppColors.textPrimary, fontSize: 15)),
                      subtitle: const Text(
                        'Block internet traffic if VPN drops unexpectedly',
                        style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
                      ),
                      value: settings.isKillSwitch,
                      activeColor: AppColors.primaryCyan,
                      onChanged: (val) => notifier.toggleKillSwitch(val),
                    ),
                    const Divider(color: AppColors.glassBorder, height: 1),

                    // Auto Connect
                    SwitchListTile(
                      secondary: const Icon(Icons.wifi_protected_setup_rounded, color: AppColors.connectedGreen),
                      title: const Text('Auto Connect', style: TextStyle(color: AppColors.textPrimary, fontSize: 15)),
                      subtitle: const Text(
                        'Connect automatically on untrusted public Wi-Fi',
                        style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
                      ),
                      value: settings.isAutoConnect,
                      activeColor: AppColors.primaryCyan,
                      onChanged: (val) => notifier.toggleAutoConnect(val),
                    ),
                    const Divider(color: AppColors.glassBorder, height: 1),

                    // Split Tunneling
                    ListTile(
                      leading: const Icon(Icons.call_split_rounded, color: AppColors.electricViolet),
                      title: const Text('Split Tunneling', style: TextStyle(color: AppColors.textPrimary, fontSize: 15)),
                      subtitle: Consumer(
                        builder: (ctx, ref, _) {
                          final excluded = ref.watch(splitTunnelProvider);
                          return Text(
                            excluded.isEmpty
                                ? 'All apps use the VPN tunnel'
                                : '${excluded.length} app${excluded.length == 1 ? '' : 's'} bypassing VPN',
                            style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                          );
                        },
                      ),
                      trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
                      onTap: () => context.push('/split-tunnel'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Section: App Preferences
              const Padding(
                padding: EdgeInsets.only(left: 4, bottom: 8),
                child: Text(
                  'PREFERENCES',
                  style: TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
              GlassCard(
                borderRadius: 20,
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Column(
                  children: [
                    SwitchListTile(
                      secondary: const Icon(Icons.dark_mode_rounded, color: AppColors.softBlue),
                      title: const Text('Dark Mode', style: TextStyle(color: AppColors.textPrimary, fontSize: 15)),
                      subtitle: const Text('Cyber glassmorphism dark theme', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                      value: settings.isDarkMode,
                      activeColor: AppColors.primaryCyan,
                      onChanged: (val) => notifier.toggleDarkMode(val),
                    ),
                    const Divider(color: AppColors.glassBorder, height: 1),
                    ListTile(
                      leading: const Icon(Icons.language_rounded, color: AppColors.primaryCyan),
                      title: const Text('Language', style: TextStyle(color: AppColors.textPrimary, fontSize: 15)),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Text('English (US)', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                          Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
                        ],
                      ),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Language: English (US) active')),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Section: Support & Legal
              const Padding(
                padding: EdgeInsets.only(left: 4, bottom: 8),
                child: Text(
                  'ABOUT & SUPPORT',
                  style: TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
              GlassCard(
                borderRadius: 20,
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.help_outline_rounded, color: AppColors.primaryCyan),
                      title: const Text('Help & FAQ', style: TextStyle(color: AppColors.textPrimary, fontSize: 15)),
                      trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
                      onTap: () => context.push('/support'),
                    ),
                    const Divider(color: AppColors.glassBorder, height: 1),
                    ListTile(
                      leading: const Icon(Icons.policy_rounded, color: AppColors.primaryCyan),
                      title: const Text('Privacy Policy', style: TextStyle(color: AppColors.textPrimary, fontSize: 15)),
                      trailing: const Icon(Icons.open_in_new_rounded, color: AppColors.textMuted, size: 18),
                      onTap: () async {
                        final Uri url = Uri.parse('https://baruavpn.com/privacy');
                        if (await canLaunchUrl(url)) {
                          await launchUrl(url);
                        }
                      },
                    ),
                    const Divider(color: AppColors.glassBorder, height: 1),
                    ListTile(
                      leading: const Icon(Icons.article_rounded, color: AppColors.primaryCyan),
                      title: const Text('Terms of Service', style: TextStyle(color: AppColors.textPrimary, fontSize: 15)),
                      trailing: const Icon(Icons.open_in_new_rounded, color: AppColors.textMuted, size: 18),
                      onTap: () async {
                        final Uri url = Uri.parse('https://baruavpn.com/terms');
                        if (await canLaunchUrl(url)) {
                          await launchUrl(url);
                        }
                      },
                    ),
                    const Divider(color: AppColors.glassBorder, height: 1),
                    ListTile(
                      leading: const Icon(Icons.info_outline_rounded, color: AppColors.textMuted),
                      title: const Text('App Version', style: TextStyle(color: AppColors.textPrimary, fontSize: 15)),
                      trailing: Text(
                        AppConstants.appVersion,
                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  void _showProtocolDialog(BuildContext context, WidgetRef ref, String current) {
    const protocols = [
      {'name': 'WireGuard', 'desc': 'Fastest, modern crypto, best battery life (Recommended)'},
      {'name': 'OpenVPN (UDP)', 'desc': 'High security, optimal for fast streaming'},
      {'name': 'OpenVPN (TCP)', 'desc': 'Best for bypassing strict firewalls & censorship'},
      {'name': 'IKEv2', 'desc': 'Fast reconnection when switching mobile networks'},
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceDark,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Text(
                  'Select VPN Protocol',
                  style: TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              ...protocols.map((p) {
                final isSelected = p['name'] == current;
                return ListTile(
                  title: Text(p['name']!, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
                  subtitle: Text(p['desc']!, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                  trailing: isSelected ? const Icon(Icons.check_circle_rounded, color: AppColors.primaryCyan) : null,
                  onTap: () {
                    ref.read(settingsNotifierProvider.notifier).setProtocol(p['name']!);
                    ctx.pop();
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }
}
