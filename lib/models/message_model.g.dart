// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MessageModelAdapter extends TypeAdapter<MessageModel> {
  @override
  final int typeId = 3;

  @override
  MessageModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MessageModel(
      id: fields[0] as int,
      matchId: fields[1] as int,
      senderId: fields[2] as int,
      content: fields[3] as String,
      messageType: fields[4] as String,
      isRead: fields[5] as bool,
      createdAt: fields[6] as DateTime,
      senderName: fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, MessageModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.matchId)
      ..writeByte(2)
      ..write(obj.senderId)
      ..writeByte(3)
      ..write(obj.content)
      ..writeByte(4)
      ..write(obj.messageType)
      ..writeByte(5)
      ..write(obj.isRead)
      ..writeByte(6)
      ..write(obj.createdAt)
      ..writeByte(7)
      ..write(obj.senderName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MessageModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageModel _$MessageModelFromJson(Map<String, dynamic> json) => MessageModel(
      id: json['id'] as int,
      matchId: json['match_id'] as int,
      senderId: json['sender_id'] as int,
      content: json['content'] as String,
      messageType: json['message_type'] as String? ?? 'text',
      isRead: json['is_read'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
      senderName: json['sender_name'] as String,
    );

Map<String, dynamic> _$MessageModelToJson(MessageModel instance) => <String, dynamic>{
      'id': instance.id,
      'match_id': instance.matchId,
      'sender_id': instance.senderId,
      'content': instance.content,
      'message_type': instance.messageType,
      'is_read': instance.isRead,
      'created_at': instance.createdAt.toIso8601String(),
      'sender_name': instance.senderName,
    };