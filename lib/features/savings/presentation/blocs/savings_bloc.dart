import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_savings_goals_usecase.dart';
import '../../domain/usecases/create_savings_goal_usecase.dart';
import '../../domain/usecases/update_savings_goal_usecase.dart';
import '../../domain/usecases/delete_savings_goal_usecase.dart';
import '../../domain/usecases/add_funds_to_goal_usecase.dart';
import '../../domain/usecases/withdraw_funds_from_goal_usecase.dart';
import 'savings_event.dart';
import 'savings_state.dart';

class SavingsBloc extends Bloc<SavingsEvent, SavingsState> {
  final GetSavingsGoalsUseCase getSavingsGoalsUseCase;
  final CreateSavingsGoalUseCase createSavingsGoalUseCase;
  final UpdateSavingsGoalUseCase updateSavingsGoalUseCase;
  final DeleteSavingsGoalUseCase deleteSavingsGoalUseCase;
  final AddFundsToGoalUseCase addFundsToGoalUseCase;
  final WithdrawFundsFromGoalUseCase withdrawFundsFromGoalUseCase;

  SavingsBloc({
    required this.getSavingsGoalsUseCase,
    required this.createSavingsGoalUseCase,
    required this.updateSavingsGoalUseCase,
    required this.deleteSavingsGoalUseCase,
    required this.addFundsToGoalUseCase,
    required this.withdrawFundsFromGoalUseCase,
  }) : super(const SavingsInitial()) {
    on<LoadSavingsGoals>(_onLoadSavingsGoals);
    on<CreateSavingsGoal>(_onCreateSavingsGoal);
    on<UpdateSavingsGoal>(_onUpdateSavingsGoal);
    on<DeleteSavingsGoal>(_onDeleteSavingsGoal);
    on<AddFundsToGoal>(_onAddFundsToGoal);
    on<WithdrawFundsFromGoal>(_onWithdrawFundsFromGoal);
  }

  Future<void> _onLoadSavingsGoals(
    LoadSavingsGoals event,
    Emitter<SavingsState> emit,
  ) async {
    emit(const SavingsLoading());

    final result = await getSavingsGoalsUseCase();

    result.fold(
      (failure) => emit(SavingsError(failure.message)),
      (goals) => emit(SavingsLoaded(goals)),
    );
  }

  Future<void> _onCreateSavingsGoal(
    CreateSavingsGoal event,
    Emitter<SavingsState> emit,
  ) async {
    emit(const SavingsLoading());

    final result = await createSavingsGoalUseCase(event.goal);

    result.fold(
      (failure) => emit(SavingsError(failure.message)),
      (goal) {
        emit(const SavingsOperationSuccess('Goal created successfully'));
        add(const LoadSavingsGoals());
      },
    );
  }

  Future<void> _onUpdateSavingsGoal(
    UpdateSavingsGoal event,
    Emitter<SavingsState> emit,
  ) async {
    emit(const SavingsLoading());

    final result = await updateSavingsGoalUseCase(event.goal);

    result.fold(
      (failure) => emit(SavingsError(failure.message)),
      (goal) {
        emit(const SavingsOperationSuccess('Goal updated successfully'));
        add(const LoadSavingsGoals());
      },
    );
  }

  Future<void> _onDeleteSavingsGoal(
    DeleteSavingsGoal event,
    Emitter<SavingsState> emit,
  ) async {
    emit(const SavingsLoading());

    final result = await deleteSavingsGoalUseCase(event.id);

    result.fold(
      (failure) => emit(SavingsError(failure.message)),
      (_) {
        emit(const SavingsOperationSuccess('Goal deleted successfully'));
        add(const LoadSavingsGoals());
      },
    );
  }

  Future<void> _onAddFundsToGoal(
    AddFundsToGoal event,
    Emitter<SavingsState> emit,
  ) async {
    emit(const SavingsLoading());

    final result = await addFundsToGoalUseCase(event.id, event.amount);

    result.fold(
      (failure) => emit(SavingsError(failure.message)),
      (goal) {
        emit(const SavingsOperationSuccess('Funds added successfully'));
        add(const LoadSavingsGoals());
      },
    );
  }

  Future<void> _onWithdrawFundsFromGoal(
    WithdrawFundsFromGoal event,
    Emitter<SavingsState> emit,
  ) async {
    emit(const SavingsLoading());

    final result = await withdrawFundsFromGoalUseCase(event.id, event.amount);

    result.fold(
      (failure) => emit(SavingsError(failure.message)),
      (goal) {
        emit(const SavingsOperationSuccess('Funds withdrawn successfully'));
        add(const LoadSavingsGoals());
      },
    );
  }
}
