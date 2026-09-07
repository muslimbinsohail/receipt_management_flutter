import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:receipt_management_flutter/app/theme/app_colors.dart';
import 'package:receipt_management_flutter/app/theme/app_text_styles.dart';
import 'package:receipt_management_flutter/core/enums/receipt_status.dart';
import 'package:receipt_management_flutter/core/enums/sync_status.dart';
import 'package:receipt_management_flutter/core/utils/formatters.dart';
import 'package:receipt_management_flutter/data/models/receipt_model.dart';

class ReceiptCard extends StatelessWidget {
  final ReceiptModel receipt;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final VoidCallback onDuplicate;

  const ReceiptCard({
    super.key,
    required this.receipt,
    required this.onTap,
    required this.onDelete,
    required this.onDuplicate,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const BehindMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => onDuplicate(),
              backgroundColor: AppColors.info,
              foregroundColor: Colors.white,
              icon: Icons.copy_rounded,
              label: 'Duplicate',
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
            ),
            SlidableAction(
              onPressed: (_) => _confirmDelete(context),
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              icon: Icons.delete_rounded,
              label: 'Delete',
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
          ],
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardTheme.color,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Theme.of(context).dividerColor.withValues(alpha: 0.5),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top row: Receipt number & status
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      receipt.receiptNumber,
                      style: AppTextStyles.receiptNumber.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                    _buildStatusChip(),
                  ],
                ),
                const SizedBox(height: 10),

                // Customer name
                if (receipt.customer != null && receipt.customer!.isNotEmpty)
                  Row(
                    children: [
                      Icon(Icons.person_outline_rounded,
                          size: 16, color: AppColors.textSecondary),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          receipt.customer!.name,
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 8),

                // Bottom row: Items count, date, total
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          '${receipt.itemCount} item${receipt.itemCount != 1 ? 's' : ''}',
                          style: AppTextStyles.caption,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          Formatters.relativeTime(receipt.createdAt),
                          style: AppTextStyles.caption,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        // Sync indicator
                        if (receipt.syncStatus.isPending)
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Icon(
                              Icons.sync_rounded,
                              size: 14,
                              color: AppColors.pending,
                            ),
                          ),
                        if (receipt.syncStatus.isFailed)
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Icon(
                              Icons.sync_problem_rounded,
                              size: 14,
                              color: AppColors.syncFailed,
                            ),
                          ),
                        Text(
                          Formatters.currency(receipt.total,
                              symbol: receipt.currencySymbol),
                          style: AppTextStyles.currencyAmountSmall.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip() {
    Color color;
    switch (receipt.status) {
      case _ when receipt.status.isDraft:
        color = AppColors.warning;
        break;
      case _ when receipt.status.isFinalized:
        color = AppColors.success;
        break;
      default:
        color = AppColors.textTertiary;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        receipt.status.label,
        style: AppTextStyles.labelSmall.copyWith(color: color),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Receipt'),
        content: Text(
            'Are you sure you want to delete receipt ${receipt.receiptNumber}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              onDelete();
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
