import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'services/api_service.dart';
import 'services/auth_service.dart';

import 'utils/app_router.dart';
import 'utils/app_theme.dart';
import 'utils/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  try {
    await Firebase.initializeApp();
    // Initialize Firebase Crashlytics
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  } catch (e) {
    print('Firebase initialization failed: $e');
  }
  
  // Initialize Hive
  await Hive.initFlutter();
  
  // Initialize SharedPreferences
  await SharedPreferences.getInstance();
  
  // Initialize Services
  await ApiService.initialize();
  await AuthService.initialize();
  
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
    Future.microtask(() => ref.read(authProvider.notifier).initializeAuth());
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