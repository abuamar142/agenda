import 'package:get/get.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/extensions/app_extensions.dart';
import '../../../../core/utils/logger_mixin.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../calendar/presentation/controllers/calendar_controller.dart';

class HomeController extends GetxController with LoggerMixin {
  var isInitialized = false.obs;

  @override
  void onInit() {
    logI('HomeController onInit called');
    super.onInit();
    _initializeHome();
  }

  void _initializeHome() async {
    await timed('Home initialization', () async {
      try {
        logI('🏠 HomeController: Initializing home screen');

        // Initialize calendar if available
        if (Get.isRegistered<CalendarController>()) {
          final calendarController = Get.find<CalendarController>();
          logI('📅 Calendar controller found, loading events');
          await calendarController.loadEvents();
        } else {
          logW('📅 Calendar controller not found');
        }

        isInitialized.value = true;
        logI('🏠 HomeController: Initialization complete');
      } catch (e, stackTrace) {
        logE('Error initializing home', e, stackTrace);
        showErrorSnackbar('Failed to initialize home screen');
      }
    });
  }

  Future<void> refreshData() async {
    await timed('Refresh home data', () async {
      try {
        logI('🔄 HomeController: Refreshing data');

        // Refresh calendar events if available
        if (Get.isRegistered<CalendarController>()) {
          final calendarController = Get.find<CalendarController>();
          await calendarController.refreshEvents();
        }

        logI('🔄 HomeController: Data refresh complete');
      } catch (e, stackTrace) {
        logE('Error refreshing home data', e, stackTrace);
        showErrorSnackbar('Failed to refresh data');
      }
    });
  }

  /// Safe logout method that handles AuthController availability
  Future<void> performLogout() async {
    logI('🔧 HomeController: Starting safe logout process');

    try {
      // Try to use AuthController if available
      if (Get.isRegistered<AuthController>()) {
        logI('✅ AuthController found, using proper logout');
        final authController = Get.find<AuthController>();
        await authController.signOut();
      } else {
        // Fallback: direct logout without AuthController
        logW('⚠️ AuthController not found, performing direct logout');
        showLogoutSuccessSnackbar();
        Get.offAllNamed(AppConstants.authRoute);
      }
    } catch (e) {
      logE('❌ Error during logout', e);
      // Ultimate fallback: force navigation to auth
      showErrorSnackbar('Logout error occurred');
      Get.offAllNamed(AppConstants.authRoute);
    }
  }
}
