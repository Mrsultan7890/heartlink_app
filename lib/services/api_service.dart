import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/user_model.dart';
import '../models/match_model.dart';
import '../models/message_model.dart';
import '../utils/constants.dart';

part 'api_service.g.dart';

@RestApi(baseUrl: AppConstants.baseUrl + AppConstants.apiVersion)
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;
  
  static late ApiService _instance;
  static late Dio _dio;
  static const _storage = FlutterSecureStorage();
  
  static Future<void> initialize() async {
    _dio = Dio();
    
    // Add interceptors
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      logPrint: (obj) => print(obj),
    ));
    
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Add auth token
        final token = await _storage.read(key: AppConstants.accessTokenKey);
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        options.headers['Content-Type'] = 'application/json';
        handler.next(options);
      },
      onError: (error, handler) async {
        // Handle token refresh
        if (error.response?.statusCode == 401) {
          await _handleTokenRefresh();
          // Retry request
          final newToken = await _storage.read(key: AppConstants.accessTokenKey);
          if (newToken != null) {
            error.requestOptions.headers['Authorization'] = 'Bearer $newToken';
            final response = await _dio.fetch<Map<String, dynamic>>(error.requestOptions);
            handler.resolve(response);
            return;
          }
        }
        handler.next(error);
      },
    ));
    
    _instance = ApiService(_dio);
  }
  
  static ApiService get instance => _instance;
  
  static Future<void> _handleTokenRefresh() async {
    try {
      final refreshToken = await _storage.read(key: AppConstants.refreshTokenKey);
      if (refreshToken != null) {
        final response = await _dio.post<Map<String, dynamic>>(
          '${AppConstants.baseUrl}${AppConstants.apiVersion}/auth/refresh',
          data: {'refresh_token': refreshToken},
        );
        
        final newToken = response.data?['access_token'];
        await _storage.write(key: AppConstants.accessTokenKey, value: newToken);
      }
    } catch (e) {
      // Clear tokens and redirect to login
      await _storage.deleteAll();
    }
  }
  
  // Authentication Endpoints
  @POST('/auth/register')
  Future<AuthResponse> register(@Body() RegisterRequest request);
  
  @POST('/auth/login')
  Future<AuthResponse> login(@Body() LoginRequest request);
  
  @POST('/auth/logout')
  Future<void> logout();
  
  @GET('/auth/me')
  Future<UserModel> getCurrentUser();
  
  // User Endpoints
  @GET('/users/profile')
  Future<UserModel> getProfile();
  
  @PUT('/users/profile')
  Future<UserModel> updateProfile(@Body() UpdateProfileRequest request);
  
  @POST('/users/upload-image')
  Future<ImageUploadResponse> uploadImage(@Body() ImageUploadRequest request);
  
  @DELETE('/users/image/{index}')
  Future<void> deleteImage(@Path('index') int index);
  
  @GET('/users/discover')
  Future<DiscoverResponse> discoverUsers({
    @Query('limit') int limit = 10,
    @Query('min_age') int? minAge,
    @Query('max_age') int? maxAge,
    @Query('max_distance_km') double? maxDistanceKm,
    @Query('relationship_intent') String? relationshipIntent,
    @Query('required_interests') String? requiredInterests,
  });
  
  @GET('/users/nearby')
  Future<NearbyUsersResponse> getNearbyUsers({
    @Query('radius_km') double radiusKm = 5.0,
    @Query('limit') int limit = 20,
  });
  
  @PUT('/users/location')
  Future<LocationUpdateResponse> updateLocation(
    @Query('latitude') double latitude,
    @Query('longitude') double longitude,
    @Query('location_name') String? locationName,
  );
  
  @PUT('/users/interests')
  Future<InterestsUpdateResponse> updateInterests(@Body() InterestsUpdateRequest request);
  
  @PUT('/users/relationship-intent')
  Future<RelationshipIntentResponse> updateRelationshipIntent(@Body() RelationshipIntentRequest request);
  
  @GET('/users/interests')
  Future<AvailableInterestsResponse> getAvailableInterests();
  
  @GET('/users/preferences')
  Future<PreferencesResponse> getPreferences();
  
  @PUT('/users/preferences')
  Future<PreferencesResponse> updatePreferences(@Body() Map<String, dynamic> preferences);
  
  // Match Endpoints
  @POST('/matches/swipe')
  Future<SwipeResponse> swipeUser(@Body() SwipeRequest request);
  
  @GET('/matches')
  Future<List<MatchModel>> getMatches();
  
  @DELETE('/matches/{matchId}')
  Future<void> unmatchUser(@Path('matchId') int matchId);
  
  // Chat Endpoints
  @GET('/chat/{matchId}/messages')
  Future<List<MessageModel>> getMessages(
    @Path('matchId') int matchId,
    {@Query('limit') int limit = 50, @Query('offset') int offset = 0}
  );
  
  @POST('/chat/{matchId}/messages')
  Future<MessageModel> sendMessage(
    @Path('matchId') int matchId,
    @Body() SendMessageRequest request
  );
  
  @GET('/chat/{matchId}/unread-count')
  Future<UnreadCountResponse> getUnreadCount(@Path('matchId') int matchId);
}

