import 'package:get/get.dart';

import '../../core/utils/app_logger.dart';
import '../../features/auth/domain/usecases/check_auth_status_usecase.dart';
import 'splash_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    AppLogger.i('🔧 SplashBinding: Initializing dependencies...');

    // All dependencies are already registered in DependencyInjection
    // We just need to ensure CheckAuthStatusUseCase is available
    if (!Get.isRegistered<CheckAuthStatusUseCase>()) {
      AppLogger.w(
        '⚠️ CheckAuthStatusUseCase not found in DI, this should not happen',
      );
    }

    // Controller - Register SplashController if not already available
    if (!Get.isRegistered<SplashController>()) {
      Get.lazyPut<SplashController>(
        () => SplashController(checkAuthStatusUseCase: Get.find()),
      );
      AppLogger.i('✅ SplashBinding: SplashController registered');
    } else {
      AppLogger.i('✅ SplashBinding: SplashController already exists');
    }

    AppLogger.i('🎯 SplashBinding: All dependencies ready from DI');
  }
}
