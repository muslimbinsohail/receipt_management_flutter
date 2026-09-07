import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:receipt_management_flutter/app/routes/app_routes.dart';
import 'package:receipt_management_flutter/core/exceptions/app_exception.dart';
import 'package:receipt_management_flutter/core/utils/snackbar_helper.dart';
import 'package:receipt_management_flutter/data/local/hive_service.dart';
import 'package:receipt_management_flutter/data/repositories/auth_repository.dart';
import 'package:receipt_management_flutter/services/error_handler_service.dart';

class AuthController extends GetxController {
  final AuthRepository _authRepository = Get.find<AuthRepository>();
  final ErrorHandlerService _errorHandler = Get.find<ErrorHandlerService>();

  // Form controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final nameController = TextEditingController();

  // Form key
  final formKey = GlobalKey<FormState>();

  // State
  final RxBool isLoading = false.obs;
  final RxBool isLogin = true.obs;
  final RxBool obscurePassword = true.obs;
  final RxBool obscureConfirmPassword = true.obs;

  void toggleLoginRegister() {
    isLogin.toggle();
    clearForm();
  }

  void togglePasswordVisibility() => obscurePassword.toggle();
  void toggleConfirmPasswordVisibility() => obscureConfirmPassword.toggle();

  /// Sign in with email
  Future<void> signIn() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;
    try {
      await _authRepository.signInWithEmail(
        email: emailController.text.trim(),
        password: passwordController.text,
      );
      _onAuthSuccess();
    } catch (e) {
      _errorHandler.handleError(e, context: 'Sign In');
    } finally {
      isLoading.value = false;
    }
  }

  /// Register with email
  Future<void> register() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;
    try {
      await _authRepository.registerWithEmail(
        email: emailController.text.trim(),
        password: passwordController.text,
        displayName: nameController.text.trim(),
      );
      _onAuthSuccess();
    } catch (e) {
      _errorHandler.handleError(e, context: 'Register');
    } finally {
      isLoading.value = false;
    }
  }

  /// Continue without signing in (offline mode)
  void continueOffline() {
    Get.offAllNamed(AppRoutes.home);
    SnackbarHelper.info(
      'You\'re in offline mode. Sign in later to sync your data.',
      title: 'Offline Mode',
    );
  }

  /// Forgot password
  Future<void> forgotPassword() async {
    final email = emailController.text.trim();
    if (email.isEmpty) {
      SnackbarHelper.warning('Please enter your email first.');
      return;
    }
    try {
      await _authRepository.sendPasswordReset(email);
      SnackbarHelper.success('Password reset email sent to $email');
    } catch (e) {
      _errorHandler.handleError(e, context: 'Password Reset');
    }
  }

  void _onAuthSuccess() {
    // Store userId for GetX lookup
    final userId = _authRepository.userId;
    if (userId != null) {
      Get.put<String>(userId, tag: 'userId');
    }

    clearForm();
    Get.offAllNamed(AppRoutes.home);
    SnackbarHelper.success('Welcome back!');
  }

  void clearForm() {
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    nameController.clear();
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      await _authRepository.signOut();
      await HiveService.clearAll();
      Get.offAllNamed(AppRoutes.login);
      SnackbarHelper.info('Signed out successfully.');
    } catch (e) {
      _errorHandler.handleError(e, context: 'Sign Out');
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    nameController.dispose();
    super.onClose();
  }
}
