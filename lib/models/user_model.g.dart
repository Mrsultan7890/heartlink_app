// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserModelAdapter extends TypeAdapter<UserModel> {
  @override
  final int typeId = 0;

  @override
  UserModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserModel(
      id: fields[0] as int,
      email: fields[1] as String,
      name: fields[2] as String,
      age: fields[3] as int?,
      bio: fields[4] as String?,
      location: fields[5] as String?,
      latitude: fields[12] as double?,
      longitude: fields[13] as double?,
      interests: (fields[14] as List?)?.cast<String>() ?? const [],
      relationshipIntent: fields[15] as String?,
      distanceKm: fields[16] as double?,
      compatibilityScore: fields[17] as double?,
      profileImages: (fields[6] as List?)?.cast<String>() ?? const [],
      preferences: (fields[7] as Map?)?.cast<String, dynamic>() ?? const {},
      isVerified: fields[8] as bool,
      isPremium: fields[9] as bool,
      createdAt: fields[10] as DateTime,
      updatedAt: fields[11] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer
      ..writeByte(18)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.email)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.age)
      ..writeByte(4)
      ..write(obj.bio)
      ..writeByte(5)
      ..write(obj.location)
      ..writeByte(6)
      ..write(obj.profileImages)
      ..writeByte(7)
      ..write(obj.preferences)
      ..writeByte(8)
      ..write(obj.isVerified)
      ..writeByte(9)
      ..write(obj.isPremium)
      ..writeByte(10)
      ..write(obj.createdAt)
      ..writeByte(11)
      ..write(obj.updatedAt)
      ..writeByte(12)
      ..write(obj.latitude)
      ..writeByte(13)
      ..write(obj.longitude)
      ..writeByte(14)
      ..write(obj.interests)
      ..writeByte(15)
      ..write(obj.relationshipIntent)
      ..writeByte(16)
      ..write(obj.distanceKm)
      ..writeByte(17)
      ..write(obj.compatibilityScore);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class UserPreferencesAdapter extends TypeAdapter<UserPreferences> {
  @override
  final int typeId = 1;

  @override
  UserPreferences read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserPreferences(
      minAge: fields[0] as int,
      maxAge: fields[1] as int,
      maxDistance: fields[2] as double,
      interestedIn: fields[3] as String,
      showMeOnApp: fields[4] as bool,
      notificationsEnabled: fields[5] as bool,
      locationEnabled: fields[6] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, UserPreferences obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.minAge)
      ..writeByte(1)
      ..write(obj.maxAge)
      ..writeByte(2)
      ..write(obj.maxDistance)
      ..writeByte(3)
      ..write(obj.interestedIn)
      ..writeByte(4)
      ..write(obj.showMeOnApp)
      ..writeByte(5)
      ..write(obj.notificationsEnabled)
      ..writeByte(6)
      ..write(obj.locationEnabled);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserPreferencesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      id: json['id'] as int,
      email: json['email'] as String,
      name: json['name'] as String,
      age: json['age'] as int?,
      bio: json['bio'] as String?,
      location: json['location'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      interests: (json['interests'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      relationshipIntent: json['relationship_intent'] as String?,
      distanceKm: (json['distance_km'] as num?)?.toDouble(),
      compatibilityScore: (json['compatibility_score'] as num?)?.toDouble(),
      profileImages: (json['profile_images'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      preferences: json['preferences'] as Map<String, dynamic>? ?? const {},
      isVerified: json['is_verified'] as bool? ?? false,
      isPremium: json['is_premium'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'name': instance.name,
      'age': instance.age,
      'bio': instance.bio,
      'location': instance.location,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'interests': instance.interests,
      'relationship_intent': instance.relationshipIntent,
      'distance_km': instance.distanceKm,
      'compatibility_score': instance.compatibilityScore,
      'profile_images': instance.profileImages,
      'preferences': instance.preferences,
      'is_verified': instance.isVerified,
      'is_premium': instance.isPremium,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

UserPreferences _$UserPreferencesFromJson(Map<String, dynamic> json) =>
    UserPreferences(
      minAge: json['min_age'] as int? ?? 18,
      maxAge: json['max_age'] as int? ?? 35,
      maxDistance: (json['max_distance'] as num?)?.toDouble() ?? 50.0,
      interestedIn: json['interested_in'] as String? ?? 'both',
      showMeOnApp: json['show_me_on_app'] as bool? ?? true,
      notificationsEnabled: json['notifications_enabled'] as bool? ?? true,
      locationEnabled: json['location_enabled'] as bool? ?? true,
    );

Map<String, dynamic> _$UserPreferencesToJson(UserPreferences instance) =>
    <String, dynamic>{
      'min_age': instance.minAge,
      'max_age': instance.maxAge,
      'max_distance': instance.maxDistance,
      'interested_in': instance.interestedIn,
      'show_me_on_app': instance.showMeOnApp,
      'notifications_enabled': instance.notificationsEnabled,
      'location_enabled': instance.locationEnabled,
    };