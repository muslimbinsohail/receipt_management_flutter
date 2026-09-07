import 'package:hive_ce/hive.dart';
import 'package:receipt_management_flutter/core/constants/hive_constants.dart';

part 'sync_status.g.dart';

@HiveType(typeId: HiveConstants.syncStatusId)
enum SyncStatus {
  @HiveField(0)
  pending,

  @HiveField(1)
  synced,

  @HiveField(2)
  failed,

  @HiveField(3)
  conflict,
}

extension SyncStatusExtension on SyncStatus {
  String get label {
    switch (this) {
      case SyncStatus.pending:
        return 'Pending Sync';
      case SyncStatus.synced:
        return 'Synced';
      case SyncStatus.failed:
        return 'Sync Failed';
      case SyncStatus.conflict:
        return 'Conflict';
    }
  }

  bool get isSynced => this == SyncStatus.synced;
  bool get isPending => this == SyncStatus.pending;
  bool get isFailed => this == SyncStatus.failed;
}
