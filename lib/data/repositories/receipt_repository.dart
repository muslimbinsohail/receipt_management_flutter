import 'package:get/get.dart';
import 'package:receipt_management_flutter/core/enums/sync_operation.dart';
import 'package:receipt_management_flutter/core/enums/sync_status.dart';
import 'package:receipt_management_flutter/core/constants/firestore_constants.dart';
import 'package:receipt_management_flutter/data/local/receipt_local_source.dart';
import 'package:receipt_management_flutter/data/models/receipt_model.dart';
import 'package:receipt_management_flutter/data/models/sync_queue_model.dart';
import 'package:receipt_management_flutter/data/remote/firestore_service.dart';
import 'package:receipt_management_flutter/data/repositories/sync_repository.dart';
import 'package:receipt_management_flutter/services/connectivity_service.dart';
import 'package:uuid/uuid.dart';

/// Offline-first receipt repository
/// All CRUD operations hit Hive first (instant), then queue for Firestore sync
class ReceiptRepository {
  final ReceiptLocalSource _localSource;
  final FirestoreService _firestoreService;
  final SyncRepository _syncRepository;
  final ConnectivityService _connectivityService;

  ReceiptRepository({
    required ReceiptLocalSource localSource,
    required FirestoreService firestoreService,
    required SyncRepository syncRepository,
    required ConnectivityService connectivityService,
  })  : _localSource = localSource,
        _firestoreService = firestoreService,
        _syncRepository = syncRepository,
        _connectivityService = connectivityService;

  /// Create a new receipt — saves locally first, then queues sync
  Future<ReceiptModel> createReceipt(ReceiptModel receipt) async {
    // 1. Save to Hive (instant)
    final now = DateTime.now();
    final newReceipt = receipt.copyWith(
      syncStatus: SyncStatus.pending,
      createdAt: now,
      updatedAt: now,
    );
    await _localSource.createReceipt(newReceipt);

    // 2. Queue for sync
    await _syncRepository.addToQueue(
      SyncQueueModel(
        id: const Uuid().v4(),
        operation: SyncOperation.create,
        collectionPath: FirestoreConstants.receiptsCollection,
        documentId: newReceipt.id,
        data: newReceipt.toFirestore(),
        timestamp: now,
      ),
    );

    // 3. If online, try immediate sync
    _tryImmediateSync(newReceipt);

    return newReceipt;
  }

  /// Update an existing receipt
  Future<ReceiptModel> updateReceipt(ReceiptModel receipt) async {
    final now = DateTime.now();
    final updated = receipt.copyWith(
      syncStatus: SyncStatus.pending,
      updatedAt: now,
    );

    // 1. Update in Hive (instant)
    await _localSource.createReceipt(updated); // put overwrites

    // 2. Queue for sync
    await _syncRepository.addToQueue(
      SyncQueueModel(
        id: const Uuid().v4(),
        operation: SyncOperation.update,
        collectionPath: FirestoreConstants.receiptsCollection,
        documentId: updated.id,
        data: updated.toFirestore(),
        timestamp: now,
      ),
    );

    // 3. Try immediate sync
    _tryImmediateSync(updated);

    return updated;
  }

  /// Soft delete a receipt
  Future<void> deleteReceipt(String id) async {
    // 1. Soft delete in Hive
    await _localSource.deleteReceipt(id);

    // 2. Queue delete for sync
    await _syncRepository.addToQueue(
      SyncQueueModel(
        id: const Uuid().v4(),
        operation: SyncOperation.delete,
        collectionPath: FirestoreConstants.receiptsCollection,
        documentId: id,
        timestamp: DateTime.now(),
      ),
    );
  }

  /// Get all active receipts
  List<ReceiptModel> getAllReceipts() {
    return _localSource.getAllReceipts();
  }

  /// Get receipt by ID
  ReceiptModel? getReceiptById(String id) {
    return _localSource.getReceiptById(id);
  }

  /// Search receipts
  List<ReceiptModel> searchReceipts(String query) {
    return _localSource.searchReceipts(query);
  }

  /// Get stats
  int get totalCount => _localSource.totalCount;
  double get totalRevenue => _localSource.totalRevenue;
  int get pendingSyncCount => _localSource.pendingSyncCount;

  /// Duplicate a receipt
  Future<ReceiptModel> duplicateReceipt(ReceiptModel original) async {
    final duplicate = original.copyWith(
      id: const Uuid().v4(),
      receiptNumber:
          '${original.receiptNumber}-COPY',
      status: original.status,
      syncStatus: SyncStatus.pending,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    return createReceipt(duplicate);
  }

  /// Try to sync immediately if online
  void _tryImmediateSync(ReceiptModel receipt) {
    if (_connectivityService.isConnected.value) {
      final userId = Get.find<String>(tag: 'userId');
      _firestoreService.upsertReceipt(userId, receipt).then((_) {
        _localSource.updateSyncStatus(receipt.id, SyncStatus.synced);
        // Remove from sync queue
        _syncRepository.removeByDocumentId(receipt.id);
      }).catchError((_) {
        // Will be retried by SyncService
      });
    }
  }

  /// Pull remote changes and merge with local
  Future<void> pullRemoteChanges(String userId, DateTime? lastSync) async {
    try {
      final List<ReceiptModel> remoteReceipts;
      if (lastSync != null) {
        remoteReceipts =
            await _firestoreService.getReceiptsUpdatedAfter(userId, lastSync);
      } else {
        remoteReceipts = await _firestoreService.getAllReceipts(userId);
      }

      for (final remote in remoteReceipts) {
        final local = _localSource.getReceiptById(remote.id);
        if (local == null) {
          // New remote receipt, save locally
          await _localSource.createReceipt(
              remote.copyWith(syncStatus: SyncStatus.synced));
        } else if (local.syncStatus == SyncStatus.synced) {
          // No local changes, accept remote
          await _localSource.createReceipt(
              remote.copyWith(syncStatus: SyncStatus.synced));
        }
        // If local has pending changes, skip (local wins)
      }
    } catch (_) {
      // Silent fail — will retry next sync cycle
    }
  }
}
