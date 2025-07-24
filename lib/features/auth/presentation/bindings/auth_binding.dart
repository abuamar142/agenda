import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/network/network_info.dart';
import '../../../../core/utils/app_logger.dart';
import '../../data/datasources/auth_local_data_source.dart';
import '../../data/datasources/auth_remote_data_source.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/usecases/check_auth_status_usecase.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../domain/usecases/login_with_google_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../controllers/auth_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    AppLogger.i('🔐 AuthBinding: Initializing dependencies...');

    // Data sources
    Get.lazyPut<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(supabaseClient: Supabase.instance.client),
    );
    AppLogger.i('✅ AuthBinding: AuthRemoteDataSource registered');

    Get.lazyPut<AuthLocalDataSource>(
      () => AuthLocalDataSourceImpl(
        sharedPreferences: Get.find<SharedPreferences>(),
        secureStorage: const FlutterSecureStorage(),
      ),
    );
    AppLogger.i('✅ AuthBinding: AuthLocalDataSource registered');

    // Repository
    Get.lazyPut<AuthRepositoryImpl>(
      () => AuthRepositoryImpl(
        remoteDataSource: Get.find<AuthRemoteDataSource>(),
        localDataSource: Get.find<AuthLocalDataSource>(),
        networkInfo: Get.find<NetworkInfo>(),
      ),
    );
    AppLogger.i('✅ AuthBinding: AuthRepositoryImpl registered');

    // Use cases
    Get.lazyPut(() => LoginWithGoogleUseCase(Get.find<AuthRepositoryImpl>()));
    Get.lazyPut(() => LogoutUseCase(Get.find<AuthRepositoryImpl>()));
    Get.lazyPut(() => GetCurrentUserUseCase(Get.find<AuthRepositoryImpl>()));
    Get.lazyPut(() => CheckAuthStatusUseCase(Get.find<AuthRepositoryImpl>()));
    AppLogger.i('✅ AuthBinding: Use cases registered');

    // Controller
    Get.lazyPut<AuthController>(
      () => AuthController(
        loginWithGoogleUseCase: Get.find(),
        logoutUseCase: Get.find(),
        getCurrentUserUseCase: Get.find(),
        checkAuthStatusUseCase: Get.find(),
      ),
    );
    AppLogger.i('✅ AuthBinding: AuthController registered');
  }
}
