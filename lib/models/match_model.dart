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