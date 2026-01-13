import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
@JsonSerializable()
class UserModel extends HiveObject {
  @HiveField(0)
  final int id;
  
  @HiveField(1)
  final String email;
  
  @HiveField(2)
  final String name;
  
  @HiveField(3)
  final int? age;
  
  @HiveField(4)
  final String? bio;
  
  @HiveField(5)
  final String? location;
  
  @HiveField(12)
  final double? latitude;
  
  @HiveField(13)
  final double? longitude;
  
  @HiveField(14)
  final List<String> interests;
  
  @HiveField(15)
  @JsonKey(name: 'relationship_intent')
  final String? relationshipIntent;
  
  @HiveField(16)
  @JsonKey(name: 'distance_km')
  final double? distanceKm;
  
  @HiveField(17)
  @JsonKey(name: 'compatibility_score')
  final double? compatibilityScore;
  
  @HiveField(6)
  @JsonKey(name: 'profile_images')
  final List<String> profileImages;
  
  @HiveField(7)
  final Map<String, dynamic> preferences;
  
  @HiveField(8)
  @JsonKey(name: 'is_verified')
  final bool isVerified;
  
  @HiveField(9)
  @JsonKey(name: 'is_premium')
  final bool isPremium;
  
  @HiveField(10)
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  
  @HiveField(11)
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;
  
  // Computed properties
  String get displayName => name;
  
  String get ageText => age != null ? '$age years old' : 'Age not specified';
  
  String get primaryImage => profileImages.isNotEmpty 
      ? profileImages.first 
      : '';
  
  bool get hasImages => profileImages.isNotEmpty;
  
  int get imageCount => profileImages.length;
  
  String get distanceText => distanceKm != null 
      ? '${distanceKm!.toStringAsFixed(1)} km away'
      : 'Distance unknown';
  
  String get compatibilityText => compatibilityScore != null 
      ? '${(compatibilityScore! * 100).round()}% match'
      : 'Compatibility unknown';
  
  String get relationshipIntentText {
    switch (relationshipIntent) {
      case 'serious':
        return 'Looking for serious relationship';
      case 'casual':
        return 'Open to casual dating';
      case 'friends':
        return 'Looking for friends';
      default:
        return 'Intent not specified';
    }
  }
  
  bool get isProfileComplete => 
      name.isNotEmpty && 
      age != null && 
      bio != null && 
      bio!.isNotEmpty && 
      profileImages.isNotEmpty &&
      interests.isNotEmpty &&
      relationshipIntent != null;
  
  double get profileCompleteness {
    double score = 0.0;
    
    if (name.isNotEmpty) score += 0.15;
    if (age != null) score += 0.15;
    if (bio != null && bio!.isNotEmpty) score += 0.15;
    if (location != null && location!.isNotEmpty) score += 0.1;
    if (latitude != null && longitude != null) score += 0.1;
    if (profileImages.isNotEmpty) score += 0.2;
    if (interests.isNotEmpty) score += 0.1;
    if (relationshipIntent != null) score += 0.05;
    
    return score;
  }
  
  UserModel({
    required this.id,
    required this.email,
    required this.name,
    this.age,
    this.bio,
    this.location,
    this.latitude,
    this.longitude,
    this.interests = const [],
    this.relationshipIntent,
    this.distanceKm,
    this.compatibilityScore,
    this.profileImages = const [],
    this.preferences = const {},
    this.isVerified = false,
    this.isPremium = false,
    required this.createdAt,
    this.updatedAt,
  });
  
  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
  
  Map<String, dynamic> toJson() => _$UserModelToJson(this);
  
  UserModel copyWith({
    int? id,
    String? email,
    String? name,
    int? age,
    String? bio,
    String? location,
    double? latitude,
    double? longitude,
    List<String>? interests,
    String? relationshipIntent,
    double? distanceKm,
    double? compatibilityScore,
    List<String>? profileImages,
    Map<String, dynamic>? preferences,
    bool? isVerified,
    bool? isPremium,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      age: age ?? this.age,
      bio: bio ?? this.bio,
      location: location ?? this.location,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      interests: interests ?? this.interests,
      relationshipIntent: relationshipIntent ?? this.relationshipIntent,
      distanceKm: distanceKm ?? this.distanceKm,
      compatibilityScore: compatibilityScore ?? this.compatibilityScore,
      profileImages: profileImages ?? this.profileImages,
      preferences: preferences ?? this.preferences,
      isVerified: isVerified ?? this.isVerified,
      isPremium: isPremium ?? this.isPremium,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModel &&
          runtimeType == other.runtimeType &&
          id == other.id;
  
  @override
  int get hashCode => id.hashCode;
  
  @override
  String toString() {
    return 'UserModel{id: $id, name: $name, email: $email}';
  }
}

// User Preferences Model
@HiveType(typeId: 1)
@JsonSerializable()
class UserPreferences extends HiveObject {
  @HiveField(0)
  @JsonKey(name: 'min_age')
  final int minAge;
  
  @HiveField(1)
  @JsonKey(name: 'max_age')
  final int maxAge;
  
  @HiveField(2)
  @JsonKey(name: 'max_distance')
  final double maxDistance;
  
  @HiveField(3)
  @JsonKey(name: 'interested_in')
  final String interestedIn; // 'men', 'women', 'both'
  
  @HiveField(4)
  @JsonKey(name: 'show_me_on_app')
  final bool showMeOnApp;
  
  @HiveField(5)
  @JsonKey(name: 'notifications_enabled')
  final bool notificationsEnabled;
  
  @HiveField(6)
  @JsonKey(name: 'location_enabled')
  final bool locationEnabled;
  
  UserPreferences({
    this.minAge = 18,
    this.maxAge = 35,
    this.maxDistance = 50.0,
    this.interestedIn = 'both',
    this.showMeOnApp = true,
    this.notificationsEnabled = true,
    this.locationEnabled = true,
  });
  
  factory UserPreferences.fromJson(Map<String, dynamic> json) =>
      _$UserPreferencesFromJson(json);
  
  Map<String, dynamic> toJson() => _$UserPreferencesToJson(this);
  
  UserPreferences copyWith({
    int? minAge,
    int? maxAge,
    double? maxDistance,
    String? interestedIn,
    bool? showMeOnApp,
    bool? notificationsEnabled,
    bool? locationEnabled,
  }) {
    return UserPreferences(
      minAge: minAge ?? this.minAge,
      maxAge: maxAge ?? this.maxAge,
      maxDistance: maxDistance ?? this.maxDistance,
      interestedIn: interestedIn ?? this.interestedIn,
      showMeOnApp: showMeOnApp ?? this.showMeOnApp,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      locationEnabled: locationEnabled ?? this.locationEnabled,
    );
  }
}