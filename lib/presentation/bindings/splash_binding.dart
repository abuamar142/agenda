import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../controllers/splash_controller.dart';
import '../../domain/usecases/check_auth_status_usecase.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/datasources/auth_remote_data_source.dart';
import '../../data/datasources/auth_local_data_source.dart';
import '../../core/network/network_info.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    // Data sources (temporary for splash)
    Get.lazyPut<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(
        supabaseClient: Supabase.instance.client,
      ),
    );

    Get.lazyPut<AuthLocalDataSource>(
      () => AuthLocalDataSourceImpl(
        sharedPreferences: Get.find<SharedPreferences>(),
        secureStorage: const FlutterSecureStorage(),
      ),
    );

    // Repository (temporary for splash)
    Get.lazyPut<AuthRepositoryImpl>(
      () => AuthRepositoryImpl(
        remoteDataSource: Get.find<AuthRemoteDataSource>(),
        localDataSource: Get.find<AuthLocalDataSource>(),
        networkInfo: Get.find<NetworkInfo>(),
      ),
    );

    // Use case
    Get.lazyPut(() => CheckAuthStatusUseCase(Get.find<AuthRepositoryImpl>()));

    // Controller
    Get.lazyPut<SplashController>(
      () => SplashController(
        checkAuthStatusUseCase: Get.find(),
      ),
    );
  }
}
