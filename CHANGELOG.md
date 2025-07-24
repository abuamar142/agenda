# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/), and this project
adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- Project setup with clean architecture
- GetX state management integration
- Supabase backend configuration
- Google Calendar API setup
- Basic UI theme and styling
- Core utilities and error handling
- Entity models for User, CalendarEvent, and EventTemplate
- Repository interfaces for authentication and calendar operations
- Dependency injection setup
- Environment configuration
- ✅ Authentication module with Supabase OAuth
- ✅ Google Sign-In integration
- ✅ Splash screen with app initialization
- ✅ User authentication state management
- ✅ Local data caching with SharedPreferences and Secure Storage
- ✅ Custom UI widgets (LoadingWidget, CustomElevatedButton)
- ✅ Auth repository implementation with offline support
- ✅ Auth use cases (Login, Logout, GetCurrentUser, CheckAuthStatus)
- ✅ Auth controller with reactive state management
- ✅ Auth and Splash views with modern UI design

### Fixed

- Fixed deprecated `withOpacity` calls to use `withValues`
- Added missing `@override` annotations
- Fixed curly braces in flow control structures

### TODO

- [ ] ~~Implement authentication with Supabase OAuth~~ ✅ COMPLETED
- [ ] ~~Create authentication views and controllers~~ ✅ COMPLETED
- [ ] Implement Google Calendar API integration
- [ ] Create calendar views and event management
- [ ] Implement event templates functionality
- [ ] Add push notifications
- [ ] Implement offline support for calendar data
- [ ] Add unit and integration tests

## [0.1.0] - 2025-01-24

### Added

- Initial project setup
- Clean architecture structure
- Basic Flutter project configuration
- Dependencies configuration in pubspec.yaml
- README with comprehensive documentation
- Git configuration and .gitignore

### Changed

- Updated project structure to follow clean architecture principles
- Migrated from basic Flutter structure to modular architecture

### Technical Details

- Flutter SDK: ^3.8.1
- State Management: GetX ^4.7.2
- Backend: Supabase Flutter ^2.5.2
- Calendar API: Google APIs ^13.1.0
- Architecture: Clean Architecture with 3 layers (Presentation, Domain, Data)
