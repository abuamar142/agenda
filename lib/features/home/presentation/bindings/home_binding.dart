import 'package:get/get.dart';

import '../../../../core/utils/app_logger.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../calendar/presentation/controllers/calendar_controller.dart';
import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    AppLogger.i('🏠 HomeBinding: Initializing dependencies...');

    // All dependencies are already registered in DependencyInjection
    // We just need to ensure required controllers are available
    if (!Get.isRegistered<AuthController>()) {
      AppLogger.w('⚠️ AuthController not found in DI, this should not happen');
    }

    if (!Get.isRegistered<CalendarController>()) {
      AppLogger.w(
        '⚠️ CalendarController not found in DI, this should not happen',
      );
    }

    if (!Get.isRegistered<HomeController>()) {
      AppLogger.w('⚠️ HomeController not found in DI, this should not happen');
    }

    AppLogger.i('✅ HomeBinding: Dependencies ready from DI');
  }
}
