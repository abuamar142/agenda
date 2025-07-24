import 'package:get/get.dart';

import '../../../../core/utils/app_logger.dart';
import '../../../calendar/domain/entities/calendar_event.dart';

class EventDetailController extends GetxController {
  final Rx<CalendarEvent?> _event = Rx<CalendarEvent?>(null);
  final RxBool _isLoading = false.obs;

  CalendarEvent? get event => _event.value;
  bool get isLoading => _isLoading.value;

  @override
  void onInit() {
    super.onInit();

    // Get event from arguments
    final eventData = Get.arguments;
    if (eventData is CalendarEvent) {
      _event.value = eventData;
      AppLogger.i(
        '📅 EventDetailController: Event loaded - ${eventData.title}',
      );
    } else {
      AppLogger.e('❌ EventDetailController: No event data provided');
    }
  }

  void refreshEvent() {
    // In future, we can reload event details from API
    _isLoading.value = true;

    // Simulate refresh
    Future.delayed(const Duration(seconds: 1), () {
      _isLoading.value = false;
      AppLogger.i('🔄 EventDetailController: Event refreshed');
    });
  }

  void editEvent() {
    AppLogger.i('✏️ EventDetailController: Edit event requested');
    // TODO: Navigate to edit screen
    Get.snackbar(
      'Coming Soon',
      'Event editing will be available soon',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void deleteEvent() {
    AppLogger.i('🗑️ EventDetailController: Delete event requested');
    // TODO: Implement delete functionality
    Get.defaultDialog(
      title: 'Delete Event',
      middleText: 'Are you sure you want to delete this event?',
      textCancel: 'Cancel',
      textConfirm: 'Delete',
      confirmTextColor: Get.theme.colorScheme.onError,
      buttonColor: Get.theme.colorScheme.error,
      onConfirm: () {
        Get.back(); // Close dialog
        Get.back(); // Go back to previous screen
        Get.snackbar(
          'Event Deleted',
          'The event has been deleted successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
      },
    );
  }

  void shareEvent() {
    AppLogger.i('📤 EventDetailController: Share event requested');
    // TODO: Implement share functionality
    Get.snackbar(
      'Coming Soon',
      'Event sharing will be available soon',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void addToCalendar() {
    AppLogger.i('📱 EventDetailController: Add to device calendar requested');
    // TODO: Implement add to device calendar
    Get.snackbar(
      'Coming Soon',
      'Add to device calendar will be available soon',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
