import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/user_provider.dart';
import '../models/user_model.dart';

// Matches Screen
class MatchesScreen extends StatelessWidget {
  const MatchesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Matches')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite, size: 80, color: Colors.red),
            SizedBox(height: 16),
            Text('Matches Screen', style: Theme.of(context).textTheme.headlineMedium),
            SizedBox(height: 8),
            Text('Your matches will appear here'),
          ],
        ),
      ),
    );
  }
}

// Chat List Screen
class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Messages')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.chat_bubble, size: 80, color: Colors.blue),
            SizedBox(height: 16),
            Text('Messages', style: Theme.of(context).textTheme.headlineMedium),
            SizedBox(height: 8),
            Text('Your conversations will appear here'),
          ],
        ),
      ),
    );
  }
}

// Replace placeholder_screens.dart content with actual implementations
class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    
    if (user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildProfileHeader(user),
            const SizedBox(height: 24),
            _buildProfileStats(user),
            const SizedBox(height: 24),
            _buildQuickActions(),
            const SizedBox(height: 24),
            _buildProfileSections(user),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(UserModel user) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: user.hasImages 
                  ? NetworkImage(user.primaryImage)
                  : null,
              child: user.hasImages ? null : const Icon(Icons.person, size: 50),
            ),
            const SizedBox(height: 12),
            Text(
              user.name,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            if (user.age != null) ..[
              const SizedBox(height: 4),
              Text(
                user.ageText,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
            if (user.relationshipIntent != null) ..[
              const SizedBox(height: 8),
              Chip(
                label: Text(user.relationshipIntentText),
                backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildProfileStats(UserModel user) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Profile Completeness',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: user.profileCompleteness,
              backgroundColor: Colors.grey[300],
            ),
            const SizedBox(height: 4),
            Text(
              '${(user.profileCompleteness * 100).round()}% complete',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Actions',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton(
                  icon: Icons.edit,
                  label: 'Edit Profile',
                  onTap: () => context.push('/edit-profile'),
                ),
                _buildActionButton(
                  icon: Icons.photo_camera,
                  label: 'Add Photos',
                  onTap: () => context.push('/photo-upload'),
                ),
                _buildActionButton(
                  icon: Icons.interests,
                  label: 'Interests',
                  onTap: () => context.push('/interests'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Icon(icon, size: 32),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSections(UserModel user) {
    return Column(
      children: [
        if (user.bio != null && user.bio!.isNotEmpty)
          _buildInfoCard('About Me', user.bio!),
        if (user.interests.isNotEmpty)
          _buildInterestsCard(user.interests),
        if (user.location != null)
          _buildInfoCard('Location', user.location!),
      ],
    );
  }

  Widget _buildInfoCard(String title, String content) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(content),
          ],
        ),
      ),
    );
  }

  Widget _buildInterestsCard(List<String> interests) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Interests',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: interests.map((interest) {
                return Chip(
                  label: Text(interest),
                  backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

// Edit Profile Screen
class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Profile')),
      body: Center(child: Text('Edit Profile Screen')),
    );
  }
}

// Photo Upload Screen
class PhotoUploadScreen extends StatelessWidget {
  const PhotoUploadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Upload Photos')),
      body: Center(child: Text('Photo Upload Screen')),
    );
  }
}

// Chat Screen
class ChatScreen extends StatelessWidget {
  final int matchId;
  final String matchName;

  const ChatScreen({super.key, required this.matchId, required this.matchName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(matchName)),
      body: Center(child: Text('Chat with $matchName')),
    );
  }
}

// Settings Screen
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: Center(child: Text('Settings Screen')),
    );
  }
}

// Privacy Screen
class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Privacy')),
      body: Center(child: Text('Privacy Screen')),
    );
  }
}

// Notifications Screen
class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Notifications')),
      body: Center(child: Text('Notifications Screen')),
    );
  }
}

// Premium Screen
class PremiumScreen extends StatelessWidget {
  const PremiumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Premium')),
      body: Center(child: Text('Premium Screen')),
    );
  }
}