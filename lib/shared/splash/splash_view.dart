import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/constants/app_strings.dart';
import '../../core/themes/app_colors.dart';
import '../../core/themes/app_text_styles.dart';
import '../../core/utils/app_logger.dart';
import 'splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    AppLogger.i('🎨 SplashView: Building splash screen');

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Logo
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.blackWithOpacity10,
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: const Icon(
                Icons.calendar_today,
                size: 60,
                color: AppColors.primary,
              ),
            ),

            const SizedBox(height: 30),

            // App Name
            const Text(AppStrings.appName, style: AppTextStyles.appTitle),

            const SizedBox(height: 10),

            // Subtitle
            Text(
              AppStrings.appSubtitle,
              style: AppTextStyles.appSubtitleOnDark,
            ),

            const SizedBox(height: 50),

            // Loading Indicator
            Obx(
              () => controller.isLoading.value
                  ? const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.white,
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
