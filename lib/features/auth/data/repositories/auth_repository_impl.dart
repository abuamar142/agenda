import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, User>> signInWithGoogle() async {
    if (await networkInfo.isConnected) {
      try {
        final userModel = await remoteDataSource.signInWithGoogle();
        // No caching - always require fresh login
        return Right(userModel);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on AuthException catch (e) {
        return Left(AuthFailure(e.message));
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      if (await networkInfo.isConnected) {
        await remoteDataSource.signOut();
      }
      await localDataSource.clearUserData();
      await localDataSource.clearTokens();
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    try {
      // Only get from remote - no cache fallback to force fresh login
      if (await networkInfo.isConnected) {
        final remoteUser = await remoteDataSource.getCurrentUser();
        return Right(remoteUser);
      } else {
        return const Left(NetworkFailure('No internet connection'));
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> isSignedIn() async {
    try {
      // Only check remote session - no cache fallback
      if (await networkInfo.isConnected) {
        final isRemoteSignedIn = await remoteDataSource.isSignedIn();
        return Right(isRemoteSignedIn);
      } else {
        // If no internet, assume not signed in to force login when connection returns
        return const Right(false);
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Stream<User?> get authStateChanges {
    return remoteDataSource.authStateChanges.map((userModel) {
      // Only clear data on logout, don't cache on login
      if (userModel == null) {
        localDataSource.clearUserData();
        localDataSource.clearTokens();
      }
      return userModel;
    });
  }
}
