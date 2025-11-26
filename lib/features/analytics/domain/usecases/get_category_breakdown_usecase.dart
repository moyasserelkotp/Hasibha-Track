import 'package:dartz/dartz.dart';
import '../../../../shared/core/failure.dart';
import '../entities/spending_analytics.dart';
import '../repositories/analytics_repository.dart';

class GetCategoryBreakdownUseCase {
  final AnalyticsRepository repository;

  GetCategoryBreakdownUseCase(this.repository);

  Future<Either<Failure, List<CategorySpending>>> call({
    required DateTime startDate,
    required DateTime endDate,
  }) {
    return repository.getCategoryBreakdown(
      startDate: startDate,
      endDate: endDate,
    );
  }
}
