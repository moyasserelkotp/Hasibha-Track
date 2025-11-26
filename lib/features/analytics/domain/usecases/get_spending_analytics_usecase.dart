import 'package:dartz/dartz.dart';
import '../../../../shared/core/failure.dart';
import '../entities/spending_analytics.dart';
import '../repositories/analytics_repository.dart';

class GetSpendingAnalyticsUseCase {
  final AnalyticsRepository repository;

  GetSpendingAnalyticsUseCase(this.repository);

  Future<Either<Failure, SpendingAnalytics>> call({
    required DateTime startDate,
    required DateTime endDate,
  }) {
    return repository.getSpendingAnalytics(
      startDate: startDate,
      endDate: endDate,
    );
  }
}
