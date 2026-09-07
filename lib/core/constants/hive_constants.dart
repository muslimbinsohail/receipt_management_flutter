/// Hive box names and key constants
class HiveConstants {
  HiveConstants._();

  // Box Names
  static const String receiptsBox = 'receipts';
  static const String businessProfilesBox = 'business_profiles';
  static const String customersBox = 'customers';
  static const String settingsBox = 'settings';
  static const String syncQueueBox = 'sync_queue';
  static const String authBox = 'auth';

  // Settings Keys
  static const String themeMode = 'theme_mode';
  static const String defaultTemplateType = 'default_template_type';
  static const String autoSync = 'auto_sync';
  static const String defaultCurrency = 'default_currency';
  static const String defaultTaxRate = 'default_tax_rate';
  static const String activeBusinessProfileId = 'active_business_profile_id';
  static const String lastSyncTimestamp = 'last_sync_timestamp';
  static const String isFirstLaunch = 'is_first_launch';
  static const String userId = 'user_id';
  static const String userEmail = 'user_email';
  static const String userName = 'user_name';

  // Type Adapter IDs
  static const int receiptModelId = 0;
  static const int receiptItemModelId = 1;
  static const int businessProfileModelId = 2;
  static const int customerModelId = 3;
  static const int syncQueueModelId = 4;
  static const int receiptStatusId = 5;
  static const int syncStatusId = 6;
  static const int templateTypeId = 7;
  static const int syncOperationId = 8;
}
