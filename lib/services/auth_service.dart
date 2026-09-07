import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import '../core/errors/app_exception.dart';

abstract class AuthService {
  Stream<UserModel?> get authStateChanges;
  UserModel? get currentUser;
  Future<UserModel> signInWithEmailPassword(String email, String password);
  Future<UserModel> registerWithEmailPassword(String email, String password, String name);
  Future<UserModel> signInWithGoogle();
  Future<UserModel> signInAsGuest();
  Future<void> sendPasswordResetEmail(String email);
  Future<void> signOut();
}

class FirebaseAuthService implements AuthService {
  FirebaseAuth? _auth;
  bool _firebaseAvailable = false;
  UserModel? _mockUser;

  FirebaseAuthService() {
    try {
      _auth = FirebaseAuth.instance;
      _firebaseAvailable = true;
    } catch (e) {
      debugPrint('Firebase Auth initialization check (offline/mock mode active): $e');
      _firebaseAvailable = false;
    }
  }

  @override
  Stream<UserModel?> get authStateChanges {
    if (_firebaseAvailable && _auth != null) {
      return _auth!.authStateChanges().map((user) {
        if (user == null) return _mockUser;
        return UserModel(
          id: user.uid,
          email: user.email ?? '',
          displayName: user.displayName ?? (user.email?.split('@').first ?? 'Barua User'),
          isGuest: user.isAnonymous,
          isPremium: false,
        );
      });
    }
    return Stream.value(_mockUser);
  }

  @override
  UserModel? get currentUser {
    if (_firebaseAvailable && _auth != null && _auth!.currentUser != null) {
      final u = _auth!.currentUser!;
      return UserModel(
        id: u.uid,
        email: u.email ?? '',
        displayName: u.displayName ?? (u.email?.split('@').first ?? 'Barua User'),
        isGuest: u.isAnonymous,
        isPremium: false,
      );
    }
    return _mockUser;
  }

  @override
  Future<UserModel> signInWithEmailPassword(String email, String password) async {
    if (_firebaseAvailable && _auth != null) {
      try {
        final cred = await _auth!.signInWithEmailAndPassword(email: email, password: password);
        final u = cred.user!;
        return UserModel(
          id: u.uid,
          email: u.email ?? email,
          displayName: u.displayName ?? email.split('@').first,
          isGuest: false,
          isPremium: false,
        );
      } on FirebaseAuthException catch (e) {
        throw AuthException(e.message ?? 'Authentication failed', code: e.code);
      }
    } else {
      // Local development simulation
      await Future.delayed(const Duration(milliseconds: 900));
      _mockUser = UserModel(
        id: 'user_${email.hashCode.abs()}',
        email: email,
        displayName: email.split('@').first,
        isGuest: false,
        isPremium: false,
      );
      return _mockUser!;
    }
  }

  @override
  Future<UserModel> registerWithEmailPassword(String email, String password, String name) async {
    if (_firebaseAvailable && _auth != null) {
      try {
        final cred = await _auth!.createUserWithEmailAndPassword(email: email, password: password);
        final u = cred.user!;
        await u.updateDisplayName(name);
        return UserModel(
          id: u.uid,
          email: u.email ?? email,
          displayName: name,
          isGuest: false,
          isPremium: false,
        );
      } on FirebaseAuthException catch (e) {
        throw AuthException(e.message ?? 'Registration failed', code: e.code);
      }
    } else {
      await Future.delayed(const Duration(milliseconds: 900));
      _mockUser = UserModel(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        email: email,
        displayName: name,
        isGuest: false,
        isPremium: false,
      );
      return _mockUser!;
    }
  }

  @override
  Future<UserModel> signInWithGoogle() async {
    if (_firebaseAvailable && _auth != null) {
      try {
        final provider = GoogleAuthProvider();
        final cred = await _auth!.signInWithProvider(provider);
        final u = cred.user!;
        return UserModel(
          id: u.uid,
          email: u.email ?? '',
          displayName: u.displayName ?? 'Google User',
          isGuest: false,
          isPremium: false,
        );
      } on FirebaseAuthException catch (e) {
        throw AuthException(e.message ?? 'Google Sign-in failed', code: e.code);
      }
    } else {
      await Future.delayed(const Duration(milliseconds: 800));
      _mockUser = const UserModel(
        id: 'google_user_101',
        email: 'google.pilot@baruavpn.com',
        displayName: 'Google Pilot',
        isGuest: false,
        isPremium: false,
      );
      return _mockUser!;
    }
  }

  @override
  Future<UserModel> signInAsGuest() async {
    if (_firebaseAvailable && _auth != null) {
      try {
        final cred = await _auth!.signInAnonymously();
        final u = cred.user!;
        return UserModel(
          id: u.uid,
          email: 'guest@baruavpn.com',
          displayName: 'Guest Explorer',
          isGuest: true,
          isPremium: false,
        );
      } on FirebaseAuthException catch (e) {
        throw AuthException(e.message ?? 'Guest sign-in failed', code: e.code);
      }
    } else {
      await Future.delayed(const Duration(milliseconds: 600));
      _mockUser = UserModel.guest();
      return _mockUser!;
    }
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    if (_firebaseAvailable && _auth != null) {
      try {
        await _auth!.sendPasswordResetEmail(email: email);
      } on FirebaseAuthException catch (e) {
        throw AuthException(e.message ?? 'Failed to send reset email', code: e.code);
      }
    } else {
      await Future.delayed(const Duration(milliseconds: 600));
    }
  }

  @override
  Future<void> signOut() async {
    if (_firebaseAvailable && _auth != null) {
      await _auth!.signOut();
    }
    _mockUser = null;
  }
}
