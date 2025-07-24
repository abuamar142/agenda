import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/network/network_info.dart';
import '../../data/datasources/calendar_remote_data_source.dart';
import '../../data/repositories/calendar_repository_impl.dart';
import '../../domain/repositories/calendar_repository.dart';
import '../../domain/usecases/get_today_events_usecase.dart';
import '../../domain/usecases/get_upcoming_events_usecase.dart';
import '../controllers/calendar_controller.dart';

class CalendarBinding extends Bindings {
  @override
  void dependencies() {
    // Data Source
    Get.lazyPut<CalendarRemoteDataSource>(
      () => CalendarRemoteDataSourceImpl(
        supabaseClient: Supabase.instance.client,
      ),
    );

    // Repository
    Get.lazyPut<CalendarRepository>(
      () => CalendarRepositoryImpl(
        remoteDataSource: Get.find<CalendarRemoteDataSource>(),
        networkInfo: Get.find<NetworkInfo>(),
      ),
    );

    // Use Cases
    Get.lazyPut(() => GetTodayEventsUseCase(Get.find<CalendarRepository>()));
    Get.lazyPut(() => GetUpcomingEventsUseCase(Get.find<CalendarRepository>()));

    // Controller
    Get.lazyPut<CalendarController>(
      () => CalendarController(
        getTodayEventsUseCase: Get.find<GetTodayEventsUseCase>(),
        getUpcomingEventsUseCase: Get.find<GetUpcomingEventsUseCase>(),
      ),
    );
  }
}
