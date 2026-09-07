// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'business_profile_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BusinessProfileModelAdapter extends TypeAdapter<BusinessProfileModel> {
  @override
  final typeId = 2;

  @override
  BusinessProfileModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BusinessProfileModel(
      id: fields[0] as String,
      name: fields[1] as String,
      address: fields[2] as String?,
      phone: fields[3] as String?,
      email: fields[4] as String?,
      taxId: fields[5] as String?,
      logoPath: fields[6] as String?,
      website: fields[7] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, BusinessProfileModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.address)
      ..writeByte(3)
      ..write(obj.phone)
      ..writeByte(4)
      ..write(obj.email)
      ..writeByte(5)
      ..write(obj.taxId)
      ..writeByte(6)
      ..write(obj.logoPath)
      ..writeByte(7)
      ..write(obj.website);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BusinessProfileModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
