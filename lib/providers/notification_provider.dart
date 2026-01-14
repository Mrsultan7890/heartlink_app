import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationSettings {
  final bool pushNotifications;
  final bool newMatches;
  final bool newMessages;
  final bool superLikes;
  final bool profileViews;
  final bool promotions;
  final bool soundEnabled;
  final bool vibrationEnabled;
  final bool quietHoursEnabled;
  final String quietHoursStart;
  final String quietHoursEnd;

  NotificationSettings({
    this.pushNotifications = true,
    this.newMatches = true,
    this.newMessages = true,
    this.superLikes = true,
    this.profileViews = false,
    this.promotions = false,
    this.soundEnabled = true,
    this.vibrationEnabled = true,
    this.quietHoursEnabled = false,
    this.quietHoursStart = '22:00',
    this.quietHoursEnd = '08:00',
  });

  NotificationSettings copyWith({
    bool? pushNotifications,
    bool? newMatches,
    bool? newMessages,
    bool? superLikes,
    bool? profileViews,
    bool? promotions,
    bool? soundEnabled,
    bool? vibrationEnabled,
    bool? quietHoursEnabled,
    String? quietHoursStart,
    String? quietHoursEnd,
  }) {
    return NotificationSettings(
      pushNotifications: pushNotifications ?? this.pushNotifications,
      newMatches: newMatches ?? this.newMatches,
      newMessages: newMessages ?? this.newMessages,
      superLikes: superLikes ?? this.superLikes,
      profileViews: profileViews ?? this.profileViews,
      promotions: promotions ?? this.promotions,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
      quietHoursEnabled: quietHoursEnabled ?? this.quietHoursEnabled,
      quietHoursStart: quietHoursStart ?? this.quietHoursStart,
      quietHoursEnd: quietHoursEnd ?? this.quietHoursEnd,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'push_notifications': pushNotifications,
      'new_matches': newMatches,
      'new_messages': newMessages,
      'super_likes': superLikes,
      'profile_views': profileViews,
      'promotions': promotions,
      'sound_enabled': soundEnabled,
      'vibration_enabled': vibrationEnabled,
      'quiet_hours_enabled': quietHoursEnabled,
      'quiet_hours_start': quietHoursStart,
      'quiet_hours_end': quietHoursEnd,
    };
  }
}

class NotificationNotifier extends StateNotifier<NotificationSettings> {
  NotificationNotifier() : super(NotificationSettings()) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    state = NotificationSettings(
      pushNotifications: prefs.getBool('push_notifications') ?? true,
      newMatches: prefs.getBool('new_matches') ?? true,
      newMessages: prefs.getBool('new_messages') ?? true,
      superLikes: prefs.getBool('super_likes') ?? true,
      profileViews: prefs.getBool('profile_views') ?? false,
      promotions: prefs.getBool('promotions') ?? false,
      soundEnabled: prefs.getBool('sound_enabled') ?? true,
      vibrationEnabled: prefs.getBool('vibration_enabled') ?? true,
      quietHoursEnabled: prefs.getBool('quiet_hours_enabled') ?? false,
      quietHoursStart: prefs.getString('quiet_hours_start') ?? '22:00',
      quietHoursEnd: prefs.getString('quiet_hours_end') ?? '08:00',
    );
  }

  Future<void> updateSetting(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    
    if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is String) {
      await prefs.setString(key, value);
    }

    // Update state
    switch (key) {
      case 'push_notifications':
        state = state.copyWith(pushNotifications: value);
        break;
      case 'new_matches':
        state = state.copyWith(newMatches: value);
        break;
      case 'new_messages':
        state = state.copyWith(newMessages: value);
        break;
      case 'super_likes':
        state = state.copyWith(superLikes: value);
        break;
      case 'profile_views':
        state = state.copyWith(profileViews: value);
        break;
      case 'promotions':
        state = state.copyWith(promotions: value);
        break;
      case 'sound_enabled':
        state = state.copyWith(soundEnabled: value);
        break;
      case 'vibration_enabled':
        state = state.copyWith(vibrationEnabled: value);
        break;
      case 'quiet_hours_enabled':
        state = state.copyWith(quietHoursEnabled: value);
        break;
      case 'quiet_hours_start':
        state = state.copyWith(quietHoursStart: value);
        break;
      case 'quiet_hours_end':
        state = state.copyWith(quietHoursEnd: value);
        break;
    }

    // Sync with backend
    await _syncWithBackend();
  }

  Future<void> _syncWithBackend() async {
    try {
      // NOTE: Add backend API call to sync notification settings
      // await ApiService.instance.updateNotificationSettings(state.toJson());
    } catch (e) {
      // Handle error silently for now
    }
  }
}

final notificationProvider = StateNotifierProvider<NotificationNotifier, NotificationSettings>((ref) {
  return NotificationNotifier();
});