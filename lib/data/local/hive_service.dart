import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:receipt_management_flutter/core/constants/hive_constants.dart';
import 'package:receipt_management_flutter/hive_registrar.g.dart';
import 'package:receipt_management_flutter/data/models/receipt_model.dart';
import 'package:receipt_management_flutter/data/models/business_profile_model.dart';
import 'package:receipt_management_flutter/data/models/sync_queue_model.dart';

/// Manages Hive initialization and box access
class HiveService {
  static bool _initialized = false;

  /// Initialize Hive and register all type adapters
  static Future<void> init() async {
    if (_initialized) return;

    await Hive.initFlutter();

    // Register all generated type adapters
    Hive.registerAdapters();

    // Open all boxes
    await Future.wait([
      Hive.openBox<ReceiptModel>(HiveConstants.receiptsBox),
      Hive.openBox<BusinessProfileModel>(HiveConstants.businessProfilesBox),
      Hive.openBox(HiveConstants.settingsBox),
      Hive.openBox<SyncQueueModel>(HiveConstants.syncQueueBox),
      Hive.openBox(HiveConstants.authBox),
    ]);

    _initialized = true;
  }

  /// Get receipts box
  static Box<ReceiptModel> get receiptsBox =>
      Hive.box<ReceiptModel>(HiveConstants.receiptsBox);

  /// Get business profiles box
  static Box<BusinessProfileModel> get businessProfilesBox =>
      Hive.box<BusinessProfileModel>(HiveConstants.businessProfilesBox);

  /// Get settings box
  static Box get settingsBox => Hive.box(HiveConstants.settingsBox);

  /// Get sync queue box
  static Box<SyncQueueModel> get syncQueueBox =>
      Hive.box<SyncQueueModel>(HiveConstants.syncQueueBox);

  /// Get auth box
  static Box get authBox => Hive.box(HiveConstants.authBox);

  /// Clear all data (for logout)
  static Future<void> clearAll() async {
    await receiptsBox.clear();
    await businessProfilesBox.clear();
    await syncQueueBox.clear();
    await authBox.clear();
  }

  /// Close all boxes
  static Future<void> close() async {
    await Hive.close();
    _initialized = false;
  }
}
