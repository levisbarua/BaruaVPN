import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/app_constants.dart';
import '../models/user_model.dart';

class StorageService {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  late final SharedPreferences _prefs;
  bool _isInitialized = false;

  Future<void> init() async {
    if (!_isInitialized) {
      _prefs = await SharedPreferences.getInstance();
      _isInitialized = true;
    }
  }

  // Auth Token
  Future<void> saveToken(String token) async {
    await _secureStorage.write(key: AppConstants.tokenKey, value: token);
  }

  Future<String?> getToken() async {
    return await _secureStorage.read(key: AppConstants.tokenKey);
  }

  Future<void> clearToken() async {
    await _secureStorage.delete(key: AppConstants.tokenKey);
  }

  // User Profile
  Future<void> saveUser(UserModel user) async {
    final userJson = jsonEncode(user.toJson());
    await _prefs.setString(AppConstants.userKey, userJson);
  }

  UserModel? getUser() {
    final str = _prefs.getString(AppConstants.userKey);
    if (str == null) return null;
    try {
      final map = jsonDecode(str) as Map<String, dynamic>;
      return UserModel.fromJson(map);
    } catch (_) {
      return null;
    }
  }

  Future<void> clearUser() async {
    await _prefs.remove(AppConstants.userKey);
    await clearToken();
  }

  // Selected Server
  String? getSelectedServerId() {
    return _prefs.getString(AppConstants.selectedServerKey);
  }

  Future<void> saveSelectedServerId(String serverId) async {
    await _prefs.setString(AppConstants.selectedServerKey, serverId);
  }

  // Favorite Servers
  List<String> getFavoriteServers() {
    return _prefs.getStringList(AppConstants.favoriteServersKey) ?? [];
  }

  Future<void> toggleFavoriteServer(String serverId) async {
    final list = List<String>.from(getFavoriteServers());
    if (list.contains(serverId)) {
      list.remove(serverId);
    } else {
      list.add(serverId);
    }
    await _prefs.setStringList(AppConstants.favoriteServersKey, list);
  }

  // Settings
  bool getAutoConnect() => _prefs.getBool(AppConstants.autoConnectKey) ?? false;
  Future<void> setAutoConnect(bool val) => _prefs.setBool(AppConstants.autoConnectKey, val);

  bool getKillSwitch() => _prefs.getBool(AppConstants.killSwitchKey) ?? false;
  Future<void> setKillSwitch(bool val) => _prefs.setBool(AppConstants.killSwitchKey, val);

  bool getSplitTunnel() => _prefs.getBool(AppConstants.splitTunnelKey) ?? false;
  Future<void> setSplitTunnel(bool val) => _prefs.setBool(AppConstants.splitTunnelKey, val);

  bool getDarkMode() => _prefs.getBool(AppConstants.darkModeKey) ?? true;
  Future<void> setDarkMode(bool val) => _prefs.setBool(AppConstants.darkModeKey, val);

  String getProtocol() => _prefs.getString(AppConstants.selectedProtocolKey) ?? 'WireGuard';
  Future<void> setProtocol(String val) => _prefs.setString(AppConstants.selectedProtocolKey, val);

  // Daily usage tracking
  int getDailyUsageBytes() {
    _checkAndResetDailyUsage();
    return _prefs.getInt(AppConstants.dailyUsageBytesKey) ?? 0;
  }

  Future<void> addDailyUsageBytes(int bytes) async {
    _checkAndResetDailyUsage();
    final current = _prefs.getInt(AppConstants.dailyUsageBytesKey) ?? 0;
    await _prefs.setInt(AppConstants.dailyUsageBytesKey, current + bytes);
  }

  void _checkAndResetDailyUsage() {
    final today = DateTime.now().toIso8601String().substring(0, 10);
    final lastReset = _prefs.getString(AppConstants.lastResetDateKey);
    if (lastReset != today) {
      _prefs.setString(AppConstants.lastResetDateKey, today);
      _prefs.setInt(AppConstants.dailyUsageBytesKey, 0);
    }
  }
}
