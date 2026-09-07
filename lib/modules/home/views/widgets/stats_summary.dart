import 'package:flutter/material.dart';
import 'package:receipt_management_flutter/app/theme/app_colors.dart';
import 'package:receipt_management_flutter/app/theme/app_text_styles.dart';
import 'package:receipt_management_flutter/core/utils/formatters.dart';

class StatsSummary extends StatelessWidget {
  final int totalReceipts;
  final double totalRevenue;
  final int pendingSync;

  const StatsSummary({
    super.key,
    required this.totalReceipts,
    required this.totalRevenue,
    required this.pendingSync,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Row(
        children: [
          _StatCard(
            icon: Icons.receipt_long_rounded,
            label: 'Total',
            value: '$totalReceipts',
            color: AppColors.primary,
          ),
          const SizedBox(width: 10),
          _StatCard(
            icon: Icons.account_balance_wallet_rounded,
            label: 'Revenue',
            value: Formatters.currency(totalRevenue),
            color: AppColors.success,
            flex: 2,
          ),
          const SizedBox(width: 10),
          _StatCard(
            icon: Icons.sync_rounded,
            label: 'Pending',
            value: '$pendingSync',
            color: pendingSync > 0 ? AppColors.warning : AppColors.success,
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final int flex;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    this.flex = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.15)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: AppTextStyles.h4.copyWith(color: color),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: AppTextStyles.caption.copyWith(color: color.withValues(alpha: 0.8)),
            ),
          ],
        ),
      ),
    );
  }
}
