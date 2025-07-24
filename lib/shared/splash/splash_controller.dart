import 'package:get/get.dart';

import '../../core/constants/app_constants.dart';
import '../../core/error/failures.dart';
import '../../core/utils/logger_mixin.dart';
import '../../features/auth/domain/usecases/check_auth_status_usecase.dart';

class SplashController extends GetxController with LoggerMixin {
  final CheckAuthStatusUseCase checkAuthStatusUseCase;

  SplashController({required this.checkAuthStatusUseCase});

  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    logI('SplashController initialized');
    _initializeApp();
  }

  void _initializeApp() async {
    logAuth('SplashController', 'Starting app initialization');

    try {
      // Add a small delay for splash screen visibility
      await Future.delayed(const Duration(seconds: 2));

      logAuth('SplashController', 'Checking authentication status');
      final result = await checkAuthStatusUseCase();

      result.fold(
        (failure) {
          logW('Auth check failed: ${_getFailureMessage(failure)}');
          logNavigation(AppConstants.authRoute);
          Get.offAllNamed(AppConstants.authRoute);
        },
        (isSignedIn) {
          logAuth('Auth check completed', 'isSignedIn: $isSignedIn');

          if (isSignedIn) {
            logNavigation(AppConstants.homeRoute);
            Get.offAllNamed(AppConstants.homeRoute);
          } else {
            logNavigation(AppConstants.authRoute);
            Get.offAllNamed(AppConstants.authRoute);
          }
        },
      );
    } catch (e) {
      logE('SplashController initialization error: $e');
      logNavigation(AppConstants.authRoute);
      Get.offAllNamed(AppConstants.authRoute);
    } finally {
      isLoading.value = false;
    }
  }

  String _getFailureMessage(Failure failure) {
    if (failure is ServerFailure) {
      return 'Server error occurred';
    } else if (failure is NetworkFailure) {
      return 'Network connection failed';
    } else if (failure is AuthFailure) {
      return 'Authentication failed';
    } else {
      return 'Unknown error occurred';
    }
  }

  @override
  void onClose() {
    logI('SplashController disposed');
    super.onClose();
  }
}
