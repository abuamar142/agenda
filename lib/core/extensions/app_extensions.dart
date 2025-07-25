import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/app_strings.dart';
import '../themes/app_colors.dart';

// Extension untuk BuildContext
extension ContextExtensions on BuildContext {
  // Screen size helpers
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;

  // Theme helpers
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => theme.textTheme;
  ColorScheme get colorScheme => theme.colorScheme;

  // Safe area helpers
  EdgeInsets get padding => MediaQuery.of(this).padding;
  EdgeInsets get viewInsets => MediaQuery.of(this).viewInsets;
}

// Extension untuk GetxController dan Widget yang menggunakan GetX Snackbar
extension GetXSnackbarExtensions on Object {
  // Success snackbar
  void showSuccessSnackbar(
    String message, {
    String? title,
    Duration duration = const Duration(seconds: 3),
    SnackPosition position = SnackPosition.BOTTOM,
  }) {
    Get.snackbar(
      title ?? 'Success',
      message,
      snackPosition: position,
      duration: duration,
      backgroundColor: AppColors.success,
      colorText: AppColors.white,
      icon: const Icon(
        Icons.check_circle_outline,
        color: AppColors.white,
        size: 28,
      ),
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      forwardAnimationCurve: Curves.easeOutBack,
      reverseAnimationCurve: Curves.easeInBack,
    );
  }

  // Error snackbar
  void showErrorSnackbar(
    String message, {
    String? title,
    Duration duration = const Duration(seconds: 4),
    SnackPosition position = SnackPosition.BOTTOM,
  }) {
    Get.snackbar(
      title ?? 'Error',
      message,
      snackPosition: position,
      duration: duration,
      backgroundColor: AppColors.error,
      colorText: AppColors.white,
      icon: const Icon(Icons.error_outline, color: AppColors.white, size: 28),
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      forwardAnimationCurve: Curves.easeOutBack,
      reverseAnimationCurve: Curves.easeInBack,
    );
  }

  // Warning snackbar
  void showWarningSnackbar(
    String message, {
    String? title,
    IconData? icon,
    Duration duration = const Duration(seconds: 3),
    SnackPosition position = SnackPosition.BOTTOM,
  }) {
    Get.snackbar(
      title ?? 'Warning',
      message,
      snackPosition: position,
      duration: duration,
      backgroundColor: AppColors.warning,
      colorText: AppColors.white,
      icon: Icon(
        icon ?? Icons.warning_outlined,
        color: AppColors.white,
        size: 28,
      ),
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      forwardAnimationCurve: Curves.easeOutBack,
      reverseAnimationCurve: Curves.easeInBack,
    );
  }

  // Info snackbar
  void showInfoSnackbar(
    String message, {
    String? title,
    Duration duration = const Duration(seconds: 3),
    SnackPosition position = SnackPosition.BOTTOM,
  }) {
    Get.snackbar(
      title ?? 'Info',
      message,
      snackPosition: position,
      duration: duration,
      backgroundColor: AppColors.info,
      colorText: AppColors.white,
      icon: const Icon(Icons.info_outline, color: AppColors.white, size: 28),
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      forwardAnimationCurve: Curves.easeOutBack,
      reverseAnimationCurve: Curves.easeInBack,
    );
  }

  // Loading snackbar
  void showLoadingSnackbar(
    String message, {
    String? title,
    Duration duration = const Duration(seconds: 2),
    SnackPosition position = SnackPosition.BOTTOM,
  }) {
    Get.snackbar(
      title ?? 'Loading',
      message,
      snackPosition: position,
      duration: duration,
      backgroundColor: AppColors.primary,
      colorText: AppColors.white,
      icon: const SizedBox(
        width: 28,
        height: 28,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
        ),
      ),
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
      isDismissible: false,
      showProgressIndicator: false,
      forwardAnimationCurve: Curves.easeOutBack,
      reverseAnimationCurve: Curves.easeInBack,
    );
  }

  // Custom snackbar
  void showCustomSnackbar(
    String message, {
    String? title,
    Duration duration = const Duration(seconds: 3),
    SnackPosition position = SnackPosition.BOTTOM,
    Color? backgroundColor,
    Color? textColor,
    Widget? icon,
    VoidCallback? onTap,
    String? actionLabel,
    VoidCallback? onActionPressed,
  }) {
    Get.snackbar(
      title ?? 'Notification',
      message,
      snackPosition: position,
      duration: duration,
      backgroundColor: backgroundColor ?? AppColors.primary,
      colorText: textColor ?? AppColors.white,
      icon: icon,
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      onTap: onTap != null ? (_) => onTap() : null,
      mainButton: actionLabel != null && onActionPressed != null
          ? TextButton(
              onPressed: onActionPressed,
              child: Text(
                actionLabel,
                style: TextStyle(color: textColor ?? AppColors.white),
              ),
            )
          : null,
      forwardAnimationCurve: Curves.easeOutBack,
      reverseAnimationCurve: Curves.easeInBack,
    );
  }

  // Quick action snackbars
  void showComingSoonSnackbar([String? feature]) {
    showInfoSnackbar(
      feature != null
          ? '$feature ${AppStrings.featureComingSoon}'
          : AppStrings.featureComingSoon,
      title: AppStrings.comingSoon,
    );
  }

  void showNetworkErrorSnackbar() {
    showErrorSnackbar(
      AppStrings.checkConnection,
      title: AppStrings.noInternetConnection,
      duration: const Duration(seconds: 5),
    );
  }

  void showLoginSuccessSnackbar([String? userName]) {
    showSuccessSnackbar(
      userName != null
          ? 'Welcome back, $userName!'
          : 'You have been logged in successfully!',
      title: 'Login Successful',
    );
  }

  void showLogoutSuccessSnackbar() {
    showSuccessSnackbar(
      'You have been logged out successfully.',
      title: 'Logout Successful',
    );
  }

  void showBrowserLoginInfoSnackbar() {
    showInfoSnackbar(
      'A browser will open for Google authentication. Please complete the login and return to the app.',
      title: 'Opening Browser',
      duration: const Duration(seconds: 5),
    );
  }

  void showValidationErrorSnackbar(String field) {
    showWarningSnackbar(
      'Please check the $field field and try again.',
      title: 'Validation Error',
    );
  }

  // Async operation with loading snackbar
  Future<T> showLoadingOperation<T>(
    String message,
    Future<T> Function() operation, {
    String? loadingTitle,
    String? successMessage,
    String? successTitle,
  }) async {
    // Show loading snackbar
    showLoadingSnackbar(message, title: loadingTitle);

    try {
      final result = await operation();

      // Hide loading snackbar by showing success
      if (successMessage != null) {
        showSuccessSnackbar(successMessage, title: successTitle);
      }

      return result;
    } catch (error) {
      // Show error snackbar
      showErrorSnackbar(error.toString());
      rethrow;
    }
  }
}