// Request/Response Models
@JsonSerializable()
class RegisterRequest {
  final String email;
  final String password;
  final String name;
  final int? age;
  final String? bio;
  final String? location;
  
  RegisterRequest({
    required this.email,
    required this.password,
    required this.name,
    this.age,
    this.bio,
    this.location,
  });
  
  factory RegisterRequest.fromJson(Map<String, dynamic> json) =>
      _$RegisterRequestFromJson(json);
  Map<String, dynamic> toJson() => _$RegisterRequestToJson(this);
}

@JsonSerializable()
class LoginRequest {
  final String email;
  final String password;
  
  LoginRequest({required this.email, required this.password});
  
  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);
  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);
}

@JsonSerializable()
class AuthResponse {
  @JsonKey(name: 'access_token')
  final String accessToken;
  @JsonKey(name: 'token_type')
  final String tokenType;
  final UserModel user;
  
  AuthResponse({
    required this.accessToken,
    required this.tokenType,
    required this.user,
  });
  
  factory AuthResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseFromJson(json);
  Map<String, dynamic> toJson() => _$AuthResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class UpdateProfileRequest {
  final String? name;
  final int? age;
  final String? bio;
  final String? location;
  
  UpdateProfileRequest({
    this.name,
    this.age,
    this.bio,
    this.location,
  });
  
  factory UpdateProfileRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateProfileRequestFromJson(json);
  Map<String, dynamic> toJson() => _$UpdateProfileRequestToJson(this);
}

@JsonSerializable()
class ImageUploadRequest {
  @JsonKey(name: 'telegram_file_id')
  final String telegramFileId;
  final String? caption;
  
  ImageUploadRequest({
    required this.telegramFileId,
    this.caption,
  });
  
  factory ImageUploadRequest.fromJson(Map<String, dynamic> json) =>
      _$ImageUploadRequestFromJson(json);
  Map<String, dynamic> toJson() => _$ImageUploadRequestToJson(this);
}

@JsonSerializable()
class ImageUploadResponse {
  final String message;
  @JsonKey(name: 'image_count')
  final int imageCount;
  @JsonKey(name: 'file_id')
  final String fileId;
  
  ImageUploadResponse({
    required this.message,
    required this.imageCount,
    required this.fileId,
  });
  
  factory ImageUploadResponse.fromJson(Map<String, dynamic> json) =>
      _$ImageUploadResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ImageUploadResponseToJson(this);
}

@JsonSerializable()
class SwipeRequest {
  @JsonKey(name: 'swiped_user_id')
  final int swipedUserId;
  @JsonKey(name: 'is_like')
  final bool isLike;
  
