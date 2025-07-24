import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'dio_logger_interceptor.dart';

class NetworkClient {
  static NetworkClient? _instance;
  static NetworkClient get instance => _instance ??= NetworkClient._internal();

  late final Dio _dio;

  NetworkClient._internal() {
    _dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add interceptors
    _dio.interceptors.add(DioLoggerInterceptor());

    // Add timing interceptor
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          options.extra['start_time'] = DateTime.now();
          handler.next(options);
        },
      ),
    );

    // Hanya tambahkan debug interceptor di development
    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          requestHeader: false,
          responseHeader: false,
          error: true,
          logPrint: (obj) {
            // Custom print untuk dio logs
            if (kDebugMode) print('🌐 Dio: $obj');
          },
        ),
      );
    }
  }

  Dio get dio => _dio;
}
