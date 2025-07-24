import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../features/auth/data/datasources/auth_local_data_source.dart';
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/check_auth_status_usecase.dart';
import '../../features/auth/domain/usecases/get_current_user_usecase.dart';
import '../../features/auth/domain/usecases/login_with_google_usecase.dart';
import '../../features/auth/domain/usecases/logout_usecase.dart';
import '../../features/auth/presentation/controllers/auth_controller.dart';
import '../../features/calendar/data/datasources/calendar_remote_data_source.dart';
import '../../features/calendar/data/repositories/calendar_repository_impl.dart';
import '../../features/calendar/domain/repositories/calendar_repository.dart';
import '../../features/calendar/domain/usecases/get_today_events_usecase.dart';
import '../../features/calendar/domain/usecases/get_upcoming_events_usecase.dart';
import '../../features/calendar/presentation/controllers/calendar_controller.dart';
import '../../features/home/presentation/controllers/home_controller.dart';
import '../../shared/splash/splash_controller.dart';
import '../network/network_client.dart';
import '../network/network_info.dart';
import '../utils/app_logger.dart';

class DependencyInjection {
  static Future<void> setup() async {
    AppLogger.i('🏗️ DependencyInjection: Setting up all dependencies...');

    // Core dependencies
    await _setupCore();

    // External dependencies
    await _setupExternal();

    // Data sources
    _setupDataSources();

    // Repositories
    _setupRepositories();

    // Use cases
    _setupUseCases();

    // Controllers
    _setupControllers();

    AppLogger.i('✅ DependencyInjection: All dependencies setup completed');
  }

  static Future<void> _setupCore() async {
    AppLogger.d('🔧 Setting up core dependencies...');

    Get.lazyPut<NetworkClient>(() => NetworkClient.instance, fenix: true);
    Get.lazyPut<NetworkInfo>(() => NetworkInfoImpl(), fenix: true);

    AppLogger.i('✅ Core dependencies registered');
  }

  static Future<void> _setupExternal() async {
    AppLogger.d('🔧 Setting up external dependencies...');

    // SharedPreferences
    final sharedPreferences = await SharedPreferences.getInstance();
    Get.put<SharedPreferences>(sharedPreferences);

    // FlutterSecureStorage
    Get.lazyPut<FlutterSecureStorage>(
      () => const FlutterSecureStorage(),
      fenix: true,
    );

    // Supabase Client
    Get.lazyPut<SupabaseClient>(() => Supabase.instance.client, fenix: true);

    AppLogger.i('✅ External dependencies registered');
  }

  static void _setupDataSources() {
    AppLogger.d('🔧 Setting up data sources...');

    // Auth Data Sources
    Get.lazyPut<AuthRemoteDataSource>(
      () =>
          AuthRemoteDataSourceImpl(supabaseClient: Get.find<SupabaseClient>()),
    );

    Get.lazyPut<AuthLocalDataSource>(
      () => AuthLocalDataSourceImpl(
        sharedPreferences: Get.find<SharedPreferences>(),
        secureStorage: Get.find<FlutterSecureStorage>(),
      ),
    );

    // Calendar Data Sources
    Get.lazyPut<CalendarRemoteDataSource>(
      () => CalendarRemoteDataSourceImpl(
        supabaseClient: Get.find<SupabaseClient>(),
      ),
    );

    AppLogger.i('✅ Data sources registered');
  }

  static void _setupRepositories() {
    AppLogger.d('🔧 Setting up repositories...');

    // Auth Repository
    Get.lazyPut<AuthRepository>(
      () => AuthRepositoryImpl(
        remoteDataSource: Get.find<AuthRemoteDataSource>(),
        localDataSource: Get.find<AuthLocalDataSource>(),
        networkInfo: Get.find<NetworkInfo>(),
      ),
    );

    // Calendar Repository
    Get.lazyPut<CalendarRepository>(
      () => CalendarRepositoryImpl(
        remoteDataSource: Get.find<CalendarRemoteDataSource>(),
        networkInfo: Get.find<NetworkInfo>(),
      ),
    );

    AppLogger.i('✅ Repositories registered');
  }

  static void _setupUseCases() {
    AppLogger.d('🔧 Setting up use cases...');

    // Auth Use Cases
    Get.lazyPut(() => LoginWithGoogleUseCase(Get.find<AuthRepository>()));
    Get.lazyPut(() => LogoutUseCase(Get.find<AuthRepository>()));
    Get.lazyPut(() => GetCurrentUserUseCase(Get.find<AuthRepository>()));
    Get.lazyPut(() => CheckAuthStatusUseCase(Get.find<AuthRepository>()));

    // Calendar Use Cases
    Get.lazyPut(() => GetTodayEventsUseCase(Get.find<CalendarRepository>()));
    Get.lazyPut(() => GetUpcomingEventsUseCase(Get.find<CalendarRepository>()));

    AppLogger.i('✅ Use cases registered');
  }

  static void _setupControllers() {
    AppLogger.d('🔧 Setting up controllers...');

    // Auth Controller
    Get.lazyPut<AuthController>(
      () => AuthController(
        loginWithGoogleUseCase: Get.find<LoginWithGoogleUseCase>(),
        logoutUseCase: Get.find<LogoutUseCase>(),
        getCurrentUserUseCase: Get.find<GetCurrentUserUseCase>(),
        checkAuthStatusUseCase: Get.find<CheckAuthStatusUseCase>(),
      ),
      fenix: true,
    );

    // Calendar Controller
    Get.lazyPut<CalendarController>(
      () => CalendarController(
        getTodayEventsUseCase: Get.find<GetTodayEventsUseCase>(),
        getUpcomingEventsUseCase: Get.find<GetUpcomingEventsUseCase>(),
      ),
      fenix: true,
    );

    // Home Controller
    Get.lazyPut<HomeController>(() => HomeController(), fenix: true);

    // Splash Controller
    Get.lazyPut<SplashController>(
      () => SplashController(
        checkAuthStatusUseCase: Get.find<CheckAuthStatusUseCase>(),
      ),
      fenix: true,
    );

    AppLogger.i('✅ Controllers registered');
  }

  /// Clean up all dependencies
  static void dispose() {
    AppLogger.i('🧹 DependencyInjection: Cleaning up dependencies...');
    Get.deleteAll(force: true);
    AppLogger.i('✅ DependencyInjection: Cleanup completed');
  }

  /// Reset all dependencies (useful for testing)
  static Future<void> reset() async {
    AppLogger.i('🔄 DependencyInjection: Resetting dependencies...');
    dispose();
    await setup();
    AppLogger.i('✅ DependencyInjection: Reset completed');
  }
}
