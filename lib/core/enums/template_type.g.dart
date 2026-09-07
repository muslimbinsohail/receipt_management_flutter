// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'template_type.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TemplateTypeAdapter extends TypeAdapter<TemplateType> {
  @override
  final typeId = 7;

  @override
  TemplateType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TemplateType.modernMinimal;
      case 1:
        return TemplateType.classicFormal;
      case 2:
        return TemplateType.boldColorful;
      case 3:
        return TemplateType.darkPremium;
      case 4:
        return TemplateType.vintage;
      default:
        return TemplateType.modernMinimal;
    }
  }

  @override
  void write(BinaryWriter writer, TemplateType obj) {
    switch (obj) {
      case TemplateType.modernMinimal:
        writer.writeByte(0);
      case TemplateType.classicFormal:
        writer.writeByte(1);
      case TemplateType.boldColorful:
        writer.writeByte(2);
      case TemplateType.darkPremium:
        writer.writeByte(3);
      case TemplateType.vintage:
        writer.writeByte(4);
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TemplateTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
