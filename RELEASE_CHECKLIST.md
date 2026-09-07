# Google Play Store Release Preparation Checklist 🚀

Before uploading **Barua VPN** to Google Play Console, review and complete every checklist item below.

---

## 1. App Identity & Android Package Configuration
- [ ] **Package Name**: Confirm bundle identifier is set to your production reverse domain in `android/app/build.gradle` (e.g., `com.baruavpn.app`).
- [ ] **Version Code & Name**: Increment `versionCode` and `versionName` in `pubspec.yaml` (e.g. `1.0.0+1`).
- [ ] **App Launcher Icons**: Generate multi-density mipmap icons (`mipmap-hdpi`, `mipmap-xhdpi`, `mipmap-xxhdpi`, `mipmap-xxxhdpi`) using `flutter_launcher_icons`.
- [ ] **Splash Screen**: Customize splash screen colors and logos in `styles.xml`.

---

## 2. Cryptographic Signing & Keystore
- [ ] **Generate Release Keystore**:
  ```bash
  keytool -genkey -v -keystore release-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias barua-vpn
  ```
- [ ] **Configure `key.properties`**: Create `android/key.properties` (ensure it is added to `.gitignore`):
  ```properties
  storePassword=YOUR_STORE_PASSWORD
  keyPassword=YOUR_KEY_PASSWORD
  keyAlias=barua-vpn
  storeFile=../release-keystore.jks
  ```
- [ ] **Update `android/app/build.gradle`**: Hook `signingConfigs.release` into `buildTypes.release`.

---

## 3. Google Play Policy & VPN Specific Disclosures
- [ ] **VpnService Policy Declaration**:
  - Google Play requires a specific declaration in Play Console under **Policy > App Content > VpnService**.
  - Provide a clear video link demonstrating that the core function of Barua VPN is establishing a secure encrypted tunnel.
  - Justify why `android.permission.BIND_VPN_SERVICE` is essential for the app's primary purpose.
- [ ] **Prominent In-App Disclosure**:
  - Display a prominent disclosure screen informing users before requesting the system VPN permission dialog.
- [ ] **Privacy Policy URL**:
  - Host a compliant privacy policy stating strict zero-logging of user traffic data.
  - Link this in Play Console under **App Content > Privacy Policy**.
- [ ] **Target API Level**:
  - Ensure `targetSdkVersion` is at least Android 14 (API level 34) or latest Google Play requirement.

---

## 4. Google Play Billing Setup
- [ ] **Google Play Console In-App Products / Subscriptions**:
  - Create Subscription Base Plan ID: `barua_vpn_1m` (Monthly)
  - Create Subscription Base Plan ID: `barua_vpn_12m` (Yearly with 7-day trial)
- [ ] **Activate Google Play Billing Library** in `pubspec.yaml` (`in_app_purchase`).
- [ ] **Upload Alpha/Closed Testing Track AAB** to enable Billing sandbox testing with licensed test accounts.

---

## 5. Proguard & Code Obfuscation
- [ ] Verify `android/app/proguard-rules.pro` contains rules for WireGuard, Firebase, and Dio:
  ```proguard
  -keep class com.wireguard.** { *; }
  -dontwarn com.wireguard.**
  ```
- [ ] Enable `minifyEnabled true` and `shrinkResources true` in release build type.

---

## 6. Build Production Android App Bundle (AAB)
- [ ] Clean build workspace:
  ```bash
  flutter clean
  flutter pub get
  ```
- [ ] Build release AAB:
  ```bash
  flutter build appbundle --release --obfuscate --split-debug-info=./build/debug-info
  ```
- [ ] The generated bundle is located at:
  `build/app/outputs/bundle/release/app-release.aab`

---

## 7. Store Listing Assets
- [ ] **App Title**: Barua VPN: Fast & Secure VPN
- [ ] **Short Description** (up to 80 chars): Fast, secure WireGuard VPN with global locations and unmetered speed.
- [ ] **Full Description** (up to 4000 chars) highlighting WireGuard, encryption, global nodes, speed test, and zero-logs.
- [ ] **App Icon**: 512 x 512 PNG (32-bit with alpha).
- [ ] **Feature Graphic**: 1024 x 500 PNG/JPEG.
- [ ] **Phone Screenshots**: At least 4 high-res screenshots (min 1080p) showing:
  1. Home Screen with large Connect Button
  2. Server Selection screen with country flags
  3. Internet Speed Test speedometer
  4. Tunnel Diagnostics screen
  5. PRO Upgrade Screen
