import 'package:firebase_auth/firebase_auth.dart';
import 'package:receipt_management_flutter/core/exceptions/app_exception.dart';

/// Firebase Authentication service wrapper
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Current user
  User? get currentUser => _auth.currentUser;

  /// Current user ID
  String? get userId => _auth.currentUser?.uid;

  /// Check if user is signed in
  bool get isSignedIn => _auth.currentUser != null;

  /// Auth state stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Sign in with email and password
  Future<UserCredential> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _mapAuthException(e);
    } catch (e) {
      throw AuthException.unknown(e.toString());
    }
  }

  /// Register with email and password
  Future<UserCredential> registerWithEmail({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      if (displayName != null && displayName.isNotEmpty) {
        await credential.user?.updateDisplayName(displayName);
      }

      return credential;
    } on FirebaseAuthException catch (e) {
      throw _mapAuthException(e);
    } catch (e) {
      throw AuthException.unknown(e.toString());
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw AuthException.unknown('Failed to sign out: $e');
    }
  }

  /// Send password reset email
  Future<void> sendPasswordReset(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw _mapAuthException(e);
    } catch (e) {
      throw AuthException.unknown(e.toString());
    }
  }

  /// Update user display name
  Future<void> updateDisplayName(String name) async {
    try {
      await _auth.currentUser?.updateDisplayName(name);
    } catch (e) {
      throw AuthException.unknown('Failed to update name: $e');
    }
  }

  /// Map Firebase auth exceptions to our custom exceptions
  AuthException _mapAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return AuthException.userNotFound();
      case 'wrong-password':
      case 'invalid-credential':
        return AuthException.invalidCredentials();
      case 'email-already-in-use':
        return AuthException.emailAlreadyInUse();
      case 'weak-password':
        return AuthException.weakPassword();
      case 'user-disabled':
        return const AuthException(
          message: 'This account has been disabled.',
          code: 'USER_DISABLED',
        );
      case 'too-many-requests':
        return const AuthException(
          message: 'Too many attempts. Please try again later.',
          code: 'TOO_MANY_REQUESTS',
        );
      case 'network-request-failed':
        return const AuthException(
          message:
              'Network error. Please check your connection and try again.',
          code: 'NETWORK_ERROR',
        );
      default:
        return AuthException.unknown(e.message);
    }
  }
}
