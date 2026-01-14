import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utils/app_theme.dart';
import '../../providers/notification_provider.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  @override
  Widget build(BuildContext context) {
    final notificationSettings = ref.watch(notificationProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Push Notifications Master Switch
              _buildMasterSwitch(notificationSettings.pushNotifications),
              const SizedBox(height: 24),
              
              // Notification Types
              _buildSectionTitle('Notification Types'),
              _buildNotificationCard([
                _buildNotificationTile(
                  icon: Icons.favorite,
                  title: 'New Matches',
                  subtitle: 'When someone likes you back',
                  value: notificationSettings.newMatches,
                  onChanged: notificationSettings.pushNotifications ? (value) {
                    ref.read(notificationProvider.notifier).updateSetting('new_matches', value);
                  } : null,
                ),
                _buildNotificationTile(
                  icon: Icons.message,
                  title: 'New Messages',
                  subtitle: 'When you receive a message',
                  value: notificationSettings.newMessages,
                  onChanged: notificationSettings.pushNotifications ? (value) {
                    ref.read(notificationProvider.notifier).updateSetting('new_messages', value);
                  } : null,
                ),
                _buildNotificationTile(
                  icon: Icons.star,
                  title: 'Super Likes',
                  subtitle: 'When someone super likes you',
                  value: notificationSettings.superLikes,
                  onChanged: notificationSettings.pushNotifications ? (value) {
                    ref.read(notificationProvider.notifier).updateSetting('super_likes', value);
                  } : null,
                ),
                _buildNotificationTile(
                  icon: Icons.visibility,
                  title: 'Profile Views',
                  subtitle: 'When someone views your profile',
                  value: notificationSettings.profileViews,
                  onChanged: notificationSettings.pushNotifications ? (value) {
                    ref.read(notificationProvider.notifier).updateSetting('profile_views', value);
                  } : null,
                ),
                _buildNotificationTile(
                  icon: Icons.local_offer,
                  title: 'Promotions & Tips',
                  subtitle: 'Special offers and dating tips',
                  value: notificationSettings.promotions,
                  onChanged: notificationSettings.pushNotifications ? (value) {
                    ref.read(notificationProvider.notifier).updateSetting('promotions', value);
                  } : null,
                ),
              ]),
              const SizedBox(height: 24),
              
              // Sound & Vibration
              _buildSectionTitle('Sound & Vibration'),
              _buildNotificationCard([
                _buildNotificationTile(
                  icon: Icons.volume_up,
                  title: 'Sound',
                  subtitle: 'Play sound for notifications',
                  value: notificationSettings.soundEnabled,
                  onChanged: notificationSettings.pushNotifications ? (value) {
                    ref.read(notificationProvider.notifier).updateSetting('sound_enabled', value);
                  } : null,
                ),
                _buildNotificationTile(
                  icon: Icons.vibration,
                  title: 'Vibration',
                  subtitle: 'Vibrate for notifications',
                  value: notificationSettings.vibrationEnabled,
                  onChanged: notificationSettings.pushNotifications ? (value) {
                    ref.read(notificationProvider.notifier).updateSetting('vibration_enabled', value);
                  } : null,
                ),
              ]),
              const SizedBox(height: 24),
              
              // Quiet Hours
              _buildSectionTitle('Quiet Hours'),
              _buildQuietHoursCard(notificationSettings),
              const SizedBox(height: 24),
              
              // Additional Settings
              _buildSectionTitle('Additional Settings'),
              _buildNotificationCard([
                ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.settings,
                      color: AppTheme.primaryColor,
                      size: 20,
                    ),
                  ),
                  title: const Text(
                    'System Settings',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: const Text(
                    'Open device notification settings',
                    style: TextStyle(fontSize: 14),
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: _openSystemSettings,
                ),
              ]),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMasterSwitch(bool pushNotifications) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: pushNotifications 
            ? AppTheme.primaryGradient 
            : const LinearGradient(
                colors: [Colors.grey, Colors.grey],
              ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: (pushNotifications ? AppTheme.primaryColor : Colors.grey)
                .withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.notifications,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Push Notifications',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Enable all push notifications',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: pushNotifications,
            onChanged: (value) {
              ref.read(notificationProvider.notifier).updateSetting('push_notifications', value);
            },
            activeColor: Colors.white,
            activeTrackColor: Colors.white.withOpacity(0.3),
            inactiveThumbColor: Colors.white70,
            inactiveTrackColor: Colors.white.withOpacity(0.2),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppTheme.textPrimary,
        ),
      ),
    );
  }

  Widget _buildNotificationCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildNotificationTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool>? onChanged,
  }) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppTheme.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          color: AppTheme.primaryColor,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
          color: onChanged != null ? AppTheme.textPrimary : AppTheme.textSecondary,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: onChanged != null ? AppTheme.textSecondary : AppTheme.textLight,
          fontSize: 14,
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: AppTheme.primaryColor,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
    );
  }

  Widget _buildQuietHoursCard(NotificationSettings settings) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.bedtime,
                  color: AppTheme.primaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quiet Hours',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'Mute notifications during these hours',
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: settings.quietHoursEnabled,
                onChanged: settings.pushNotifications ? (value) {
                  ref.read(notificationProvider.notifier).updateSetting('quiet_hours_enabled', value);
                } : null,
                activeColor: AppTheme.primaryColor,
              ),
            ],
          ),
          if (settings.quietHoursEnabled) ...[
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _buildTimeSelector(
                    'From',
                    settings.quietHoursStart,
                    (time) {
                      ref.read(notificationProvider.notifier).updateSetting('quiet_hours_start', time);
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTimeSelector(
                    'To',
                    settings.quietHoursEnd,
                    (time) {
                      ref.read(notificationProvider.notifier).updateSetting('quiet_hours_end', time);
                    },
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTimeSelector(String label, String time, ValueChanged<String> onChanged) {
    return GestureDetector(
      onTap: () => _selectTime(time, onChanged),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.primaryColor.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              time,
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectTime(String currentTime, ValueChanged<String> onChanged) async {
    final timeParts = currentTime.split(':');
    final initialTime = TimeOfDay(
      hour: int.parse(timeParts[0]),
      minute: int.parse(timeParts[1]),
    );
    
    final selectedTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );
    
    if (selectedTime != null) {
      final formattedTime = '${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}';
      onChanged(formattedTime);
    }
  }

  void _openSystemSettings() {
    // NOTE: System settings integration coming soon
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('System settings integration coming soon'),
      ),
    );
  }
}