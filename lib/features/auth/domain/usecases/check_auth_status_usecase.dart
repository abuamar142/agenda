import 'package:dartz/dartz.dart';

import '../../../../../../core/error/failures.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class CheckAuthStatusUseCase {
  final AuthRepository repository;

  CheckAuthStatusUseCase(this.repository);

  Future<Either<Failure, bool>> call() async {
    return await repository.isSignedIn();
  }

  Stream<User?> get authStateChanges => repository.authStateChanges;
}
