import 'package:dartz/dartz.dart';
import '../../domain/entities/expense.dart';
import '../../domain/entities/expense_category.dart';
import '../../domain/repositories/expense_repository.dart';
import '../../../../shared/core/failure.dart';
import '../../../../shared/core/error/exceptions.dart';
import '../datasources/remote/expense_remote_datasource.dart';
import '../datasources/local/expense_local_datasource.dart';
import '../models/expense_model.dart';
import '../dtos/expense_dto.dart';
import '../../../../shared/services/ocr_service.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  final ExpenseRemoteDataSource remoteDataSource;
  final ExpenseLocalDataSource localDataSource;
  final OcrService ocrService;

  ExpenseRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.ocrService,
  });

  @override
  Future<Either<Failure, List<Expense>>> getExpenses({
    DateTime? startDate,
    DateTime? endDate,
    String? categoryId,
    List<String>? tags,
    int? limit,
    int? offset,
  }) async {
    try {
      // Try to fetch from API
      final expenses = await remoteDataSource.getExpenses(
        startDate: startDate,
        endDate: endDate,
        categoryId: categoryId,
        tags: tags,
        limit: limit,
        offset: offset,
      );

      // Cache the results
      await localDataSource.cacheExpenses(expenses);

      return Right(expenses.map((model) => model.toEntity()).toList());
    } on NetworkException catch (_) {
      // Network error - try cache
      try {
        final cachedExpenses = await localDataSource.getCachedExpenses();
        if (cachedExpenses.isNotEmpty) {
          return Right(cachedExpenses.map((model) => model.toEntity()).toList());
        }
      } catch (_) {}
      return const Left(NetworkFailure());
    } on TimeoutException catch (_) {
      // Timeout - try cache
      try {
        final cachedExpenses = await localDataSource.getCachedExpenses();
        if (cachedExpenses.isNotEmpty) {
          return Right(cachedExpenses.map((model) => model.toEntity()).toList());
        }
      } catch (_) {}
      return const Left(TimeoutFailure());
    } on ServerException catch (e) {
      // API error - try cache
      try {
        final cachedExpenses = await localDataSource.getCachedExpenses();
        if (cachedExpenses.isNotEmpty) {
          return Right(cachedExpenses.map((model) => model.toEntity()).toList());
        }
      } catch (_) {}
      
      return Left(ServerFailure(message: e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Expense>> getExpenseById(String id) async {
    try {
      final expense = await remoteDataSource.getExpenseById(id);
      await localDataSource.cacheExpense(expense);
      return Right(expense.toEntity());
    } on ServerException catch (e) {
      // Try cache
      final cachedExpense = await localDataSource.getCachedExpense(id);
      if (cachedExpense != null) {
        return Right(cachedExpense.toEntity());
      }
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Expense>> createExpense(Expense expense) async {
    try {
      final dto = ExpenseDto(
        amount: expense.amount,
        categoryId: expense.categoryId,
        date: expense.date.toIso8601String(),
        description: expense.description,
        note: expense.note,
        tags: expense.tags,
        attachmentUrl: expense.attachmentUrl,
        receiptImagePath: expense.receiptImagePath,
        merchant: expense.merchant,
        isRecurring: expense.isRecurring,
        recurringPeriod: expense.recurringPeriod,
      );

      final createdExpense = await remoteDataSource.createExpense(dto);
      await localDataSource.cacheExpense(createdExpense);
      return Right(createdExpense.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Expense>> updateExpense(Expense expense) async {
    try {
      final dto = ExpenseDto(
        amount: expense.amount,
        categoryId: expense.categoryId,
        date: expense.date.toIso8601String(),
        description: expense.description,
        note: expense.note,
        tags: expense.tags,
        attachmentUrl: expense.attachmentUrl,
        receiptImagePath: expense.receiptImagePath,
        merchant: expense.merchant,
        isRecurring: expense.isRecurring,
        recurringPeriod: expense.recurringPeriod,
      );

      final updatedExpense = await remoteDataSource.updateExpense(expense.id, dto);
      await localDataSource.cacheExpense(updatedExpense);
      return Right(updatedExpense.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteExpense(String id) async {
    try {
      await remoteDataSource.deleteExpense(id);
      await localDataSource.deleteExpenseFromCache(id);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ExpenseCategory>>> getCategories() async {
    try {
      final categories = await remoteDataSource.getCategories();
      await localDataSource.cacheCategories(categories);
      return Right(categories.map((model) => model.toEntity()).toList());
    } on ServerException catch (e) {
      // Try cache
      try {
        final cachedCategories = await localDataSource.getCachedCategories();
        if (cachedCategories.isNotEmpty) {
          return Right(cachedCategories.map((model) => model.toEntity()).toList());
        }
      } catch (_) {}
      
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ExpenseCategory>> createCategory(
      ExpenseCategory category) async {
    try {
      final categoryData = {
        'name': category.name,
        'icon_name': category.iconName,
        'color_hex': category.colorHex,
        'type': category.type,
        'budget_limit': category.budgetLimit,
      };

      final createdCategory = await remoteDataSource.createCategory(categoryData);
      return Right(createdCategory.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ExpenseCategory>> updateCategory(
      ExpenseCategory category) async {
    // TODO: Implement when backend supports category updates
    return Left(ServerFailure(message: 'Not implemented'));
  }

  @override
  Future<Either<Failure, void>> deleteCategory(String id) async {
    // TODO: Implement when backend supports category deletion
    return Left(ServerFailure(message: 'Not implemented'));
  }

  @override
  Future<Either<Failure, Map<String, double>>> getSpendingByCategory({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final stats = await remoteDataSource.getSpendingByCategory(
        startDate: startDate,
        endDate: endDate,
      );
      return Right(stats);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Expense>> importExpenseFromImage(String imagePath) async {
    try {
      // Use OCR to extract text from image
      final ocrResult = await ocrService.extractTextFromImage(imagePath);
      
      // Parse the OCR result to create an expense
      final expense = ExpenseModel(
        id: '', // Will be assigned by backend
        amount: ocrResult['amount'] ?? 0.0,
        categoryId: ocrResult['categoryId'] ?? '',
        date: ocrResult['date'] ?? DateTime.now(),
        description: ocrResult['description'],
        merchant: ocrResult['merchant'],
        receiptImagePath: imagePath,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      return Right(expense.toEntity());
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to import expense from image: ${e.toString()}'));
    }
  }
}
