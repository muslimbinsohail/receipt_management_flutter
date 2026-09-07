import 'package:intl/intl.dart';
import 'package:receipt_management_flutter/core/constants/app_constants.dart';

/// Formatting utilities for currency, dates, and numbers
class Formatters {
  Formatters._();

  /// Format a number as currency
  static String currency(
    double amount, {
    String? symbol,
    int decimalDigits = 2,
  }) {
    final currencySymbol = symbol ?? AppConstants.defaultCurrencySymbol;
    final formatter = NumberFormat.currency(
      symbol: '$currencySymbol ',
      decimalDigits: decimalDigits,
    );
    return formatter.format(amount);
  }

  /// Format a number with commas
  static String number(double value, {int decimalDigits = 2}) {
    final formatter = NumberFormat('#,##0.${'0' * decimalDigits}');
    return formatter.format(value);
  }

  /// Format a number as percentage
  static String percentage(double value, {int decimalDigits = 1}) {
    return '${value.toStringAsFixed(decimalDigits)}%';
  }

  /// Format date for display
  static String date(DateTime dateTime) {
    return DateFormat(AppConstants.displayDateFormat).format(dateTime);
  }

  /// Format time for display
  static String time(DateTime dateTime) {
    return DateFormat(AppConstants.displayTimeFormat).format(dateTime);
  }

  /// Format date and time for display
  static String dateTime(DateTime dateTime) {
    return DateFormat(AppConstants.displayDateTimeFormat).format(dateTime);
  }

  /// Format date for receipt
  static String receiptDate(DateTime dateTime) {
    return DateFormat(AppConstants.receiptDateFormat).format(dateTime);
  }

  /// Generate a receipt number
  static String generateReceiptNumber() {
    final now = DateTime.now();
    final timestamp = '${now.year}${now.month.toString().padLeft(2, '0')}'
        '${now.day.toString().padLeft(2, '0')}'
        '${now.hour.toString().padLeft(2, '0')}'
        '${now.minute.toString().padLeft(2, '0')}'
        '${now.second.toString().padLeft(2, '0')}';
    return '${AppConstants.receiptNumberPrefix}-$timestamp';
  }

  /// Format file size
  static String fileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  /// Relative time (e.g., "2 hours ago")
  static String relativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);

    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return date(dateTime);
  }
}
