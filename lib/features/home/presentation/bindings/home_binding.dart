import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/network/network_info.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../auth/data/datasources/auth_local_data_source.dart';
import '../../../auth/data/datasources/auth_remote_data_source.dart';
import '../../../auth/data/repositories/auth_repository_impl.dart';
import '../../../auth/domain/usecases/check_auth_status_usecase.dart';
import '../../../auth/domain/usecases/get_current_user_usecase.dart';
import '../../../auth/domain/usecases/login_with_google_usecase.dart';
import '../../../auth/domain/usecases/logout_usecase.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../calendar/data/datasources/calendar_remote_data_source.dart';
import '../../../calendar/data/repositories/calendar_repository_impl.dart';
import '../../../calendar/domain/repositories/calendar_repository.dart';
import '../../../calendar/domain/usecases/get_today_events_usecase.dart';
import '../../../calendar/domain/usecases/get_upcoming_events_usecase.dart';
import '../../../calendar/presentation/controllers/calendar_controller.dart';
import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    AppLogger.i('🏠 HomeBinding: Initializing dependencies...');

    // Check if AuthController already exists, if not create it
    if (!Get.isRegistered<AuthController>()) {
      AppLogger.i(
        '🏠 HomeBinding: AuthController not found, creating dependencies...',
      );

      // Data sources
      Get.lazyPut<AuthRemoteDataSource>(
        () =>
            AuthRemoteDataSourceImpl(supabaseClient: Supabase.instance.client),
      );

      Get.lazyPut<AuthLocalDataSource>(
        () => AuthLocalDataSourceImpl(
          sharedPreferences: Get.find<SharedPreferences>(),
          secureStorage: const FlutterSecureStorage(),
        ),
      );

      // Repository
      Get.lazyPut<AuthRepositoryImpl>(
        () => AuthRepositoryImpl(
          remoteDataSource: Get.find<AuthRemoteDataSource>(),
          localDataSource: Get.find<AuthLocalDataSource>(),
          networkInfo: Get.find<NetworkInfo>(),
        ),
      );

      // Use cases
      Get.lazyPut(() => LoginWithGoogleUseCase(Get.find<AuthRepositoryImpl>()));
      Get.lazyPut(() => LogoutUseCase(Get.find<AuthRepositoryImpl>()));
      Get.lazyPut(() => GetCurrentUserUseCase(Get.find<AuthRepositoryImpl>()));
      Get.lazyPut(() => CheckAuthStatusUseCase(Get.find<AuthRepositoryImpl>()));

      // AuthController
      Get.lazyPut<AuthController>(
        () => AuthController(
          loginWithGoogleUseCase: Get.find(),
          logoutUseCase: Get.find(),
          getCurrentUserUseCase: Get.find(),
          checkAuthStatusUseCase: Get.find(),
        ),
      );
      AppLogger.i('✅ HomeBinding: AuthController created');
    } else {
      AppLogger.i('✅ HomeBinding: AuthController already exists');
    }

    // HomeController
    Get.lazyPut(() => HomeController());
    AppLogger.i('✅ HomeBinding: HomeController registered');

    // Calendar dependencies - Register directly
    _registerCalendarDependencies();
    AppLogger.i('✅ HomeBinding: Calendar dependencies registered');
  }

  void _registerCalendarDependencies() {
    // Supabase Client (if not already registered)
    if (!Get.isRegistered<SupabaseClient>()) {
      Get.lazyPut<SupabaseClient>(() => Supabase.instance.client);
    }

    // Calendar Data Sources
    Get.lazyPut<CalendarRemoteDataSource>(
      () => CalendarRemoteDataSourceImpl(
        supabaseClient: Get.find<SupabaseClient>(),
      ),
    );

    // Calendar Repository
    Get.lazyPut<CalendarRepository>(
      () => CalendarRepositoryImpl(
        remoteDataSource: Get.find<CalendarRemoteDataSource>(),
        networkInfo: Get.find<NetworkInfo>(),
      ),
    );

    // Calendar Use Cases
    Get.lazyPut(() => GetTodayEventsUseCase(Get.find<CalendarRepository>()));
    Get.lazyPut(() => GetUpcomingEventsUseCase(Get.find<CalendarRepository>()));

    // Calendar Controller
    Get.lazyPut(
      () => CalendarController(
        getTodayEventsUseCase: Get.find<GetTodayEventsUseCase>(),
        getUpcomingEventsUseCase: Get.find<GetUpcomingEventsUseCase>(),
      ),
    );
  }
}
