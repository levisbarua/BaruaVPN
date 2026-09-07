import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import 'core_providers.dart';

final authStateProvider = StreamProvider<UserModel?>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return repo.authStateChanges;
});

class AuthStateNotifier extends StateNotifier<AsyncValue<UserModel?>> {
  final Ref ref;

  AuthStateNotifier(this.ref) : super(const AsyncValue.loading()) {
    _loadInitialUser();
  }

  void _loadInitialUser() {
    final repo = ref.read(authRepositoryProvider);
    final user = repo.currentUser;
    state = AsyncValue.data(user);
  }

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final user = await ref.read(authRepositoryProvider).login(email, password);
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> register(String email, String password, String name) async {
    state = const AsyncValue.loading();
    try {
      final user = await ref.read(authRepositoryProvider).register(email, password, name);
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> loginWithGoogle() async {
    state = const AsyncValue.loading();
    try {
      final user = await ref.read(authRepositoryProvider).loginWithGoogle();
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> loginAsGuest() async {
    state = const AsyncValue.loading();
    try {
      final user = await ref.read(authRepositoryProvider).loginAsGuest();
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> sendPasswordReset(String email) async {
    await ref.read(authRepositoryProvider).sendPasswordReset(email);
  }

  Future<void> logout() async {
    await ref.read(authRepositoryProvider).logout();
    state = const AsyncValue.data(null);
  }

  Future<void> upgradeToPremium() async {
    await ref.read(authRepositoryProvider).upgradeToPremium();
    _loadInitialUser();
  }
}

final authNotifierProvider = StateNotifierProvider<AuthStateNotifier, AsyncValue<UserModel?>>((ref) {
  return AuthStateNotifier(ref);
});
