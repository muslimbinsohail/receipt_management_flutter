import 'package:hive_ce/hive.dart';
import 'package:receipt_management_flutter/core/enums/receipt_status.dart';
import 'package:receipt_management_flutter/core/enums/sync_status.dart';
import 'package:receipt_management_flutter/core/exceptions/app_exception.dart';
import 'package:receipt_management_flutter/data/local/hive_service.dart';
import 'package:receipt_management_flutter/data/models/receipt_model.dart';

/// Local data source for receipt CRUD operations using Hive
class ReceiptLocalSource {
  Box<ReceiptModel> get _box => HiveService.receiptsBox;

  /// Create a new receipt
  Future<void> createReceipt(ReceiptModel receipt) async {
    try {
      await _box.put(receipt.id, receipt);
    } catch (e) {
      throw StorageException.writeFailed('Failed to save receipt locally: $e');
    }
  }

  /// Update an existing receipt
  Future<void> updateReceipt(ReceiptModel receipt) async {
    try {
      final updated = receipt.copyWith(
        syncStatus: SyncStatus.pending,
        updatedAt: DateTime.now(),
      );
      await _box.put(updated.id, updated);
    } catch (e) {
      throw StorageException.writeFailed(
          'Failed to update receipt locally: $e');
    }
  }

  /// Soft delete a receipt
  Future<void> deleteReceipt(String id) async {
    try {
      final receipt = _box.get(id);
      if (receipt != null) {
        final deleted = receipt.copyWith(
          isDeleted: true,
          syncStatus: SyncStatus.pending,
          updatedAt: DateTime.now(),
        );
        await _box.put(id, deleted);
      }
    } catch (e) {
      throw StorageException.writeFailed(
          'Failed to delete receipt locally: $e');
    }
  }

  /// Hard delete (after successful sync)
  Future<void> permanentDelete(String id) async {
    try {
      await _box.delete(id);
    } catch (e) {
      throw StorageException.writeFailed('Failed to permanently delete: $e');
    }
  }

  /// Get all active receipts (not deleted)
  List<ReceiptModel> getAllReceipts() {
    try {
      return _box.values.where((r) => !r.isDeleted).toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } catch (e) {
      throw StorageException.readFailed('Failed to read receipts: $e');
    }
  }

  /// Get receipt by ID
  ReceiptModel? getReceiptById(String id) {
    try {
      return _box.get(id);
    } catch (e) {
      throw StorageException.readFailed('Failed to read receipt: $e');
    }
  }

  /// Search receipts by query
  List<ReceiptModel> searchReceipts(String query) {
    try {
      final lowerQuery = query.toLowerCase();
      return _box.values.where((r) {
        if (r.isDeleted) return false;
        return r.receiptNumber.toLowerCase().contains(lowerQuery) ||
            (r.customer?.name.toLowerCase().contains(lowerQuery) ?? false) ||
            (r.businessProfile?.name.toLowerCase().contains(lowerQuery) ??
                false) ||
            r.items.any(
                (item) => item.name.toLowerCase().contains(lowerQuery));
      }).toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } catch (e) {
      throw StorageException.readFailed('Failed to search receipts: $e');
    }
  }

  /// Get receipts pending sync
  List<ReceiptModel> getPendingSyncReceipts() {
    try {
      return _box.values
          .where((r) => r.syncStatus == SyncStatus.pending)
          .toList();
    } catch (e) {
      return [];
    }
  }

  /// Update sync status for a receipt
  Future<void> updateSyncStatus(String id, SyncStatus status) async {
    try {
      final receipt = _box.get(id);
      if (receipt != null) {
        final updated = receipt.copyWith(syncStatus: status);
        await _box.put(id, updated);
      }
    } catch (e) {
      // Silent fail for sync status updates
    }
  }

  /// Get total count of active receipts
  int get totalCount => _box.values.where((r) => !r.isDeleted).length;

  /// Get total revenue from all finalized receipts
  double get totalRevenue => _box.values
      .where((r) => !r.isDeleted && r.status.isFinalized)
      .fold(0.0, (sum, r) => sum + r.total);

  /// Get count of receipts pending sync
  int get pendingSyncCount =>
      _box.values.where((r) => r.syncStatus.isPending).length;

  /// Batch save receipts (for pull from Firestore)
  Future<void> batchSave(List<ReceiptModel> receipts) async {
    try {
      final Map<String, ReceiptModel> entries = {
        for (final r in receipts) r.id: r,
      };
      await _box.putAll(entries);
    } catch (e) {
      throw StorageException.writeFailed('Failed to batch save receipts: $e');
    }
  }
}
