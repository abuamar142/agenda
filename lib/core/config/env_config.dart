import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  static String get supabaseUrl => dotenv.env['SUPABASE_URL'] ?? '';
  static String get supabaseAnonKey => dotenv.env['SUPABASE_ANON_KEY'] ?? '';
  static String get googleClientId => dotenv.env['GOOGLE_CLIENT_ID'] ?? '';
  static String get googleClientSecret => dotenv.env['GOOGLE_CLIENT_SECRET'] ?? '';
  static String get environment => dotenv.env['ENVIRONMENT'] ?? 'development';
  static bool get debugMode => dotenv.env['DEBUG_MODE'] == 'true';
  static int get apiTimeout => int.tryParse(dotenv.env['API_TIMEOUT'] ?? '') ?? 30000;
  static int get maxRetryAttempts => int.tryParse(dotenv.env['MAX_RETRY_ATTEMPTS'] ?? '') ?? 3;
  static bool get enableAnalytics => dotenv.env['ENABLE_ANALYTICS'] == 'true';
  static bool get enableCrashReporting => dotenv.env['ENABLE_CRASH_REPORTING'] == 'true';

  // Validation
  static bool get isConfigured {
    return supabaseUrl.isNotEmpty && 
           supabaseAnonKey.isNotEmpty;
  }

  static void validateConfig() {
    if (supabaseUrl.isEmpty) {
      throw Exception('SUPABASE_URL is not configured in .env file');
    }
    if (supabaseAnonKey.isEmpty) {
      throw Exception('SUPABASE_ANON_KEY is not configured in .env file');
    }
  }
}
