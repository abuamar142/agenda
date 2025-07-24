import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class AppLogger {
  static AppLogger? _instance;
  static AppLogger get instance => _instance ??= AppLogger._internal();

  late final Logger _logger;

  AppLogger._internal() {
    _logger = Logger(
      filter: kDebugMode ? DevelopmentFilter() : ProductionFilter(),
      printer: PrettyPrinter(
        methodCount: 2,
        errorMethodCount: 8,
        lineLength: 120,
        colors: true,
        printEmojis: true,
        dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
        excludeBox: {Level.debug: true, Level.info: true},
        noBoxingByDefault: true,
      ),
      output: kDebugMode ? ConsoleOutput() : null,
    );
  }

  // Debug logs (hanya development)
  static void d(String message, [dynamic error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      instance._logger.d(message, error: error, stackTrace: stackTrace);
    }
  }

  // Info logs (hanya development)
  static void i(String message, [dynamic error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      instance._logger.i(message, error: error, stackTrace: stackTrace);
    }
  }

  // Warning logs (development + release untuk monitoring)
  static void w(String message, [dynamic error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      instance._logger.w(message, error: error, stackTrace: stackTrace);
    }
    // Di production, bisa dikirim ke crash analytics
  }

  // Error logs (development + release)
  static void e(String message, [dynamic error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      instance._logger.e(message, error: error, stackTrace: stackTrace);
    }
    // Di production, wajib dikirim ke crash analytics
    _sendToAnalytics(message, error, stackTrace);
  }

  // Fatal logs (development + release)
  static void f(String message, [dynamic error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      instance._logger.f(message, error: error, stackTrace: stackTrace);
    }
    // Di production, wajib dikirim ke crash analytics
    _sendToAnalytics(message, error, stackTrace);
  }

  // Send to analytics (hanya production)
  static void _sendToAnalytics(
    String message,
    dynamic error,
    StackTrace? stackTrace,
  ) {
    if (!kDebugMode) {
      // TODO: Implement crash analytics (Firebase Crashlytics, Sentry, etc.)
      // Example: FirebaseCrashlytics.instance.recordError(error, stackTrace);
    }
  }

  // Performance logging
  static void performance(String operation, Duration duration) {
    if (kDebugMode) {
      instance._logger.i(
        '⚡ Performance: $operation took ${duration.inMilliseconds}ms',
      );
    }
  }

  // Network logging
  static void network(
    String method,
    String url,
    int statusCode, [
    Duration? duration,
  ]) {
    if (kDebugMode) {
      final durationText = duration != null
          ? ' (${duration.inMilliseconds}ms)'
          : '';
      instance._logger.i('🌐 Network: $method $url → $statusCode$durationText');
    }
  }

  // Authentication logging
  static void auth(String action, [String? details]) {
    if (kDebugMode) {
      final detailsText = details != null ? ' - $details' : '';
      instance._logger.i('🔐 Auth: $action$detailsText');
    }
  }

  // Navigation logging
  static void navigation(String from, String to) {
    if (kDebugMode) {
      instance._logger.i('🧭 Navigation: $from → $to');
    }
  }
}

// Custom filter untuk production (tidak log apapun)
class ProductionFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    return false; // Tidak ada log di production
  }
}
