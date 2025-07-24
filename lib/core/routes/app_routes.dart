import 'package:get/get.dart';

import '../../features/auth/presentation/bindings/auth_binding.dart';
import '../../features/auth/presentation/views/auth/auth_view.dart';
import '../../features/event_detail/presentation/bindings/event_detail_binding.dart';
import '../../features/event_detail/presentation/views/event_detail_view.dart';
import '../../features/home/presentation/bindings/home_binding.dart';
import '../../features/home/presentation/views/home_view.dart';
import '../../shared/splash/splash_binding.dart';
import '../../shared/splash/splash_view.dart';
import '../constants/app_constants.dart';

class AppRoutes {
  static const String initial = AppConstants.splashRoute;

  static final List<GetPage> routes = [
    GetPage(
      name: AppConstants.splashRoute,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppConstants.authRoute,
      page: () => const AuthView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppConstants.homeRoute,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppConstants.eventDetailRoute,
      page: () => const EventDetailView(),
      binding: EventDetailBinding(),
    ),
    // TODO: Add more routes here
    // GetPage(
    //   name: AppConstants.calendarRoute,
    //   page: () => const CalendarView(),
    //   binding: CalendarBinding(),
    // ),
  ];
}
