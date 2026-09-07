/// App-wide constants
class AppConstants {
  AppConstants._();

  static const String appName = 'Receipt Manager';
  static const String appVersion = '1.0.0';

  // Sync
  static const int maxSyncRetries = 5;
  static const int syncBatchSize = 500;
  static const Duration syncDebounce = Duration(seconds: 2);
  static const Duration connectivityCheckInterval = Duration(seconds: 10);

  // Receipt
  static const String receiptNumberPrefix = 'REC';
  static const int receiptNumberLength = 8;
  static const double defaultTaxRate = 0.0;
  static const double defaultDiscountRate = 0.0;

  // Pagination
  static const int defaultPageSize = 20;

  // Validation
  static const int maxReceiptItems = 100;
  static const int maxNoteLength = 500;
  static const double maxItemPrice = 9999999.99;
  static const double maxQuantity = 99999;

  // Date Formats
  static const String displayDateFormat = 'MMM dd, yyyy';
  static const String displayTimeFormat = 'hh:mm a';
  static const String displayDateTimeFormat = 'MMM dd, yyyy • hh:mm a';
  static const String receiptDateFormat = 'dd/MM/yyyy';

  // Currency
  static const String defaultCurrency = 'PKR';
  static const String defaultCurrencySymbol = 'Rs.';

  // Placeholder image for business logo
  static const String defaultLogoPath = 'assets/images/default_logo.png';
}
