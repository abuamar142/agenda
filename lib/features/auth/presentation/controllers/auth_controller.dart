import 'package:get/get.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/extensions/app_extensions.dart';
import '../../../../core/utils/logger_mixin.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/check_auth_status_usecase.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../domain/usecases/login_with_google_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';

class AuthController extends GetxController with LoggerMixin {
  final LoginWithGoogleUseCase loginWithGoogleUseCase;
  final LogoutUseCase logoutUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final CheckAuthStatusUseCase checkAuthStatusUseCase;

  AuthController({
    required this.loginWithGoogleUseCase,
    required this.logoutUseCase,
    required this.getCurrentUserUseCase,
    required this.checkAuthStatusUseCase,
  }) {
    logI('Controller constructor called');
  }

  // Reactive variables
  final _currentUser = Rxn<User>();
  final _isLoading = false.obs;
  final _isSignedIn = false.obs;

  // Getters
  User? get currentUser => _currentUser.value;
  bool get isLoading => _isLoading.value;
  bool get isSignedIn => _isSignedIn.value;

  @override
  void onInit() {
    logI('Controller onInit called');
    super.onInit();
    _initAuth();
  }

  void _initAuth() async {
    await timed('Auth initialization', () async {
      _isLoading.value = true;

      try {
        logAuth('Checking auth status on controller init');
        final authResult = await checkAuthStatusUseCase();

        authResult.fold((failure) => _handleError(failure.toString()), (
          isSignedIn,
        ) {
          logAuth('Auth status checked', 'isSignedIn: $isSignedIn');
          _isSignedIn.value = isSignedIn;
          if (isSignedIn) {
            _getCurrentUser();
          }
        });
      } catch (e, stackTrace) {
        logE('Error during auth initialization', e, stackTrace);
        _handleError(e.toString());
      } finally {
        _isLoading.value = false;
      }
    });
  }

  Future<void> loginWithGoogle() async {
    await timed('Google login', () async {
      _isLoading.value = true;

      try {
        logAuth('Starting Google login');
        final result = await loginWithGoogleUseCase();

        result.fold(
          (failure) {
            logW('Google login failed', failure.toString());
            _handleError(failure.toString());
          },
          (user) {
            logAuth('Google login successful', 'User: ${user.email}');
            _currentUser.value = user;
            _isSignedIn.value = true;

            showLoginSuccessSnackbar(user.name);
            logNavigation(AppConstants.homeRoute);
            Get.offAllNamed(AppConstants.homeRoute);
          },
        );
      } catch (e, stackTrace) {
        logE('Exception during Google login', e, stackTrace);
        _handleError(e.toString());
      } finally {
        _isLoading.value = false;
      }
    });
  }

  Future<void> logout() async {
    await timed('Logout', () async {
      _isLoading.value = true;

      try {
        logAuth('Starting logout');
        final result = await logoutUseCase();

        result.fold(
          (failure) {
            logW('Logout failed', failure.toString());
            _handleError(failure.toString());
          },
          (_) {
            logAuth('Logout successful');
            _currentUser.value = null;
            _isSignedIn.value = false;

            showLogoutSuccessSnackbar();
            logNavigation(AppConstants.authRoute);
            Get.offAllNamed(AppConstants.authRoute);
          },
        );
      } catch (e, stackTrace) {
        logE('Exception during logout', e, stackTrace);
        _handleError(e.toString());
      } finally {
        _isLoading.value = false;
      }
    });
  }

  Future<void> _getCurrentUser() async {
    await timed('Get current user', () async {
      try {
        logAuth('Getting current user data');
        final result = await getCurrentUserUseCase();

        result.fold(
          (failure) {
            logW('Get current user failed', failure.toString());
            _handleError(failure.toString());
          },
          (user) {
            logAuth('Current user retrieved', 'User: ${user?.email ?? "null"}');
            _currentUser.value = user;
          },
        );
      } catch (e, stackTrace) {
        logE('Exception getting current user', e, stackTrace);
        _handleError(e.toString());
      }
    });
  }

  // Alias methods for different naming conventions
  Future<void> signInWithGoogle() => loginWithGoogle();
  Future<void> signOut() => logout();

  void _handleError(String error) {
    logE('Handling error: $error');
    showErrorSnackbar(error);
  }
}
