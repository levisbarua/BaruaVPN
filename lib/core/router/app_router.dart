import 'package:go_router/go_router.dart';
import '../../screens/splash/splash_screen.dart';
import '../../screens/onboarding/onboarding_screen.dart';
import '../../screens/home/home_screen.dart';
import '../../screens/servers/server_list_screen.dart';
import '../../screens/connection/connection_details_screen.dart';
import '../../screens/speed_test/speed_test_screen.dart';
import '../../screens/settings/settings_screen.dart';
import '../../screens/settings/split_tunnel_screen.dart';
import '../../screens/support/support_screen.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/servers',
        builder: (context, state) => const ServerListScreen(),
      ),
      GoRoute(
        path: '/connection-details',
        builder: (context, state) => const ConnectionDetailsScreen(),
      ),
      GoRoute(
        path: '/speed-test',
        builder: (context, state) => const SpeedTestScreen(),
      ),

      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/split-tunnel',
        builder: (context, state) => const SplitTunnelScreen(),
      ),
      GoRoute(
        path: '/support',
        builder: (context, state) => const SupportScreen(),
      ),
    ],
  );
}
