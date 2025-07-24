import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/network/network_info.dart';
import '../../core/utils/app_logger.dart';
import '../../features/auth/data/datasources/auth_local_data_source.dart';
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/check_auth_status_usecase.dart';
import 'splash_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    AppLogger.i('🔧 SplashBinding: Initializing dependencies...');

    // Data sources (temporary for splash)
    Get.lazyPut<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(supabaseClient: Supabase.instance.client),
    );
    AppLogger.i('✅ SplashBinding: AuthRemoteDataSource registered');

    Get.lazyPut<AuthLocalDataSource>(
      () => AuthLocalDataSourceImpl(
        sharedPreferences: Get.find<SharedPreferences>(),
        secureStorage: const FlutterSecureStorage(),
      ),
    );
    AppLogger.i('✅ SplashBinding: AuthLocalDataSource registered');

    // Repository (use interface)
    Get.lazyPut<AuthRepository>(
      () => AuthRepositoryImpl(
        remoteDataSource: Get.find<AuthRemoteDataSource>(),
        localDataSource: Get.find<AuthLocalDataSource>(),
        networkInfo: Get.find<NetworkInfo>(),
      ),
    );
    AppLogger.i('✅ SplashBinding: AuthRepository registered');

    // Use case
    Get.lazyPut(() => CheckAuthStatusUseCase(Get.find<AuthRepository>()));
    AppLogger.i('✅ SplashBinding: CheckAuthStatusUseCase registered');

    // Controller
    Get.lazyPut<SplashController>(
      () => SplashController(checkAuthStatusUseCase: Get.find()),
    );
    AppLogger.i('✅ SplashBinding: SplashController registered');

    AppLogger.i('🎯 SplashBinding: All dependencies initialized successfully');
  }
}
