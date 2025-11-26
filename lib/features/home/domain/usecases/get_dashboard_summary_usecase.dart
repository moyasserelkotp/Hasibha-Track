import 'package:dartz/dartz.dart';

import '../../../../shared/core/failure.dart';
import '../entities/dashboard_summary.dart';
import '../repositories/home_repository.dart';


class GetDashboardSummaryUseCase {
  final HomeRepository repository;

  GetDashboardSummaryUseCase({required this.repository});

  Future<Either<Failure, DashboardSummary>> call() async {
    return await repository.getDashboardSummary();
  }
}
