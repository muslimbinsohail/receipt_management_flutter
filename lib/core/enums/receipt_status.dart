import 'package:hive_ce/hive.dart';
import 'package:receipt_management_flutter/core/constants/hive_constants.dart';

part 'receipt_status.g.dart';

@HiveType(typeId: HiveConstants.receiptStatusId)
enum ReceiptStatus {
  @HiveField(0)
  draft,

  @HiveField(1)
  finalized,

  @HiveField(2)
  voided,
}

extension ReceiptStatusExtension on ReceiptStatus {
  String get label {
    switch (this) {
      case ReceiptStatus.draft:
        return 'Draft';
      case ReceiptStatus.finalized:
        return 'Finalized';
      case ReceiptStatus.voided:
        return 'Voided';
    }
  }

  bool get isDraft => this == ReceiptStatus.draft;
  bool get isFinalized => this == ReceiptStatus.finalized;
  bool get isVoided => this == ReceiptStatus.voided;
}
