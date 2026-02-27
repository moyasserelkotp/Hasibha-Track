import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../shared/data/mock_data_provider.dart';
import '../../../../../shared/services/budget_expense_sync_service.dart';
import '../../../domain/entities/expense.dart';
import '../../../domain/usecases/get_expenses_usecase.dart';
import '../../../domain/usecases/create_expense_usecase.dart';
import '../../../domain/usecases/update_expense_usecase.dart';
import '../../../domain/usecases/delete_expense_usecase.dart';
import '../../../domain/usecases/import_expense_from_image_usecase.dart';
import 'expense_event.dart';
import 'expense_state.dart';

class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  final GetExpensesUseCase getExpensesUseCase;
  final CreateExpenseUseCase createExpenseUseCase;
  final UpdateExpenseUseCase updateExpenseUseCase;
  final DeleteExpenseUseCase deleteExpenseUseCase;
  final ImportExpenseFromImageUseCase importExpenseFromImageUseCase;
  final BudgetExpenseSyncService budgetSyncService;
  final bool useMockData;

  ExpenseBloc({
    required this.getExpensesUseCase,
    required this.createExpenseUseCase,
    required this.updateExpenseUseCase,
    required this.deleteExpenseUseCase,
    required this.importExpenseFromImageUseCase,
    required this.budgetSyncService,
    this.useMockData = true,
  }) : super(const ExpenseInitial()) {
    on<LoadExpenses>(_onLoadExpenses);
    on<RefreshExpenses>(_onRefreshExpenses);
    on<CreateExpense>(_onCreateExpense);
    on<UpdateExpense>(_onUpdateExpense);
    on<DeleteExpense>(_onDeleteExpense);
    on<ImportExpenseFromImage>(_onImportExpenseFromImage);
    on<FilterExpensesByCategory>(_onFilterByCategory);
    on<FilterExpensesByDateRange>(_onFilterByDateRange);
  }

  Future<void> _onLoadExpenses(
    LoadExpenses event,
    Emitter<ExpenseState> emit,
  ) async {
    emit(const ExpenseLoading());
    
    final expenses = await _fetchExpenses(
      startDate: event.startDate,
      endDate: event.endDate,
      categoryId: event.categoryId,
    );

    emit(ExpenseLoaded(
      expenses: expenses,
      filterStartDate: event.startDate,
      filterEndDate: event.endDate,
      filterCategoryId: event.categoryId,
    ));
  }

  Future<void> _onRefreshExpenses(
    RefreshExpenses event,
    Emitter<ExpenseState> emit,
  ) async {
    // Get current filters if in loaded state
    DateTime? startDate;
    DateTime? endDate;
    String? categoryId;

    if (state is ExpenseLoaded) {
      final loadedState = state as ExpenseLoaded;
      startDate = loadedState.filterStartDate;
      endDate = loadedState.filterEndDate;
      categoryId = loadedState.filterCategoryId;
    }

    final expenses = await _fetchExpenses(
      startDate: startDate,
      endDate: endDate,
      categoryId: categoryId,
    );

    emit(ExpenseLoaded(
      expenses: expenses,
      filterStartDate: startDate,
      filterEndDate: endDate,
      filterCategoryId: categoryId,
    ));
  }

  Future<void> _onCreateExpense(
    CreateExpense event,
    Emitter<ExpenseState> emit,
  ) async {
    emit(const ExpenseLoading());

    if (useMockData) {
      await Future.delayed(const Duration(milliseconds: 600));
      add(const RefreshExpenses());
      return;
    }

    final result = await createExpenseUseCase(event.expense);

    result.fold(
      (failure) => emit(ExpenseError(failure.message)),
      (expense) async {
        await budgetSyncService.onExpenseCreated(expense);
        add(const RefreshExpenses());
      },
    );
  }

  Future<void> _onUpdateExpense(
    UpdateExpense event,
    Emitter<ExpenseState> emit,
  ) async {
    emit(const ExpenseLoading());

    if (useMockData) {
      await Future.delayed(const Duration(milliseconds: 600));
      add(const RefreshExpenses());
      return;
    }

    final result = await updateExpenseUseCase(event.expense);

    result.fold(
      (failure) => emit(ExpenseError(failure.message)),
      (expense) async {
        await budgetSyncService.onExpenseCreated(expense);
        add(const RefreshExpenses());
      },
    );
  }

  Future<void> _onDeleteExpense(
    DeleteExpense event,
    Emitter<ExpenseState> emit,
  ) async {
    emit(const ExpenseLoading());

    if (useMockData) {
      await Future.delayed(const Duration(milliseconds: 600));
      add(const RefreshExpenses());
      return;
    }

    final result = await deleteExpenseUseCase(event.id);

    result.fold(
      (failure) => emit(ExpenseError(failure.message)),
      (_) async {
        add(const RefreshExpenses());
      },
    );
  }

  Future<void> _onImportExpenseFromImage(
    ImportExpenseFromImage event,
    Emitter<ExpenseState> emit,
  ) async {
    emit(const ExpenseImporting());

    final result = await importExpenseFromImageUseCase(event.imagePath);

    result.fold(
      (failure) => emit(ExpenseError(failure.message)),
      (expense) => emit(ExpenseImported(expense)),
    );
  }

  Future<void> _onFilterByCategory(
    FilterExpensesByCategory event,
    Emitter<ExpenseState> emit,
  ) async {
    emit(const ExpenseLoading());

    DateTime? startDate;
    DateTime? endDate;

    if (state is ExpenseLoaded) {
      final loadedState = state as ExpenseLoaded;
      startDate = loadedState.filterStartDate;
      endDate = loadedState.filterEndDate;
    }

    final expenses = await _fetchExpenses(
      startDate: startDate,
      endDate: endDate,
      categoryId: event.categoryId,
    );

    emit(ExpenseLoaded(
      expenses: expenses,
      filterStartDate: startDate,
      filterEndDate: endDate,
      filterCategoryId: event.categoryId,
    ));
  }

  Future<void> _onFilterByDateRange(
    FilterExpensesByDateRange event,
    Emitter<ExpenseState> emit,
  ) async {
    emit(const ExpenseLoading());

    String? categoryId;

    if (state is ExpenseLoaded) {
      final loadedState = state as ExpenseLoaded;
      categoryId = loadedState.filterCategoryId;
    }

    final expenses = await _fetchExpenses(
      startDate: event.startDate,
      endDate: event.endDate,
      categoryId: categoryId,
    );

    emit(ExpenseLoaded(
      expenses: expenses,
      filterStartDate: event.startDate,
      filterEndDate: event.endDate,
      filterCategoryId: categoryId,
    ));
  }

  Future<List<Expense>> _fetchExpenses({
    DateTime? startDate,
    DateTime? endDate,
    String? categoryId,
  }) async {
    if (useMockData) {
      await Future.delayed(const Duration(milliseconds: 600));
      return MockDataProvider.getAllTransactions()
          .where((e) => e.type == 'expense')
          .where((e) => categoryId == null || e.category == categoryId)
          .where((e) => startDate == null || e.date.isAfter(startDate))
          .where((e) => endDate == null || e.date.isBefore(endDate))
          .map((e) => Expense(
                id: e.id,
                amount: e.amount,
                categoryId: e.category,
                date: e.date,
                description: e.title,
                note: e.description,
                createdAt: e.date,
                updatedAt: e.date,
              ))
          .toList();
    }

    final result = await getExpensesUseCase(
      startDate: startDate,
      endDate: endDate,
      categoryId: categoryId,
    );

    return result.fold(
      (failure) => [],
      (expenses) => expenses,
    );
  }
}
