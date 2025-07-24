import 'package:get/get.dart';

import '../../../../core/utils/app_logger.dart';
import '../controllers/calendar_controller.dart';

class CalendarBinding extends Bindings {
  @override
  void dependencies() {
    AppLogger.i('📅 CalendarBinding: Initializing dependencies...');

    // All dependencies are already registered in DependencyInjection
    // We just need to ensure CalendarController is available
    if (!Get.isRegistered<CalendarController>()) {
      AppLogger.w(
        '⚠️ CalendarController not found in DI, this should not happen',
      );
    }

    AppLogger.i('✅ CalendarBinding: Dependencies ready from DI');
  }
}
