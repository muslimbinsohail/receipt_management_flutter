import 'package:hive_ce/hive.dart';
import 'package:receipt_management_flutter/core/constants/hive_constants.dart';
import 'package:receipt_management_flutter/core/enums/sync_operation.dart';

part 'sync_queue_model.g.dart';

@HiveType(typeId: HiveConstants.syncQueueModelId)
class SyncQueueModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final SyncOperation operation;

  @HiveField(2)
  final String collectionPath;

  @HiveField(3)
  final String documentId;

  @HiveField(4)
  final Map<String, dynamic>? data;

  @HiveField(5)
  final DateTime timestamp;

  @HiveField(6)
  int retryCount;

  @HiveField(7)
  String? lastError;

  SyncQueueModel({
    required this.id,
    required this.operation,
    required this.collectionPath,
    required this.documentId,
    this.data,
    required this.timestamp,
    this.retryCount = 0,
    this.lastError,
  });

  SyncQueueModel copyWith({
    String? id,
    SyncOperation? operation,
    String? collectionPath,
    String? documentId,
    Map<String, dynamic>? data,
    DateTime? timestamp,
    int? retryCount,
    String? lastError,
  }) {
    return SyncQueueModel(
      id: id ?? this.id,
      operation: operation ?? this.operation,
      collectionPath: collectionPath ?? this.collectionPath,
      documentId: documentId ?? this.documentId,
      data: data ?? this.data,
      timestamp: timestamp ?? this.timestamp,
      retryCount: retryCount ?? this.retryCount,
      lastError: lastError ?? this.lastError,
    );
  }

  bool get hasExceededMaxRetries => retryCount >= 5;
}
