import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/splash_controller.dart';
import '../widgets/loading_widget.dart';
import '../../core/themes/app_colors.dart';
import '../../core/constants/app_constants.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.primaryGradient,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App Logo
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
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
                AppConstants.appName,
                style: Get.textTheme.headlineLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              const SizedBox(height: 8),
              
              // App Tagline
              Text(
                'Manage your calendar with ease',
                style: Get.textTheme.bodyLarge?.copyWith(
                  color: Colors.white.withValues(alpha: 0.9),
                ),
              ),
              
              const SizedBox(height: 60),
              
              // Loading Indicator
              const LoadingWidget(
                color: Colors.white,
                size: 32,
              ),
              
              const SizedBox(height: 40),
              
              // Version
              Text(
                'Version ${AppConstants.appVersion}',
                style: Get.textTheme.bodySmall?.copyWith(
                  color: Colors.white.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
