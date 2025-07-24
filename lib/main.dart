import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/config/env_config.dart';
import 'core/di/dependency_injection.dart';
import 'core/routes/app_routes.dart';
import 'core/themes/app_theme.dart';
import 'core/utils/app_logger.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    AppLogger.i('🚀 Starting application...');

    // Load environment variables
    AppLogger.d('📁 Loading environment variables...');
    await dotenv.load(fileName: ".env");

    // Initialize Supabase
    AppLogger.d('🔧 Initializing Supabase...');
    await Supabase.initialize(
      url: EnvConfig.supabaseUrl,
      anonKey: EnvConfig.supabaseAnonKey,
    );
    AppLogger.i('✅ Supabase initialized successfully');

    // Setup dependency injection
    AppLogger.d('🔧 Setting up dependency injection...');
    await DependencyInjection.setup();
    AppLogger.i('✅ Dependency injection setup completed');

    AppLogger.i('🎉 Application initialization completed');
    runApp(const MyApp());
  } catch (error, stackTrace) {
    AppLogger.e('💥 Failed to initialize application', error, stackTrace);
    rethrow;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    AppLogger.d('🎨 Building MyApp widget');

    return GetMaterialApp(
      title: 'Agenda',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: AppRoutes.initial,
      getPages: AppRoutes.routes,
    );
  }
}
