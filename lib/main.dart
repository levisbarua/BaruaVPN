import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'core/constants/app_constants.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'providers/core_providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations & transparent system bars
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF0A0E1A),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  // Initialize Firebase safely (allows running without google-services.json in local development/testing)
  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint('Firebase initialization notice (running in offline/dev mock mode): $e');
  }

  // Initialize Google Mobile Ads
  try {
    await MobileAds.instance.initialize();
  } catch (e) {
    debugPrint('AdMob initialization notice: $e');
  }

  // Pre-initialize storage
  final container = ProviderContainer();
  try {
    await container.read(storageServiceProvider).init();
  } catch (e) {
    debugPrint('Storage pre-init notice: $e');
  }

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const BaruaVpnApp(),
    ),
  );
}

class BaruaVpnApp extends ConsumerWidget {
  const BaruaVpnApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      routerConfig: AppRouter.router,
    );
  }
}
