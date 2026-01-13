import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../models/user_model.dart';
import '../../utils/app_theme.dart';

class ProfileCard extends StatelessWidget {
  final UserModel user;
  final VoidCallback? onTap;

  const ProfileCard({
    super.key,
    required this.user,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              // Background Image
              _buildBackgroundImage(),
              
              // Gradient Overlay
              _buildGradientOverlay(),
              
              // User Info
              _buildUserInfo(context),
              
              // Verification Badge
              if (user.isVerified) _buildVerificationBadge(),
              
              // Premium Badge
              if (user.isPremium) _buildPremiumBadge(),
              
              // Image Indicators
              if (user.profileImages.length > 1) _buildImageIndicators(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackgroundImage() {
    return Positioned.fill(
      child: user.profileImages.isNotEmpty
          ? CachedNetworkImage(
              imageUrl: user.primaryImage,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: Colors.grey.shade200,
                child: const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
                  ),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                color: Colors.grey.shade200,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.person,
                      size: 80,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'No Photo',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : Container(
              color: Colors.grey.shade200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.person,
                    size: 80,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'No Photo',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildGradientOverlay() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.transparent,
              Colors.black.withOpacity(0.7),
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfo(BuildContext context) {
    return Positioned(
      left: 20,
      right: 20,
      bottom: 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name and Age
          Row(
            children: [
              Expanded(
                child: Text(
                  '${user.name}, ${user.age ?? 'N/A'}',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (user.isVerified)
                Container(
                  margin: const EdgeInsets.only(left: 8),
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.verified,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
            ],
          ),
          
          const SizedBox(height: 8),
          
          // Location
          if (user.location != null)
            Row(
              children: [
                Icon(
                  Icons.location_on,
                  color: Colors.white.withOpacity(0.8),
                  size: 16,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    user.location!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withOpacity(0.8),
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          
          const SizedBox(height: 8),
          
          // Bio Preview
          if (user.bio != null)
            Text(
              user.bio!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.white.withOpacity(0.9),
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
        ],
      ),
    ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.3, end: 0);
  }

  Widget _buildVerificationBadge() {
    return Positioned(
      top: 16,
      right: 16,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.verified,
              color: Colors.white,
              size: 14,
            ),
            const SizedBox(width: 4),
            Text(
              'Verified',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 500.ms).scale(begin: Offset(0.8, 0.8), end: Offset(1, 1));
  }

  Widget _buildPremiumBadge() {
    return Positioned(
      top: 16,
      left: 16,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Colors.amber, Colors.orange],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.star,
              color: Colors.white,
              size: 14,
            ),
            const SizedBox(width: 4),
            Text(
              'Premium',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 700.ms).scale(begin: Offset(0.8, 0.8), end: Offset(1, 1));
  }

  Widget _buildImageIndicators() {
    return Positioned(
      top: 16,
      left: 16,
      right: 16,
      child: Row(
        children: List.generate(
          user.profileImages.length,
          (index) => Expanded(
            child: Container(
              height: 3,
              margin: EdgeInsets.only(
                right: index < user.profileImages.length - 1 ? 4 : 0,
              ),
              decoration: BoxDecoration(
                color: index == 0 
                    ? Colors.white 
                    : Colors.white.withOpacity(0.5),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ),
      ),
    );
  }
}