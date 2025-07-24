import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/extensions/app_extensions.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';

class HomeController extends GetxController {
  final googleSignIn = GoogleSignIn(
    scopes: ['email', 'https://www.googleapis.com/auth/calendar'],
  );

  var isSignedIn = false.obs;
  GoogleSignInAccount? currentUser;

  Future<void> handleSignIn() async {
    try {
      currentUser = await googleSignIn.signIn();
      isSignedIn.value = currentUser != null;
    } catch (error) {
      showErrorSnackbar(error.toString());
    }
  }

  Future<void> handleSignOut() async {
    await googleSignIn.signOut();
    currentUser = null;
    isSignedIn.value = false;
  }

  /// Safe logout method that handles AuthController availability
  Future<void> performLogout() async {
    AppLogger.i('🔧 HomeController: Starting safe logout process');

    try {
      // Try to use AuthController if available
      if (Get.isRegistered<AuthController>()) {
        AppLogger.i('✅ AuthController found, using proper logout');
        final authController = Get.find<AuthController>();
        await authController.signOut();
      } else {
        // Fallback: direct logout without AuthController
        AppLogger.w('⚠️ AuthController not found, performing direct logout');
        await handleSignOut();
        showLogoutSuccessSnackbar();
        Get.offAllNamed(AppConstants.authRoute);
      }
    } catch (e) {
      AppLogger.e('❌ Error during logout', e);
      // Ultimate fallback: force navigation to auth
      showErrorSnackbar('Logout error occurred');
      Get.offAllNamed(AppConstants.authRoute);
    }
  }
}
