import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';

class UserState {
  final UserModel? user;
  final bool isLoading;
  final String? error;

  UserState({
    this.user,
    this.isLoading = false,
    this.error,
  });

  UserState copyWith({
    UserModel? user,
    bool? isLoading,
    String? error,
  }) {
    return UserState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class UserNotifier extends StateNotifier<UserState> {
  UserNotifier() : super(UserState());

  Future<void> loadProfile() async {
    state = state.copyWith(isLoading: true);
    try {
      final user = await ApiService.instance.getProfile();
      state = state.copyWith(user: user, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> updateProfile({
    String? name,
    int? age,
    String? bio,
    String? location,
    List<String>? interests,
    String? relationshipIntent,
  }) async {
    state = state.copyWith(isLoading: true);
    try {
      final request = UpdateProfileRequest(
        name: name,
        age: age,
        bio: bio,
        location: location,
      );
      final user = await ApiService.instance.updateProfile(request);
      
      // Update interests if provided
      if (interests != null) {
        await ApiService.instance.updateInterests(
          InterestsUpdateRequest(interests: interests),
        );
      }
      
      // Update relationship intent if provided
      if (relationshipIntent != null) {
        await ApiService.instance.updateRelationshipIntent(
          RelationshipIntentRequest(intent: relationshipIntent),
        );
      }
      
      state = state.copyWith(user: user, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
      rethrow;
    }
  }
}

final userProvider = StateNotifierProvider<UserNotifier, UserState>((ref) {
  return UserNotifier();
});