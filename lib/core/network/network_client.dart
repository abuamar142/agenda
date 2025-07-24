import 'package:dio/dio.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NetworkClient {
  static final NetworkClient _instance = NetworkClient._internal();
  factory NetworkClient() => _instance;
  NetworkClient._internal();

  late final Dio _dio;
  late final SupabaseClient _supabaseClient;

  void init({
    required String supabaseUrl,
    required String supabaseAnonKey,
    String? baseUrl,
  }) {
    // Initialize Dio
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl ?? '',
        connectTimeout: const Duration(milliseconds: 30000),
        receiveTimeout: const Duration(milliseconds: 30000),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    // Add interceptors
    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        requestHeader: true,
        responseHeader: false,
      ),
    );

    // Initialize Supabase
    _supabaseClient = Supabase.instance.client;
  }

  Dio get dio => _dio;
  SupabaseClient get supabaseClient => _supabaseClient;
}
