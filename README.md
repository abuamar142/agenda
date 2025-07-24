# Agenda - Google Calendar Manager

A Flutter application for managing Google Calendar events with OAuth authentication via Supabase,
built with clean architecture and GetX state management.

## Features

- 🔐 OAuth authentication via Supabase
- 📅 Google Calendar integration
- 📝 Event templates for quick event creation
- 🎨 Modern Material Design UI
- 🏗️ Clean Architecture
- 🔄 GetX state management
- 📱 Cross-platform (iOS & Android)

## Tech Stack

- **Frontend**: Flutter
- **State Management**: GetX
- **Backend & Auth**: Supabase
- **Calendar API**: Google Calendar API
- **Architecture**: Clean Architecture
- **Local Storage**: Shared Preferences, Secure Storage

## Project Structure

```
lib/
├── core/                           # Core functionality
│   ├── constants/                  # App constants
│   │   └── app_constants.dart
│   ├── error/                      # Error handling
│   │   ├── exceptions.dart
│   │   └── failures.dart
│   ├── network/                    # Network layer
│   │   ├── network_client.dart
│   │   └── network_info.dart
│   ├── themes/                     # App themes
│   │   ├── app_colors.dart
│   │   └── app_theme.dart
│   └── utils/                      # Utility functions
│       ├── date_time_utils.dart
│       └── validation_utils.dart
├── data/                           # Data layer
│   ├── datasources/                # Data sources (API, local)
│   ├── models/                     # Data models
│   └── repositories/               # Repository implementations
├── domain/                         # Domain layer
│   ├── entities/                   # Business entities
│   ├── repositories/               # Repository interfaces
│   └── usecases/                   # Business logic
├── presentation/                   # Presentation layer
│   ├── bindings/                   # GetX bindings
│   ├── controllers/                # GetX controllers
│   ├── views/                      # UI screens
│   └── widgets/                    # Reusable widgets
├── app_routes.dart                 # Route definitions
└── main.dart                       # App entry point
```

## Getting Started

### Prerequisites

- Flutter SDK (>= 3.8.1)
- Dart SDK
- Android Studio / VS Code
- Google Cloud Console account
- Supabase account

### Installation

1. **Clone the repository**

   ```bash
   git clone <repository-url>
   cd agenda
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Setup Supabase**

   - Create a new project on [Supabase](https://supabase.com)
   - Get your project URL and anon key
   - Update `lib/core/constants/app_constants.dart`:
     ```dart
     static const String supabaseUrl = 'YOUR_SUPABASE_URL';
     static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';
     ```

4. **Setup Google Calendar API**

   - Go to [Google Cloud Console](https://console.cloud.google.com)
   - Create a new project or select existing one
   - Enable Google Calendar API
   - Create credentials (OAuth 2.0 client ID)
   - Download the configuration file
   - For Android: Place `google-services.json` in `android/app/`
   - For iOS: Place `GoogleService-Info.plist` in `ios/Runner/`

5. **Configure OAuth in Supabase**
   - Go to Authentication > Settings in your Supabase dashboard
   - Add Google as a provider
   - Configure redirect URLs

### Running the App

```bash
# Debug mode
flutter run

# Release mode
flutter run --release

# Specific platform
flutter run -d android
flutter run -d ios
```

## Architecture Overview

This project follows Clean Architecture principles with three main layers:

### 1. Presentation Layer

- **Views**: UI screens built with Flutter widgets
- **Controllers**: GetX controllers managing UI state
- **Bindings**: Dependency injection for controllers

### 2. Domain Layer

- **Entities**: Core business objects
- **Repositories**: Abstract interfaces for data access
- **Use Cases**: Business logic and application rules

### 3. Data Layer

- **Models**: Data transfer objects
- **Data Sources**: API and local storage implementations
- **Repositories**: Concrete implementations of domain repositories

## Key Dependencies

```yaml
dependencies:
  # State Management
  get: ^4.7.2

  # Backend & Auth
  supabase_flutter: ^2.5.2

  # Google Calendar
  googleapis: ^13.1.0
  googleapis_auth: ^1.4.1

  # Network & HTTP
  dio: ^5.4.3
  http: ^1.4.0

  # Local Storage
  shared_preferences: ^2.2.2
  flutter_secure_storage: ^9.0.0

  # Utilities
  intl: ^0.19.0
  dartz: ^0.10.1
  equatable: ^2.0.5
```

## Configuration

### Environment Variables

Create a `.env` file in the root directory:

```env
SUPABASE_URL=your_supabase_url
SUPABASE_ANON_KEY=your_supabase_anon_key
GOOGLE_CLIENT_ID=your_google_client_id
```

### Android Configuration

Update `android/app/build.gradle`:

```gradle
android {
    compileSdkVersion 34

    defaultConfig {
        minSdkVersion 21
        targetSdkVersion 34
    }
}
```

Add to `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
```

### iOS Configuration

Update `ios/Runner/Info.plist`:

```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleURLName</key>
        <string>google</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>YOUR_REVERSED_CLIENT_ID</string>
        </array>
    </dict>
</array>
```

## Features Roadmap

- [x] Project setup with clean architecture
- [x] Basic UI structure
- [ ] Supabase OAuth integration
- [ ] Google Calendar API integration
- [ ] Event creation and management
- [ ] Event templates
- [ ] Calendar view
- [ ] Push notifications
- [ ] Offline support
- [ ] Dark mode
- [ ] Multi-language support

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## Code Style

This project follows Flutter/Dart conventions:

- Use `dart format` for code formatting
- Follow naming conventions (camelCase for variables, PascalCase for classes)
- Use meaningful variable and function names
- Add comments for complex logic
- Write unit tests for business logic

## Testing

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run integration tests
flutter drive --target=test_driver/app.dart
```

## Deployment

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

## Troubleshooting

### Common Issues

1. **Google Sign-In not working**

   - Ensure SHA-1 fingerprint is added to Firebase project
   - Check package name matches in all configurations

2. **Supabase connection issues**

   - Verify URL and API key are correct
   - Check network permissions

3. **Build issues**
   - Run `flutter clean && flutter pub get`
   - Check minimum SDK versions

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

For support, email support@example.com or create an issue in this repository.

---

**Happy Coding! 🚀**
