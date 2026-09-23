import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:android_intent_plus/android_intent.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/settings_provider.dart';
import '../../providers/core_providers.dart';
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

                    // Kill Switch — OS-level guide
                    ListTile(
                      leading: const Icon(Icons.gpp_bad_rounded, color: AppColors.softBlue),
                      title: const Text('Kill Switch', style: TextStyle(color: AppColors.textPrimary, fontSize: 15)),
                      subtitle: const Text(
                        'Block all traffic if VPN drops unexpectedly',
                        style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
                      ),
                      trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
                      onTap: () => _showKillSwitchGuide(context),
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
                    const Divider(color: AppColors.glassBorder, height: 1),

                    // DNS Leak Protection — always active indicator
                    ListTile(
                      leading: const Icon(Icons.dns_rounded, color: AppColors.connectedGreen),
                      title: const Text('DNS Leak Protection', style: TextStyle(color: AppColors.textPrimary, fontSize: 15)),
                      subtitle: const Text(
                        'Cloudflare 1.1.1.1 / 1.0.0.1  •  no-log policy',
                        style: TextStyle(color: AppColors.connectedGreen, fontSize: 12),
                      ),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.connectedGreen.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text('ACTIVE',
                          style: TextStyle(color: AppColors.connectedGreen, fontWeight: FontWeight.bold, fontSize: 11),
                        ),
                      ),
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
                      leading: const Icon(Icons.language_rounded, color: AppColors.primaryCyan),
                      title: const Text('Official Website', style: TextStyle(color: AppColors.textPrimary, fontSize: 15)),
                      trailing: const Icon(Icons.open_in_new_rounded, color: AppColors.textMuted, size: 18),
                      onTap: () async {
                        final Uri url = Uri.parse('https://baruavpn.com');
                        if (await canLaunchUrl(url)) {
                          await launchUrl(url);
                        }
                      },
                    ),
                    const Divider(color: AppColors.glassBorder, height: 1),
                    ListTile(
                      leading: const Icon(Icons.info_outline_rounded, color: AppColors.textMuted),
                      title: const Text('App Version', style: TextStyle(color: AppColors.textPrimary, fontSize: 15)),
                      trailing: ref.watch(appVersionProvider).when(
                            data: (version) => Text(
                              version,
                              style: const TextStyle(color: AppColors.textSecondary, fontSize: 13, fontWeight: FontWeight.bold),
                            ),
                            loading: () => const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primaryCyan),
                            ),
                            error: (_, __) => const Text(
                              'Unknown',
                              style: TextStyle(color: AppColors.textSecondary, fontSize: 13, fontWeight: FontWeight.bold),
                            ),
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
                    if (p['name'] == 'WireGuard') {
                      ref.read(settingsNotifierProvider.notifier).setProtocol(p['name']!);
                      ctx.pop();
                    } else {
                      ctx.pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${p['name']} support is coming soon!'),
                          backgroundColor: AppColors.primaryBlue,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }

  void _showKillSwitchGuide(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceDark,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.softBlue.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.gpp_bad_rounded, color: AppColors.softBlue, size: 28),
                ),
                const SizedBox(width: 14),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Kill Switch', style: TextStyle(color: AppColors.textPrimary, fontSize: 20, fontWeight: FontWeight.bold)),
                    Text('OS-level traffic protection', style: TextStyle(color: AppColors.textMuted, fontSize: 13)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.glassFillDark,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.glassBorder),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('How it works', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 14)),
                  SizedBox(height: 8),
                  Text(
                    'Android\'s built-in "Always-on VPN + Block connections without VPN" feature acts as a kill switch at the OS level. '
                    'If the VPN tunnel drops, Android immediately blocks ALL internet traffic — no app can bypass it.',
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 13, height: 1.5),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.primaryCyan.withOpacity(0.07),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.primaryCyan.withOpacity(0.2)),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Setup guide', style: TextStyle(color: AppColors.primaryCyan, fontWeight: FontWeight.bold, fontSize: 14)),
                  SizedBox(height: 8),
                  _StepRow(step: '1', text: 'Tap "Open VPN Settings" below'),
                  SizedBox(height: 6),
                  _StepRow(step: '2', text: 'Tap the ⚙ gear icon next to Barua VPN'),
                  SizedBox(height: 6),
                  _StepRow(step: '3', text: 'Enable "Always-on VPN"'),
                  SizedBox(height: 6),
                  _StepRow(step: '4', text: 'Enable "Block connections without VPN"'),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.settings_rounded),
                label: const Text('Open VPN Settings'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryCyan,
                  foregroundColor: AppColors.background,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                onPressed: () async {
                  Navigator.pop(ctx);
                  try {
                    const intent = AndroidIntent(
                      action: 'android.settings.VPN_SETTINGS',
                    );
                    await intent.launch();
                  } catch (e) {
                    debugPrint('Could not open VPN settings: $e');
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StepRow extends StatelessWidget {
  final String step;
  final String text;
  const _StepRow({required this.step, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 22,
          height: 22,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.primaryCyan.withOpacity(0.15),
            shape: BoxShape.circle,
          ),
          child: Text(step, style: const TextStyle(color: AppColors.primaryCyan, fontSize: 11, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(width: 10),
        Expanded(child: Text(text, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13))),
      ],
    );
  }
}
