import 'package:dartz/dartz.dart';
import '../../../../shared/core/failure.dart';
import '../entities/analytics_data.dart';
import '../repositories/home_repository.dart';

class GetAnalyticsUseCase {
  final HomeRepository repository;

  GetAnalyticsUseCase(this.repository);

  Future<Either<Failure, AnalyticsData>> call({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    return await repository.getAnalytics(
      startDate: startDate,
      endDate: endDate,
    );
  }
}
