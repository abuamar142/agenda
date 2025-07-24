import 'package:get/get.dart';

import '../../../../core/extensions/app_extensions.dart';
import '../../../../core/utils/logger_mixin.dart';
import '../../domain/entities/calendar_event.dart';
import '../../domain/usecases/get_today_events_usecase.dart';
import '../../domain/usecases/get_upcoming_events_usecase.dart';

class CalendarController extends GetxController with LoggerMixin {
  final GetTodayEventsUseCase getTodayEventsUseCase;
  final GetUpcomingEventsUseCase getUpcomingEventsUseCase;

  CalendarController({
    required this.getTodayEventsUseCase,
    required this.getUpcomingEventsUseCase,
  }) {
    logI('CalendarController constructor called');
  }

  // Reactive variables
  final _todayEvents = <CalendarEvent>[].obs;
  final _upcomingEvents = <CalendarEvent>[].obs;
  final _isLoading = false.obs;
  final _isRefreshing = false.obs;

  // Getters
  List<CalendarEvent> get todayEvents => _todayEvents;
  List<CalendarEvent> get upcomingEvents => _upcomingEvents;
  bool get isLoading => _isLoading.value;
  bool get isRefreshing => _isRefreshing.value;

  // Computed getters
  bool get hasTodayEvents => _todayEvents.isNotEmpty;
  bool get hasUpcomingEvents => _upcomingEvents.isNotEmpty;

  List<CalendarEvent> get ongoingEvents =>
      _todayEvents.where((event) => event.isOngoing).toList();

  CalendarEvent? get nextEvent =>
      _upcomingEvents.isNotEmpty ? _upcomingEvents.first : null;

  @override
  void onInit() {
    logI('CalendarController onInit called');
    super.onInit();
    loadEvents();
  }

  Future<void> loadEvents() async {
    await timed('Load calendar events', () async {
      _isLoading.value = true;

      try {
        logCalendar('Loading today and upcoming events');

        // Load both today and upcoming events in parallel
        await Future.wait([_loadTodayEvents(), _loadUpcomingEvents()]);

        logCalendar(
          'Events loaded successfully',
          'Today: ${_todayEvents.length}, Upcoming: ${_upcomingEvents.length}',
        );
      } catch (e, stackTrace) {
        logE('Error loading calendar events', e, stackTrace);
        _handleError('Failed to load calendar events: ${e.toString()}');
      } finally {
        _isLoading.value = false;
      }
    });
  }

  Future<void> refreshEvents() async {
    await timed('Refresh calendar events', () async {
      _isRefreshing.value = true;

      try {
        logCalendar('Refreshing calendar events');

        // Clear existing events
        _todayEvents.clear();
        _upcomingEvents.clear();

        // Reload events
        await loadEvents();

        showSuccessSnackbar('Calendar refreshed successfully');
      } catch (e, stackTrace) {
        logE('Error refreshing calendar events', e, stackTrace);
        _handleError('Failed to refresh calendar: ${e.toString()}');
      } finally {
        _isRefreshing.value = false;
      }
    });
  }

  Future<void> _loadTodayEvents() async {
    final result = await getTodayEventsUseCase();

    result.fold(
      (failure) {
        logW('Failed to load today events', failure.toString());
        _handleError(failure.toString());
      },
      (events) {
        logCalendar('Today events loaded', 'Count: ${events.length}');
        _todayEvents.assignAll(events);
      },
    );
  }

  Future<void> _loadUpcomingEvents() async {
    final result = await getUpcomingEventsUseCase();

    result.fold(
      (failure) {
        logW('Failed to load upcoming events', failure.toString());
        _handleError(failure.toString());
      },
      (events) {
        logCalendar('Upcoming events loaded', 'Count: ${events.length}');
        _upcomingEvents.assignAll(events);
      },
    );
  }

  void _handleError(String error) {
    logE('Handling calendar error: $error');
    showErrorSnackbar(error);
  }

  // Helper method for logging calendar events
  void logCalendar(String message, [String? details]) {
    if (details != null) {
      logI('📅 Calendar: $message - $details');
    } else {
      logI('📅 Calendar: $message');
    }
  }

  @override
  void onClose() {
    logI('CalendarController disposed');
    super.onClose();
  }
}
