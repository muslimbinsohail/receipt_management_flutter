import 'package:hive_ce/hive.dart';
import 'package:receipt_management_flutter/core/enums/receipt_status.dart';
import 'package:receipt_management_flutter/core/enums/sync_operation.dart';
import 'package:receipt_management_flutter/core/enums/sync_status.dart';
import 'package:receipt_management_flutter/core/enums/template_type.dart';
import 'package:receipt_management_flutter/data/models/business_profile_model.dart';
import 'package:receipt_management_flutter/data/models/customer_model.dart';
import 'package:receipt_management_flutter/data/models/receipt_item_model.dart';
import 'package:receipt_management_flutter/data/models/receipt_model.dart';
import 'package:receipt_management_flutter/data/models/sync_queue_model.dart';

/// Extension to register all Hive type adapters
extension HiveRegistrar on HiveInterface {
  void registerAdapters() {
    if (!isAdapterRegistered(0)) registerAdapter(ReceiptModelAdapter());
    if (!isAdapterRegistered(1)) registerAdapter(ReceiptItemModelAdapter());
    if (!isAdapterRegistered(2)) registerAdapter(BusinessProfileModelAdapter());
    if (!isAdapterRegistered(3)) registerAdapter(CustomerModelAdapter());
    if (!isAdapterRegistered(4)) registerAdapter(SyncQueueModelAdapter());
    if (!isAdapterRegistered(5)) registerAdapter(ReceiptStatusAdapter());
    if (!isAdapterRegistered(6)) registerAdapter(SyncStatusAdapter());
    if (!isAdapterRegistered(7)) registerAdapter(TemplateTypeAdapter());
    if (!isAdapterRegistered(8)) registerAdapter(SyncOperationAdapter());
  }
}
