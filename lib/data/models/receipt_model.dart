import 'package:hive_ce/hive.dart';
import 'package:receipt_management_flutter/core/constants/hive_constants.dart';
import 'package:receipt_management_flutter/core/enums/receipt_status.dart';
import 'package:receipt_management_flutter/core/enums/sync_status.dart';
import 'package:receipt_management_flutter/core/enums/template_type.dart';
import 'package:receipt_management_flutter/data/models/business_profile_model.dart';
import 'package:receipt_management_flutter/data/models/customer_model.dart';
import 'package:receipt_management_flutter/data/models/receipt_item_model.dart';

part 'receipt_model.g.dart';

@HiveType(typeId: HiveConstants.receiptModelId)
class ReceiptModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String receiptNumber;

  @HiveField(2)
  final BusinessProfileModel? businessProfile;

  @HiveField(3)
  final CustomerModel? customer;

  @HiveField(4)
  final List<ReceiptItemModel> items;

  @HiveField(5)
  final double subtotal;

  @HiveField(6)
  final double taxRate;

  @HiveField(7)
  final double taxAmount;

  @HiveField(8)
  final double discountRate;

  @HiveField(9)
  final double discountAmount;

  @HiveField(10)
  final double total;

  @HiveField(11)
  final TemplateType templateType;

  @HiveField(12)
  final String? notes;

  @HiveField(13)
  final ReceiptStatus status;

  @HiveField(14)
  final SyncStatus syncStatus;

  @HiveField(15)
  final String currency;

  @HiveField(16)
  final String currencySymbol;

  @HiveField(17)
  final String? paymentMethod;

  @HiveField(18)
  final DateTime createdAt;

  @HiveField(19)
  final DateTime updatedAt;

  @HiveField(20)
  final bool isDeleted;

  ReceiptModel({
    required this.id,
    required this.receiptNumber,
    this.businessProfile,
    this.customer,
    required this.items,
    required this.subtotal,
    required this.taxRate,
    required this.taxAmount,
    required this.discountRate,
    required this.discountAmount,
    required this.total,
    required this.templateType,
    this.notes,
    required this.status,
    required this.syncStatus,
    required this.currency,
    required this.currencySymbol,
    this.paymentMethod,
    required this.createdAt,
    required this.updatedAt,
    this.isDeleted = false,
  });

  ReceiptModel copyWith({
    String? id,
    String? receiptNumber,
    BusinessProfileModel? businessProfile,
    CustomerModel? customer,
    List<ReceiptItemModel>? items,
    double? subtotal,
    double? taxRate,
    double? taxAmount,
    double? discountRate,
    double? discountAmount,
    double? total,
    TemplateType? templateType,
    String? notes,
    ReceiptStatus? status,
    SyncStatus? syncStatus,
    String? currency,
    String? currencySymbol,
    String? paymentMethod,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isDeleted,
  }) {
    return ReceiptModel(
      id: id ?? this.id,
      receiptNumber: receiptNumber ?? this.receiptNumber,
      businessProfile: businessProfile ?? this.businessProfile,
      customer: customer ?? this.customer,
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      taxRate: taxRate ?? this.taxRate,
      taxAmount: taxAmount ?? this.taxAmount,
      discountRate: discountRate ?? this.discountRate,
      discountAmount: discountAmount ?? this.discountAmount,
      total: total ?? this.total,
      templateType: templateType ?? this.templateType,
      notes: notes ?? this.notes,
      status: status ?? this.status,
      syncStatus: syncStatus ?? this.syncStatus,
      currency: currency ?? this.currency,
      currencySymbol: currencySymbol ?? this.currencySymbol,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'receiptNumber': receiptNumber,
      'businessProfile': businessProfile?.toFirestore(),
      'customer': customer?.toFirestore(),
      'items': items.map((item) => item.toFirestore()).toList(),
      'subtotal': subtotal,
      'taxRate': taxRate,
      'taxAmount': taxAmount,
      'discountRate': discountRate,
      'discountAmount': discountAmount,
      'total': total,
      'templateType': templateType.index,
      'notes': notes,
      'status': status.index,
      'currency': currency,
      'currencySymbol': currencySymbol,
      'paymentMethod': paymentMethod,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isDeleted': isDeleted,
    };
  }

  factory ReceiptModel.fromFirestore(Map<String, dynamic> data) {
    return ReceiptModel(
      id: data['id'] as String? ?? '',
      receiptNumber: data['receiptNumber'] as String? ?? '',
      businessProfile: data['businessProfile'] != null
          ? BusinessProfileModel.fromFirestore(
              data['businessProfile'] as Map<String, dynamic>)
          : null,
      customer: data['customer'] != null
          ? CustomerModel.fromFirestore(
              data['customer'] as Map<String, dynamic>)
          : null,
      items: (data['items'] as List<dynamic>?)
              ?.map((item) =>
                  ReceiptItemModel.fromFirestore(item as Map<String, dynamic>))
              .toList() ??
          [],
      subtotal: (data['subtotal'] as num?)?.toDouble() ?? 0.0,
      taxRate: (data['taxRate'] as num?)?.toDouble() ?? 0.0,
      taxAmount: (data['taxAmount'] as num?)?.toDouble() ?? 0.0,
      discountRate: (data['discountRate'] as num?)?.toDouble() ?? 0.0,
      discountAmount: (data['discountAmount'] as num?)?.toDouble() ?? 0.0,
      total: (data['total'] as num?)?.toDouble() ?? 0.0,
      templateType: TemplateType
          .values[(data['templateType'] as int?) ?? 0],
      notes: data['notes'] as String?,
      status: ReceiptStatus.values[(data['status'] as int?) ?? 0],
      syncStatus: SyncStatus.synced,
      currency: data['currency'] as String? ?? 'PKR',
      currencySymbol: data['currencySymbol'] as String? ?? 'Rs.',
      paymentMethod: data['paymentMethod'] as String?,
      createdAt: data['createdAt'] != null
          ? DateTime.parse(data['createdAt'] as String)
          : DateTime.now(),
      updatedAt: data['updatedAt'] != null
          ? DateTime.parse(data['updatedAt'] as String)
          : DateTime.now(),
      isDeleted: data['isDeleted'] as bool? ?? false,
    );
  }

  /// Check if receipt has any items
  bool get hasItems => items.isNotEmpty;

  /// Check if receipt is complete enough to finalize
  bool get canFinalize =>
      hasItems && businessProfile != null && businessProfile!.isComplete;

  /// Number of items
  int get itemCount => items.length;
}
