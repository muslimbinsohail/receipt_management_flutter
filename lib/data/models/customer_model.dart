import 'package:hive_ce/hive.dart';
import 'package:receipt_management_flutter/core/constants/hive_constants.dart';

part 'customer_model.g.dart';

@HiveType(typeId: HiveConstants.customerModelId)
class CustomerModel extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String? email;

  @HiveField(2)
  final String? phone;

  @HiveField(3)
  final String? address;

  CustomerModel({
    required this.name,
    this.email,
    this.phone,
    this.address,
  });

  CustomerModel copyWith({
    String? name,
    String? email,
    String? phone,
    String? address,
  }) {
    return CustomerModel(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
    };
  }

  factory CustomerModel.fromFirestore(Map<String, dynamic> data) {
    return CustomerModel(
      name: data['name'] as String? ?? '',
      email: data['email'] as String?,
      phone: data['phone'] as String?,
      address: data['address'] as String?,
    );
  }

  factory CustomerModel.empty() {
    return CustomerModel(name: '');
  }

  bool get isEmpty => name.isEmpty;
  bool get isNotEmpty => name.isNotEmpty;
}
