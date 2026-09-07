import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/glass_card.dart';

class PremiumScreen extends ConsumerStatefulWidget {
  const PremiumScreen({super.key});

  @override
  ConsumerState<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends ConsumerState<PremiumScreen> {
  int _selectedPlanIndex = 1; // Default to 12 months
  bool _isProcessing = false;

  final List<Map<String, dynamic>> _plans = [
    {
      'id': 'barua_vpn_1m',
      'title': '1 Month',
      'price': '\$4.99',
      'period': '/ month',
      'savings': null,
      'isPopular': false,
    },
    {
      'id': 'barua_vpn_12m',
      'title': '12 Months',
      'price': '\$39.99',
      'period': '/ year (\$3.33/mo)',
      'savings': 'SAVE 35%',
      'isPopular': true,
    },
  ];

  Future<void> _handleSubscription() async {
    setState(() => _isProcessing = true);

    // Google Play Billing / App Store In-App Purchase integration simulation
    await Future.delayed(const Duration(milliseconds: 1400));

    if (mounted) {
      await ref.read(authNotifierProvider.notifier).upgradeToPremium();
      if (!mounted) return;
      setState(() => _isProcessing = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('🎉 Welcome to Barua VPN PRO! Unlimited access unlocked.'),
          backgroundColor: AppColors.connectedGreen,
        ),
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Barua VPN PRO'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              children: [
                // Crown Glow Banner
                Container(
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Color(0xFFFFD700), Color(0xFFFFA000)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x66FFD700),
                        blurRadius: 28,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  child: const Icon(Icons.workspace_premium_rounded, size: 44, color: Colors.black),
                ),
                const SizedBox(height: 18),

                const Text(
                  'Upgrade to Unlimited PRO',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Unlock all global locations with no speed throttles',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                ),
                const SizedBox(height: 24),

                // Features list
                GlassCard(
                  padding: const EdgeInsets.all(18),
                  borderRadius: 20,
                  child: Column(
                    children: [
                      _buildFeatureItem('Unlimited Bandwidth', 'No 500 MB daily data cap'),
                      const Divider(color: AppColors.glassBorder, height: 20),
                      _buildFeatureItem('All 9+ Country Nodes', 'Kenya, USA, UK, Japan, Singapore, etc.'),
                      const Divider(color: AppColors.glassBorder, height: 20),
                      _buildFeatureItem('Ultra-Fast 10 Gbps Nodes', 'Optimized for 4K streaming and low-ping gaming'),
                      const Divider(color: AppColors.glassBorder, height: 20),
                      _buildFeatureItem('Ad-Free Clean Experience', 'Completely zero sponsored interruptions'),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Pricing Cards
                Row(
                  children: List.generate(_plans.length, (idx) {
                    final plan = _plans[idx];
                    final isSelected = _selectedPlanIndex == idx;
                    final isPopular = plan['isPopular'] as bool;

                    return Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedPlanIndex = idx),
                        child: Container(
                          margin: EdgeInsets.only(right: idx == 0 ? 8 : 0, left: idx == 1 ? 8 : 0),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.primaryBlue.withOpacity(0.18) : AppColors.surfaceDark,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected ? AppColors.primaryCyan : AppColors.glassBorder,
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (isPopular)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  margin: const EdgeInsets.only(bottom: 8),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFD700),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Text(
                                    'BEST VALUE',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 9,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                              Text(
                                plan['title'] as String,
                                style: const TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                plan['price'] as String,
                                style: const TextStyle(
                                  color: AppColors.primaryCyan,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              Text(
                                plan['period'] as String,
                                style: const TextStyle(
                                  color: AppColors.textMuted,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 28),

                // Subscribe Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isProcessing ? null : _handleSubscription,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryCyan,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: _isProcessing
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.black),
                          )
                        : const Text(
                            'START 7-DAY FREE TRIAL',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.8,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 14),

                // Restore purchase & terms
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Checking Google Play purchase receipts...')),
                        );
                      },
                      child: const Text(
                        'Restore Purchases',
                        style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
                      ),
                    ),
                    const Text('•', style: TextStyle(color: AppColors.textMuted)),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Cancel Anytime',
                        style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String title, String desc) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0x3300F298),
          ),
          child: const Icon(Icons.check_rounded, color: AppColors.connectedGreen, size: 16),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                desc,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
