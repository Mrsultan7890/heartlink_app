import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'user_model.dart';

part 'match_model.g.dart';

@HiveType(typeId: 2)
@JsonSerializable()
class MatchModel extends HiveObject {
  @HiveField(0)
  final int id;
  
  @HiveField(1)
  @JsonKey(name: 'user1_id')
  final int user1Id;
  
  @HiveField(2)
  @JsonKey(name: 'user2_id')
  final int user2Id;
  
  @HiveField(3)
  @JsonKey(name: 'user1_profile')
  final UserModel user1Profile;
  
  @HiveField(4)
  @JsonKey(name: 'user2_profile')
  final UserModel user2Profile;
  
  @HiveField(5)
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  
  @HiveField(6)
  @JsonKey(name: 'last_message')
  final String? lastMessage;
  
  @HiveField(7)
  @JsonKey(name: 'last_message_time')
  final DateTime? lastMessageTime;

  MatchModel({
    required this.id,
    required this.user1Id,
    required this.user2Id,
    required this.user1Profile,
    required this.user2Profile,
    required this.createdAt,
    this.lastMessage,
    this.lastMessageTime,
  });

  factory MatchModel.fromJson(Map<String, dynamic> json) =>
      _$MatchModelFromJson(json);

  Map<String, dynamic> toJson() => _$MatchModelToJson(this);
}

@HiveType(typeId: 3)
@JsonSerializable()
class MessageModel extends HiveObject {
  @HiveField(0)
  final int id;
  
  @HiveField(1)
  @JsonKey(name: 'match_id')
  final int matchId;
  
  @HiveField(2)
  @JsonKey(name: 'sender_id')
  final int senderId;
  
  @HiveField(3)
  final String content;
  
  @HiveField(4)
  @JsonKey(name: 'message_type')
  final String messageType;
  
  @HiveField(5)
  @JsonKey(name: 'is_read')
  final bool isRead;
  
  @HiveField(6)
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  
  @HiveField(7)
  @JsonKey(name: 'sender_name')
  final String senderName;

  MessageModel({
    required this.id,
    required this.matchId,
    required this.senderId,
    required this.content,
    required this.messageType,
    required this.isRead,
    required this.createdAt,
    required this.senderName,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) =>
      _$MessageModelFromJson(json);

  Map<String, dynamic> toJson() => _$MessageModelToJson(this);
}