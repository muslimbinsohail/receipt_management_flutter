import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:receipt_management_flutter/core/constants/app_constants.dart';
import 'package:receipt_management_flutter/core/enums/sync_operation.dart';
import 'package:receipt_management_flutter/core/enums/sync_status.dart';
import 'package:receipt_management_flutter/core/utils/snackbar_helper.dart';
import 'package:receipt_management_flutter/data/local/receipt_local_source.dart';
import 'package:receipt_management_flutter/data/local/settings_local_source.dart';
import 'package:receipt_management_flutter/data/models/sync_queue_model.dart';
import 'package:receipt_management_flutter/data/remote/firestore_service.dart';
import 'package:receipt_management_flutter/data/repositories/sync_repository.dart';
import 'package:receipt_management_flutter/services/connectivity_service.dart';

/// Background sync engine that processes pending operations
class SyncService extends GetxService {
  final ConnectivityService _connectivityService;
  final SyncRepository _syncRepository;
  final FirestoreService _firestoreService;
  final ReceiptLocalSource _receiptLocalSource;
  final SettingsLocalSource _settingsLocalSource;

  final RxBool isSyncing = false.obs;
  final RxInt pendingCount = 0.obs;
  final RxString lastSyncTime = ''.obs;

  Worker? _connectivityWorker;
  Timer? _syncTimer;
  bool _disposed = false;

  SyncService({
    required ConnectivityService connectivityService,
    required SyncRepository syncRepository,
    required FirestoreService firestoreService,
    required ReceiptLocalSource receiptLocalSource,
    required SettingsLocalSource settingsLocalSource,
  })  : _connectivityService = connectivityService,
        _syncRepository = syncRepository,
        _firestoreService = firestoreService,
        _receiptLocalSource = receiptLocalSource,
        _settingsLocalSource = settingsLocalSource;

  @override
  void onInit() {
    super.onInit();
    _updatePendingCount();

    // Watch connectivity changes — sync when reconnected
    _connectivityWorker = ever(
      _connectivityService.isConnected,
      (bool connected) {
        if (connected && !_disposed) {
          _debouncedSync();
        }
      },
    );

    // Periodic sync every 5 minutes
    _syncTimer = Timer.periodic(
      const Duration(minutes: 5),
      (_) {
        if (_connectivityService.isConnected.value && !_disposed) {
          syncAll();
        }
      },
    );
  }

  Timer? _debounceTimer;

  void _debouncedSync() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(AppConstants.syncDebounce, () {
      if (!_disposed) syncAll();
    });
  }

  /// Process all pending sync operations
  Future<void> syncAll() async {
    if (isSyncing.value || _disposed) return;
    if (!_connectivityService.isConnected.value) return;

    final userId = _getUserId();
    if (userId == null) return;

    isSyncing.value = true;
    int syncedCount = 0;
    bool hadErrors = false;

    try {
      final pendingOps = _syncRepository.getPendingOperations();
      if (pendingOps.isEmpty) {
        isSyncing.value = false;
        return;
      }

      for (final op in pendingOps) {
        if (_disposed || !_connectivityService.isConnected.value) break;

        try {
          await _processOperation(userId, op);
          await _syncRepository.removeFromQueue(op.id);
          syncedCount++;
        } catch (e) {
          hadErrors = true;
          await _syncRepository.incrementRetryCount(op.id, e.toString());

          if (op.retryCount >= AppConstants.maxSyncRetries) {
            debugPrint('Max retries exceeded for ${op.documentId}: $e');
          }
        }
      }

      // Remove failed items that exceeded max retries
      await _syncRepository.removeFailedItems();

      // Update last sync timestamp
      await _settingsLocalSource.setLastSyncTimestamp(
        DateTime.now().millisecondsSinceEpoch,
      );

      _updatePendingCount();

      if (syncedCount > 0) {
        SnackbarHelper.syncComplete(syncedCount);
      }
      if (hadErrors) {
        SnackbarHelper.syncFailed();
      }
    } catch (e) {
      debugPrint('Sync error: $e');
    } finally {
      if (!_disposed) {
        isSyncing.value = false;
      }
    }
  }

  /// Process a single sync operation
  Future<void> _processOperation(
      String userId, SyncQueueModel operation) async {
    switch (operation.operation) {
      case SyncOperation.create:
      case SyncOperation.update:
        if (operation.data != null) {
          final receipt =
              _receiptLocalSource.getReceiptById(operation.documentId);
          if (receipt != null) {
            await _firestoreService.upsertReceipt(userId, receipt);
            await _receiptLocalSource.updateSyncStatus(
                operation.documentId, SyncStatus.synced);
          }
        }
        break;

      case SyncOperation.delete:
        await _firestoreService.deleteReceipt(userId, operation.documentId);
        await _receiptLocalSource.permanentDelete(operation.documentId);
        break;
    }
  }

  void _updatePendingCount() {
    if (!_disposed) {
      pendingCount.value = _syncRepository.pendingCount;
    }
  }

  String? _getUserId() {
    try {
      return Get.find<String>(tag: 'userId');
    } catch (_) {
      return null;
    }
  }

  /// Force a full sync
  Future<void> forceSync() async {
    await _connectivityService.forceCheck();
    if (_connectivityService.isConnected.value) {
      await syncAll();
    } else {
      SnackbarHelper.offline();
    }
  }

  @override
  void onClose() {
    _disposed = true;
    _connectivityWorker?.dispose();
    _syncTimer?.cancel();
    _debounceTimer?.cancel();
    super.onClose();
  }
}
