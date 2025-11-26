import 'package:dartz/dartz.dart';

import '../repositories/splash_repository.dart';
import '../../../../shared/core/failure.dart';
import '../entities/app_status.dart';

class CheckAuthStatusUseCase {
  final SplashRepository repository;

  CheckAuthStatusUseCase({required this.repository});

  Future<Either<Failure, AppStatus>> call() async {
    return await repository.checkAppStatus();
  }
}
