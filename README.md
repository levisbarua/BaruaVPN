# Barua VPN 🛡️⚡

A modern, high-performance, cross-platform VPN client built with **Flutter (Dart)** and inspired by Urban VPN, Proton VPN, and Cloudflare 1.1.1.1.

Featuring next-generation **WireGuard** tunneling, **Riverpod** state management, **GoRouter** deep navigation, glassmorphic Material 3 cyber aesthetics, live speed telemetry, built-in animated internet speed testing, and Free vs. PRO subscription monetization architecture.

---

## Key Highlights & Features

* 🚀 **WireGuard VPN Engine**: Powered by `wireguard_flutter` with low latency, battery-efficient encryption (ChaCha20-Poly1305), and automatic fallback mode for emulator/offline development.
* 🎨 **Cyber Glassmorphic UI**: Midnight obsidian backgrounds, neon cyan/violet gradients, frosted backdrop filters, animated glowing button states, and world map network radar backgrounds.
* 🌍 **Global Server Catalog**: Pre-configured high-speed nodes in:
  - 🇰🇪 **Kenya** (Nairobi Fast)
  - 🇺🇸 **United States** (New York & Los Angeles)
  - 🇬🇧 **United Kingdom** (London)
  - 🇩🇪 **Germany** (Frankfurt)
  - 🇫🇷 **France** (Paris)
  - 🇳🇱 **Netherlands** (Amsterdam)
  - 🇸🇬 **Singapore** (Singapore Central)
  - 🇯🇵 **Japan** (Tokyo Gaming)
  - 🇨🇦 **Canada** (Toronto)
* ⚡ **Built-in Speed Test**: CustomPainter animated speedometer gauge with real ping latency, jitter, download Mbps, and upload Mbps metrics.
* 🔒 **Security & Settings**:
  - Kill Switch UI
  - Auto-Connect on untrusted Wi-Fi
  - Split Tunneling configuration
  - Protocol switcher (WireGuard, OpenVPN UDP/TCP, IKEv2)
  - Dark Mode glassmorphic theme
* 💎 **Free vs. PRO Tiers**:
  - **Free**: 500 MB daily bandwidth limit, standard servers, daily usage tracking with progress bar.
  - **PRO**: Unlimited bandwidth, unlocked 10 Gbps streaming nodes, zero ads, Google Play Billing / In-App Purchase integration readiness.
* 🔐 **Authentication**: Firebase Auth with Email & Password, Google Sign-In, Guest mode, and Password Reset.
* 🌐 **Admin Backend Ready**: Complete Dio HTTP client layer with token interceptors, certificate verification, and repository architecture ready for backend microservices.

---

## Tech Stack

| Technology | Purpose |
|---|---|
| **Flutter 3.41+ / Dart 3.11+** | Cross-platform framework & language |
| **Flutter Riverpod** | Reactive Clean Architecture state management |
| **GoRouter** | Declarative type-safe routing |
| **Dio** | HTTP networking with interceptors & token refresh |
| **Flutter Secure Storage** | Encrypted token storage & credential persistence |
| **Shared Preferences** | Local preferences & settings caching |
| **WireGuard Flutter** | Platform VPN tunnel management (`VpnService` / NetworkExtension) |
| **Firebase Core, Auth, Analytics, Crashlytics** | Authentication & telemetry suite |
| **Flutter SVG & Lottie** | Vector assets and animated ripples |
| **Google Fonts** | Inter & Cyber typography |

---

## Project Structure

