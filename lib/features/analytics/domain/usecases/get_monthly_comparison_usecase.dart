import 'package:dartz/dartz.dart';
import '../../../../shared/core/failure.dart';
import '../entities/spending_analytics.dart';
import '../repositories/analytics_repository.dart';

class GetMonthlyComparisonUseCase {
  final AnalyticsRepository repository;

  GetMonthlyComparisonUseCase(this.repository);

  Future<Either<Failure, List<MonthlySpending>>> call({
    required int year,
  }) {
    return repository.getMonthlyComparison(year: year);
  }
}
