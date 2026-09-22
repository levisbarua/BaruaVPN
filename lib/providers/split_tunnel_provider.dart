import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kExcludedPackagesKey = 'split_tunnel_excluded_packages';

class SplitTunnelNotifier extends StateNotifier<Set<String>> {
  SplitTunnelNotifier() : super({}) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList(_kExcludedPackagesKey) ?? [];
    state = Set<String>.from(saved);
  }

  Future<void> toggle(String packageName) async {
    final updated = Set<String>.from(state);
    if (updated.contains(packageName)) {
      updated.remove(packageName);
    } else {
      updated.add(packageName);
    }
    state = updated;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_kExcludedPackagesKey, updated.toList());
  }

  bool isExcluded(String packageName) => state.contains(packageName);
}

final splitTunnelProvider = StateNotifierProvider<SplitTunnelNotifier, Set<String>>(
  (ref) => SplitTunnelNotifier(),
);