```
lib/
├── core/
│   ├── constants/       # AppConstants, endpoints, storage keys, quotas
│   ├── errors/          # AppException, NetworkException, AuthException
│   ├── network/         # DioClient with interceptors & error handlers
│   ├── router/          # AppRouter with GoRouter definitions
│   ├── theme/           # AppColors & AppTheme (Material 3 Dark Glass)
│   └── utils/           # Formatters (bytes, speeds, durations, pings)
├── models/
│   ├── server_model.dart        # Server entity, latency, load, flags
│   ├── user_model.dart          # User entity, PRO status, daily usage
│   ├── vpn_state_model.dart     # VpnStatus state machine
│   ├── traffic_stats_model.dart # Upload/download speed & transfer counters
│   └── speed_test_model.dart    # Gauge metrics, jitter, download, upload
├── services/
│   ├── vpn_service.dart         # WireGuard VPN service + dev fallback
│   ├── auth_service.dart        # Firebase Auth + guest mode
│   ├── api_service.dart         # Backend endpoints (login, servers, usage)
│   ├── storage_service.dart     # SecureStorage + SharedPreferences
│   └── speed_test_service.dart  # Real network throughput & ping tester
├── repositories/
│   ├── auth_repository.dart     # Authentication & session persistence
│   ├── vpn_repository.dart      # Connection state & usage logging
│   ├── server_repository.dart   # Server catalog & favorite management
│   └── settings_repository.dart # Kill switch, protocols, dark mode
├── providers/
│   ├── core_providers.dart      # Service and repository providers
│   ├── auth_provider.dart       # User authentication notifier
│   ├── vpn_provider.dart        # VPN connection controller & duration ticker
│   ├── server_provider.dart     # Filtered servers & search notifier
│   ├── settings_provider.dart   # Settings state notifier
│   └── speed_test_provider.dart # Speed test execution provider
├── widgets/
│   ├── animated_connect_button.dart # Pulsing neon circle & rotating loader
│   ├── glass_card.dart              # BackdropFilter frosted container
│   ├── connection_timer.dart        # HH:MM:SS active duration badge
│   ├── traffic_stat_badge.dart      # Live up/down speed indicators
│   ├── server_card.dart             # Country flag, city, load & ping
│   ├── speed_gauge.dart             # CustomPainter speedometer
│   └── modern_text_field.dart       # Frosted text input fields
├── screens/
│   ├── splash/splash_screen.dart
│   ├── onboarding/onboarding_screen.dart
│   ├── auth/login_screen.dart
│   ├── auth/register_screen.dart
│   ├── auth/forgot_password_screen.dart
│   ├── home/home_screen.dart
│   ├── servers/server_list_screen.dart
│   ├── connection/connection_details_screen.dart
│   ├── speed_test/speed_test_screen.dart
│   ├── premium/premium_screen.dart
│   ├── profile/profile_screen.dart
│   ├── settings/settings_screen.dart
│   └── support/support_screen.dart
└── main.dart
```

---

## Setup & Running Instructions

### 1. Prerequisites
- Flutter SDK 3.41+ installed and in your PATH.
- Android Studio / VS Code with Flutter extensions.
- For Android: Android SDK with Android 14+ (API 34) tools.
- For iOS: macOS with Xcode 15+ and Apple Developer account (for NetworkExtension capabilities).

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Firebase Configuration (Optional for Production)
The app is engineered with safe offline/mock fallback:
- **Android**: Place `google-services.json` inside `android/app/`.
- **iOS**: Place `GoogleService-Info.plist` inside `ios/Runner/`.

### 4. Run the App
```bash
# Run on connected device or emulator
flutter run
```

### 5. Run Automated Tests
```bash
flutter test
```

---

## Native Permissions

### Android (`android/app/src/main/AndroidManifest.xml`)
- `android.permission.INTERNET`
- `android.permission.ACCESS_NETWORK_STATE`
- `android.permission.CHANGE_NETWORK_STATE`
- `android.permission.FOREGROUND_SERVICE`
- `android.permission.FOREGROUND_SERVICE_SPECIAL_USE`
- `android.permission.POST_NOTIFICATIONS`
- Handled by system `VpnService` dialog when connecting.

### iOS (`ios/Runner/Info.plist` & `ios/Runner/Runner.entitlements`)
- `UIBackgroundModes`: `network-authentication`, `fetch`, `remote-notification`
- `NSLocalNetworkUsageDescription`: Access explanation for WireGuard tunnel.
- Entitlement: `packet-tunnel-provider` (`com.apple.developer.networking.networkextension`).

---

## License
Proprietary © 2026 Barua VPN. All rights reserved.
