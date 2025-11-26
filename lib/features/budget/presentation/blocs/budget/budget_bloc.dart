import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_budgets_usecase.dart';
import '../../domain/usecases/create_budget_usecase.dart';
import '../../domain/usecases/update_budget_usecase.dart';
import '../../domain/usecases/delete_budget_usecase.dart';
import '../../domain/usecases/check_budget_limits_usecase.dart';
import 'budget_event.dart';
import 'budget_state.dart';

class BudgetBloc extends Bloc<BudgetEvent, BudgetState> {
  final GetBudgetsUseCase getBudgetsUseCase;
  final CreateBudgetUseCase createBudgetUseCase;
  final UpdateBudgetUseCase updateBudgetUseCase;
  final DeleteBudgetUseCase deleteBudgetUseCase;
  final CheckBudgetLimitsUseCase checkBudgetLimitsUseCase;

  BudgetBloc({
    required this.getBudgetsUseCase,
    required this.createBudgetUseCase,
    required this.updateBudgetUseCase,
    required this.deleteBudgetUseCase,
    required this.checkBudgetLimitsUseCase,
  }) : super(const BudgetInitial()) {
    on<LoadBudgets>(_onLoadBudgets);
    on<RefreshBudgets>(_onRefreshBudgets);
    on<CreateBudget>(_onCreateBudget);
    on<UpdateBudget>(_onUpdateBudget);
    on<DeleteBudget>(_onDeleteBudget);
    on<CheckBudgetLimits>(_onCheckBudgetLimits);
  }

  Future<void> _onLoadBudgets(
    LoadBudgets event,
    Emitter<BudgetState> emit,
  ) async {
    emit(const BudgetLoading());

    final result = await getBudgetsUseCase(
      isActive: event.isActive,
      categoryId: event.categoryId,
    );

    await result.fold(
      (failure) async => emit(BudgetError(failure.message)),
      (budgets) async {
        // Also check for exceeded and approaching budgets
        final exceededResult = await checkBudgetLimitsUseCase.callExceeded();
        final approachingResult = await checkBudgetLimitsUseCase.callApproaching();

        final exceeded = exceededResult.fold(
          (_) => <Budget>[],
          (list) => list,
        );

        final approaching = approachingResult.fold(
          (_) => <Budget>[],
          (list) => list,
        );

        emit(BudgetLoaded(
          budgets: budgets,
          exceededBudgets: exceeded,
          approachingBudgets: approaching,
        ));
      },
    );
  }

  Future<void> _onRefreshBudgets(
    RefreshBudgets event,
    Emitter<BudgetState> emit,
  ) async {
    add(const LoadBudgets());
  }

  Future<void> _onCreateBudget(
    CreateBudget event,
    Emitter<BudgetState> emit,
  ) async {
    emit(const BudgetLoading());

    final result = await createBudgetUseCase(event.budget);

    result.fold(
      (failure) => emit(BudgetError(failure.message)),
      (_) {
        add(const RefreshBudgets());
        emit(const BudgetOperationSuccess('Budget created successfully'));
      },
    );
  }

  Future<void> _onUpdateBudget(
    UpdateBudget event,
    Emitter<BudgetState> emit,
  ) async {
    emit(const BudgetLoading());

    final result = await updateBudgetUseCase(event.budget);

    result.fold(
      (failure) => emit(BudgetError(failure.message)),
      (_) {
        add(const RefreshBudgets());
        emit(const BudgetOperationSuccess('Budget updated successfully'));
      },
    );
  }

  Future<void> _onDeleteBudget(
    DeleteBudget event,
    Emitter<BudgetState> emit,
  ) async {
    emit(const BudgetLoading());

    final result = await deleteBudgetUseCase(event.id);

    result.fold(
      (failure) => emit(BudgetError(failure.message)),
      (_) {
        add(const RefreshBudgets());
        emit(const BudgetOperationSuccess('Budget deleted successfully'));
      },
    );
  }

  Future<void> _onCheckBudgetLimits(
    CheckBudgetLimits event,
    Emitter<BudgetState> emit,
  ) async {
    // Check limits without loading state
    if (state is BudgetLoaded) {
      final currentState = state as BudgetLoaded;

      final exceededResult = await checkBudgetLimitsUseCase.callExceeded();
      final approachingResult = await checkBudgetLimitsUseCase.callApproaching();

      final exceeded = exceededResult.fold(
        (_) => currentState.exceededBudgets,
        (list) => list,
      );

      final approaching = approachingResult.fold(
        (_) => currentState.approachingBudgets,
        (list) => list,
      );

      emit(currentState.copyWith(
        exceededBudgets: exceeded,
        approachingBudgets: approaching,
      ));
    }
  }
}
