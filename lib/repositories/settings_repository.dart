import '../services/storage_service.dart';

class SettingsRepository {
  final StorageService storageService;

  SettingsRepository({required this.storageService});

  bool get isKillSwitch => storageService.getKillSwitch();
  Future<void> setKillSwitch(bool value) => storageService.setKillSwitch(value);

  bool get isSplitTunnel => storageService.getSplitTunnel();
  Future<void> setSplitTunnel(bool value) => storageService.setSplitTunnel(value);

  String get protocol => storageService.getProtocol();
  Future<void> setProtocol(String value) => storageService.setProtocol(value);

  int get dailyUsageBytes => storageService.getDailyUsageBytes();
}
