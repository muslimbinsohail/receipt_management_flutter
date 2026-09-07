import 'package:receipt_management_flutter/data/local/hive_service.dart';
import 'package:receipt_management_flutter/data/models/sync_queue_model.dart';

/// Repository for managing the sync queue
class SyncRepository {
  /// Add an operation to the sync queue
  Future<void> addToQueue(SyncQueueModel item) async {
    await HiveService.syncQueueBox.put(item.id, item);
  }

  /// Get all pending sync operations ordered by timestamp
  List<SyncQueueModel> getPendingOperations() {
    final items = HiveService.syncQueueBox.values.toList();
    items.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    return items;
  }

  /// Remove a completed sync operation
  Future<void> removeFromQueue(String id) async {
    await HiveService.syncQueueBox.delete(id);
  }

  /// Remove all queue items for a specific document
  Future<void> removeByDocumentId(String documentId) async {
    final keysToDelete = <String>[];
    for (final entry in HiveService.syncQueueBox.toMap().entries) {
      if (entry.value.documentId == documentId) {
        keysToDelete.add(entry.key);
      }
    }
    for (final key in keysToDelete) {
      await HiveService.syncQueueBox.delete(key);
    }
  }

  /// Update retry count for a failed operation
  Future<void> incrementRetryCount(String id, String error) async {
    final item = HiveService.syncQueueBox.get(id);
    if (item != null) {
      item.retryCount++;
      item.lastError = error;
      await item.save();
    }
  }

  /// Get count of pending operations
  int get pendingCount => HiveService.syncQueueBox.length;

  /// Check if queue is empty
  bool get isEmpty => HiveService.syncQueueBox.isEmpty;

  /// Clear all items (after full sync)
  Future<void> clearAll() async {
    await HiveService.syncQueueBox.clear();
  }

  /// Remove items that exceeded max retries
  Future<List<SyncQueueModel>> removeFailedItems() async {
    final failed = HiveService.syncQueueBox.values
        .where((item) => item.hasExceededMaxRetries)
        .toList();

    for (final item in failed) {
      await HiveService.syncQueueBox.delete(item.id);
    }

    return failed;
  }
}
