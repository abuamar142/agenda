import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/calendar_event.dart';

abstract class CalendarRepository {
  /// Get events for a specific date range
  Future<Either<Failure, List<CalendarEvent>>> getEvents({
    DateTime? startDate,
    DateTime? endDate,
    String? calendarId,
  });

  /// Get today's events
  Future<Either<Failure, List<CalendarEvent>>> getTodayEvents();

  /// Get upcoming events (next 7 days)
  Future<Either<Failure, List<CalendarEvent>>> getUpcomingEvents();

  /// Get a specific event by ID
  Future<Either<Failure, CalendarEvent?>> getEvent(String eventId);

  /// Create a new event
  Future<Either<Failure, CalendarEvent>> createEvent(CalendarEvent event);

  /// Update an existing event
  Future<Either<Failure, CalendarEvent>> updateEvent(CalendarEvent event);

  /// Delete an event
  Future<Either<Failure, void>> deleteEvent(String eventId);

  /// Get available calendars
  Future<Either<Failure, List<String>>> getCalendars();
}
