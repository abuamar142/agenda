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
  }
}
