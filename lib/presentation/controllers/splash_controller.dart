import 'package:get/get.dart';
import '../../domain/usecases/check_auth_status_usecase.dart';
import '../../core/constants/app_constants.dart';

class SplashController extends GetxController {
  final CheckAuthStatusUseCase checkAuthStatusUseCase;

  SplashController({required this.checkAuthStatusUseCase});

  @override
  void onReady() {
    super.onReady();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Wait for splash screen duration
    await Future.delayed(const Duration(seconds: 2));

    try {
      // Check authentication status
      final result = await checkAuthStatusUseCase();
      
      result.fold(
        (failure) {
          // If check fails, go to auth
          Get.offAllNamed(AppConstants.authRoute);
        },
        (isSignedIn) {
          if (isSignedIn) {
            // User is signed in, go to home
            Get.offAllNamed(AppConstants.homeRoute);
          } else {
            // User is not signed in, go to auth
            Get.offAllNamed(AppConstants.authRoute);
          }
        },
      );
    } catch (e) {
      // If any error occurs, go to auth
      Get.offAllNamed(AppConstants.authRoute);
    }
  }
}
