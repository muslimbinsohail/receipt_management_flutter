import 'package:receipt_management_flutter/core/constants/hive_constants.dart';
import 'package:receipt_management_flutter/data/local/hive_service.dart';

/// Local source for app settings persistence
class SettingsLocalSource {
  /// Get a setting value
  T? getSetting<T>(String key) {
    try {
      return HiveService.settingsBox.get(key) as T?;
    } catch (e) {
      return null;
    }
  }

  /// Set a setting value
  Future<void> setSetting<T>(String key, T value) async {
    await HiveService.settingsBox.put(key, value);
  }

  /// Remove a setting
  Future<void> removeSetting(String key) async {
    await HiveService.settingsBox.delete(key);
  }

  // Convenience getters/setters

  bool get isDarkMode =>
      getSetting<bool>(HiveConstants.themeMode) ?? false;

  Future<void> setDarkMode(bool value) =>
      setSetting(HiveConstants.themeMode, value);

  bool get isAutoSync =>
      getSetting<bool>(HiveConstants.autoSync) ?? true;

  Future<void> setAutoSync(bool value) =>
      setSetting(HiveConstants.autoSync, value);

  String get defaultCurrency =>
      getSetting<String>(HiveConstants.defaultCurrency) ?? 'PKR';

  Future<void> setDefaultCurrency(String value) =>
      setSetting(HiveConstants.defaultCurrency, value);

  double get defaultTaxRate =>
      getSetting<double>(HiveConstants.defaultTaxRate) ?? 0.0;

  Future<void> setDefaultTaxRate(double value) =>
      setSetting(HiveConstants.defaultTaxRate, value);

  String? get activeBusinessProfileId =>
      getSetting<String>(HiveConstants.activeBusinessProfileId);

  Future<void> setActiveBusinessProfileId(String value) =>
      setSetting(HiveConstants.activeBusinessProfileId, value);

  int? get lastSyncTimestamp =>
      getSetting<int>(HiveConstants.lastSyncTimestamp);

  Future<void> setLastSyncTimestamp(int value) =>
      setSetting(HiveConstants.lastSyncTimestamp, value);

  bool get isFirstLaunch =>
      getSetting<bool>(HiveConstants.isFirstLaunch) ?? true;

  Future<void> setFirstLaunch(bool value) =>
      setSetting(HiveConstants.isFirstLaunch, value);

  int get defaultTemplateIndex =>
      getSetting<int>(HiveConstants.defaultTemplateType) ?? 0;

  Future<void> setDefaultTemplateIndex(int value) =>
      setSetting(HiveConstants.defaultTemplateType, value);
}
