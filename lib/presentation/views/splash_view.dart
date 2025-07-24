import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/constants/app_constants.dart';
import '../../core/constants/app_strings.dart';
import '../../core/themes/app_colors.dart';
import '../../core/utils/app_logger.dart';
import '../../shared/splash/splash_controller.dart';
import '../../shared/widgets/loading_widget.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    AppLogger.i('🎨 SplashView: Building splash screen...');

    // Ensure controller is instantiated and initialized
    final splashController = Get.find<SplashController>();
    AppLogger.i(
      '🎮 SplashView: Controller found: ${splashController.runtimeType}',
    );

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App Logo
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.blackWithOpacity10,
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.calendar_today,
                  color: AppColors.primary,
                  size: 60,
                ),
              ),

              const SizedBox(height: 32),

              // App Name
              Text(
                AppStrings.appName,
                style: Get.textTheme.headlineLarge?.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              // App Tagline
              Text(
                'Manage your calendar with ease',
                style: Get.textTheme.bodyLarge?.copyWith(
                  color: AppColors.whiteWithOpacity90,
                ),
              ),

              const SizedBox(height: 60),

              // Loading Indicator
              const LoadingWidget(
                message: 'Loading...',
                color: AppColors.white,
              ),

              const SizedBox(height: 40),

              // Version
              Text(
                'Version ${AppConstants.appVersion}',
                style: Get.textTheme.bodySmall?.copyWith(
                  color: AppColors.whiteWithOpacity70,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
