import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'services/api_service.dart';
import 'services/auth_service.dart';
import 'providers/auth_provider.dart';

import 'utils/app_router.dart';
import 'utils/app_theme.dart';
import 'utils/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase (optional)
  try {
    await Firebase.initializeApp();
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  } catch (e) {
    print('Firebase not configured: $e');
  }
  
  // Initialize Hive
  try {
    await Hive.initFlutter();
  } catch (e) {
    print('Hive init failed: $e');
  }
  
  // Initialize SharedPreferences
  try {
    await SharedPreferences.getInstance();
  } catch (e) {
    print('SharedPreferences init failed: $e');
  }
  
  // Initialize Services (non-blocking)
  ApiService.initialize().catchError((e) {
    print('API Service init failed: $e');
  });
  
  AuthService.initialize().catchError((e) {
    print('Auth Service init failed: $e');
  });
  
  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  runApp(
    ProviderScope(
      child: HeartLinkApp(),
    ),
  );
}

class HeartLinkApp extends ConsumerStatefulWidget {
  const HeartLinkApp({super.key});

  @override
  ConsumerState<HeartLinkApp> createState() => _HeartLinkAppState();
}

class _HeartLinkAppState extends ConsumerState<HeartLinkApp> {
  @override
  void initState() {
    super.initState();
    // Don't call initializeAuth here - it's already called in splash
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(appRouterProvider);
    
    return MaterialApp.router(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      
      // Theme
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      
      // Routing
      routerConfig: router,
      
      // Localization
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('hi', 'IN'),
      ],
      
      // Builder for global configurations
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.noScaling, // Prevent text scaling
          ),
          child: child!,
        );
      },
    );
  }
}