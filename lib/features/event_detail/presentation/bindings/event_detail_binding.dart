import 'package:get/get.dart';

import '../../../../core/utils/app_logger.dart';
import '../controllers/event_detail_controller.dart';

class EventDetailBinding extends Bindings {
  @override
  void dependencies() {
    AppLogger.i('📅 EventDetailBinding: Initializing dependencies...');

    // Register EventDetailController
    Get.lazyPut<EventDetailController>(() => EventDetailController());

    AppLogger.i('✅ EventDetailBinding: Dependencies ready');
  }
}
