import 'package:hive_ce/hive.dart';
import 'package:receipt_management_flutter/core/constants/hive_constants.dart';

part 'receipt_item_model.g.dart';

@HiveType(typeId: HiveConstants.receiptItemModelId)
class ReceiptItemModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String? description;

  @HiveField(3)
  final double quantity;

  @HiveField(4)
  final double unitPrice;

  @HiveField(5)
  final double total;

  ReceiptItemModel({
    required this.id,
    required this.name,
    this.description,
    required this.quantity,
    required this.unitPrice,
    required this.total,
  });

  ReceiptItemModel copyWith({
    String? id,
    String? name,
    String? description,
    double? quantity,
    double? unitPrice,
    double? total,
  }) {
    return ReceiptItemModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      total: total ?? this.total,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'total': total,
    };
  }

  factory ReceiptItemModel.fromFirestore(Map<String, dynamic> data) {
    return ReceiptItemModel(
      id: data['id'] as String? ?? '',
      name: data['name'] as String? ?? '',
      description: data['description'] as String?,
      quantity: (data['quantity'] as num?)?.toDouble() ?? 0.0,
      unitPrice: (data['unitPrice'] as num?)?.toDouble() ?? 0.0,
      total: (data['total'] as num?)?.toDouble() ?? 0.0,
    );
  }

  factory ReceiptItemModel.empty(String id) {
    return ReceiptItemModel(
      id: id,
      name: '',
      quantity: 1,
      unitPrice: 0,
      total: 0,
    );
  }
}
