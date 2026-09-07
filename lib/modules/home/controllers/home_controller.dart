import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:receipt_management_flutter/app/routes/app_routes.dart';
import 'package:receipt_management_flutter/core/enums/receipt_status.dart';
import 'package:receipt_management_flutter/core/enums/sync_status.dart';
import 'package:receipt_management_flutter/core/utils/formatters.dart';
import 'package:receipt_management_flutter/core/utils/snackbar_helper.dart';
import 'package:receipt_management_flutter/data/models/receipt_model.dart';
import 'package:receipt_management_flutter/data/repositories/receipt_repository.dart';
import 'package:receipt_management_flutter/services/connectivity_service.dart';
import 'package:receipt_management_flutter/services/error_handler_service.dart';
import 'package:receipt_management_flutter/services/sync_service.dart';

class HomeController extends GetxController {
  final ReceiptRepository _receiptRepository = Get.find<ReceiptRepository>();
  final ConnectivityService _connectivityService =
      Get.find<ConnectivityService>();
  final SyncService _syncService = Get.find<SyncService>();
  final ErrorHandlerService _errorHandler = Get.find<ErrorHandlerService>();

  // State
  final RxList<ReceiptModel> receipts = <ReceiptModel>[].obs;
  final RxList<ReceiptModel> filteredReceipts = <ReceiptModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString searchQuery = ''.obs;
  final RxInt selectedFilter = 0.obs; // 0=All, 1=Draft, 2=Finalized, 3=Voided

  // Stats
  final RxInt totalReceipts = 0.obs;
  final RxDouble totalRevenue = 0.0.obs;
  final RxInt pendingSyncCount = 0.obs;

  // Connectivity
  bool get isOnline => _connectivityService.isConnected.value;
  RxBool get isSyncing => _syncService.isSyncing;

  @override
  void onInit() {
    super.onInit();
    loadReceipts();

    // Auto-refresh when search query changes
    debounce(searchQuery, (_) => _applyFilters(),
        time: const Duration(milliseconds: 300));

    // Watch connectivity for UI updates
    ever(_connectivityService.isConnected, (bool connected) {
      if (!connected) {
        SnackbarHelper.offline();
      }
    });
  }

  @override
  void onReady() {
    super.onReady();
    // Trigger sync on app start if online
    if (isOnline) {
      _syncService.syncAll();
    }
  }

  void loadReceipts() {
    try {
      isLoading.value = true;
      receipts.value = _receiptRepository.getAllReceipts();
      _updateStats();
      _applyFilters();
    } catch (e) {
      _errorHandler.handleError(e, context: 'Load Receipts');
    } finally {
      isLoading.value = false;
    }
  }

  void _updateStats() {
    totalReceipts.value = _receiptRepository.totalCount;
    totalRevenue.value = _receiptRepository.totalRevenue;
    pendingSyncCount.value = _receiptRepository.pendingSyncCount;
  }

  void _applyFilters() {
    var result = List<ReceiptModel>.from(receipts);

    // Apply search
    if (searchQuery.value.isNotEmpty) {
      result = _receiptRepository.searchReceipts(searchQuery.value);
    }

    // Apply status filter
    switch (selectedFilter.value) {
      case 1:
        result = result.where((r) => r.status.isDraft).toList();
        break;
      case 2:
        result = result.where((r) => r.status.isFinalized).toList();
        break;
      case 3:
        result = result.where((r) => r.status.isVoided).toList();
        break;
    }

    filteredReceipts.value = result;
  }

  void setFilter(int index) {
    selectedFilter.value = index;
    _applyFilters();
  }

  void onSearchChanged(String query) {
    searchQuery.value = query;
  }

  /// Delete a receipt
  Future<void> deleteReceipt(String id) async {
    try {
      await _receiptRepository.deleteReceipt(id);
      loadReceipts();
      SnackbarHelper.success('Receipt deleted');
    } catch (e) {
      _errorHandler.handleError(e, context: 'Delete Receipt');
    }
  }

  /// Duplicate a receipt
  Future<void> duplicateReceipt(ReceiptModel receipt) async {
    try {
      await _receiptRepository.duplicateReceipt(receipt);
      loadReceipts();
      SnackbarHelper.success('Receipt duplicated');
    } catch (e) {
      _errorHandler.handleError(e, context: 'Duplicate Receipt');
    }
  }

  /// Navigate to create receipt
  void goToCreateReceipt() {
    Get.toNamed(AppRoutes.createReceipt)?.then((_) => loadReceipts());
  }

  /// Navigate to receipt detail
  void goToReceiptDetail(String id) {
    Get.toNamed(AppRoutes.receiptDetail, arguments: id)
        ?.then((_) => loadReceipts());
  }

  /// Force sync
  Future<void> forceSync() async {
    await _syncService.forceSync();
    loadReceipts();
  }
}
