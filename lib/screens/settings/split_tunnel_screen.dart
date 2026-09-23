import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:installed_apps/installed_apps.dart';
import 'package:installed_apps/app_info.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/split_tunnel_provider.dart';

class SplitTunnelScreen extends ConsumerStatefulWidget {
  const SplitTunnelScreen({super.key});

  @override
  ConsumerState<SplitTunnelScreen> createState() => _SplitTunnelScreenState();
}

class _SplitTunnelScreenState extends ConsumerState<SplitTunnelScreen> {
  List<AppInfo> _apps = [];
  List<AppInfo> _filtered = [];
  bool _loading = true;
  final _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadApps();
    _searchCtrl.addListener(_onSearch);
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadApps() async {
    final apps = await InstalledApps.getInstalledApps(
      excludeSystemApps: true,
      excludeNonLaunchableApps: true,
      withIcon: true,
    );
    if (mounted) {
      setState(() {
        _apps = apps;
        _filtered = apps;
        _loading = false;
      });
    }
  }

  void _onSearch() {
    final query = _searchCtrl.text.toLowerCase();
    setState(() {
      _filtered = query.isEmpty
          ? _apps
          : _apps
              .where((app) =>
                  app.name.toLowerCase().contains(query) ||
                  app.packageName.toLowerCase().contains(query))
              .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final excluded = ref.watch(splitTunnelProvider);
    final notifier = ref.read(splitTunnelProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceDark,
        elevation: 0,
        title: const Text(
          'Split Tunneling',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: TextField(
              controller: _searchCtrl,
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: 'Search apps...',
                hintStyle: const TextStyle(color: AppColors.textMuted),
                prefixIcon: const Icon(Icons.search, color: AppColors.textMuted),
                filled: true,
                fillColor: AppColors.glassFillDark,
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Info banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: AppColors.primaryCyan.withValues(alpha: 0.08),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: AppColors.primaryCyan, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Apps toggled ON bypass the VPN and use your direct connection.',
                    style: TextStyle(
                      color: AppColors.primaryCyan.withValues(alpha: 0.85),
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),

          if (excluded.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Row(
                children: [
                  Text(
                    '${excluded.length} app${excluded.length == 1 ? '' : 's'} bypassing VPN',
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                  ),
                ],
              ),
            ),

          // App list
          Expanded(
            child: _loading
                ? const Center(
                    child: CircularProgressIndicator(color: AppColors.primaryCyan),
                  )
                : _filtered.isEmpty
                    ? const Center(
                        child: Text('No apps found',
                            style: TextStyle(color: AppColors.textMuted)),
                      )
                    : ListView.builder(
                        itemCount: _filtered.length,
                        itemBuilder: (context, index) {
                          final app = _filtered[index];
                          final isExcluded = excluded.contains(app.packageName);

                          return ListTile(
                            leading: _AppIcon(icon: app.icon),
                            title: Text(
                              app.name,
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            subtitle: Text(
                              app.packageName,
                              style: const TextStyle(
                                  color: AppColors.textMuted, fontSize: 11),
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: Switch(
                              value: isExcluded,
                              activeThumbColor: AppColors.primaryCyan,
                              onChanged: (_) => notifier.toggle(app.packageName),
                            ),
                            onTap: () => notifier.toggle(app.packageName),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

class _AppIcon extends StatelessWidget {
  final Uint8List? icon;
  const _AppIcon({this.icon});

  @override
  Widget build(BuildContext context) {
    if (icon != null && icon!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.memory(
          icon!,
          width: 40,
          height: 40,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _placeholder(),
        ),
      );
    }
    return _placeholder();
  }

  Widget _placeholder() => Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.glassFillDark,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Icon(Icons.android, color: AppColors.textMuted, size: 22),
      );
}
