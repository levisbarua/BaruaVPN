import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/storage_service.dart';
import '../services/api_service.dart';

class AuthRepository {
  final AuthService authService;
  final StorageService storageService;
  final ApiService apiService;

  AuthRepository({
    required this.authService,
    required this.storageService,
    required this.apiService,
  });

  Stream<UserModel?> get authStateChanges => authService.authStateChanges;

  UserModel? get currentUser {
    return storageService.getUser() ?? authService.currentUser;
  }

  Future<UserModel> login(String email, String password) async {
    final user = await authService.signInWithEmailPassword(email, password);
    // Also authenticate with backend if configured
    try {
      final backendRes = await apiService.login(email, password);
      if (backendRes['token'] != null) {
        await storageService.saveToken(backendRes['token'] as String);
      }
    } catch (_) {}
    await storageService.saveUser(user);
    return user;
  }

  Future<UserModel> register(String email, String password, String name) async {
    final user = await authService.registerWithEmailPassword(email, password, name);
    try {
      final backendRes = await apiService.register(email, password, name);
      if (backendRes['token'] != null) {
        await storageService.saveToken(backendRes['token'] as String);
      }
    } catch (_) {}
    await storageService.saveUser(user);
    return user;
  }

  Future<UserModel> loginWithGoogle() async {
    final user = await authService.signInWithGoogle();
    await storageService.saveUser(user);
    return user;
  }

  Future<UserModel> loginAsGuest() async {
    final user = await authService.signInAsGuest();
    await storageService.saveUser(user);
    return user;
  }

  Future<void> sendPasswordReset(String email) async {
    await authService.sendPasswordResetEmail(email);
  }

  Future<void> logout() async {
    await authService.signOut();
    await storageService.clearUser();
    await storageService.clearToken();
  }

  Future<void> upgradeToPremium() async {
    final current = currentUser;
    if (current != null) {
      final updated = current.copyWith(
        isPremium: true,
        premiumExpiry: DateTime.now().add(const Duration(days: 365)),
      );
      await storageService.saveUser(updated);
    }
  }
}
