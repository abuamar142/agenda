import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../utils/app_logger.dart';

class DioLoggerInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      AppLogger.network(
        options.method.toUpperCase(),
        options.uri.toString(),
        0, // Request belum selesai
      );
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      final duration = _calculateDuration(response.requestOptions.extra);
      AppLogger.network(
        response.requestOptions.method.toUpperCase(),
        response.requestOptions.uri.toString(),
        response.statusCode ?? 0,
        duration,
      );
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      AppLogger.e(
        'Network Error: ${err.requestOptions.method.toUpperCase()} ${err.requestOptions.uri}',
        err,
      );
    }
    handler.next(err);
  }

  Duration? _calculateDuration(Map<String, dynamic> extra) {
    final startTime = extra['start_time'] as DateTime?;
    return startTime != null ? DateTime.now().difference(startTime) : null;
  }
}
