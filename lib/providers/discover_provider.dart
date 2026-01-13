import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';

// Discover State
class DiscoverState {
  final List<UserModel> users;
  final bool isLoading;
  final String? error;
  final bool hasMore;

  const DiscoverState({
    this.users = const [],
    this.isLoading = false,
    this.error,
    this.hasMore = true,
  });

  DiscoverState copyWith({
    List<UserModel>? users,
    bool? isLoading,
    String? error,
    bool? hasMore,
  }) {
    return DiscoverState(
      users: users ?? this.users,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

// Discover Notifier
class DiscoverNotifier extends StateNotifier<DiscoverState> {
  DiscoverNotifier() : super(const DiscoverState());

  Future<void> loadUsers({bool refresh = false}) async {
    if (state.isLoading) return;

    state = state.copyWith(
      isLoading: true,
      error: null,
    );

    try {
      final response = await ApiService.instance.discoverUsers(limit: 20);
      
      state = state.copyWith(
        users: refresh ? response.users : [...state.users, ...response.users],
        isLoading: false,
        hasMore: response.users.length >= 20,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> swipeUser(int userId, bool isLike) async {
    try {
      final request = SwipeRequest(
        swipedUserId: userId,
        isLike: isLike,
      );
      
      final response = await ApiService.instance.swipeUser(request);
      
      if (response.isMatch) {
        _showMatchDialog(response.matchId);
      }
      
      // Remove user from list
      final updatedUsers = state.users.where((user) => user.id != userId).toList();
      state = state.copyWith(users: updatedUsers);
      
      // Load more users if running low
      if (updatedUsers.length < 5) {
        loadUsers();
      }
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> superLikeUser(int userId) async {
    // Similar to swipeUser but with super like logic
    await swipeUser(userId, true);
  }

  void _showMatchDialog(int? matchId) {
    // This would typically show a match dialog
    // For now, we'll just update the state
    print('It\'s a match! Match ID: $matchId');
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

// Provider
final discoverProvider = StateNotifierProvider<DiscoverNotifier, DiscoverState>((ref) {
  return DiscoverNotifier();
});