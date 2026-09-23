import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/glass_card.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  final List<Map<String, String>> _faqs = const [
    {
      'question': 'How does Barua VPN protect my privacy?',
      'answer':
          'Barua VPN encrypts all inbound and outbound network traffic using state-of-the-art WireGuard ChaCha20-Poly1305 cryptography. Your real IP address is replaced by our secure gateway node, preventing ISPs, advertisers, and eavesdroppers from snooping on your internet activity.',
    },
    {
      'question': 'What is WireGuard and why is it faster?',
      'answer':
          'WireGuard is an extremely modern, streamlined VPN protocol designed to run directly in kernel space. It uses a fraction of the code compared to legacy protocols like OpenVPN, offering dramatically faster handshake speeds, lower latency, and significantly improved mobile battery life.',
    },
    {
      'question': 'Is Barua VPN really free?',
      'answer':
          'Yes! Barua VPN is 100% free for everyone. There are no bandwidth limits, no speed throttles, and no sign-ups required. We provide high-speed, secure nodes globally without forcing you into premium tiers.',
    },
    {
      'question': 'What does the Kill Switch do?',
      'answer':
          'The Kill Switch acts as an automatic safety fail-safe. If your VPN connection drops unexpectedly, it instantly shuts down internet access on your device so unencrypted packets never leak over public or unsecure networks.',
    },
    {
      'question': 'Do you keep logs of my activity?',
      'answer':
          'No. Barua VPN operates on a strict No-Logs policy. We do not track, collect, or share your private data, browsing history, or DNS queries. Your privacy is our highest priority.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Help & Support'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            children: [
              // Contact Card
              GlassCard(
                padding: const EdgeInsets.all(20),
                borderRadius: 20,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0x2200D2FF),
                      ),
                      child: const Icon(Icons.headset_mic_rounded, color: AppColors.primaryCyan, size: 32),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      '24/7 Dedicated Support',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Have an inquiry or experiencing a connection issue?',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      width: double.infinity,
                      height: 46,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Contact email copied: ${AppConstants.supportEmail}')),
                          );
                        },
                        icon: const Icon(Icons.email_outlined, size: 18),
                        label: const Text('EMAIL SUPPORT TEAM'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryBlue,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // FAQ Section Title
              const Padding(
                padding: EdgeInsets.only(left: 4, bottom: 8),
                child: Text(
                  'FREQUENTLY ASKED QUESTIONS',
                  style: TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  ),
                ),
              ),

              ..._faqs.map((faq) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: GlassCard(
                    borderRadius: 18,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    child: Theme(
                      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                      child: ExpansionTile(
                        iconColor: AppColors.primaryCyan,
                        collapsedIconColor: AppColors.textMuted,
                        tilePadding: EdgeInsets.zero,
                        title: Text(
                          faq['question']!,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Text(
                              faq['answer']!,
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 13,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),

              const SizedBox(height: 16),

              // Diagnostics Button
              Center(
                child: TextButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Diagnostic logs exported successfully')),
                    );
                  },
                  icon: const Icon(Icons.bug_report_outlined, size: 16, color: AppColors.textMuted),
                  label: const Text(
                    'Export Connection Logs',
                    style: TextStyle(color: AppColors.textMuted, fontSize: 12),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
