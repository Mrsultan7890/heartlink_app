import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../screens/splash_screen.dart';
import '../screens/onboarding_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/auth/forgot_password_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/profile/edit_profile_screen.dart';
import '../screens/profile/photo_upload_screen.dart';
import '../screens/discover/discover_screen.dart';
import '../screens/matches/matches_screen.dart';
import '../screens/chat/chat_list_screen.dart';
import '../screens/chat/chat_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../screens/settings/privacy_screen.dart';
import '../screens/settings/notifications_screen.dart';
import '../screens/premium/premium_screen.dart';
import '../providers/auth_provider.dart';

// Route Names
class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String home = '/home';
  static const String profile = '/profile';
  static const String editProfile = '/edit-profile';
  static const String photoUpload = '/photo-upload';
  static const String discover = '/discover';
  static const String matches = '/matches';
  static const String chatList = '/chat-list';
  static const String chat = '/chat';
  static const String settings = '/settings';
  static const String privacy = '/privacy';
  static const String notifications = '/notifications';
  static const String premium = '/premium';
}

final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);
  
  return GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    
    redirect: (context, state) {
      final isLoggedIn = authState.isAuthenticated;
      final isOnboarded = authState.isOnboarded;
      final currentPath = state.fullPath;
      
      // Splash screen logic
      if (currentPath == AppRoutes.splash) {
        if (!isOnboarded) {
          return AppRoutes.onboarding;
        } else if (!isLoggedIn) {
          return AppRoutes.login;
        } else {
          return AppRoutes.home;
        }
      }
      
      // Protect authenticated routes
      if (!isLoggedIn && _isProtectedRoute(currentPath)) {
        return AppRoutes.login;
      }
      
      // Redirect authenticated users away from auth screens
      if (isLoggedIn && _isAuthRoute(currentPath)) {
        return AppRoutes.home;
      }
      
      return null;
    },
    
    routes: [
      // Splash Screen
      GoRoute(
        path: AppRoutes.splash,
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      
      // Onboarding
      GoRoute(
        path: AppRoutes.onboarding,
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      
      // Authentication Routes
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      
      GoRoute(
        path: AppRoutes.register,
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      
      GoRoute(
        path: AppRoutes.forgotPassword,
        name: 'forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      
      // Main App Routes
      ShellRoute(
        builder: (context, state, child) {
          return HomeScreen(child: child);
        },
        routes: [
          GoRoute(
            path: AppRoutes.discover,
            name: 'discover',
            builder: (context, state) => const DiscoverScreen(),
          ),
          
          GoRoute(
            path: AppRoutes.matches,
            name: 'matches',
            builder: (context, state) => const MatchesScreen(),
          ),
          
          GoRoute(
            path: AppRoutes.chatList,
            name: 'chat-list',
            builder: (context, state) => const ChatListScreen(),
          ),
          
          GoRoute(
            path: AppRoutes.profile,
            name: 'profile',
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),
      
      GoRoute(
        path: AppRoutes.home,
        name: 'home',
        redirect: (context, state) => AppRoutes.discover,
      ),
      
      // Profile Routes
      GoRoute(
        path: AppRoutes.editProfile,
        name: 'edit-profile',
        builder: (context, state) => const EditProfileScreen(),
      ),
      
      GoRoute(
        path: AppRoutes.photoUpload,
        name: 'photo-upload',
        builder: (context, state) => const PhotoUploadScreen(),
      ),
      
      // Chat Route
      GoRoute(
        path: '${AppRoutes.chat}/:matchId',
        name: 'chat',
        builder: (context, state) {
          final matchId = state.pathParameters['matchId']!;
          final matchName = state.uri.queryParameters['name'] ?? 'Chat';
          return ChatScreen(
            matchId: int.parse(matchId),
            matchName: matchName,
          );
        },
      ),
      
      // Settings Routes
      GoRoute(
        path: AppRoutes.settings,
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
        routes: [
          GoRoute(
            path: 'privacy',
            name: 'privacy',
            builder: (context, state) => const PrivacyScreen(),
          ),
          GoRoute(
            path: 'notifications',
            name: 'notifications',
            builder: (context, state) => const NotificationsScreen(),
          ),
        ],
      ),
      
      // Premium Route
      GoRoute(
        path: AppRoutes.premium,
        name: 'premium',
        builder: (context, state) => const PremiumScreen(),
      ),
    ],
    
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(
        title: const Text('Page Not Found'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'Page not found: ${state.fullPath}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go(AppRoutes.home),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
});

bool _isProtectedRoute(String path) {
  const protectedRoutes = [
    AppRoutes.home,
    AppRoutes.discover,
    AppRoutes.matches,
    AppRoutes.chatList,
    AppRoutes.profile,
    AppRoutes.editProfile,
    AppRoutes.photoUpload,
    AppRoutes.settings,
    AppRoutes.premium,
  ];
  
  return protectedRoutes.any((route) => path.startsWith(route)) ||
         path.startsWith(AppRoutes.chat);
}

bool _isAuthRoute(String path) {
  const authRoutes = [
    AppRoutes.login,
    AppRoutes.register,
    AppRoutes.forgotPassword,
    AppRoutes.onboarding,
  ];
  
  return authRoutes.contains(path);
}