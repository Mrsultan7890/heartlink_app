// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'match_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MatchModelAdapter extends TypeAdapter<MatchModel> {
  @override
  final int typeId = 2;

  @override
  MatchModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MatchModel(
      id: fields[0] as int,
      user1Id: fields[1] as int,
      user2Id: fields[2] as int,
      user1Profile: fields[3] as UserModel,
      user2Profile: fields[4] as UserModel,
      createdAt: fields[5] as DateTime,
      lastMessage: fields[6] as String?,
      lastMessageTime: fields[7] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, MatchModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.user1Id)
      ..writeByte(2)
      ..write(obj.user2Id)
      ..writeByte(3)
      ..write(obj.user1Profile)
      ..writeByte(4)
      ..write(obj.user2Profile)
      ..writeByte(5)
      ..write(obj.createdAt)
      ..writeByte(6)
      ..write(obj.lastMessage)
      ..writeByte(7)
      ..write(obj.lastMessageTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MatchModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MatchModel _$MatchModelFromJson(Map<String, dynamic> json) => MatchModel(
      id: json['id'] as int,
      user1Id: json['user1_id'] as int,
      user2Id: json['user2_id'] as int,
      user1Profile: UserModel.fromJson(json['user1_profile'] as Map<String, dynamic>),
      user2Profile: UserModel.fromJson(json['user2_profile'] as Map<String, dynamic>),
      createdAt: DateTime.parse(json['created_at'] as String),
      lastMessage: json['last_message'] as String?,
      lastMessageTime: json['last_message_time'] == null
          ? null
          : DateTime.parse(json['last_message_time'] as String),
    );

Map<String, dynamic> _$MatchModelToJson(MatchModel instance) => <String, dynamic>{
      'id': instance.id,
      'user1_id': instance.user1Id,
      'user2_id': instance.user2Id,
      'user1_profile': instance.user1Profile,
      'user2_profile': instance.user2Profile,
      'created_at': instance.createdAt.toIso8601String(),
      'last_message': instance.lastMessage,
      'last_message_time': instance.lastMessageTime?.toIso8601String(),
    };