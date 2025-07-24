import 'package:dartz/dartz.dart';
import '../entities/calendar_event.dart';
import '../entities/event_template.dart';
import '../../core/error/failures.dart';

abstract class CalendarRepository {
  // Events
  Future<Either<Failure, List<CalendarEvent>>> getEvents({
    required DateTime startDate,
    required DateTime endDate,
  });

  Future<Either<Failure, CalendarEvent>> createEvent(CalendarEvent event);

  Future<Either<Failure, CalendarEvent>> updateEvent(CalendarEvent event);

  Future<Either<Failure, void>> deleteEvent(String eventId);

  Future<Either<Failure, CalendarEvent>> getEvent(String eventId);

  // Templates
  Future<Either<Failure, List<EventTemplate>>> getEventTemplates();

  Future<Either<Failure, EventTemplate>> createEventTemplate(
    EventTemplate template,
  );

  Future<Either<Failure, EventTemplate>> updateEventTemplate(
    EventTemplate template,
  );

  Future<Either<Failure, void>> deleteEventTemplate(String templateId);

  Future<Either<Failure, CalendarEvent>> createEventFromTemplate({
    required EventTemplate template,
    required DateTime startTime,
    DateTime? endTime,
  });
}
