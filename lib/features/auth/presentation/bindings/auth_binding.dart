import 'package:get/get.dart';

import '../../../../core/utils/app_logger.dart';
import '../controllers/auth_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    AppLogger.i('🔐 AuthBinding: Initializing dependencies...');

    // All dependencies are already registered in DependencyInjection
    // We just need to ensure AuthController is available
    if (!Get.isRegistered<AuthController>()) {
      AppLogger.w('⚠️ AuthController not found in DI, this should not happen');
    }

    AppLogger.i('✅ AuthBinding: Dependencies ready from DI');
  }
}
