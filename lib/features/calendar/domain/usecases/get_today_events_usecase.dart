import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/calendar_event.dart';
import '../repositories/calendar_repository.dart';

class GetTodayEventsUseCase {
  final CalendarRepository repository;

  GetTodayEventsUseCase(this.repository);

  Future<Either<Failure, List<CalendarEvent>>> call() async {
    return await repository.getTodayEvents();
  }
}
