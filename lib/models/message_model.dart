import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'message_model.g.dart';

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
    this.messageType = 'text',
    this.isRead = false,
    required this.createdAt,
    required this.senderName,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) =>
      _$MessageModelFromJson(json);

  Map<String, dynamic> toJson() => _$MessageModelToJson(this);

  MessageModel copyWith({
    int? id,
    int? matchId,
    int? senderId,
    String? content,
    String? messageType,
    bool? isRead,
    DateTime? createdAt,
    String? senderName,
  }) {
    return MessageModel(
      id: id ?? this.id,
      matchId: matchId ?? this.matchId,
      senderId: senderId ?? this.senderId,
      content: content ?? this.content,
      messageType: messageType ?? this.messageType,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
      senderName: senderName ?? this.senderName,
    );
  }
}