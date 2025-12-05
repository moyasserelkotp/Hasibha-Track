import 'package:dartz/dartz.dart';
import '../../../../shared/core/failure.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

/// Use case for getting current authenticated user
class GetCurrentUserUseCase {
  final AuthRepository repository;

  GetCurrentUserUseCase({required this.repository});

  Future<Either<Failure, User?>> call() async {
    return await repository.getCurrentUser();
  }
}
