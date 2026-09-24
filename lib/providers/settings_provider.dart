import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core_providers.dart';

class SettingsState {
  final bool isKillSwitch;
  final bool isSplitTunnel;
  final String protocol;
  final int dailyUsageBytes;

  const SettingsState({
    this.isKillSwitch = false,
    this.isSplitTunnel = false,
    this.protocol = 'WireGuard',
    this.dailyUsageBytes = 0,
  });

  SettingsState copyWith({
    bool? isKillSwitch,
    bool? isSplitTunnel,
    String? protocol,
    int? dailyUsageBytes,
  }) {
    return SettingsState(
      isKillSwitch: isKillSwitch ?? this.isKillSwitch,
      isSplitTunnel: isSplitTunnel ?? this.isSplitTunnel,
      protocol: protocol ?? this.protocol,
      dailyUsageBytes: dailyUsageBytes ?? this.dailyUsageBytes,
    );
  }
}

class SettingsNotifier extends StateNotifier<SettingsState> {
  final Ref ref;

  SettingsNotifier(this.ref) : super(const SettingsState()) {
    _loadSettings();
  }

  void _loadSettings() {
    final repo = ref.read(settingsRepositoryProvider);
    state = SettingsState(
      isKillSwitch: repo.isKillSwitch,
      isSplitTunnel: repo.isSplitTunnel,
      protocol: repo.protocol,
      dailyUsageBytes: repo.dailyUsageBytes,
    );
  }

  Future<void> toggleKillSwitch(bool value) async {
    state = state.copyWith(isKillSwitch: value);
    await ref.read(settingsRepositoryProvider).setKillSwitch(value);
  }

  Future<void> toggleSplitTunnel(bool value) async {
    state = state.copyWith(isSplitTunnel: value);
    await ref.read(settingsRepositoryProvider).setSplitTunnel(value);
  }

  Future<void> setProtocol(String protocol) async {
    state = state.copyWith(protocol: protocol);
    await ref.read(settingsRepositoryProvider).setProtocol(protocol);
  }
}

final settingsNotifierProvider = StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  return SettingsNotifier(ref);
});
