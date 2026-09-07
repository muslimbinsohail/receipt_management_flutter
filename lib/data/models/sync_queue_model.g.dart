// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_queue_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SyncQueueModelAdapter extends TypeAdapter<SyncQueueModel> {
  @override
  final typeId = 4;

  @override
  SyncQueueModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SyncQueueModel(
      id: fields[0] as String,
      operation: fields[1] as SyncOperation,
      collectionPath: fields[2] as String,
      documentId: fields[3] as String,
      data: (fields[4] as Map?)?.cast<String, dynamic>(),
      timestamp: fields[5] as DateTime,
      retryCount: fields[6] == null ? 0 : (fields[6] as num).toInt(),
      lastError: fields[7] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, SyncQueueModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.operation)
      ..writeByte(2)
      ..write(obj.collectionPath)
      ..writeByte(3)
      ..write(obj.documentId)
      ..writeByte(4)
      ..write(obj.data)
      ..writeByte(5)
      ..write(obj.timestamp)
      ..writeByte(6)
      ..write(obj.retryCount)
      ..writeByte(7)
      ..write(obj.lastError);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SyncQueueModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
