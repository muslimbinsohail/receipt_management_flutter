import 'package:get/get.dart';
import 'package:receipt_management_flutter/data/remote/auth_service.dart';
import 'package:receipt_management_flutter/core/exceptions/app_exception.dart';

/// Authentication repository wrapping AuthService with GetX reactivity
class AuthRepository {
  final AuthService _authService;

  AuthRepository({required AuthService authService})
      : _authService = authService;

  String? get userId => _authService.userId;
  bool get isSignedIn => _authService.isSignedIn;
  String? get userEmail => _authService.currentUser?.email;
  String? get userName => _authService.currentUser?.displayName;

  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    await _authService.signInWithEmail(email: email, password: password);
  }

  Future<void> registerWithEmail({
    required String email,
    required String password,
    String? displayName,
  }) async {
    await _authService.registerWithEmail(
      email: email,
      password: password,
      displayName: displayName,
    );
  }

  Future<void> signOut() async {
    await _authService.signOut();
  }

  Future<void> sendPasswordReset(String email) async {
    await _authService.sendPasswordReset(email);
  }

  Future<void> updateDisplayName(String name) async {
    await _authService.updateDisplayName(name);
  }

  Stream<bool> get authStateStream =>
      _authService.authStateChanges.map((user) => user != null);
}
