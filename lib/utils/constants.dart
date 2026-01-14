class AppConstants {
  // App Info
  static const String appName = 'HeartLink';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Find Your Perfect Match';
  
  // API Configuration
  static const String baseUrl = 'http://localhost:8000';
  static const String apiVersion = '/api';
  static const String wsUrl = 'ws://localhost:8000/api/chat/ws';
  
  // Storage Keys
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userDataKey = 'user_data';
  static const String onboardingKey = 'onboarding_completed';
  static const String notificationKey = 'notifications_enabled';
  
  // Hive Boxes
  static const String userBox = 'user_box';
  static const String chatBox = 'chat_box';
  static const String matchBox = 'match_box';
  
  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 400);
  static const Duration longAnimation = Duration(milliseconds: 600);
  
  // UI Constants
  static const double borderRadius = 12.0;
  static const double cardElevation = 4.0;
  static const double buttonHeight = 56.0;
  static const double inputHeight = 56.0;
  
  // Swipe Constants
  static const double swipeThreshold = 100.0;
  static const double rotationAngle = 0.3;
  static const int maxSwipeDistance = 300;
  
  // Image Constants
  static const int maxImageSize = 5 * 1024 * 1024; // 5MB
  static const int imageQuality = 85;
  static const int maxImages = 6;
  
  // Chat Constants
  static const int messagesPerPage = 50;
  static const int maxMessageLength = 1000;
  
  // Location Constants
  static const double defaultLatitude = 28.6139;
  static const double defaultLongitude = 77.2090;
  static const double maxDistance = 100.0; // km
  
  // Age Constants
  static const int minAge = 18;
  static const int maxAge = 100;
  
  // Validation
  static const int minPasswordLength = 6;
  static const int maxBioLength = 500;
  static const int maxNameLength = 50;
  
  // Premium Features
  static const int freeSwipesPerDay = 100;
  static const int premiumSwipesPerDay = 1000;
  static const int superLikesPerDay = 5;
  
  // Error Messages
  static const String networkError = 'Network connection failed';
  static const String serverError = 'Server error occurred';
  static const String unknownError = 'Something went wrong';
  static const String noInternetError = 'No internet connection';
  
  // Success Messages
  static const String profileUpdated = 'Profile updated successfully';
  static const String imageUploaded = 'Image uploaded successfully';
  static const String matchFound = 'It\'s a match! 🎉';
  
  // Regex Patterns
  static const String emailPattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  static const String phonePattern = r'^\+?[1-9]\d{1,14}$';
  
  // Social Media
  static const String instagramUrl = 'https://instagram.com/heartlink_app';
  static const String twitterUrl = 'https://twitter.com/heartlink_app';
  static const String websiteUrl = 'https://heartlink.app';
  
  // Support
  static const String supportEmail = 'support@heartlink.app';
  static const String privacyPolicyUrl = 'https://heartlink.app/privacy';
  static const String termsOfServiceUrl = 'https://heartlink.app/terms';
}