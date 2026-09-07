import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:receipt_management_flutter/app/routes/app_routes.dart';
import 'package:receipt_management_flutter/app/theme/app_colors.dart';
import 'package:receipt_management_flutter/app/theme/app_text_styles.dart';
import 'package:receipt_management_flutter/core/enums/receipt_status.dart';
import 'package:receipt_management_flutter/core/enums/sync_status.dart';
import 'package:receipt_management_flutter/core/enums/template_type.dart';
import 'package:receipt_management_flutter/core/utils/formatters.dart';
import 'package:receipt_management_flutter/core/utils/snackbar_helper.dart';
import 'package:receipt_management_flutter/data/models/receipt_model.dart';
import 'package:receipt_management_flutter/data/repositories/receipt_repository.dart';
import 'package:receipt_management_flutter/services/error_handler_service.dart';
import 'package:receipt_management_flutter/services/pdf_service.dart';

class ReceiptDetailScreen extends StatelessWidget {
  const ReceiptDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final receiptId = Get.arguments as String;
    final repository = Get.find<ReceiptRepository>();
    final errorHandler = Get.find<ErrorHandlerService>();
    final pdfService = PdfService();
    final receipt = repository.getReceiptById(receiptId);

    if (receipt == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Receipt')),
        body: const Center(child: Text('Receipt not found')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(receipt.receiptNumber, style: AppTextStyles.receiptNumber),
        actions: [
          PopupMenuButton<String>(
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'edit', child: Text('Edit')),
              const PopupMenuItem(value: 'duplicate', child: Text('Duplicate')),
              const PopupMenuItem(value: 'share', child: Text('Share PDF')),
              const PopupMenuItem(value: 'print', child: Text('Print')),
              if (receipt.status.isDraft)
                const PopupMenuItem(
                    value: 'finalize', child: Text('Finalize')),
              if (!receipt.status.isVoided)
                const PopupMenuItem(
                  value: 'void',
                  child: Text('Void Receipt',
                      style: TextStyle(color: AppColors.error)),
                ),
              const PopupMenuItem(
                value: 'delete',
                child: Text('Delete',
                    style: TextStyle(color: AppColors.error)),
              ),
            ],
            onSelected: (action) async {
              switch (action) {
                case 'edit':
                  Get.toNamed(AppRoutes.createReceipt, arguments: receipt);
                  break;
                case 'duplicate':
                  try {
                    await repository.duplicateReceipt(receipt);
                    SnackbarHelper.success('Receipt duplicated');
                    Get.back();
                  } catch (e) {
                    errorHandler.handleError(e);
                  }
                  break;
                case 'share':
                  try {
                    await pdfService.sharePdf(receipt);
                  } catch (e) {
                    errorHandler.handleError(e, context: 'Share PDF');
                  }
                  break;
                case 'print':
                  try {
                    await pdfService.printPdf(receipt);
                  } catch (e) {
                    errorHandler.handleError(e, context: 'Print');
                  }
                  break;
                case 'finalize':
                  try {
                    await repository.updateReceipt(
                        receipt.copyWith(status: ReceiptStatus.finalized));
                    SnackbarHelper.success('Receipt finalized');
                    Get.back();
                  } catch (e) {
                    errorHandler.handleError(e);
                  }
                  break;
                case 'void':
                  try {
                    await repository.updateReceipt(
                        receipt.copyWith(status: ReceiptStatus.voided));
                    SnackbarHelper.info('Receipt voided');
                    Get.back();
                  } catch (e) {
                    errorHandler.handleError(e);
                  }
                  break;
                case 'delete':
                  final confirm = await Get.dialog<bool>(AlertDialog(
                    title: const Text('Delete Receipt'),
                    content: const Text(
                        'This will permanently delete this receipt.'),
                    actions: [
                      TextButton(
                          onPressed: () => Get.back(result: false),
                          child: const Text('Cancel')),
                      TextButton(
                          onPressed: () => Get.back(result: true),
                          style: TextButton.styleFrom(
                              foregroundColor: AppColors.error),
                          child: const Text('Delete')),
                    ],
                  ));
                  if (confirm == true) {
                    await repository.deleteReceipt(receipt.id);
                    SnackbarHelper.success('Receipt deleted');
                    Get.back();
                  }
                  break;
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status & Template
            Row(
              children: [
                _statusChip(receipt),
                const SizedBox(width: 8),
                _syncChip(receipt),
                const Spacer(),
                Text(receipt.templateType.label,
                    style: AppTextStyles.caption),
              ],
            ),
            const SizedBox(height: 20),

            // Business info
            if (receipt.businessProfile != null) ...[
              Text(receipt.businessProfile!.name, style: AppTextStyles.h2),
              if (receipt.businessProfile!.address != null)
                Text(receipt.businessProfile!.address!,
                    style: AppTextStyles.bodySmall
                        .copyWith(color: AppColors.textSecondary)),
              const SizedBox(height: 16),
            ],

            // Date & receipt number
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Receipt No', style: AppTextStyles.caption),
                      Text(receipt.receiptNumber,
                          style: AppTextStyles.receiptNumber),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('Date', style: AppTextStyles.caption),
                      Text(Formatters.dateTime(receipt.createdAt),
                          style: AppTextStyles.bodySmall),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Customer
            if (receipt.customer != null && receipt.customer!.isNotEmpty) ...[
              Text('Customer', style: AppTextStyles.labelLarge),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.divider),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(receipt.customer!.name,
                        style: AppTextStyles.bodyMedium
                            .copyWith(fontWeight: FontWeight.w600)),
                    if (receipt.customer!.email != null)
                      Text(receipt.customer!.email!,
                          style: AppTextStyles.bodySmall),
                    if (receipt.customer!.phone != null)
                      Text(receipt.customer!.phone!,
                          style: AppTextStyles.bodySmall),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Items
            Text('Items (${receipt.itemCount})',
                style: AppTextStyles.labelLarge),
            const SizedBox(height: 8),
            ...receipt.items.asMap().entries.map((entry) {
              final item = entry.value;
              return Container(
                margin: const EdgeInsets.only(bottom: 6),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardTheme.color,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: AppColors.divider.withValues(alpha: 0.5)),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 14,
                      backgroundColor:
                          AppColors.primary.withValues(alpha: 0.1),
                      child: Text('${entry.key + 1}',
                          style: AppTextStyles.labelSmall
                              .copyWith(color: AppColors.primary)),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.name,
                              style: AppTextStyles.bodyMedium
                                  .copyWith(fontWeight: FontWeight.w500)),
                          Text(
                              '${item.quantity} × ${Formatters.currency(item.unitPrice, symbol: receipt.currencySymbol)}',
                              style: AppTextStyles.caption),
                        ],
                      ),
                    ),
                    Text(
                      Formatters.currency(item.total,
                          symbol: receipt.currencySymbol),
                      style: AppTextStyles.currencyAmountSmall
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 16),

            // Totals
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary.withValues(alpha: 0.06),
                    AppColors.secondary.withValues(alpha: 0.04),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.12)),
              ),
              child: Column(
                children: [
                  _detailRow('Subtotal',
                      Formatters.currency(receipt.subtotal, symbol: receipt.currencySymbol)),
                  if (receipt.taxRate > 0)
                    _detailRow(
                        'Tax (${receipt.taxRate}%)',
                        Formatters.currency(receipt.taxAmount,
                            symbol: receipt.currencySymbol)),
                  if (receipt.discountRate > 0)
                    _detailRow(
                        'Discount (${receipt.discountRate}%)',
                        '-${Formatters.currency(receipt.discountAmount, symbol: receipt.currencySymbol)}'),
                  const Divider(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('TOTAL',
                          style: AppTextStyles.h3
                              .copyWith(color: AppColors.primary)),
                      Text(
                        Formatters.currency(receipt.total,
                            symbol: receipt.currencySymbol),
                        style: AppTextStyles.currencyAmount
                            .copyWith(color: AppColors.primary),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Payment & Notes
            if (receipt.paymentMethod != null)
              _detailRow('Payment', receipt.paymentMethod!),
            if (receipt.notes != null && receipt.notes!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text('Notes', style: AppTextStyles.labelLarge),
              const SizedBox(height: 4),
              Text(receipt.notes!,
                  style: AppTextStyles.bodySmall
                      .copyWith(color: AppColors.textSecondary)),
            ],
            const SizedBox(height: 30),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      try {
                        await pdfService.sharePdf(receipt);
                      } catch (e) {
                        errorHandler.handleError(e);
                      }
                    },
                    icon: const Icon(Icons.share_rounded),
                    label: const Text('Share'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      try {
                        await pdfService.printPdf(receipt);
                      } catch (e) {
                        errorHandler.handleError(e);
                      }
                    },
                    icon: const Icon(Icons.print_rounded),
                    label: const Text('Print'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _statusChip(ReceiptModel receipt) {
    Color color;
    if (receipt.status.isDraft) {
      color = AppColors.warning;
    } else if (receipt.status.isFinalized) {
      color = AppColors.success;
    } else {
      color = AppColors.textTertiary;
    }
    return Chip(
      label: Text(receipt.status.label,
          style: AppTextStyles.labelSmall.copyWith(color: color)),
      backgroundColor: color.withValues(alpha: 0.1),
      side: BorderSide.none,
      padding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
    );
  }

  Widget _syncChip(ReceiptModel receipt) {
    final synced = receipt.syncStatus.isSynced;
    return Chip(
      avatar: Icon(
        synced ? Icons.cloud_done_rounded : Icons.sync_rounded,
        size: 14,
        color: synced ? AppColors.success : AppColors.warning,
      ),
      label: Text(receipt.syncStatus.label,
          style: AppTextStyles.labelSmall.copyWith(
              color: synced ? AppColors.success : AppColors.warning)),
      backgroundColor: (synced ? AppColors.success : AppColors.warning)
          .withValues(alpha: 0.1),
      side: BorderSide.none,
      padding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.bodyMedium),
          Text(value,
              style: AppTextStyles.bodyMedium
                  .copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
