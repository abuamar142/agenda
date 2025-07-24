import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/calendar_event.dart';
import '../../domain/repositories/calendar_repository.dart';
import '../datasources/calendar_remote_data_source.dart';
import '../models/calendar_event_model.dart';

class CalendarRepositoryImpl implements CalendarRepository {
  final CalendarRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  CalendarRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<CalendarEvent>>> getEvents({
    DateTime? startDate,
    DateTime? endDate,
    String? calendarId,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final events = await remoteDataSource.getEvents(
          startDate: startDate,
          endDate: endDate,
          calendarId: calendarId,
        );
        return Right(events);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on AuthException catch (e) {
        return Left(AuthFailure(e.message));
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<CalendarEvent>>> getTodayEvents() async {
    if (await networkInfo.isConnected) {
      try {
        final events = await remoteDataSource.getTodayEvents();
        return Right(events);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on AuthException catch (e) {
        return Left(AuthFailure(e.message));
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<CalendarEvent>>> getUpcomingEvents() async {
    if (await networkInfo.isConnected) {
      try {
        final events = await remoteDataSource.getUpcomingEvents();
        return Right(events);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on AuthException catch (e) {
        return Left(AuthFailure(e.message));
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, CalendarEvent?>> getEvent(String eventId) async {
    if (await networkInfo.isConnected) {
      try {
        final event = await remoteDataSource.getEvent(eventId);
        return Right(event);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on AuthException catch (e) {
        return Left(AuthFailure(e.message));
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, CalendarEvent>> createEvent(
    CalendarEvent event,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final eventModel = CalendarEventModel(
          id: event.id,
          title: event.title,
          description: event.description,
          startTime: event.startTime,
          endTime: event.endTime,
          location: event.location,
          isAllDay: event.isAllDay,
          organizerEmail: event.organizerEmail,
          organizerName: event.organizerName,
          attendeeEmails: event.attendeeEmails,
          status: event.status,
          meetingLink: event.meetingLink,
          calendarId: event.calendarId,
        );

        final createdEvent = await remoteDataSource.createEvent(eventModel);
        return Right(createdEvent);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on AuthException catch (e) {
        return Left(AuthFailure(e.message));
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, CalendarEvent>> updateEvent(
    CalendarEvent event,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final eventModel = CalendarEventModel(
          id: event.id,
          title: event.title,
          description: event.description,
          startTime: event.startTime,
          endTime: event.endTime,
          location: event.location,
          isAllDay: event.isAllDay,
          organizerEmail: event.organizerEmail,
          organizerName: event.organizerName,
          attendeeEmails: event.attendeeEmails,
          status: event.status,
          meetingLink: event.meetingLink,
          calendarId: event.calendarId,
        );

        final updatedEvent = await remoteDataSource.updateEvent(eventModel);
        return Right(updatedEvent);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on AuthException catch (e) {
        return Left(AuthFailure(e.message));
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteEvent(String eventId) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.deleteEvent(eventId);
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on AuthException catch (e) {
        return Left(AuthFailure(e.message));
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getCalendars() async {
    if (await networkInfo.isConnected) {
      try {
        final calendars = await remoteDataSource.getCalendars();
        return Right(calendars);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on AuthException catch (e) {
        return Left(AuthFailure(e.message));
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }
}
