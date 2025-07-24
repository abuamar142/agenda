import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<UserModel?> getCachedUser();
  Future<void> cacheUser(UserModel user);
  Future<void> clearUserData();
  Future<String?> getAccessToken();
  Future<void> saveAccessToken(String token);
  Future<String?> getRefreshToken();
  Future<void> saveRefreshToken(String token);
  Future<void> clearTokens();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;
  final FlutterSecureStorage secureStorage;

  AuthLocalDataSourceImpl({
    required this.sharedPreferences,
    required this.secureStorage,
  });

  @override
  Future<UserModel?> getCachedUser() async {
    try {
      final userString = sharedPreferences.getString(AppConstants.userDataKey);
      if (userString == null) return null;

      final userJson = json.decode(userString) as Map<String, dynamic>;
      return UserModel.fromJson(userJson);
    } catch (e) {
      throw CacheException(e.toString());
    }
  }

  @override
  Future<void> cacheUser(UserModel user) async {
    try {
      final userString = json.encode(user.toJson());
      await sharedPreferences.setString(AppConstants.userDataKey, userString);
    } catch (e) {
      throw CacheException(e.toString());
    }
  }

  @override
  Future<void> clearUserData() async {
    try {
      await sharedPreferences.remove(AppConstants.userDataKey);
    } catch (e) {
      throw CacheException(e.toString());
    }
  }

  @override
  Future<String?> getAccessToken() async {
    try {
      return await secureStorage.read(key: AppConstants.userTokenKey);
    } catch (e) {
      throw CacheException(e.toString());
    }
  }

  @override
  Future<void> saveAccessToken(String token) async {
    try {
      await secureStorage.write(key: AppConstants.userTokenKey, value: token);
    } catch (e) {
      throw CacheException(e.toString());
    }
  }

  @override
  Future<String?> getRefreshToken() async {
    try {
      return await secureStorage.read(key: AppConstants.refreshTokenKey);
    } catch (e) {
      throw CacheException(e.toString());
    }
  }

  @override
  Future<void> saveRefreshToken(String token) async {
    try {
      await secureStorage.write(
        key: AppConstants.refreshTokenKey,
        value: token,
      );
    } catch (e) {
      throw CacheException(e.toString());
    }
  }

  @override
  Future<void> clearTokens() async {
    try {
      await secureStorage.delete(key: AppConstants.userTokenKey);
      await secureStorage.delete(key: AppConstants.refreshTokenKey);
    } catch (e) {
      throw CacheException(e.toString());
    }
  }
}
