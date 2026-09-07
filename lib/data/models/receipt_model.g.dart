// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'receipt_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ReceiptModelAdapter extends TypeAdapter<ReceiptModel> {
  @override
  final typeId = 0;

  @override
  ReceiptModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ReceiptModel(
      id: fields[0] as String,
      receiptNumber: fields[1] as String,
      businessProfile: fields[2] as BusinessProfileModel?,
      customer: fields[3] as CustomerModel?,
      items: (fields[4] as List).cast<ReceiptItemModel>(),
      subtotal: (fields[5] as num).toDouble(),
      taxRate: (fields[6] as num).toDouble(),
      taxAmount: (fields[7] as num).toDouble(),
      discountRate: (fields[8] as num).toDouble(),
      discountAmount: (fields[9] as num).toDouble(),
      total: (fields[10] as num).toDouble(),
      templateType: fields[11] as TemplateType,
      notes: fields[12] as String?,
      status: fields[13] as ReceiptStatus,
      syncStatus: fields[14] as SyncStatus,
      currency: fields[15] as String,
      currencySymbol: fields[16] as String,
      paymentMethod: fields[17] as String?,
      createdAt: fields[18] as DateTime,
      updatedAt: fields[19] as DateTime,
      isDeleted: fields[20] == null ? false : fields[20] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, ReceiptModel obj) {
    writer
      ..writeByte(21)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.receiptNumber)
      ..writeByte(2)
      ..write(obj.businessProfile)
      ..writeByte(3)
      ..write(obj.customer)
      ..writeByte(4)
      ..write(obj.items)
      ..writeByte(5)
      ..write(obj.subtotal)
      ..writeByte(6)
      ..write(obj.taxRate)
      ..writeByte(7)
      ..write(obj.taxAmount)
      ..writeByte(8)
      ..write(obj.discountRate)
      ..writeByte(9)
      ..write(obj.discountAmount)
      ..writeByte(10)
      ..write(obj.total)
      ..writeByte(11)
      ..write(obj.templateType)
      ..writeByte(12)
      ..write(obj.notes)
      ..writeByte(13)
      ..write(obj.status)
      ..writeByte(14)
      ..write(obj.syncStatus)
      ..writeByte(15)
      ..write(obj.currency)
      ..writeByte(16)
      ..write(obj.currencySymbol)
      ..writeByte(17)
      ..write(obj.paymentMethod)
      ..writeByte(18)
      ..write(obj.createdAt)
      ..writeByte(19)
      ..write(obj.updatedAt)
      ..writeByte(20)
      ..write(obj.isDeleted);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReceiptModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
