import 'package:flutter/foundation.dart';

class BuildConfig {
  static const bool isDebug = kDebugMode;
  static const bool isProfile = kProfileMode;
  static const bool isRelease = kReleaseMode;

  // Logger configuration
  static const bool enableLogging = kDebugMode;
  static const bool enableNetworkLogging = kDebugMode;
  static const bool enablePerformanceLogging = kDebugMode;

  // Analytics configuration
  static const bool enableAnalytics = kReleaseMode;
  static const bool enableCrashlytics = !kDebugMode;

  // Feature flags
  static const bool enableDetailedErrors = kDebugMode;
  static const bool enableDebugPanel = kDebugMode;

  static String get buildMode {
    if (kDebugMode) return 'DEBUG';
    if (kProfileMode) return 'PROFILE';
    return 'RELEASE';
  }

  static void printBuildInfo() {
    if (kDebugMode) {
      print('🏗️  Build Mode: $buildMode');
      print('📝 Logging Enabled: $enableLogging');
      print('🌐 Network Logging: $enableNetworkLogging');
      print('⚡ Performance Logging: $enablePerformanceLogging');
      print('📊 Analytics Enabled: $enableAnalytics');
    }
  }
}
