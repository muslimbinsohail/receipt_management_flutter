import 'package:flutter/material.dart';
import 'package:receipt_management_flutter/app/theme/app_colors.dart';
import 'package:receipt_management_flutter/app/theme/app_text_styles.dart';

class SyncStatusIndicator extends StatelessWidget {
  final bool isOnline;
  final bool isSyncing;
  final int pendingCount;
  final VoidCallback? onTap;

  const SyncStatusIndicator({
    super.key,
    required this.isOnline,
    required this.isSyncing,
    required this.pendingCount,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: _backgroundColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: _borderColor, width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSyncing)
              SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.primary,
                ),
              )
            else
              Icon(_icon, size: 14, color: _iconColor),
            const SizedBox(width: 4),
            Text(
              _label,
              style: AppTextStyles.labelSmall.copyWith(color: _iconColor),
            ),
          ],
        ),
      ),
    );
  }

  Color get _backgroundColor {
    if (!isOnline) return AppColors.error.withValues(alpha: 0.08);
    if (isSyncing) return AppColors.primary.withValues(alpha: 0.08);
    if (pendingCount > 0) return AppColors.warning.withValues(alpha: 0.08);
    return AppColors.success.withValues(alpha: 0.08);
  }

  Color get _borderColor {
    if (!isOnline) return AppColors.error.withValues(alpha: 0.2);
    if (isSyncing) return AppColors.primary.withValues(alpha: 0.2);
    if (pendingCount > 0) return AppColors.warning.withValues(alpha: 0.2);
    return AppColors.success.withValues(alpha: 0.2);
  }

  IconData get _icon {
    if (!isOnline) return Icons.wifi_off_rounded;
    if (pendingCount > 0) return Icons.sync_rounded;
    return Icons.cloud_done_rounded;
  }

  Color get _iconColor {
    if (!isOnline) return AppColors.error;
    if (isSyncing) return AppColors.primary;
    if (pendingCount > 0) return AppColors.warning;
    return AppColors.success;
  }

  String get _label {
    if (!isOnline) return 'Offline';
    if (isSyncing) return 'Syncing';
    if (pendingCount > 0) return '$pendingCount pending';
    return 'Synced';
  }
}
