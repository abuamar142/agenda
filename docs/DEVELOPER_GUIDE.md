# Developer Guide

## Project Overview

Agenda adalah aplikasi Flutter untuk mengelola acara Google Calendar dengan clean architecture,
menggunakan GetX untuk state management dan Supabase untuk backend serta OAuth authentication.

## Architecture

### Clean Architecture Layers

1. **Presentation Layer** (`lib/presentation/`)

   - Views: UI screens dan widgets
   - Controllers: GetX controllers untuk state management
   - Bindings: Dependency injection untuk controllers

2. **Domain Layer** (`lib/domain/`)

   - Entities: Business objects
   - Repositories: Abstract interfaces
   - Use Cases: Business logic

3. **Data Layer** (`lib/data/`)

   - Models: Data transfer objects
   - Data Sources: API dan local storage
   - Repositories: Implementasi dari domain repositories

4. **Core Layer** (`lib/core/`)
   - Constants: App constants dan konfigurasi
   - Error: Error handling dan exceptions
   - Network: Network client dan utilities
   - Themes: App themes dan styling
   - Utils: Utility functions

## Setup Development Environment

### Prerequisites

1. **Flutter SDK** (>= 3.8.1)

   ```bash
   flutter --version
   ```

2. **IDE Setup**

   - Android Studio atau VS Code
   - Flutter dan Dart plugins

3. **Platform Setup**
   - Android: Android SDK, Android Studio
   - iOS: Xcode (untuk development di macOS)

### Environment Configuration

1. **Copy environment file**

   ```bash
   cp .env.example .env
   ```

2. **Update environment variables**

   - `SUPABASE_URL`: URL project Supabase Anda
   - `SUPABASE_ANON_KEY`: Anon key dari Supabase
   - `GOOGLE_CLIENT_ID`: Client ID dari Google Console

3. **Update app constants** Edit `lib/core/constants/app_constants.dart`:
   ```dart
   static const String supabaseUrl = 'YOUR_ACTUAL_SUPABASE_URL';
   static const String supabaseAnonKey = 'YOUR_ACTUAL_SUPABASE_ANON_KEY';
   ```

## Development Workflow

### 1. Feature Development

Untuk setiap feature baru, ikuti struktur ini:

```
lib/
├── domain/
│   ├── entities/new_entity.dart
│   ├── repositories/new_repository.dart
│   └── usecases/new_usecase.dart
├── data/
│   ├── models/new_model.dart
│   ├── datasources/new_datasource.dart
│   └── repositories/new_repository_impl.dart
└── presentation/
    ├── views/new_feature/
    ├── controllers/new_controller.dart
    └── bindings/new_binding.dart
```

### 2. Adding New Routes

1. Tambahkan konstanta route di `lib/core/constants/app_constants.dart`
2. Update `lib/app_routes.dart` dengan route baru
3. Buat binding yang sesuai

### 3. State Management dengan GetX

#### Controller Pattern

```dart
class FeatureController extends GetxController {
  // Observable variables
  final _isLoading = false.obs;
  final _data = <Model>[].obs;

  // Getters
  bool get isLoading => _isLoading.value;
  List<Model> get data => _data;

  // Methods
  Future<void> fetchData() async {
    _isLoading.value = true;
    try {
      // Business logic
      final result = await useCase.call();
      _data.value = result;
    } catch (e) {
      // Error handling
    } finally {
      _isLoading.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }
}
```

#### Binding Pattern

```dart
class FeatureBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FeatureController>(() => FeatureController());
  }
}
```

### 4. Error Handling

#### Domain Layer

```dart
// entities/result.dart
abstract class Failure extends Equatable {
  const Failure();
}

class ServerFailure extends Failure {
  final String message;
  const ServerFailure(this.message);

  @override
  List<Object> get props => [message];
}
```

#### Data Layer

```dart
// repositories/repository_impl.dart
Future<Either<Failure, Model>> getData() async {
  try {
    final result = await dataSource.getData();
    return Right(result.toEntity());
  } on ServerException catch (e) {
    return Left(ServerFailure(e.message));
  } on NetworkException catch (e) {
    return Left(NetworkFailure(e.message));
  }
}
```

#### Presentation Layer

```dart
// controllers/controller.dart
void handleResult(Either<Failure, Model> result) {
  result.fold(
    (failure) => _showError(failure.message),
    (data) => _updateData(data),
  );
}
```

## Testing Strategy

### 1. Unit Tests

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run specific test file
flutter test test/domain/usecases/auth_test.dart
```

### 2. Widget Tests

```dart
testWidgets('HomeView displays correctly', (WidgetTester tester) async {
  await tester.pumpWidget(MyApp());
  expect(find.text('Agenda Calendar'), findsOneWidget);
});
```

### 3. Integration Tests

```bash
flutter drive --target=test_driver/app.dart
```

## Code Style Guidelines

### 1. Naming Conventions

- **Classes**: PascalCase (e.g., `UserController`)
- **Variables & Functions**: camelCase (e.g., `userName`, `fetchUserData()`)
- **Constants**: UPPER_SNAKE_CASE (e.g., `API_BASE_URL`)
- **Files**: snake_case (e.g., `user_controller.dart`)

### 2. File Structure

```dart
// 1. Dart imports
import 'dart:async';

// 2. Flutter imports
import 'package:flutter/material.dart';

// 3. Package imports
import 'package:get/get.dart';

// 4. Project imports
import '../core/constants/app_constants.dart';
```

### 3. Documentation

```dart
/// Service class for handling user authentication
///
/// This class provides methods for:
/// - Google OAuth authentication
/// - User session management
/// - Token refresh
class AuthService {
  /// Signs in user with Google OAuth
  ///
  /// Returns [User] object on success or throws [AuthException] on failure
  Future<User> signInWithGoogle() async {
    // Implementation
  }
}
```

## Common Issues & Solutions

### 1. Build Issues

```bash
# Clean and rebuild
flutter clean && flutter pub get && flutter build apk
```

### 2. Dependency Conflicts

```bash
# Check outdated packages
flutter pub outdated

# Upgrade dependencies
flutter pub upgrade
```

### 3. Platform-specific Issues

#### Android

- Ensure minimum SDK version is 21
- Check ProGuard rules for release builds
- Verify SHA-1 fingerprint for Google Services

#### iOS

- Update iOS deployment target to 11.0
- Check Info.plist configurations
- Verify provisioning profiles

## Performance Optimization

### 1. Code Optimization

- Use `const` constructors where possible
- Implement lazy loading for large lists
- Optimize image loading with `cached_network_image`

### 2. Build Optimization

```bash
# Release build optimizations
flutter build apk --release --shrink
flutter build appbundle --release
```

### 3. Memory Management

- Dispose controllers and streams properly
- Use `Get.delete()` when removing controllers
- Monitor memory usage with Flutter Inspector

## Deployment

### Development

```bash
flutter run --debug
```

### Staging

```bash
flutter build apk --debug
```

### Production

```bash
flutter build apk --release
flutter build appbundle --release
```

## Helpful Commands

```bash
# Generate files
flutter packages pub run build_runner build

# Check dependencies
flutter pub deps

# Analyze code
flutter analyze

# Format code
dart format .

# Run on device
flutter run -d <device_id>

# Hot reload
# Press 'r' in terminal or Ctrl+S in IDE
```

## Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [GetX Documentation](https://pub.dev/packages/get)
- [Supabase Flutter Documentation](https://supabase.com/docs/guides/getting-started/tutorials/with-flutter)
- [Google Calendar API Documentation](https://developers.google.com/calendar)
- [Clean Architecture Guide](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
