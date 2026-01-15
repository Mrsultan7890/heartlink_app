import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_animate/flutter_animate.dart';

import '../providers/auth_provider.dart';
import '../utils/app_router.dart';
import '../utils/app_theme.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _heartController;
  late AnimationController _textController;
  
  @override
  void initState() {
    super.initState();
    
    _heartController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _textController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _initializeApp();
  }
  
  @override
  void dispose() {
    _heartController.dispose();
    _textController.dispose();
    super.dispose();
  }
  
  Future<void> _initializeApp() async {
    // Start animations
    _heartController.forward();
    await Future<void>.delayed(const Duration(milliseconds: 500));
    _textController.forward();
    
    // Wait for minimum splash duration first
    await Future<void>.delayed(const Duration(milliseconds: 1500));
    
    // Initialize app services with timeout (non-blocking)
    try {
      await ref.read(authProvider.notifier).initializeAuth().timeout(
        const Duration(seconds: 3),
        onTimeout: () {
          print('⚠️ Auth initialization timeout - proceeding to onboarding/login');
        },
      );
    } catch (e) {
      print('⚠️ Auth initialization failed: $e - proceeding anyway');
    }
    
    // Navigate based on auth state (always navigate, never hang)
    if (mounted) {
      try {
        final authState = ref.read(authProvider);
        
        print('📍 Navigation: onboarded=${authState.isOnboarded}, authenticated=${authState.isAuthenticated}');
        
        if (!authState.isOnboarded) {
          context.go(AppRoutes.onboarding);
        } else if (!authState.isAuthenticated) {
          context.go(AppRoutes.login);
        } else {
          context.go(AppRoutes.home);
        }
      } catch (e) {
        print('❌ Navigation error: $e - going to onboarding');
        context.go(AppRoutes.onboarding);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFF6B6B), Color(0xFFFF8E8E), Color(0xFFFFB3B3)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(flex: 2),
              
              // Heart Logo Animation
              Center(
                child: AnimatedBuilder(
                  animation: _heartController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: 0.5 + (_heartController.value * 0.5),
                      child: Opacity(
                        opacity: _heartController.value,
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.favorite,
                            size: 60,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              
              const SizedBox(height: 40),
              
              // App Name Animation
              AnimatedBuilder(
                animation: _textController,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, 50 * (1 - _textController.value)),
                    child: Opacity(
                      opacity: _textController.value,
                      child: Column(
                        children: [
                          Text(
                            'HeartLink',
                            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Find Your Perfect Match',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Colors.white.withOpacity(0.9),
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              
              const Spacer(flex: 2),
              
              // Loading Animation
              Animate(
                effects: const [
                  FadeEffect(
                    delay: Duration(milliseconds: 1000),
                    duration: Duration(milliseconds: 500),
                  ),
                ],
                child: Column(
                  children: [
                    SizedBox(
                      width: 40,
                      height: 40,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.white.withOpacity(0.8),
                        ),
                        strokeWidth: 3,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Loading...',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }
}