  SwipeRequest({
    required this.swipedUserId,
    required this.isLike,
  });
  
  factory SwipeRequest.fromJson(Map<String, dynamic> json) =>
      _$SwipeRequestFromJson(json);
  Map<String, dynamic> toJson() => _$SwipeRequestToJson(this);
}

@JsonSerializable()
class SwipeResponse {
  @JsonKey(name: 'is_match')
  final bool isMatch;
  @JsonKey(name: 'match_id')
  final int? matchId;
  
  SwipeResponse({
    required this.isMatch,
    this.matchId,
  });
  
  factory SwipeResponse.fromJson(Map<String, dynamic> json) =>
      _$SwipeResponseFromJson(json);
  Map<String, dynamic> toJson() => _$SwipeResponseToJson(this);
}

@JsonSerializable()
class SendMessageRequest {
  final String content;
  @JsonKey(name: 'message_type')
  final String messageType;
  
  SendMessageRequest({
    required this.content,
    this.messageType = 'text',
  });
  
  factory SendMessageRequest.fromJson(Map<String, dynamic> json) =>
      _$SendMessageRequestFromJson(json);
  Map<String, dynamic> toJson() => _$SendMessageRequestToJson(this);
}

@JsonSerializable()
class UnreadCountResponse {
  @JsonKey(name: 'unread_count')
  final int unreadCount;
  
  UnreadCountResponse({required this.unreadCount});
  
  factory UnreadCountResponse.fromJson(Map<String, dynamic> json) =>
      _$UnreadCountResponseFromJson(json);
  Map<String, dynamic> toJson() => _$UnreadCountResponseToJson(this);
}

// New Request/Response Models for Advanced Features
@JsonSerializable(explicitToJson: true)
class DiscoverResponse {
  final List<UserModel> users;
  @JsonKey(name: 'total_found')
  final int totalFound;
  @JsonKey(name: 'filters_applied')
  final Map<String, String> filtersApplied;
  
  DiscoverResponse({
    required this.users,
    required this.totalFound,
    required this.filtersApplied,
  });
  
  factory DiscoverResponse.fromJson(Map<String, dynamic> json) =>
      _$DiscoverResponseFromJson(json);
  Map<String, dynamic> toJson() => _$DiscoverResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class NearbyUsersResponse {
  @JsonKey(name: 'nearby_users')
  final List<UserModel> nearbyUsers;
  @JsonKey(name: 'radius_km')
  final double radiusKm;
  @JsonKey(name: 'user_location')
  final Map<String, double> userLocation;
  
  NearbyUsersResponse({
    required this.nearbyUsers,
    required this.radiusKm,
    required this.userLocation,
  });
  
  factory NearbyUsersResponse.fromJson(Map<String, dynamic> json) =>
      _$NearbyUsersResponseFromJson(json);
  Map<String, dynamic> toJson() => _$NearbyUsersResponseToJson(this);
}

@JsonSerializable()
class LocationUpdateRequest {
  final double latitude;
  final double longitude;
  @JsonKey(name: 'location_name')
  final String? locationName;
  
  LocationUpdateRequest({
    required this.latitude,
    required this.longitude,
    this.locationName,
  });
  
  factory LocationUpdateRequest.fromJson(Map<String, dynamic> json) =>
      _$LocationUpdateRequestFromJson(json);
  Map<String, dynamic> toJson() => _$LocationUpdateRequestToJson(this);
}

@JsonSerializable()
class LocationUpdateResponse {
  final String message;
  final double latitude;
  final double longitude;
  @JsonKey(name: 'location_name')
  final String? locationName;
  
  LocationUpdateResponse({
    required this.message,
    required this.latitude,
    required this.longitude,
    this.locationName,
  });
  
