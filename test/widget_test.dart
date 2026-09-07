import 'package:flutter_test/flutter_test.dart';
import 'package:barua_vpn/core/utils/formatters.dart';
import 'package:barua_vpn/models/server_model.dart';
import 'package:barua_vpn/models/user_model.dart';
import 'package:barua_vpn/models/vpn_state_model.dart';
import 'package:barua_vpn/models/speed_test_model.dart';

void main() {
  group('Formatters Tests', () {
    test('formatBytes formats properly across scales', () {
      expect(Formatters.formatBytes(0), '0 B');
      expect(Formatters.formatBytes(512), '512.0 B');
      expect(Formatters.formatBytes(1024), '1.0 KB');
      expect(Formatters.formatBytes(1048576), '1.0 MB');
      expect(Formatters.formatBytes(1073741824), '1.0 GB');
    });

    test('formatSpeed formats bytes per second', () {
      expect(Formatters.formatSpeed(0), '0.0 KB/s');
      expect(Formatters.formatSpeed(500), '500 B/s');
      expect(Formatters.formatSpeed(2048), '2.0 KB/s');
      expect(Formatters.formatSpeed(5242880), '5.00 MB/s');
    });

    test('formatDuration formats HH:MM:SS and MM:SS', () {
      expect(Formatters.formatDuration(const Duration(seconds: 45)), '00:45');
      expect(Formatters.formatDuration(const Duration(minutes: 5, seconds: 12)), '05:12');
      expect(Formatters.formatDuration(const Duration(hours: 1, minutes: 23, seconds: 45)), '01:23:45');
    });
  });

  group('ServerModel Tests', () {
    test('Sample servers contain required countries', () {
      final servers = ServerModel.sampleServers;
      final countries = servers.map((s) => s.country).toSet();

      expect(countries.contains('Kenya'), isTrue);
      expect(countries.contains('United States'), isTrue);
      expect(countries.contains('United Kingdom'), isTrue);
      expect(countries.contains('Germany'), isTrue);
      expect(countries.contains('France'), isTrue);
      expect(countries.contains('Netherlands'), isTrue);
      expect(countries.contains('Singapore'), isTrue);
      expect(countries.contains('Japan'), isTrue);
      expect(countries.contains('Canada'), isTrue);
    });

    test('ServerModel JSON serialization', () {
      final original = ServerModel.sampleServers.first;
      final json = original.toJson();
      final reconstructed = ServerModel.fromJson(json);

      expect(reconstructed.id, original.id);
      expect(reconstructed.country, original.country);
      expect(reconstructed.endpoint, original.endpoint);
    });
  });

  group('UserModel Tests', () {
    test('Guest user has free limits and isGuest flag', () {
      final guest = UserModel.guest();
      expect(guest.isGuest, isTrue);
      expect(guest.isPremium, isFalse);
      expect(guest.dailyLimitBytes, 500 * 1024 * 1024);
      expect(guest.hasExceededDailyLimit, isFalse);
    });

    test('Premium user has unlimited bandwidth', () {
      const pro = UserModel(
        id: 'pro_1',
        email: 'pro@baruavpn.com',
        displayName: 'Pro User',
        isPremium: true,
        dailyUsageBytes: 9999999999,
      );
      expect(pro.isPremium, isTrue);
      expect(pro.dailyLimitBytes, -1);
      expect(pro.hasExceededDailyLimit, isFalse);
      expect(pro.usagePercentage, 0.0);
    });
  });

  group('VpnConnectionState Tests', () {
    test('VpnStatus state logic', () {
      const state = VpnConnectionState(status: VpnStatus.connected);
      expect(state.status.isConnected, isTrue);
      expect(state.status.isConnecting, isFalse);
      expect(state.status.label, 'Connected • Protected');
    });
  });

  group('SpeedTestResult Tests', () {
    test('SpeedTestStage progression', () {
      var result = const SpeedTestResult(stage: SpeedTestStage.idle);
      expect(result.stage.label, 'Ready to test');

      result = result.copyWith(stage: SpeedTestStage.measuringPing, pingMs: 25);
      expect(result.pingMs, 25);
      expect(result.stage.label, 'Testing Latency & Jitter...');
    });
  });
}
