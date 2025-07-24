import 'app_logger.dart';

mixin LoggerMixin {
  String get _className => runtimeType.toString();

  void logD(String message) {
    AppLogger.d('[$_className] $message');
  }

  void logI(String message) {
    AppLogger.i('[$_className] $message');
  }

  void logW(String message, [dynamic error]) {
    AppLogger.w('[$_className] $message', error);
  }

  void logE(String message, [dynamic error, StackTrace? stackTrace]) {
    AppLogger.e('[$_className] $message', error, stackTrace);
  }

  void logAuth(String action, [String? details]) {
    AppLogger.auth('[$_className] $action', details);
  }

  void logNavigation(String to) {
    AppLogger.navigation(_className, to);
  }

  void logPerformance(String operation, Duration duration) {
    AppLogger.performance('[$_className] $operation', duration);
  }

  Future<T> timed<T>(String operation, Future<T> Function() function) async {
    final stopwatch = Stopwatch()..start();
    try {
      final result = await function();
      stopwatch.stop();
      logPerformance(operation, stopwatch.elapsed);
      return result;
    } catch (error, stackTrace) {
      stopwatch.stop();
      logE(
        '$operation failed after ${stopwatch.elapsed.inMilliseconds}ms',
        error,
        stackTrace,
      );
      rethrow;
    }
  }
}
