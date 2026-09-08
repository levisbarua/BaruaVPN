import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../models/server_model.dart';
import '../../models/vpn_state_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/core_providers.dart';
import '../../providers/server_provider.dart';
import '../../providers/vpn_provider.dart';
import '../../widgets/server_card.dart';

class ServerListScreen extends ConsumerWidget {
  const ServerListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final servers = ref.watch(filteredServersProvider);
    final selectedServer = ref.watch(selectedServerProvider);
    final currentTab = ref.watch(serverTabFilterProvider);
    final vpnState = ref.watch(vpnControllerProvider);
    final currentUser = ref.watch(authNotifierProvider).value;
    final isUserPremium = currentUser?.isPremium ?? false;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Select Location'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Refresh Pings',
            onPressed: () {
              ref.invalidate(serverListProvider);
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: Column(
          children: [
            // Search Input
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: TextField(
                onChanged: (val) => ref.read(serverSearchQueryProvider.notifier).state = val,
                style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Search country or city...',
                  prefixIcon: const Icon(Icons.search_rounded, color: AppColors.primaryCyan, size: 20),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  suffixIcon: ref.watch(serverSearchQueryProvider).isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear_rounded, color: AppColors.textMuted, size: 18),
                          onPressed: () => ref.read(serverSearchQueryProvider.notifier).state = '',
                        )
                      : null,
                ),
              ),
            ),

            // Filter Tabs (All, Recommended, Free, Premium)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: Row(
                children: [
                  _buildTabChip(ref, ServerTabFilter.all, 'All Servers (${ServerModel.sampleServers.length})', currentTab),
                  _buildTabChip(ref, ServerTabFilter.recommended, '⚡ Fastest', currentTab),
                  _buildTabChip(ref, ServerTabFilter.free, 'Free Tier', currentTab),
                  _buildTabChip(ref, ServerTabFilter.premium, '👑 Premium Pro', currentTab),
                ],
              ),
            ),

            const SizedBox(height: 6),

            // Server Cards List
            Expanded(
              child: servers.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.public_off_rounded, size: 48, color: AppColors.textMuted),
                          SizedBox(height: 12),
                          Text(
                            'No servers match your criteria',
                            style: TextStyle(color: AppColors.textSecondary, fontSize: 15),
                          ),
                        ],
                      ),
                    )
                  : Builder(
                      builder: (context) {
                        final Map<String, List<ServerModel>> groupedServers = {
                          'Europe (Fastest for You)': servers.where((s) => ['NL', 'NO', 'PL', 'RO', 'CH'].contains(s.countryCode)).toList(),
                          'Americas': servers.where((s) => ['US', 'CA', 'MX'].contains(s.countryCode)).toList(),
                          'Asia Pacific': servers.where((s) => ['JP', 'SG'].contains(s.countryCode)).toList(),
                          'Other Locations': servers.where((s) => !['NL', 'NO', 'PL', 'RO', 'CH', 'US', 'CA', 'MX', 'JP', 'SG'].contains(s.countryCode)).toList(),
                        };

                        final flattenedList = <dynamic>[];
                        for (var entry in groupedServers.entries) {
                          if (entry.value.isNotEmpty) {
                            flattenedList.add(entry.key);
                            flattenedList.addAll(entry.value);
                          }
                        }

                        return ListView.builder(
                          itemCount: flattenedList.length,
                          padding: const EdgeInsets.only(bottom: 24),
                          itemBuilder: (context, index) {
                            final item = flattenedList[index];

                            if (item is String) {
                              return Padding(
                                padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                                child: Row(
                                  children: [
                                    if (item.contains('Fastest')) 
                                      const Icon(Icons.speed_rounded, color: AppColors.primaryCyan, size: 18),
                                    if (item.contains('Fastest')) 
                                      const SizedBox(width: 8),
                                    Text(
                                      item.toUpperCase(),
                                      style: const TextStyle(
                                        color: AppColors.primaryCyan,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 1.2,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }

                            final server = item as ServerModel;
                            final isSelected = selectedServer?.id == server.id;

                            return ServerCard(
                              server: server,
                              isSelected: isSelected,
                              onTap: () async {
                                if (server.isPremium && !isUserPremium) {
                                  _showPremiumUpgradePrompt(context);
                                  return;
                                }

                                await ref.read(selectedServerProvider.notifier).selectServer(server);

                                // If connected, automatically reconnect or update active tunnel
                                if (vpnState.status == VpnStatus.connected) {
                                  await ref.read(vpnControllerProvider.notifier).reconnect(server);
                                }

                                if (context.mounted) {
                                  context.pop();
                                }
                              },
                              onFavoriteToggle: () {
                                ref.read(serverRepositoryProvider).toggleFavorite(server.id);
                                ref.invalidate(serverListProvider);
                              },
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabChip(WidgetRef ref, ServerTabFilter filter, String label, ServerTabFilter activeFilter) {
    final isSelected = filter == activeFilter;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        selectedColor: AppColors.primaryBlue,
        backgroundColor: AppColors.surfaceDark,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : AppColors.textSecondary,
          fontSize: 12,
          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
        ),
        side: BorderSide(
          color: isSelected ? AppColors.primaryCyan : AppColors.glassBorder,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        onSelected: (_) {
          ref.read(serverTabFilterProvider.notifier).state = filter;
        },
      ),
    );
  }

  void _showPremiumUpgradePrompt(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(colors: [Color(0xFFFFD700), Color(0xFFFFA000)]),
                ),
                child: const Icon(Icons.workspace_premium_rounded, color: Colors.black, size: 28),
              ),
              const SizedBox(height: 16),
              const Text(
                'Premium Server Location',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'This high-speed gaming/streaming node is reserved for Barua VPN PRO subscribers.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    ctx.pop();
                    context.push('/premium');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryCyan,
                    foregroundColor: Colors.black,
                  ),
                  child: const Text('UNLOCK WITH PRO', style: TextStyle(fontWeight: FontWeight.w800)),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }
}
