import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/error/exceptions.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> signInWithGoogle();
  Future<void> signOut();
  Future<UserModel?> getCurrentUser();
  Future<bool> isSignedIn();
  Stream<UserModel?> get authStateChanges;
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;

  AuthRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<UserModel> signInWithGoogle() async {
    try {
      // Launch OAuth flow in external browser and wait for callback
      final response = await supabaseClient.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: 'com.abuamar.agenda.agenda://auth/callback',
        authScreenLaunchMode: LaunchMode.externalApplication,
      );

      if (!response) {
        throw const ServerException('OAuth flow was cancelled or failed');
      }

      // Wait for auth state change with timeout
      await _waitForAuthStateChange();

      if (supabaseClient.auth.currentUser == null) {
        throw const ServerException('Authentication failed - no user found');
      }

      return UserModel.fromSupabaseUser(supabaseClient.auth.currentUser!);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Google Sign-In failed: ${e.toString()}');
    }
  }

  /// Wait for auth state change with timeout
  Future<void> _waitForAuthStateChange() async {
    const timeout = Duration(seconds: 30);
    const checkInterval = Duration(milliseconds: 500);

    final stopwatch = Stopwatch()..start();

    while (stopwatch.elapsed < timeout) {
      if (supabaseClient.auth.currentUser != null) {
        return;
      }

      await Future.delayed(checkInterval);
    }

    throw const ServerException('Authentication timeout - please try again');
  }

  @override
  Future<void> signOut() async {
    try {
      await supabaseClient.auth.signOut();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final user = supabaseClient.auth.currentUser;
      if (user == null) return null;

      return UserModel.fromSupabaseUser(user);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<bool> isSignedIn() async {
    try {
      return supabaseClient.auth.currentUser != null;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Stream<UserModel?> get authStateChanges {
    return supabaseClient.auth.onAuthStateChange.map((data) {
      final user = data.session?.user;
      if (user == null) return null;
      return UserModel.fromSupabaseUser(user);
    });
  }
}
