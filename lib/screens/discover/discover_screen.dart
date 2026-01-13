import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../models/user_model.dart';
import '../../providers/discover_provider.dart';
import '../../utils/app_theme.dart';
import '../../widgets/cards/profile_card.dart';
import '../../widgets/common/custom_button.dart';

class DiscoverScreen extends ConsumerStatefulWidget {
  const DiscoverScreen({super.key});

  @override
  ConsumerState<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends ConsumerState<DiscoverScreen> {
  final CardSwiperController _cardController = CardSwiperController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(discoverProvider.notifier).loadUsers();
    });
  }

  @override
  void dispose() {
    _cardController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final discoverState = ref.watch(discoverProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.location_on, color: AppTheme.primaryColor, size: 20),
            const SizedBox(width: 8),
            Text(
              'Discover',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune),
            onPressed: _showFilters,
          ),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Cards Section
              Expanded(
                child: _buildCardsSection(discoverState),
              ),
              
              // Action Buttons
              _buildActionButtons(),
              
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardsSection(DiscoverState state) {
    if (state.isLoading && state.users.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
        ),
      );
    }

    if (state.users.isEmpty) {
      return _buildEmptyState();
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: CardSwiper(
        controller: _cardController,
        cardsCount: state.users.length,
        onSwipe: _onSwipe,
        onUndo: _onUndo,
        numberOfCardsDisplayed: 3,
        backCardOffset: const Offset(40, 40),
        padding: const EdgeInsets.all(24),
        cardBuilder: (context, index, horizontalThresholdPercentage, verticalThresholdPercentage) {
          return ProfileCard(
            user: state.users[index],
            onTap: () => _showUserDetails(state.users[index]),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 80,
            color: AppTheme.textSecondary,
          ),
          const SizedBox(height: 16),
          Text(
            'No more profiles',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Check back later for new matches',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          CustomButton(
            text: 'Refresh',
            onPressed: () => ref.read(discoverProvider.notifier).loadUsers(),
            icon: Icons.refresh,
            width: 200,
          ),
        ],
      ),
    ).animate().fadeIn().slideY(begin: 0.3, end: 0);
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Pass Button
          _buildActionButton(
            icon: Icons.close,
            color: Colors.grey,
            onPressed: () => _cardController.swipe(CardSwiperDirection.left),
          ),
          
          // Super Like Button
          _buildActionButton(
            icon: Icons.star,
            color: Colors.blue,
            onPressed: () => _cardController.swipe(CardSwiperDirection.top),
            size: 50,
          ),
          
          // Like Button
          _buildActionButton(
            icon: Icons.favorite,
            color: AppTheme.primaryColor,
            onPressed: () => _cardController.swipe(CardSwiperDirection.right),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.5, end: 0);
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
    double size = 60,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(size / 2),
          child: Icon(
            icon,
            color: color,
            size: size * 0.4,
          ),
        ),
      ),
    );
  }

  bool _onSwipe(int previousIndex, int? currentIndex, CardSwiperDirection direction) {
    final users = ref.read(discoverProvider).users;
    if (previousIndex >= users.length) return false;
    
    final user = users[previousIndex];
    
    switch (direction) {
      case CardSwiperDirection.left:
        _handleSwipe(user, false);
        break;
      case CardSwiperDirection.right:
        _handleSwipe(user, true);
        break;
      case CardSwiperDirection.top:
        _handleSuperLike(user);
        break;
      default:
        break;
    }
    
    return true;
  }

  bool _onUndo(int? previousIndex, int currentIndex, CardSwiperDirection direction) {
    // Handle undo logic if needed
    return true;
  }

  void _handleSwipe(UserModel user, bool isLike) {
    ref.read(discoverProvider.notifier).swipeUser(user.id, isLike);
    
    if (isLike) {
      _showLikeAnimation();
    }
  }

  void _handleSuperLike(UserModel user) {
    ref.read(discoverProvider.notifier).superLikeUser(user.id);
    _showSuperLikeAnimation();
  }

  void _showLikeAnimation() {
    // Show like animation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.favorite, color: Colors.white),
            const SizedBox(width: 8),
            Text('Liked!'),
          ],
        ),
        backgroundColor: AppTheme.primaryColor,
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showSuperLikeAnimation() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.star, color: Colors.white),
            const SizedBox(width: 8),
            Text('Super Liked!'),
          ],
        ),
        backgroundColor: Colors.blue,
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showUserDetails(UserModel user) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildUserDetailsSheet(user),
    );
  }

  Widget _buildUserDetailsSheet(UserModel user) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // User Details
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Images
                  if (user.profileImages.isNotEmpty)
                    SizedBox(
                      height: 300,
                      child: PageView.builder(
                        itemCount: user.profileImages.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              image: DecorationImage(
                                image: NetworkImage(user.profileImages[index]),
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  
                  const SizedBox(height: 24),
                  
                  // Name and Age
                  Text(
                    '${user.name}, ${user.age ?? 'N/A'}',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Location
                  if (user.location != null)
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 16, color: AppTheme.textSecondary),
                        const SizedBox(width: 4),
                        Text(
                          user.location!,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  
                  const SizedBox(height: 16),
                  
                  // Bio
                  if (user.bio != null) ...[
                    Text(
                      'About',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      user.bio!,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ],
              ),
            ),
          ),
          
          // Action Buttons
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: 'Pass',
                    onPressed: () {
                      Navigator.pop(context);
                      _handleSwipe(user, false);
                    },
                    backgroundColor: Colors.grey,
                    icon: Icons.close,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: CustomButton(
                    text: 'Like',
                    onPressed: () {
                      Navigator.pop(context);
                      _handleSwipe(user, true);
                    },
                    gradient: AppTheme.primaryGradient,
                    icon: Icons.favorite,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showFilters() {
    // Show filters bottom sheet
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Filters',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            Text('Filters coming soon!'),
            const SizedBox(height: 24),
            CustomButton(
              text: 'Close',
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}