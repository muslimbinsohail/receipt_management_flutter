import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:receipt_management_flutter/app/routes/app_routes.dart';
import 'package:receipt_management_flutter/app/theme/app_colors.dart';
import 'package:receipt_management_flutter/app/theme/app_text_styles.dart';
import 'package:receipt_management_flutter/core/utils/formatters.dart';
import 'package:receipt_management_flutter/modules/home/controllers/home_controller.dart';
import 'package:receipt_management_flutter/modules/home/views/widgets/receipt_card.dart';
import 'package:receipt_management_flutter/modules/home/views/widgets/stats_summary.dart';
import 'package:receipt_management_flutter/modules/home/views/widgets/sync_status_indicator.dart';
import 'package:receipt_management_flutter/modules/home/views/widgets/empty_state_widget.dart';
import 'package:receipt_management_flutter/services/connectivity_service.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final connectivityService = Get.find<ConnectivityService>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Receipt Manager', style: AppTextStyles.h3),
        actions: [
          // Sync status
          Obx(() => SyncStatusIndicator(
                isOnline: connectivityService.isConnected.value,
                isSyncing: controller.isSyncing.value,
                pendingCount: controller.pendingSyncCount.value,
                onTap: controller.forceSync,
              )),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => Get.toNamed(AppRoutes.settings),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          controller.loadReceipts();
          await controller.forceSync();
        },
        child: CustomScrollView(
          slivers: [
            // Stats summary
            SliverToBoxAdapter(
              child: Obx(() => StatsSummary(
                    totalReceipts: controller.totalReceipts.value,
                    totalRevenue: controller.totalRevenue.value,
                    pendingSync: controller.pendingSyncCount.value,
                  )),
            ),

            // Search bar
            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TextField(
                  onChanged: controller.onSearchChanged,
                  decoration: InputDecoration(
                    hintText: 'Search receipts...',
                    prefixIcon: const Icon(Icons.search_rounded, size: 22),
                    suffixIcon: Obx(() => controller.searchQuery.value.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear_rounded, size: 20),
                            onPressed: () {
                              controller.onSearchChanged('');
                            },
                          )
                        : const SizedBox.shrink()),
                  ),
                ),
              ),
            ),

            // Filter chips
            SliverToBoxAdapter(
              child: Obx(() => SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        _filterChip('All', 0),
                        const SizedBox(width: 8),
                        _filterChip('Draft', 1),
                        const SizedBox(width: 8),
                        _filterChip('Finalized', 2),
                        const SizedBox(width: 8),
                        _filterChip('Voided', 3),
                      ],
                    ),
                  )),
            ),

            // Receipt list
            Obx(() {
              if (controller.isLoading.value) {
                return const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (controller.filteredReceipts.isEmpty) {
                return SliverFillRemaining(
                  child: EmptyStateWidget(
                    icon: Icons.receipt_long_outlined,
                    title: controller.searchQuery.value.isNotEmpty
                        ? 'No receipts found'
                        : 'No receipts yet',
                    subtitle: controller.searchQuery.value.isNotEmpty
                        ? 'Try a different search term'
                        : 'Tap + to create your first receipt',
                    onAction: controller.searchQuery.value.isEmpty
                        ? controller.goToCreateReceipt
                        : null,
                    actionLabel: 'Create Receipt',
                  ),
                );
              }

              return SliverPadding(
                padding: const EdgeInsets.only(bottom: 80),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final receipt = controller.filteredReceipts[index];
                      return ReceiptCard(
                        receipt: receipt,
                        onTap: () =>
                            controller.goToReceiptDetail(receipt.id),
                        onDelete: () =>
                            controller.deleteReceipt(receipt.id),
                        onDuplicate: () =>
                            controller.duplicateReceipt(receipt),
                      );
                    },
                    childCount: controller.filteredReceipts.length,
                  ),
                ),
              );
            }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: controller.goToCreateReceipt,
        icon: const Icon(Icons.add_rounded),
        label: const Text('New Receipt'),
      ),
    );
  }

  Widget _filterChip(String label, int index) {
    return Obx(() => ChoiceChip(
          label: Text(label),
          selected: controller.selectedFilter.value == index,
          onSelected: (_) => controller.setFilter(index),
          selectedColor: AppColors.primary.withValues(alpha: 0.15),
          labelStyle: TextStyle(
            color: controller.selectedFilter.value == index
                ? AppColors.primary
                : null,
            fontWeight: controller.selectedFilter.value == index
                ? FontWeight.w600
                : FontWeight.w400,
          ),
        ));
  }
}
