import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_expenses_usecase.dart';
import '../../domain/usecases/create_expense_usecase.dart';
import '../../domain/usecases/update_expense_usecase.dart';
import '../../domain/usecases/delete_expense_usecase.dart';
import '../../domain/usecases/import_expense_from_image_usecase.dart';
import 'expense_event.dart';
import 'expense_state.dart';

class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  final GetExpensesUseCase getExpensesUseCase;
  final CreateExpenseUseCase createExpenseUseCase;
  final UpdateExpenseUseCase updateExpenseUseCase;
  final DeleteExpenseUseCase deleteExpenseUseCase;
  final ImportExpenseFromImageUseCase importExpenseFromImageUseCase;

  ExpenseBloc({
    required this.getExpensesUseCase,
    required this.createExpenseUseCase,
    required this.updateExpenseUseCase,
    required this.deleteExpenseUseCase,
    required this.importExpenseFromImageUseCase,
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

    final result = await getExpensesUseCase(
      startDate: event.startDate,
      endDate: event.endDate,
      categoryId: event.categoryId,
      tags: event.tags,
    );

    result.fold(
      (failure) => emit(ExpenseError(failure.message)),
      (expenses) => emit(ExpenseLoaded(
        expenses: expenses,
        filterStartDate: event.startDate,
        filterEndDate: event.endDate,
        filterCategoryId: event.categoryId,
      )),
    );
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

    final result = await getExpensesUseCase(
      startDate: startDate,
      endDate: endDate,
      categoryId: categoryId,
    );

    result.fold(
      (failure) => emit(ExpenseError(failure.message)),
      (expenses) => emit(ExpenseLoaded(
        expenses: expenses,
        filterStartDate: startDate,
        filterEndDate: endDate,
        filterCategoryId: categoryId,
      )),
    );
  }

  Future<void> _onCreateExpense(
    CreateExpense event,
    Emitter<ExpenseState> emit,
  ) async {
    emit(const ExpenseLoading());

    final result = await createExpenseUseCase(event.expense);

    result.fold(
      (failure) => emit(ExpenseError(failure.message)),
      (expense) async {
        // Reload expenses to show the new one
        add(const RefreshExpenses());
      },
    );
  }

  Future<void> _onUpdateExpense(
    UpdateExpense event,
    Emitter<ExpenseState> emit,
  ) async {
    emit(const ExpenseLoading());

    final result = await updateExpenseUseCase(event.expense);

    result.fold(
      (failure) => emit(ExpenseError(failure.message)),
      (expense) async {
        // Reload expenses to show the update
        add(const RefreshExpenses());
      },
    );
  }

  Future<void> _onDeleteExpense(
    DeleteExpense event,
    Emitter<ExpenseState> emit,
  ) async {
    emit(const ExpenseLoading());

    final result = await deleteExpenseUseCase(event.id);

    result.fold(
      (failure) => emit(ExpenseError(failure.message)),
      (_) async {
        // Reload expenses after deletion
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

    // Get current date filters if available
    DateTime? startDate;
    DateTime? endDate;

    if (state is ExpenseLoaded) {
      final loadedState = state as ExpenseLoaded;
      startDate = loadedState.filterStartDate;
      endDate = loadedState.filterEndDate;
    }

    final result = await getExpensesUseCase(
      startDate: startDate,
      endDate: endDate,
      categoryId: event.categoryId,
    );

    result.fold(
      (failure) => emit(ExpenseError(failure.message)),
      (expenses) => emit(ExpenseLoaded(
        expenses: expenses,
        filterStartDate: startDate,
        filterEndDate: endDate,
        filterCategoryId: event.categoryId,
      )),
    );
  }

  Future<void> _onFilterByDateRange(
    FilterExpensesByDateRange event,
    Emitter<ExpenseState> emit,
  ) async {
    emit(const ExpenseLoading());

    // Get current category filter if available
    String? categoryId;

    if (state is ExpenseLoaded) {
      final loadedState = state as ExpenseLoaded;
      categoryId = loadedState.filterCategoryId;
    }

    final result = await getExpensesUseCase(
      startDate: event.startDate,
      endDate: event.endDate,
      categoryId: categoryId,
    );

    result.fold(
      (failure) => emit(ExpenseError(failure.message)),
      (expenses) => emit(ExpenseLoaded(
        expenses: expenses,
        filterStartDate: event.startDate,
        filterEndDate: event.endDate,
        filterCategoryId: categoryId,
      )),
    );
  }
}
