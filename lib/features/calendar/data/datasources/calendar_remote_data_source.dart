import 'package:googleapis/calendar/v3.dart' as calendar;
import 'package:googleapis_auth/googleapis_auth.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/utils/app_logger.dart';
import '../models/calendar_event_model.dart';

abstract class CalendarRemoteDataSource {
  Future<List<CalendarEventModel>> getEvents({
    DateTime? startDate,
    DateTime? endDate,
    String? calendarId,
  });

  Future<List<CalendarEventModel>> getTodayEvents();
  Future<List<CalendarEventModel>> getUpcomingEvents();
  Future<CalendarEventModel?> getEvent(String eventId);
  Future<CalendarEventModel> createEvent(CalendarEventModel event);
  Future<CalendarEventModel> updateEvent(CalendarEventModel event);
  Future<void> deleteEvent(String eventId);
  Future<List<String>> getCalendars();
}

class CalendarRemoteDataSourceImpl implements CalendarRemoteDataSource {
  final SupabaseClient supabaseClient;
  calendar.CalendarApi? _calendarApi;

  CalendarRemoteDataSourceImpl({required this.supabaseClient});

  Future<calendar.CalendarApi> _getCalendarApi() async {
    if (_calendarApi != null) return _calendarApi!;

    AppLogger.i('Getting Google Calendar API access...');

    final session = supabaseClient.auth.currentSession;
    if (session == null) {
      AppLogger.e('Not authenticated with Supabase');
      throw const ServerException('Not authenticated with Supabase');
    }

    // Get provider token for Google
    final providerToken = session.providerToken;
    if (providerToken == null) {
      AppLogger.e('Google provider token not available in Supabase session');
      throw const ServerException(
        'Google provider token not available. Please re-login to grant Calendar access.',
      );
    }

    AppLogger.i('Found Google provider token, creating Calendar API client');

    try {
      // Ensure expiry date is in UTC
      final expiryDate = session.expiresAt != null
          ? DateTime.fromMillisecondsSinceEpoch(
              session.expiresAt! * 1000,
            ).toUtc()
          : DateTime.now().toUtc().add(const Duration(hours: 1));

      final credentials = AccessCredentials(
        AccessToken('Bearer', providerToken, expiryDate),
        null, // refresh token not needed for provider token
        [
          'https://www.googleapis.com/auth/calendar',
          'https://www.googleapis.com/auth/calendar.events',
          'https://www.googleapis.com/auth/calendar.readonly',
        ],
      );

      final client = authenticatedClient(http.Client(), credentials);

      _calendarApi = calendar.CalendarApi(client);
      AppLogger.i('Google Calendar API client created successfully');
      return _calendarApi!;
    } catch (e) {
      AppLogger.e('Failed to create Calendar API client: $e');
      throw ServerException(
        'Failed to setup Google Calendar access: ${e.toString()}',
      );
    }
  }

  @override
  Future<List<CalendarEventModel>> getEvents({
    DateTime? startDate,
    DateTime? endDate,
    String? calendarId,
  }) async {
    try {
      AppLogger.i('Fetching events from Google Calendar API...');
      final api = await _getCalendarApi();
      final calendarIdToUse = calendarId ?? 'primary';

      AppLogger.i('Making API call to events.list...');
      final events = await api.events.list(
        calendarIdToUse,
        timeMin: startDate,
        timeMax: endDate,
        singleEvents: true,
        orderBy: 'startTime',
        maxResults: 100,
      );

      final eventModels =
          events.items
              ?.map((event) => CalendarEventModel.fromGoogleEvent(event))
              .toList() ??
          [];

      AppLogger.i(
        'Successfully fetched ${eventModels.length} events from Google Calendar',
      );
      return eventModels;
    } catch (e) {
      AppLogger.e('Failed to fetch events from Google Calendar: $e');

      // Check if it's an access/scope error
      if (e.toString().contains('insufficient_scope') ||
          e.toString().contains('Access was denied')) {
        throw const ServerException(
          'Google Calendar access not granted. Please logout and login again to grant Calendar permissions.',
        );
      }

      throw ServerException('Failed to fetch events: ${e.toString()}');
    }
  }

  @override
  Future<List<CalendarEventModel>> getTodayEvents() async {
    AppLogger.i('Fetching today events...');
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return await getEvents(startDate: startOfDay, endDate: endOfDay);
  }

  @override
  Future<List<CalendarEventModel>> getUpcomingEvents() async {
    AppLogger.i('Fetching upcoming events...');
    final now = DateTime.now();
    final nextWeek = now.add(const Duration(days: 7));

    return await getEvents(startDate: now, endDate: nextWeek);
  }

  @override
  Future<CalendarEventModel?> getEvent(String eventId) async {
    try {
      final api = await _getCalendarApi();
      final event = await api.events.get('primary', eventId);

      return CalendarEventModel.fromGoogleEvent(event);
    } catch (e) {
      if (e.toString().contains('404')) {
        return null;
      }
      throw ServerException('Failed to fetch event: ${e.toString()}');
    }
  }

  @override
  Future<CalendarEventModel> createEvent(CalendarEventModel event) async {
    try {
      final api = await _getCalendarApi();
      final googleEvent = event.toGoogleEvent();

      final createdEvent = await api.events.insert(googleEvent, 'primary');
      return CalendarEventModel.fromGoogleEvent(createdEvent);
    } catch (e) {
      throw ServerException('Failed to create event: ${e.toString()}');
    }
  }

  @override
  Future<CalendarEventModel> updateEvent(CalendarEventModel event) async {
    try {
      final api = await _getCalendarApi();
      final googleEvent = event.toGoogleEvent();

      final updatedEvent = await api.events.update(
        googleEvent,
        'primary',
        event.id,
      );
      return CalendarEventModel.fromGoogleEvent(updatedEvent);
    } catch (e) {
      throw ServerException('Failed to update event: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteEvent(String eventId) async {
    try {
      final api = await _getCalendarApi();
      await api.events.delete('primary', eventId);
    } catch (e) {
      throw ServerException('Failed to delete event: ${e.toString()}');
    }
  }

  @override
  Future<List<String>> getCalendars() async {
    try {
      final api = await _getCalendarApi();
      final calendars = await api.calendarList.list();

      return calendars.items
              ?.map((calendar) => calendar.id ?? '')
              .where((id) => id.isNotEmpty)
              .toList() ??
          [];
    } catch (e) {
      throw ServerException('Failed to fetch calendars: ${e.toString()}');
    }
  }
}
