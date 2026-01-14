# HeartLink - Dating App

A modern, feature-rich dating application built with Flutter.

## Features

- 🔐 **Authentication** - Secure login and registration
- 💕 **Swipe Matching** - Tinder-style card swiping
- 💬 **Real-time Chat** - Instant messaging with matches
- 📍 **Location-based** - Find people nearby
- 🎯 **Smart Matching** - Interest-based compatibility
- 🔔 **Push Notifications** - Stay updated with matches
- 🎨 **Beautiful UI** - Modern dating app design
- 🌙 **Dark Mode** - Eye-friendly theme

## Tech Stack

- **Framework**: Flutter 3.19.0
- **State Management**: Riverpod
- **Routing**: GoRouter
- **API**: Retrofit + Dio
- **Local Storage**: Hive + Secure Storage
- **Animations**: Flutter Animate

## Getting Started

### Prerequisites

- Flutter SDK 3.19.0 or higher
- Dart 3.0 or higher
- Android Studio / VS Code
- Android SDK / Xcode

### Installation

1. Clone the repository:
```bash
git clone https://github.com/Mrsultan7890/heartlink_app.git
cd heartlink_app
```

2. Install dependencies:
```bash
flutter pub get
```

3. Generate code:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

4. Run the app:
```bash
# For local development (localhost:8000)
flutter run

# For production
flutter run --dart-define=API_URL=https://heartlink-api.onrender.com --dart-define=WS_URL=wss://heartlink-api.onrender.com/api/chat/ws
```

### Build APK

```bash
# Debug APK (for testing)
flutter build apk --debug

# Release APK (for production)
flutter build apk --release --dart-define=API_URL=https://heartlink-api.onrender.com --dart-define=WS_URL=wss://heartlink-api.onrender.com/api/chat/ws
```

## Project Structure

```
lib/
├── models/          # Data models
├── providers/       # State management
├── screens/         # UI screens
├── services/        # API services
├── utils/           # Utilities & constants
└── widgets/         # Reusable widgets
```

## Configuration

### API URLs

The app uses environment variables for API configuration:

- **Local**: `http://localhost:8000`
- **Production**: `https://heartlink-api.onrender.com`

### Firebase Setup

1. Add `google-services.json` to `android/app/`
2. Add `GoogleService-Info.plist` to `ios/Runner/`

## CI/CD

GitHub Actions automatically builds and deploys the app on every push to main branch.

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License.

## Support

For support, email support@heartlink.app or join our Telegram channel.
