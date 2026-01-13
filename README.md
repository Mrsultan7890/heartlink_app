# 💕 HeartLink - AI-Powered Dating App

<div align="center">
  <img src="assets/images/logo.png" alt="HeartLink Logo" width="120" height="120">
  
  [![Flutter](https://img.shields.io/badge/Flutter-3.16.0-blue.svg)](https://flutter.dev/)
  [![Dart](https://img.shields.io/badge/Dart-3.2.0-blue.svg)](https://dart.dev/)
  [![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
  [![CI/CD](https://github.com/yourusername/heartlink/workflows/CI%2FCD/badge.svg)](https://github.com/yourusername/heartlink/actions)
</div>

## 🌟 Features

### 🔥 Core Features
- **Smart Matching Algorithm** - AI-powered compatibility matching
- **Swipe Interface** - Intuitive Tinder-like swiping experience
- **Real-time Chat** - Instant messaging with WebSocket support
- **Location-based Discovery** - Find matches nearby
- **Profile Verification** - Enhanced security and trust
- **Premium Features** - Super likes, boosts, and advanced filters

### 🎨 UI/UX Features
- **Modern Material Design** - Beautiful, intuitive interface
- **Dark/Light Theme** - Automatic theme switching
- **Smooth Animations** - Fluid transitions and micro-interactions
- **Responsive Design** - Perfect on all screen sizes
- **Accessibility** - Full accessibility support

### 🔒 Security & Privacy
- **End-to-end Encryption** - Secure messaging
- **Privacy Controls** - Granular privacy settings
- **Photo Verification** - AI-powered photo authenticity
- **Block & Report** - Safety features
- **Data Protection** - GDPR compliant

## 🚀 Quick Start

### Prerequisites
- Flutter SDK (3.16.0+)
- Dart SDK (3.2.0+)
- Android Studio / VS Code
- Git

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/heartlink.git
   cd heartlink/heartlink_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate code**
   ```bash
   flutter packages pub run build_runner build --delete-conflicting-outputs
   ```

4. **Configure Firebase**
   - Create a new Firebase project
   - Add Android/iOS apps
   - Download `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
   - Place them in respective platform folders

5. **Set up environment variables**
   ```bash
   cp .env.example .env
   # Edit .env with your configuration
   ```

6. **Run the app**
   ```bash
   flutter run
   ```

## 🏗️ Architecture

### Project Structure
```
lib/
├── main.dart                 # App entry point
├── models/                   # Data models
│   ├── user_model.dart
│   ├── match_model.dart
│   └── message_model.dart
├── providers/                # State management (Riverpod)
│   ├── auth_provider.dart
│   ├── user_provider.dart
│   └── chat_provider.dart
├── screens/                  # UI screens
│   ├── auth/
│   ├── home/
│   ├── profile/
│   ├── discover/
│   ├── matches/
│   └── chat/
├── widgets/                  # Reusable widgets
│   ├── common/
│   ├── cards/
│   └── forms/
├── services/                 # Business logic
│   ├── api_service.dart
│   ├── auth_service.dart
│   ├── notification_service.dart
│   └── websocket_service.dart
└── utils/                    # Utilities
    ├── constants.dart
    ├── app_theme.dart
    ├── app_router.dart
    └── helpers.dart
```

### State Management
- **Riverpod** for reactive state management
- **Hive** for local data persistence
- **Secure Storage** for sensitive data

### Networking
- **Dio** with Retrofit for API calls
- **WebSocket** for real-time messaging
- **JWT** authentication with auto-refresh

## 🎨 Design System

### Color Palette
```dart
Primary: #FF6B6B (Coral Red)
Secondary: #4ECDC4 (Turquoise)
Accent: #FFE66D (Yellow)
Background: #F8F9FA (Light Gray)
Surface: #FFFFFF (White)
```

### Typography
- **Font Family**: Poppins
- **Sizes**: 10px - 32px
- **Weights**: 300, 400, 500, 600, 700

### Components
- Custom buttons with gradients
- Animated cards with shadows
- Modern input fields
- Floating action buttons

## 📱 Screens

### Authentication Flow
- **Splash Screen** - App initialization
- **Onboarding** - Feature introduction
- **Login/Register** - User authentication
- **Profile Setup** - Initial profile creation

### Main App Flow
- **Discover** - Swipe through potential matches
- **Matches** - View mutual matches
- **Chat** - Real-time messaging
- **Profile** - User profile management
- **Settings** - App preferences

## 🔧 Configuration

### Environment Variables
```env
# API Configuration
API_BASE_URL=https://heartlink-api.onrender.com
WS_URL=wss://heartlink-api.onrender.com/ws

# Firebase Configuration
FIREBASE_PROJECT_ID=your-project-id
FIREBASE_API_KEY=your-api-key

# Feature Flags
ENABLE_PREMIUM_FEATURES=true
ENABLE_LOCATION_SERVICES=true
```

### Build Variants
- **Debug** - Development build with debugging enabled
- **Release** - Production build with optimizations
- **Profile** - Performance profiling build

## 🧪 Testing

### Unit Tests
```bash
flutter test
```

### Integration Tests
```bash
flutter test integration_test/
```

### Widget Tests
```bash
flutter test test/widget_test.dart
```

### Coverage Report
```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

## 🚀 Deployment

### Android
```bash
# Build APK
flutter build apk --release

# Build App Bundle
flutter build appbundle --release
```

### iOS
```bash
# Build iOS
flutter build ios --release
```

### Web
```bash
# Build Web
flutter build web --release
```

## 📊 Performance

### Optimization Techniques
- **Code Splitting** - Lazy loading of screens
- **Image Optimization** - Cached network images
- **State Management** - Efficient state updates
- **Memory Management** - Proper disposal of resources

### Metrics
- **App Size**: < 50MB
- **Cold Start**: < 3 seconds
- **Hot Reload**: < 1 second
- **Memory Usage**: < 200MB

## 🔐 Security

### Data Protection
- **Encryption**: AES-256 for sensitive data
- **Authentication**: JWT with refresh tokens
- **API Security**: HTTPS with certificate pinning
- **Local Storage**: Encrypted secure storage

### Privacy Features
- **Data Minimization** - Collect only necessary data
- **User Consent** - Explicit consent for data usage
- **Right to Delete** - Complete data deletion
- **Anonymization** - Remove PII from analytics

## 🌍 Localization

### Supported Languages
- English (en)
- Hindi (hi)
- Spanish (es)
- French (fr)

### Adding New Language
1. Add locale to `supportedLocales`
2. Create translation files in `lib/l10n/`
3. Generate translations: `flutter gen-l10n`

## 🤝 Contributing

### Development Workflow
1. Fork the repository
2. Create feature branch: `git checkout -b feature/amazing-feature`
3. Commit changes: `git commit -m 'Add amazing feature'`
4. Push to branch: `git push origin feature/amazing-feature`
5. Open Pull Request

### Code Standards
- Follow [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- Use `flutter analyze` for linting
- Write tests for new features
- Update documentation

## 📈 Analytics

### Tracked Events
- User registration/login
- Profile completion
- Swipe actions
- Match creation
- Message sending
- Premium feature usage

### Privacy-First Analytics
- No PII collection
- Anonymized user IDs
- Opt-out available
- GDPR compliant

## 🐛 Troubleshooting

### Common Issues

**Build Errors**
```bash
flutter clean
flutter pub get
flutter packages pub run build_runner build --delete-conflicting-outputs
```

**iOS Build Issues**
```bash
cd ios
pod install --repo-update
cd ..
flutter build ios
```

**Android Build Issues**
```bash
cd android
./gradlew clean
cd ..
flutter build apk
```

## 📞 Support

### Getting Help
- **Documentation**: [docs.heartlink.app](https://docs.heartlink.app)
- **Issues**: [GitHub Issues](https://github.com/yourusername/heartlink/issues)
- **Discord**: [Community Server](https://discord.gg/heartlink)
- **Email**: support@heartlink.app

### Bug Reports
Please include:
- Device information
- Flutter version
- Steps to reproduce
- Expected vs actual behavior
- Screenshots/logs

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **Flutter Team** - Amazing framework
- **Firebase** - Backend services
- **Riverpod** - State management
- **Community** - Open source packages

---

<div align="center">
  Made with ❤️ by the HeartLink Team
  
  [Website](https://heartlink.app) • [Privacy Policy](https://heartlink.app/privacy) • [Terms of Service](https://heartlink.app/terms)
</div># heartlink_app
