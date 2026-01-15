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
  
  try {
    await Firebase.initializeApp();
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  } catch (e) {}
  
  try {
    await Hive.initFlutter();
  } catch (e) {}
  
  try {
    await SharedPreferences.getInstance();
  } catch (e) {}
  
  await ApiService.initialize();
  await AuthService.initialize();
  
  try {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  } catch (e) {}
  
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
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: router,
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('hi', 'IN'),
      ],
      builder: (context, child) {
        ErrorWidget.builder = (FlutterErrorDetails details) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red),
                  SizedBox(height: 16),
                  Text('Error', style: TextStyle(fontSize: 20)),
                ],
              ),
            ),
          );
        };
        
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.noScaling,
          ),
          child: child!,
        );
      },
    );
  }
}