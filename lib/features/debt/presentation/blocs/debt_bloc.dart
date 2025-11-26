import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../shared/core/use_case/use_case.dart';
import '../../domain/usecases/add_payment_usecase.dart';
import '../../domain/usecases/create_debt_usecase.dart';
import '../../domain/usecases/delete_debt_usecase.dart';
import '../../domain/usecases/get_debt_summary_usecase.dart';
import '../../domain/usecases/get_debts_usecase.dart';
import '../../domain/usecases/update_debt_usecase.dart';
import 'debt_event.dart';
import 'debt_state.dart';

class DebtBloc extends Bloc<DebtEvent, DebtState> {
  final GetDebtsUseCase getDebtsUseCase;
  final CreateDebtUseCase createDebtUseCase;
  final UpdateDebtUseCase updateDebtUseCase;
  final DeleteDebtUseCase deleteDebtUseCase;
  final AddPaymentUseCase addPaymentUseCase;
  final GetDebtSummaryUseCase getDebtSummaryUseCase;

  DebtBloc({
    required this.getDebtsUseCase,
    required this.createDebtUseCase,
    required this.updateDebtUseCase,
    required this.deleteDebtUseCase,
    required this.addPaymentUseCase,
    required this.getDebtSummaryUseCase,
  }) : super(const DebtInitial()) {
    on<LoadDebts>(_onLoadDebts);
    on<RefreshDebts>(_onRefreshDebts);
    on<CreateDebt>(_onCreateDebt);
    on<UpdateDebt>(_onUpdateDebt);
    on<DeleteDebt>(_onDeleteDebt);
    on<AddPayment>(_onAddPayment);
    on<LoadDebtSummary>(_onLoadDebtSummary);
  }

  Future<void> _onLoadDebts(
    LoadDebts event,
    Emitter<DebtState> emit,
  ) async {
    emit(const DebtLoading());

    final result = await getDebtsUseCase(
      GetDebtsParams(type: event.type, status: event.status),
    );

    await result.fold(
      (failure) async => emit(DebtError(failure.message)),
      (debts) async {
        // Also fetch summary
        final summaryResult = await getDebtSummaryUseCase(NoParams());
        final summary = summaryResult.fold(
          (_) => <String, double>{},
          (s) => s,
        );

        emit(DebtLoaded(debts: debts, summary: summary));
      },
    );
  }

  Future<void> _onRefreshDebts(
    RefreshDebts event,
    Emitter<DebtState> emit,
  ) async {
    add(const LoadDebts());
  }

  Future<void> _onCreateDebt(
    CreateDebt event,
    Emitter<DebtState> emit,
  ) async {
    emit(const DebtLoading());

    final result = await createDebtUseCase(event.debt);

    result.fold(
      (failure) => emit(DebtError(failure.message)),
      (_) {
        add(const RefreshDebts());
        emit(const DebtOperationSuccess('Debt created successfully'));
      },
    );
  }

  Future<void> _onUpdateDebt(
    UpdateDebt event,
    Emitter<DebtState> emit,
  ) async {
    emit(const DebtLoading());

    final result = await updateDebtUseCase(event.debt);

    result.fold(
      (failure) => emit(DebtError(failure.message)),
      (_) {
        add(const RefreshDebts());
        emit(const DebtOperationSuccess('Debt updated successfully'));
      },
    );
  }

  Future<void> _onDeleteDebt(
    DeleteDebt event,
    Emitter<DebtState> emit,
  ) async {
    emit(const DebtLoading());

    final result = await deleteDebtUseCase(event.id);

    result.fold(
      (failure) => emit(DebtError(failure.message)),
      (_) {
        add(const RefreshDebts());
        emit(const DebtOperationSuccess('Debt deleted successfully'));
      },
    );
  }

  Future<void> _onAddPayment(
    AddPayment event,
    Emitter<DebtState> emit,
  ) async {
    emit(const DebtLoading());

    final result = await addPaymentUseCase(
      AddPaymentParams(debtId: event.debtId, payment: event.payment),
    );

    result.fold(
      (failure) => emit(DebtError(failure.message)),
      (_) {
        add(const RefreshDebts());
        emit(const DebtOperationSuccess('Payment added successfully'));
      },
    );
  }

  Future<void> _onLoadDebtSummary(
    LoadDebtSummary event,
    Emitter<DebtState> emit,
  ) async {
    if (state is DebtLoaded) {
      final currentState = state as DebtLoaded;
      final summaryResult = await getDebtSummaryUseCase(NoParams());

      summaryResult.fold(
        (_) {}, // Keep existing summary on error
        (summary) => emit(currentState.copyWith(summary: summary)),
      );
    }
  }
}
