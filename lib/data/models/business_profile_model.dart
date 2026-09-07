import 'package:hive_ce/hive.dart';
import 'package:receipt_management_flutter/core/constants/hive_constants.dart';

part 'business_profile_model.g.dart';

@HiveType(typeId: HiveConstants.businessProfileModelId)
class BusinessProfileModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String? address;

  @HiveField(3)
  final String? phone;

  @HiveField(4)
  final String? email;

  @HiveField(5)
  final String? taxId;

  @HiveField(6)
  final String? logoPath;

  @HiveField(7)
  final String? website;

  BusinessProfileModel({
    required this.id,
    required this.name,
    this.address,
    this.phone,
    this.email,
    this.taxId,
    this.logoPath,
    this.website,
  });

  BusinessProfileModel copyWith({
    String? id,
    String? name,
    String? address,
    String? phone,
    String? email,
    String? taxId,
    String? logoPath,
    String? website,
  }) {
    return BusinessProfileModel(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      taxId: taxId ?? this.taxId,
      logoPath: logoPath ?? this.logoPath,
      website: website ?? this.website,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'phone': phone,
      'email': email,
      'taxId': taxId,
      'logoPath': logoPath,
      'website': website,
    };
  }

  factory BusinessProfileModel.fromFirestore(Map<String, dynamic> data) {
    return BusinessProfileModel(
      id: data['id'] as String? ?? '',
      name: data['name'] as String? ?? '',
      address: data['address'] as String?,
      phone: data['phone'] as String?,
      email: data['email'] as String?,
      taxId: data['taxId'] as String?,
      logoPath: data['logoPath'] as String?,
      website: data['website'] as String?,
    );
  }

  factory BusinessProfileModel.empty(String id) {
    return BusinessProfileModel(
      id: id,
      name: '',
    );
  }

  bool get isComplete => name.isNotEmpty;
}
