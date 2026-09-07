// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'receipt_status.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ReceiptStatusAdapter extends TypeAdapter<ReceiptStatus> {
  @override
  final typeId = 5;

  @override
  ReceiptStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ReceiptStatus.draft;
      case 1:
        return ReceiptStatus.finalized;
      case 2:
        return ReceiptStatus.voided;
      default:
        return ReceiptStatus.draft;
    }
  }

  @override
  void write(BinaryWriter writer, ReceiptStatus obj) {
    switch (obj) {
      case ReceiptStatus.draft:
        writer.writeByte(0);
      case ReceiptStatus.finalized:
        writer.writeByte(1);
      case ReceiptStatus.voided:
        writer.writeByte(2);
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReceiptStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
