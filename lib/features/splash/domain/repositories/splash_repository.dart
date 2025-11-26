import 'package:dartz/dartz.dart';

import '../entities/app_status.dart';
import '../../../../shared/core/failure.dart';

abstract class SplashRepository {
  Future<Either<Failure, AppStatus>> checkAppStatus();
}
