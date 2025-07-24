import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/themes/app_colors.dart';
import '../../../../../core/utils/app_logger.dart';
import '../../../../../shared/widgets/custom_elevated_button.dart';
import '../../../../../shared/widgets/loading_widget.dart';
import '../../controllers/auth_controller.dart';

class AuthView extends GetView<AuthController> {
  const AuthView({super.key});

  @override
  Widget build(BuildContext context) {
    AppLogger.i('🔐 AuthView: Building auth screen...');

    // Ensure controller is instantiated
    final authController = Get.find<AuthController>();
    AppLogger.i('🔐 AuthView: Controller found: ${authController.runtimeType}');

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App Logo/Title
              _buildHeader(),

              const SizedBox(height: 60),

              // Sign in content
              _buildSignInContent(),

              const SizedBox(height: 40),

              // Footer
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        // App Icon
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: const Icon(
            Icons.calendar_today,
            color: Colors.white,
            size: 50,
          ),
        ),

        const SizedBox(height: 24),

        // App Title
        Text(
          'Agenda',
          style: Get.textTheme.headlineLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 8),

        // App Subtitle
        Text(
          'Manage your Google Calendar events with ease',
          textAlign: TextAlign.center,
          style: Get.textTheme.bodyLarge,
        ),
      ],
    );
  }

  Widget _buildSignInContent() {
    return Column(
      children: [
        // Welcome Message
        Text(
          'Welcome Back!',
          style: Get.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 8),

        Text(
          'Sign in to access your calendar and manage events',
          textAlign: TextAlign.center,
          style: Get.textTheme.bodyMedium?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),

        const SizedBox(height: 32),

        // Google Sign In Button
        Obx(
          () => controller.isLoading
              ? const LoadingWidget(
                  message: 'Opening browser for authentication...',
                )
              : _buildGoogleSignInButton(),
        ),
      ],
    );
  }

  Widget _buildGoogleSignInButton() {
    return CustomElevatedButton(
      text: 'Continue with Google',
      onPressed: controller.signInWithGoogle,
      icon: Icons.account_circle,
      backgroundColor: Colors.white,
      textColor: AppColors.textPrimary,
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        Text(
          'By signing in, you agree to our Terms of Service\nand Privacy Policy',
          textAlign: TextAlign.center,
          style: Get.textTheme.bodySmall?.copyWith(color: AppColors.textHint),
        ),

        const SizedBox(height: 16),

        // Version Info
        Text(
          'Version 1.0.0',
          style: Get.textTheme.bodySmall?.copyWith(color: AppColors.textHint),
        ),
      ],
    );
  }
}
