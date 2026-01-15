import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../models/user_model.dart';
import '../services/api_service.dart';
import '../services/location_service.dart';
import '../utils/constants.dart';

// Auth State
class AuthState {
  final bool isAuthenticated;
  final bool isLoading;
  final bool isOnboarded;
  final UserModel? user;
  final String? error;
  
  const AuthState({
    this.isAuthenticated = false,
    this.isLoading = false,
    this.isOnboarded = false,
    this.user,
    this.error,
  });
  
  AuthState copyWith({
    bool? isAuthenticated,
    bool? isLoading,
    bool? isOnboarded,
    UserModel? user,
    String? error,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      isOnboarded: isOnboarded ?? this.isOnboarded,
      user: user ?? this.user,
      error: error,
    );
  }
}

// Auth Provider
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState());
  
  static const _storage = FlutterSecureStorage();
  
  Future<void> initializeAuth() async {
    state = state.copyWith(isLoading: true);
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final isOnboarded = prefs.getBool(AppConstants.onboardingKey) ?? false;
      
      final token = await _storage.read(key: AppConstants.accessTokenKey)
          .timeout(const Duration(seconds: 2), onTimeout: () => null);
      
      if (token != null && token.isNotEmpty) {
        try {
          final isExpired = JwtDecoder.isExpired(token);
          
          if (!isExpired) {
            try {
              final user = await ApiService.instance.getCurrentUser().timeout(
                const Duration(seconds: 3),
                onTimeout: () => throw Exception('API timeout'),
              );
              
              state = state.copyWith(
                isAuthenticated: true,
                isOnboarded: isOnboarded,
                user: user,
                isLoading: false,
              );
              return;
            } catch (e) {
              state = state.copyWith(
                isAuthenticated: true,
                isOnboarded: isOnboarded,
                isLoading: false,
              );
              return;
            }
          }
        } catch (e) {}
      }
      
      await _clearAuthData();
      state = state.copyWith(
        isAuthenticated: false,
        isOnboarded: isOnboarded,
        isLoading: false,
      );
    } catch (e) {
      try {
        final prefs = await SharedPreferences.getInstance().timeout(
          const Duration(seconds: 1),
          onTimeout: () => throw Exception('SharedPreferences timeout'),
        );
        final isOnboarded = prefs.getBool(AppConstants.onboardingKey) ?? false;
        
        final token = await _storage.read(key: AppConstants.accessTokenKey)
            .timeout(const Duration(seconds: 1), onTimeout: () => null);
        
        if (token != null && token.isNotEmpty) {
          try {
            final isExpired = JwtDecoder.isExpired(token);
            if (!isExpired) {
              state = state.copyWith(
                isAuthenticated: true,
                isOnboarded: isOnboarded,
                isLoading: false,
              );
              return;
            }
          } catch (_) {}
        }
        
        state = state.copyWith(
          isAuthenticated: false,
          isOnboarded: isOnboarded,
          isLoading: false,
        );
      } catch (storageError) {
        state = state.copyWith(
          isAuthenticated: false,
          isOnboarded: false,
          isLoading: false,
          error: null,
        );
      }
    }
  }
  
  // Register new user
  Future<bool> register({
    required String email,
    required String password,
    required String name,
    int? age,
    String? bio,
    String? location,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final request = RegisterRequest(
        email: email,
        password: password,
        name: name,
        age: age,
        bio: bio,
        location: location,
      );
      
      final response = await ApiService.instance.register(request);
      
      // Store tokens
      await _storage.write(
        key: AppConstants.accessTokenKey,
        value: response.accessToken,
      );
      
      state = state.copyWith(
        isAuthenticated: true,
        user: response.user,
        isLoading: false,
      );
      
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: _getErrorMessage(e),
      );
      return false;
    }
  }
  
  // Login user
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final request = LoginRequest(
        email: email,
        password: password,
      );
      
      final response = await ApiService.instance.login(request);
      
      // Store tokens
      await _storage.write(
        key: AppConstants.accessTokenKey,
        value: response.accessToken,
      );
      
      print('✅ Login successful, token stored');
      
      state = state.copyWith(
        isAuthenticated: true,
        user: response.user,
        isLoading: false,
      );
      
      // Auto-detect and update location in background
      _updateLocationInBackground();
      
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: _getErrorMessage(e),
      );
      return false;
    }
  }
  
  // Logout user
  Future<void> logout() async {
    state = state.copyWith(isLoading: true);
    
    try {
      await ApiService.instance.logout();
    } catch (e) {
      // Continue with logout even if API call fails
    }
    
    await _clearAuthData();
    state = const AuthState(isOnboarded: true);
  }
  
  // Update user profile
  Future<bool> updateProfile(UserModel updatedUser) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final request = UpdateProfileRequest(
        name: updatedUser.name,
        age: updatedUser.age,
        bio: updatedUser.bio,
        location: updatedUser.location,
      );
      
      final user = await ApiService.instance.updateProfile(request);
      
      state = state.copyWith(
        user: user,
        isLoading: false,
      );
      
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: _getErrorMessage(e),
      );
      return false;
    }
  }
  
  // Mark onboarding as completed
  Future<void> completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.onboardingKey, true);
    
    state = state.copyWith(isOnboarded: true);
  }
  
  // Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }
  
  Future<void> _updateLocationInBackground() async {
    try {
      final locationData = await LocationService.getCurrentLocationWithAddress();
      
      if (locationData != null) {
        await ApiService.instance.updateLocation(
          locationData['latitude'],
          locationData['longitude'],
          locationData['address'],
        );
      }
    } catch (e) {}
  }
  
  // Private methods
  Future<void> _clearAuthData() async {
    await _storage.deleteAll();
  }
  
  String _getErrorMessage(dynamic error) {
    final errorStr = error.toString().toLowerCase();
    
    // Authentication errors
    if (errorStr.contains('401') || errorStr.contains('unauthorized')) {
      return 'Invalid email or password';
    }
    if (errorStr.contains('incorrect email or password')) {
      return 'Incorrect email or password';
    }
    
    // Registration errors
    if (errorStr.contains('400') || errorStr.contains('bad request')) {
      if (errorStr.contains('email already registered')) {
        return 'Email already registered. Please login instead.';
      }
      return 'Invalid information. Please check your details.';
    }
    
    // Server errors
    if (errorStr.contains('500') || errorStr.contains('internal server')) {
      return 'Server error. Please try again later.';
    }
    
    // Network errors
    if (errorStr.contains('network') || errorStr.contains('connection')) {
      return 'Network error. Please check your internet connection.';
    }
    if (errorStr.contains('timeout')) {
      return 'Request timeout. Please try again.';
    }
    if (errorStr.contains('failed host lookup')) {
      return 'Cannot connect to server. Please check your connection.';
    }
    
    // Validation errors
    if (errorStr.contains('email')) {
      return 'Invalid email format';
    }
    if (errorStr.contains('password')) {
      return 'Password must be at least 6 characters';
    }
    
    return 'An unexpected error occurred. Please try again.';
  }
}

// Provider
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

// Computed providers
final currentUserProvider = Provider<UserModel?>((ref) {
  return ref.watch(authProvider).user;
});

final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).isAuthenticated;
});

final isLoadingProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).isLoading;
});

final authErrorProvider = Provider<String?>((ref) {
  return ref.watch(authProvider).error;
});