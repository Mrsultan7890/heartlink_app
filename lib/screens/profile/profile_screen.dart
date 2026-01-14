import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../providers/auth_provider.dart';
import '../../providers/user_provider.dart';
import '../../utils/app_theme.dart';
import '../../utils/app_router.dart';
import '../../widgets/common/custom_button.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(userProvider.notifier).loadProfile());
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userProvider);
    final user = userState.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.push(AppRoutes.settings),
          ),
        ],
      ),
      body: userState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : user == null
              ? const Center(child: Text('No profile data'))
              : RefreshIndicator(
                  onRefresh: () => ref.read(userProvider.notifier).loadProfile(),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        // Profile Header
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: AppTheme.primaryGradient,
                          ),
                          child: Column(
                            children: [
                              const SizedBox(height: 24),
                              // Profile Image
                              Stack(
                                children: [
                                  Container(
                                    width: 120,
                                    height: 120,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.white, width: 4),
                                      image: user.profileImages.isNotEmpty
                                          ? DecorationImage(
                                              image: CachedNetworkImageProvider(user.profileImages.first),
                                              fit: BoxFit.cover,
                                            )
                                          : null,
                                    ),
                                    child: user.profileImages.isEmpty
                                        ? const Icon(Icons.person, size: 60, color: Colors.white)
                                        : null,
                                  ),
                                  if (user.isVerified)
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: const BoxDecoration(
                                          color: Colors.blue,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(Icons.verified, color: Colors.white, size: 20),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              // Name & Age
                              Text(
                                '${user.name}, ${user.age ?? "N/A"}',
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 8),
                              // Location
                              if (user.location != null)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.location_on, color: Colors.white70, size: 16),
                                    const SizedBox(width: 4),
                                    Text(
                                      user.location ?? '',
                                      style: const TextStyle(color: Colors.white70),
                                    ),
                                  ],
                                ),
                              const SizedBox(height: 24),
                            ],
                          ),
                        ),

                        // Edit Profile Button
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Expanded(
                                child: CustomButton(
                                  text: 'Edit Profile',
                                  onPressed: () => context.push(AppRoutes.editProfile),
                                  icon: Icons.edit,
                                  gradient: AppTheme.primaryGradient,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: CustomButton(
                                  text: 'Manage Photos',
                                  onPressed: () => context.push(AppRoutes.photoUpload),
                                  icon: Icons.photo_library,
                                  backgroundColor: AppTheme.secondaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Profile Info Cards
                        _buildInfoCard(
                          context,
                          'About Me',
                          user.bio ?? 'No bio yet',
                          Icons.info_outline,
                        ),

                        if (user.interests?.isNotEmpty ?? false)
                          _buildInterestsCard(context, user.interests!),

                        if (user.relationshipIntent != null)
                          _buildInfoCard(
                            context,
                            'Looking For',
                            user.relationshipIntent!,
                            Icons.favorite_outline,
                          ),

                        // Photos Grid
                        if (user.profileImages.isNotEmpty)
                          _buildPhotosGrid(context, user.profileImages),

                        // Premium Badge
                        if (user.isPremium)
                          Container(
                            margin: const EdgeInsets.all(16),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Colors.amber, Colors.orange],
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.star, color: Colors.white),
                                const SizedBox(width: 8),
                                const Text(
                                  'Premium Member',
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),

                        // Logout Button
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: CustomButton(
                            text: 'Logout',
                            onPressed: () => _showLogoutDialog(context),
                            backgroundColor: Colors.red,
                            icon: Icons.logout,
                          ),
                        ),

                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget _buildInfoCard(BuildContext context, String title, String content, IconData icon) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
          Row(
            children: [
              Icon(icon, color: AppTheme.primaryColor),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: TextStyle(fontSize: 16, color: AppTheme.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildInterestsCard(BuildContext context, List<String> interests) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
          Row(
            children: [
              Icon(Icons.interests, color: AppTheme.primaryColor),
              const SizedBox(width: 8),
              const Text(
                'Interests',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: interests.map((interest) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  interest,
                  style: TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.w500),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotosGrid(BuildContext context, List<String> photos) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
          Row(
            children: [
              Icon(Icons.photo_library, color: AppTheme.primaryColor),
              const SizedBox(width: 8),
              const Text(
                'Photos',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: photos.length,
            itemBuilder: (context, index) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: photos[index],
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: Colors.grey[300],
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey[300],
                    child: const Icon(Icons.error),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(authProvider.notifier).logout();
              context.go(AppRoutes.login);
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}