  factory LocationUpdateResponse.fromJson(Map<String, dynamic> json) =>
      _$LocationUpdateResponseFromJson(json);
  Map<String, dynamic> toJson() => _$LocationUpdateResponseToJson(this);
}

@JsonSerializable()
class InterestsUpdateRequest {
  final List<String> interests;
  
  InterestsUpdateRequest({required this.interests});
  
  factory InterestsUpdateRequest.fromJson(Map<String, dynamic> json) =>
      _$InterestsUpdateRequestFromJson(json);
  Map<String, dynamic> toJson() => _$InterestsUpdateRequestToJson(this);
}

@JsonSerializable()
class InterestsUpdateResponse {
  final String message;
  final List<String> interests;
  @JsonKey(name: 'available_interests')
  final List<String> availableInterests;
  
  InterestsUpdateResponse({
    required this.message,
    required this.interests,
    required this.availableInterests,
  });
  
  factory InterestsUpdateResponse.fromJson(Map<String, dynamic> json) =>
      _$InterestsUpdateResponseFromJson(json);
  Map<String, dynamic> toJson() => _$InterestsUpdateResponseToJson(this);
}

@JsonSerializable()
class RelationshipIntentRequest {
  final String intent;
  
  RelationshipIntentRequest({required this.intent});
  
  factory RelationshipIntentRequest.fromJson(Map<String, dynamic> json) =>
      _$RelationshipIntentRequestFromJson(json);
  Map<String, dynamic> toJson() => _$RelationshipIntentRequestToJson(this);
}

@JsonSerializable()
class RelationshipIntentResponse {
  final String message;
  final String intent;
  @JsonKey(name: 'available_intents')
  final List<String> availableIntents;
  
  RelationshipIntentResponse({
    required this.message,
    required this.intent,
    required this.availableIntents,
  });
  
  factory RelationshipIntentResponse.fromJson(Map<String, dynamic> json) =>
      _$RelationshipIntentResponseFromJson(json);
  Map<String, dynamic> toJson() => _$RelationshipIntentResponseToJson(this);
}

@JsonSerializable()
class AvailableInterestsResponse {
  final List<String> interests;
  @JsonKey(name: 'total_count')
  final int totalCount;
  
  AvailableInterestsResponse({
    required this.interests,
    required this.totalCount,
  });
  
  factory AvailableInterestsResponse.fromJson(Map<String, dynamic> json) =>
      _$AvailableInterestsResponseFromJson(json);
  Map<String, dynamic> toJson() => _$AvailableInterestsResponseToJson(this);
}

@JsonSerializable()
class PreferencesResponse {
  final String message;
  final Map<String, dynamic> preferences;
  
  PreferencesResponse({
    this.message = '',
    required this.preferences,
  });
  
  factory PreferencesResponse.fromJson(Map<String, dynamic> json) =>
      _$PreferencesResponseFromJson(json);
  Map<String, dynamic> toJson() => _$PreferencesResponseToJson(this);
}

// Static helper methods
class ApiServiceHelpers {
  static Future<DiscoverResponse> discoverUsersWithFilters(Map<String, dynamic> filters) async {
    return await ApiService.instance.discoverUsers(
      limit: filters['limit'] ?? 10,
      minAge: filters['min_age'],
      maxAge: filters['max_age'],
      maxDistanceKm: filters['max_distance_km'],
      relationshipIntent: filters['relationship_intent'],
      requiredInterests: filters['required_interests'],
    );
  }
  
  static Future<void> updateUserLocation(double latitude, double longitude, {String? locationName}) async {
    await ApiService.instance.updateLocation(
      latitude,
      longitude,
      locationName,
    );
  }
  
  static Future<void> updateInterests(List<String> interests) async {
    await ApiService.instance.updateInterests(
      InterestsUpdateRequest(interests: interests),
    );
  }
  
  static Future<void> updateRelationshipIntent(String intent) async {
    await ApiService.instance.updateRelationshipIntent(
      RelationshipIntentRequest(intent: intent),
    );
  }
}