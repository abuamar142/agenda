import '../config/env_config.dart';

class AppConstants {
  // App Info
  static const String appVersion = '1.0.0';

  // API Endpoints
  static const String baseUrl = 'https://your-api-endpoint.com/api/v1';

  // Supabase Configuration (from environment)
  static String get supabaseUrl => EnvConfig.supabaseUrl;
  static String get supabaseAnonKey => EnvConfig.supabaseAnonKey;

  // Google Configuration (from environment)
  static String get googleClientId =>
      EnvConfig.googleClientId; // Google Calendar API
  static const String googleCalendarApiUrl =
      'https://www.googleapis.com/calendar/v3';
  static const List<String> googleCalendarScopes = [
    'https://www.googleapis.com/auth/calendar',
    'https://www.googleapis.com/auth/calendar.events',
  ];

  // Storage Keys
  static const String userTokenKey = 'user_token';
  static const String userDataKey = 'user_data';
  static const String refreshTokenKey = 'refresh_token';
  static const String isFirstTimeKey = 'is_first_time';

  // Route Names
  static const String splashRoute = '/splash';
  static const String authRoute = '/auth';
  static const String homeRoute = '/home';
  static const String calendarRoute = '/calendar';
  static const String eventRoute = '/event';
  static const String templateRoute = '/template';
  static const String settingsRoute = '/settings';

  // Error Messages
  static const String networkErrorMessage =
      'Please check your internet connection';
  static const String serverErrorMessage =
      'Something went wrong. Please try again later';
  static const String authErrorMessage =
      'Authentication failed. Please login again';
  static const String validationErrorMessage = 'Please check your input';

  // Success Messages
  static const String loginSuccessMessage = 'Login successful';
  static const String logoutSuccessMessage = 'Logout successful';
  static const String eventCreatedMessage = 'Event created successfully';
  static const String eventUpdatedMessage = 'Event updated successfully';
  static const String eventDeletedMessage = 'Event deleted successfully';
}
