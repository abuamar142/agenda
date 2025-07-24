import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../controllers/auth_controller.dart';
import '../../domain/usecases/login_with_google_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../domain/usecases/check_auth_status_usecase.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/datasources/auth_remote_data_source.dart';
import '../../data/datasources/auth_local_data_source.dart';
import '../../core/network/network_info.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    // Data sources
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

    // Controller
    Get.lazyPut<AuthController>(
      () => AuthController(
        loginWithGoogleUseCase: Get.find(),
        logoutUseCase: Get.find(),
        getCurrentUserUseCase: Get.find(),
        checkAuthStatusUseCase: Get.find(),
      ),
    );
  }
}
