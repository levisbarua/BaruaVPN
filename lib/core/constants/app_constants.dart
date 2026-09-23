class AppConstants {
  static const String appName = 'Barua VPN';
  static const String appTagline = 'Fast • Secure • Borderless';
  static const String appVersion = '1.0.0';
  static const String wireguardInterfaceName = 'wg_barua_vpn';

  // Storage Keys
  static const String selectedServerKey = 'selected_server_id';
  static const String favoriteServersKey = 'favorite_servers';
  static const String autoConnectKey = 'setting_auto_connect';
  static const String killSwitchKey = 'setting_kill_switch';
  static const String splitTunnelKey = 'setting_split_tunnel';
  static const String selectedProtocolKey = 'setting_protocol';
  static const String dailyUsageBytesKey = 'daily_usage_bytes';
  static const String lastResetDateKey = 'last_usage_reset_date';

  // Free Tier Limits
  static const int freeDailyDataLimitBytes = 500 * 1024 * 1024; // 500 MB

  // API Endpoints (Backend Ready)
  static const String baseApiUrl = 'https://api.baruavpn.com/v1';
  static const String serversEndpoint = '/servers';
  static const String usageReportEndpoint = '/telemetry/usage';

  // Support Links
  static const String privacyPolicyUrl = 'https://baruavpn.com/privacy';
  static const String termsOfServiceUrl = 'https://baruavpn.com/terms';
  static const String supportEmail = 'support@baruavpn.com';
}
