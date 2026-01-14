import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/app_theme.dart';

class PrivacyScreen extends ConsumerStatefulWidget {
  const PrivacyScreen({super.key});

  @override
  ConsumerState<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends ConsumerState<PrivacyScreen> {
  bool showMeOnApp = true;
  bool showDistance = true;
  bool showAge = true;
  bool showOnlineStatus = false;
  bool allowMessageRequests = true;
  bool blurPhotosForNonMatches = false;
  bool hideFromFacebook = false;
  bool hideFromContacts = false;
  String profileVisibility = 'everyone'; // everyone, matches_only, hidden
  String ageRange = '18-35';
  double maxDistance = 50.0;
  String interestedIn = 'everyone'; // men, women, everyone

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      showMeOnApp = prefs.getBool('show_me_on_app') ?? true;
      showDistance = prefs.getBool('show_distance') ?? true;
      showAge = prefs.getBool('show_age') ?? true;
      showOnlineStatus = prefs.getBool('show_online_status') ?? false;
      allowMessageRequests = prefs.getBool('allow_message_requests') ?? true;
      blurPhotosForNonMatches = prefs.getBool('blur_photos_for_non_matches') ?? false;
      hideFromFacebook = prefs.getBool('hide_from_facebook') ?? false;
      hideFromContacts = prefs.getBool('hide_from_contacts') ?? false;
      profileVisibility = prefs.getString('profile_visibility') ?? 'everyone';
      ageRange = prefs.getString('age_range') ?? '18-35';
      maxDistance = prefs.getDouble('max_distance') ?? 50.0;
      interestedIn = prefs.getString('interested_in') ?? 'everyone';
    });
  }

  Future<void> _saveSetting(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is String) {
      await prefs.setString(key, value);
    } else if (value is double) {
      await prefs.setDouble(key, value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Settings'),
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
              // Profile Visibility
              _buildSectionTitle('Profile Visibility'),
              _buildPrivacyCard([
                _buildPrivacyTile(
                  icon: Icons.visibility,
                  title: 'Show me on HeartLink',
                  subtitle: 'Allow others to discover your profile',
                  value: showMeOnApp,
                  onChanged: (value) {
                    setState(() => showMeOnApp = value);
                    _saveSetting('show_me_on_app', value);
                  },
                ),
                _buildDropdownTile(
                  icon: Icons.people,
                  title: 'Profile Visibility',
                  subtitle: 'Who can see your profile',
                  value: profileVisibility,
                  items: [
                    {'value': 'everyone', 'label': 'Everyone'},
                    {'value': 'matches_only', 'label': 'Matches Only'},
                    {'value': 'hidden', 'label': 'Hidden'},
                  ],
                  onChanged: (value) {
                    setState(() => profileVisibility = value!);
                    _saveSetting('profile_visibility', value);
                  },
                ),
              ]),
              const SizedBox(height: 24),
              
              // Information Display
              _buildSectionTitle('Information Display'),
              _buildPrivacyCard([
                _buildPrivacyTile(
                  icon: Icons.location_on,
                  title: 'Show Distance',
                  subtitle: 'Display distance from your location',
                  value: showDistance,
                  onChanged: (value) {
                    setState(() => showDistance = value);
                    _saveSetting('show_distance', value);
                  },
                ),
                _buildPrivacyTile(
                  icon: Icons.cake,
                  title: 'Show Age',
                  subtitle: 'Display your age on profile',
                  value: showAge,
                  onChanged: (value) {
                    setState(() => showAge = value);
                    _saveSetting('show_age', value);
                  },
                ),
                _buildPrivacyTile(
                  icon: Icons.circle,
                  title: 'Show Online Status',
                  subtitle: 'Let others see when you\'re online',
                  value: showOnlineStatus,
                  onChanged: (value) {
                    setState(() => showOnlineStatus = value);
                    _saveSetting('show_online_status', value);
                  },
                ),
              ]),
              const SizedBox(height: 24),
              
              // Photo Privacy
              _buildSectionTitle('Photo Privacy'),
              _buildPrivacyCard([
                _buildPrivacyTile(
                  icon: Icons.blur_on,
                  title: 'Blur Photos for Non-Matches',
                  subtitle: 'Only matches can see clear photos',
                  value: blurPhotosForNonMatches,
                  onChanged: (value) {
                    setState(() => blurPhotosForNonMatches = value);
                    _saveSetting('blur_photos_for_non_matches', value);
                  },
                ),
              ]),
              const SizedBox(height: 24),
              
              // Communication
              _buildSectionTitle('Communication'),
              _buildPrivacyCard([
                _buildPrivacyTile(
                  icon: Icons.message,
                  title: 'Allow Message Requests',
                  subtitle: 'Let non-matches send you messages',
                  value: allowMessageRequests,
                  onChanged: (value) {
                    setState(() => allowMessageRequests = value);
                    _saveSetting('allow_message_requests', value);
                  },
                ),
              ]),
              const SizedBox(height: 24),
              
              // Discovery Preferences
              _buildSectionTitle('Discovery Preferences'),
              _buildDiscoveryCard(),
              const SizedBox(height: 24),
              
              // Social Media Privacy
              _buildSectionTitle('Social Media Privacy'),
              _buildPrivacyCard([
                _buildPrivacyTile(
                  icon: Icons.facebook,
                  title: 'Hide from Facebook Friends',
                  subtitle: 'Don\'t show your profile to Facebook friends',
                  value: hideFromFacebook,
                  onChanged: (value) {
                    setState(() => hideFromFacebook = value);
                    _saveSetting('hide_from_facebook', value);
                  },
                ),
                _buildPrivacyTile(
                  icon: Icons.contacts,
                  title: 'Hide from Contacts',
                  subtitle: 'Don\'t show your profile to phone contacts',
                  value: hideFromContacts,
                  onChanged: (value) {
                    setState(() => hideFromContacts = value);
                    _saveSetting('hide_from_contacts', value);
                  },
                ),
              ]),
              const SizedBox(height: 24),
              
              // Data & Account
              _buildSectionTitle('Data & Account'),
              _buildPrivacyCard([
                ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.download,
                      color: AppTheme.primaryColor,
                      size: 20,
                    ),
                  ),
                  title: const Text(
                    'Download My Data',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: const Text(
                    'Get a copy of your data',
                    style: TextStyle(fontSize: 14),
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: _downloadData,
                ),
                ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.delete_forever,
                      color: Colors.red,
                      size: 20,
                    ),
                  ),
                  title: const Text(
                    'Delete Account',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colors.red,
                    ),
                  ),
                  subtitle: const Text(
                    'Permanently delete your account',
                    style: TextStyle(fontSize: 14),
                  ),
                  trailing: const Icon(Icons.chevron_right, color: Colors.red),
                  onTap: _deleteAccount,
                ),
              ]),
              const SizedBox(height: 32),
            ],
          ),
        ),
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

  Widget _buildPrivacyCard(List<Widget> children) {
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

  Widget _buildPrivacyTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
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
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          color: AppTheme.textSecondary,
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

  Widget _buildDropdownTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required String value,
    required List<Map<String, String>> items,
    required ValueChanged<String?> onChanged,
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
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            subtitle,
            style: const TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          DropdownButton<String>(
            value: value,
            isExpanded: true,
            underline: Container(),
            items: items.map((item) {
              return DropdownMenuItem<String>(
                value: item['value'],
                child: Text(item['label']!),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ],
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
    );
  }

  Widget _buildDiscoveryCard() {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Interested In
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
                  Icons.favorite,
                  color: AppTheme.primaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Text(
                  'Interested In',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: interestedIn,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            items: [
              const DropdownMenuItem(value: 'men', child: Text('Men')),
              const DropdownMenuItem(value: 'women', child: Text('Women')),
              const DropdownMenuItem(value: 'everyone', child: Text('Everyone')),
            ],
            onChanged: (value) {
              setState(() => interestedIn = value!);
              _saveSetting('interested_in', value);
            },
          ),
          const SizedBox(height: 20),
          
          // Age Range
          const Text(
            'Age Range',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            ageRange,
            style: TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 20),
          
          // Max Distance
          Text(
            'Maximum Distance: ${maxDistance.round()} km',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Slider(
            value: maxDistance,
            min: 1,
            max: 100,
            divisions: 99,
            activeColor: AppTheme.primaryColor,
            onChanged: (value) {
              setState(() => maxDistance = value);
            },
            onChangeEnd: (value) {
              _saveSetting('max_distance', value);
            },
          ),
        ],
      ),
    );
  }

  void _downloadData() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Download Data'),
        content: const Text(
          'We\'ll prepare your data and send it to your email address. This may take up to 24 hours.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Data download request submitted'),
                ),
              );
            },
            child: const Text('Request'),
          ),
        ],
      ),
    );
  }

  void _deleteAccount() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'Are you sure you want to delete your account? This action cannot be undone and all your data will be permanently removed.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement account deletion
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Account deletion will be available soon'),
                ),
              );
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}