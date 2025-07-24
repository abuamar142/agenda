import 'package:get/get.dart';
import 'package:agenda/presentation/views/splash_view.dart';
import 'package:agenda/presentation/views/home_view.dart';
import 'package:agenda/presentation/views/auth/auth_view.dart';
import 'package:agenda/presentation/bindings/splash_binding.dart';
import 'package:agenda/presentation/bindings/home_binding.dart';
import 'package:agenda/presentation/bindings/auth_binding.dart';
import 'package:agenda/core/constants/app_constants.dart';

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
    // TODO: Add more routes here
    // GetPage(
    //   name: AppConstants.calendarRoute,
    //   page: () => const CalendarView(),
    //   binding: CalendarBinding(),
    // ),
  ];
}
