import 'package:dartz/dartz.dart';
import '../../../../shared/cache/cache_manager.dart';
import '../../../../shared/core/failure.dart';
import '../../../../shared/models/pagination.dart';
import '../../../../shared/services/logger_service.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/local/home_local_data_source.dart';
import '../models/transaction_model.dart';

/// Repository implementation with caching
class HomeRepositoryWithCache {
  final HomeLocalDataSource localDataSource;
  final CacheManager cacheManager;
  final Logger logger;

  HomeRepositoryWithCache({
    required this.localDataSource,
    required this.cacheManager,
    required this.logger,
  });

  /// Get paginated transactions
  Future<Either<Failure, PaginatedData<Transaction>>> getTransactionsPaginated({
    required int page,
    int pageSize = 20,
  }) async {
    try {
      logger.info('Fetching transactions page $page');

      // Try cache first
      final cacheKey = 'transactions_page_$page';
      final cached = await cacheManager.get<PaginatedData<Transaction>>(
        key: cacheKey,
        fromJson: (json) => _paginatedTransactionFromJson(json),
      );

      if (cached != null) {
        logger.debug('Returning cached transactions for page $page');
        return Right(cached);
      }

      // Fetch from local storage
      final allTransactions = await localDataSource.getTransactions();

      // Create paginated data
      final paginatedData = PaginatedData.fromList(
        allItems: allTransactions,
        page: page,
        pageSize: pageSize,
      );

      // Cache the result
      await cacheManager.put(
        key: cacheKey,
        value: paginatedData,
        toJson: (data) => _paginatedTransactionToJson(data),
        memoryTtl: const Duration(minutes: 5),
        diskTtl: const Duration(hours: 1),
      );

      logger.info('Fetched ${paginatedData.items.length} transactions for page $page');
      return Right(paginatedData);
    } catch (e, stackTrace) {
      logger.error('Failed to fetch transactions', error: e, stackTrace: stackTrace);
      return Left(CacheFailure(message: e.toString()));
    }
  }

  // Helper methods for JSON serialization
  PaginatedData<Transaction> _paginatedTransactionFromJson(Map<String, dynamic> json) {
    final items = (json['items'] as List)
        .map((e) => TransactionModel.fromJson(e))
        .toList();

    return PaginatedData(
      items: items,
      currentPage: json['currentPage'],
      totalPages: json['totalPages'],
      totalItems: json['totalItems'],
      pageSize: json['pageSize'],
    );
  }

  Map<String, dynamic> _paginatedTransactionToJson(PaginatedData<Transaction> data) {
    return {
      'items': data.items.map((e) {
        if (e is TransactionModel) {
          return e.toJson();
        }
        return TransactionModel.fromEntity(e).toJson();
      }).toList(),
      'currentPage': data.currentPage,
      'totalPages': data.totalPages,
      'totalItems': data.totalItems,
      'pageSize': data.pageSize,
    };
  }

  /// Invalidate cache
  Future<void> invalidateCache() async {
    logger.info('Invalidating transactions cache');
    await cacheManager.clear();
  }
}
