import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../models/user_model.dart';
import '../services/api_service.dart';
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
  
  // Initialize authentication state
  Future<void> initializeAuth() async {
    state = state.copyWith(isLoading: true);
    
    try {
      // Check onboarding status
      final prefs = await SharedPreferences.getInstance();
      final isOnboarded = prefs.getBool(AppConstants.onboardingKey) ?? false;
      
      // Check for stored token
      final token = prefs.getString(AppConstants.accessTokenKey);
      
      if (token != null && !JwtDecoder.isExpired(token)) {
        // Token exists and is valid, get user data
        final user = await ApiService.instance.getCurrentUser();
        
        state = state.copyWith(
          isAuthenticated: true,
          isOnboarded: isOnboarded,
          user: user,
          isLoading: false,
        );
      } else {
        // No valid token
        await _clearAuthData();
        state = state.copyWith(
          isAuthenticated: false,
          isOnboarded: isOnboarded,
          isLoading: false,
        );
      }
    } catch (e) {
      await _clearAuthData();
      state = state.copyWith(
        isAuthenticated: false,
        isOnboarded: false,
        isLoading: false,
        error: 'Failed to initialize authentication',
      );
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
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        AppConstants.accessTokenKey,
        response.accessToken,
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
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        AppConstants.accessTokenKey,
        response.accessToken,
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
        preferences: updatedUser.preferences,
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
  
  // Private methods
  Future<void> _clearAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
  
  String _getErrorMessage(dynamic error) {
    if (error.toString().contains('401')) {
      return 'Invalid email or password';
    } else if (error.toString().contains('400')) {
      return 'Invalid request. Please check your input.';
    } else if (error.toString().contains('500')) {
      return 'Server error. Please try again later.';
    } else if (error.toString().contains('network')) {
      return 'Network error. Please check your connection.';
    } else {
      return 'An unexpected error occurred';
    }
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