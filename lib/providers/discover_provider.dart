import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';

class DiscoverState {
  final List<UserModel> users;
  final bool isLoading;
  final String? error;

  DiscoverState({
    this.users = const [],
    this.isLoading = false,
    this.error,
  });

  DiscoverState copyWith({
    List<UserModel>? users,
    bool? isLoading,
    String? error,
  }) {
    return DiscoverState(
      users: users ?? this.users,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class DiscoverNotifier extends StateNotifier<DiscoverState> {
  DiscoverNotifier() : super(DiscoverState());

  Future<void> loadUsers() async {
    state = state.copyWith(isLoading: true);
    try {
      final response = await ApiService.instance.discoverUsers();
      state = state.copyWith(
        users: response.users,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  Future<void> swipeUser(int userId, bool isLike) async {
    try {
      final response = await ApiService.instance.swipeUser(
        SwipeRequest(swipedUserId: userId, isLike: isLike),
      );
      
      // Remove swiped user from list
      final updatedUsers = state.users.where((user) => user.id != userId).toList();
      state = state.copyWith(users: updatedUsers);
      
      // If it's a match, show notification
      if (response.isMatch) {
        // Handle match notification
      }
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> superLikeUser(int userId) async {
    try {
      // Implement super like logic
      await swipeUser(userId, true);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
}

final discoverProvider = StateNotifierProvider<DiscoverNotifier, DiscoverState>((ref) {
  return DiscoverNotifier();
});