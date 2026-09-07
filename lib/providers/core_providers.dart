import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/storage_service.dart';
import '../services/auth_service.dart';
import '../services/vpn_service.dart';
import '../services/api_service.dart';
import '../services/speed_test_service.dart';
import '../core/network/dio_client.dart';
import '../repositories/auth_repository.dart';
import '../repositories/server_repository.dart';
import '../repositories/vpn_repository.dart';
import '../repositories/settings_repository.dart';

// Services
final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageService();
});

final dioClientProvider = Provider<DioClient>((ref) {
  final storage = ref.watch(storageServiceProvider);
  return DioClient(storageService: storage);
});

final apiServiceProvider = Provider<ApiService>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return ApiService(dioClient: dioClient);
});

final authServiceProvider = Provider<AuthService>((ref) {
  return FirebaseAuthService();
});

final vpnServiceProvider = Provider<VpnService>((ref) {
  return WireGuardVpnService();
});

final speedTestServiceProvider = Provider<SpeedTestService>((ref) {
  return SpeedTestService();
});

// Repositories
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final authService = ref.watch(authServiceProvider);
  final storageService = ref.watch(storageServiceProvider);
  final apiService = ref.watch(apiServiceProvider);
  return AuthRepository(
    authService: authService,
    storageService: storageService,
    apiService: apiService,
  );
});

final serverRepositoryProvider = Provider<ServerRepository>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  final storageService = ref.watch(storageServiceProvider);
  return ServerRepository(
    apiService: apiService,
    storageService: storageService,
  );
});

final vpnRepositoryProvider = Provider<VpnRepository>((ref) {
  final vpnService = ref.watch(vpnServiceProvider);
  final storageService = ref.watch(storageServiceProvider);
  return VpnRepository(
    vpnService: vpnService,
    storageService: storageService,
  );
});

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  final storageService = ref.watch(storageServiceProvider);
  return SettingsRepository(storageService: storageService);
});
