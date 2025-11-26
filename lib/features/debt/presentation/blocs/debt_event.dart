import 'package:equatable/equatable.dart';
import '../../domain/entities/debt.dart';
import '../../domain/entities/debt_enums.dart';
import '../../domain/entities/payment.dart';

abstract class DebtEvent extends Equatable {
  const DebtEvent();

  @override
  List<Object?> get props => [];
}

class LoadDebts extends DebtEvent {
  final DebtType? type;
  final DebtStatus? status;

  const LoadDebts({this.type, this.status});

  @override
  List<Object?> get props => [type, status];
}

class RefreshDebts extends DebtEvent {
  const RefreshDebts();
}

class CreateDebt extends DebtEvent {
  final Debt debt;

  const CreateDebt(this.debt);

  @override
  List<Object?> get props => [debt];
}

class UpdateDebt extends DebtEvent {
  final Debt debt;

  const UpdateDebt(this.debt);

  @override
  List<Object?> get props => [debt];
}

class DeleteDebt extends DebtEvent {
  final String id;

  const DeleteDebt(this.id);

  @override
  List<Object?> get props => [id];
}

class AddPayment extends DebtEvent {
  final String debtId;
  final Payment payment;

  const AddPayment({
    required this.debtId,
    required this.payment,
  });

  @override
  List<Object?> get props => [debtId, payment];
}

class LoadDebtSummary extends DebtEvent {
  const LoadDebtSummary();
}
