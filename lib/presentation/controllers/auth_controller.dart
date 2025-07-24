import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/login_with_google_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../domain/usecases/check_auth_status_usecase.dart';
import '../../core/constants/app_constants.dart';

class AuthController extends GetxController {
  final LoginWithGoogleUseCase loginWithGoogleUseCase;
  final LogoutUseCase logoutUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final CheckAuthStatusUseCase checkAuthStatusUseCase;

  AuthController({
    required this.loginWithGoogleUseCase,
    required this.logoutUseCase,
    required this.getCurrentUserUseCase,
    required this.checkAuthStatusUseCase,
  });

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
    super.onInit();
    _initAuth();
    _listenToAuthStateChanges();
  }

  void _initAuth() async {
    _isLoading.value = true;
    
    try {
      // Check if user is already signed in
      final authResult = await checkAuthStatusUseCase();
      authResult.fold(
        (failure) => _handleError(failure.toString()),
        (isSignedIn) {
          _isSignedIn.value = isSignedIn;
          if (isSignedIn) {
            _getCurrentUser();
          }
        },
      );
    } catch (e) {
      _handleError(e.toString());
    } finally {
      _isLoading.value = false;
    }
  }

  void _listenToAuthStateChanges() {
    checkAuthStatusUseCase.authStateChanges.listen((user) {
      _currentUser.value = user;
      _isSignedIn.value = user != null;
      
      if (user != null) {
        // User signed in, navigate to home
        Get.offAllNamed(AppConstants.homeRoute);
      } else {
        // User signed out, navigate to auth
        Get.offAllNamed(AppConstants.authRoute);
      }
    });
  }

  Future<void> _getCurrentUser() async {
    try {
      final result = await getCurrentUserUseCase();
      result.fold(
        (failure) => _handleError(failure.toString()),
        (user) => _currentUser.value = user,
      );
    } catch (e) {
      _handleError(e.toString());
    }
  }

  Future<void> signInWithGoogle() async {
    if (_isLoading.value) return;
    
    _isLoading.value = true;
    
    try {
      final result = await loginWithGoogleUseCase();
      result.fold(
        (failure) => _handleError(failure.toString()),
        (user) {
          _currentUser.value = user;
          _isSignedIn.value = true;
          _showSuccessMessage(AppConstants.loginSuccessMessage);
          Get.offAllNamed(AppConstants.homeRoute);
        },
      );
    } catch (e) {
      _handleError(e.toString());
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    if (_isLoading.value) return;
    
    _isLoading.value = true;
    
    try {
      final result = await logoutUseCase();
      result.fold(
        (failure) => _handleError(failure.toString()),
        (_) {
          _currentUser.value = null;
          _isSignedIn.value = false;
          _showSuccessMessage(AppConstants.logoutSuccessMessage);
          Get.offAllNamed(AppConstants.authRoute);
        },
      );
    } catch (e) {
      _handleError(e.toString());
    } finally {
      _isLoading.value = false;
    }
  }

  void _handleError(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.shade100,
      colorText: Colors.red.shade800,
      duration: const Duration(seconds: 3),
    );
  }

  void _showSuccessMessage(String message) {
    Get.snackbar(
      'Success',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.shade100,
      colorText: Colors.green.shade800,
      duration: const Duration(seconds: 2),
    );
  }
}
