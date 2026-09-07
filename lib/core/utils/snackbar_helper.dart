import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Styled snackbar helper for consistent messaging
class SnackbarHelper {
  SnackbarHelper._();

  static void success(String message, {String title = 'Success'}) {
    if (Get.isSnackbarOpen) Get.closeCurrentSnackbar();
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF1DB954),
      colorText: Colors.white,
      borderRadius: 12,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      icon: const Icon(Icons.check_circle_rounded, color: Colors.white),
      duration: const Duration(seconds: 3),
      animationDuration: const Duration(milliseconds: 400),
      snackStyle: SnackStyle.FLOATING,
    );
  }

  static void error(String message, {String title = 'Error'}) {
    if (Get.isSnackbarOpen) Get.closeCurrentSnackbar();
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFFE53935),
      colorText: Colors.white,
      borderRadius: 12,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      icon: const Icon(Icons.error_rounded, color: Colors.white),
      duration: const Duration(seconds: 4),
      animationDuration: const Duration(milliseconds: 400),
      snackStyle: SnackStyle.FLOATING,
    );
  }

  static void warning(String message, {String title = 'Warning'}) {
    if (Get.isSnackbarOpen) Get.closeCurrentSnackbar();
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFFFFA726),
      colorText: Colors.white,
      borderRadius: 12,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      icon: const Icon(Icons.warning_rounded, color: Colors.white),
      duration: const Duration(seconds: 3),
      animationDuration: const Duration(milliseconds: 400),
      snackStyle: SnackStyle.FLOATING,
    );
  }

  static void info(String message, {String title = 'Info'}) {
    if (Get.isSnackbarOpen) Get.closeCurrentSnackbar();
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF42A5F5),
      colorText: Colors.white,
      borderRadius: 12,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      icon: const Icon(Icons.info_rounded, color: Colors.white),
      duration: const Duration(seconds: 3),
      animationDuration: const Duration(milliseconds: 400),
      snackStyle: SnackStyle.FLOATING,
    );
  }

  static void offline() {
    info(
      'You are offline. Changes will sync when connected.',
      title: 'Offline Mode',
    );
  }

  static void syncing() {
    info(
      'Syncing your data...',
      title: 'Sync',
    );
  }

  static void syncComplete(int count) {
    success(
      '$count item${count > 1 ? 's' : ''} synced successfully.',
      title: 'Sync Complete',
    );
  }

  static void syncFailed() {
    error(
      'Some items failed to sync. Will retry automatically.',
      title: 'Sync Failed',
    );
  }
}
