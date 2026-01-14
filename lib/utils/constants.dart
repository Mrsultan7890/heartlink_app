class AppConstants {
  // API Configuration
  static const String baseUrl = 'http://localhost:8000';
  static const String apiVersion = '/api';
  
  // Storage Keys
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userIdKey = 'user_id';
  static const String onboardingKey = 'onboarding_completed';
  
  // App Configuration
  static const String appName = 'HeartLink';
  static const String appVersion = '1.0.0';
  
  // Validation
  static const int minAge = 18;
  static const int maxAge = 100;
  static const int maxBioLength = 500;
  static const int maxInterests = 10;
  static const int maxNameLength = 50;
  static const int minPasswordLength = 6;
  static const String emailPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
  
  // Pagination
  static const int defaultPageSize = 20;
  static const int maxImageCount = 6;
}