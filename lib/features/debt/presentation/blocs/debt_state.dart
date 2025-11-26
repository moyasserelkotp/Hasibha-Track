import 'package:equatable/equatable.dart';
import '../../domain/entities/debt.dart';
import '../../domain/entities/debt_enums.dart';

abstract class DebtState extends Equatable {
  const DebtState();

  @override
  List<Object?> get props => [];
}

class DebtInitial extends DebtState {
  const DebtInitial();
}

class DebtLoading extends DebtState {
  const DebtLoading();
}

class DebtLoaded extends DebtState {
  final List<Debt> debts;
  final Map<String, double> summary;

  const DebtLoaded({
    required this.debts,
    this.summary = const {},
  });

  double get totalOwedToMe => summary['totalOwedToMe'] ?? 0.0;
  double get totalOwedByMe => summary['totalOwedByMe'] ?? 0.0;
  double get netBalance => summary['netBalance'] ?? 0.0;

  List<Debt> get receivables =>
      debts.where((d) => d.type.isReceivable).toList();
  List<Debt> get payables => debts.where((d) => d.type.isPayable).toList();

  DebtLoaded copyWith({
    List<Debt>? debts,
    Map<String, double>? summary,
  }) {
    return DebtLoaded(
      debts: debts ?? this.debts,
      summary: summary ?? this.summary,
    );
  }

  @override
  List<Object?> get props => [debts, summary];
}

class DebtError extends DebtState {
  final String message;

  const DebtError(this.message);

  @override
  List<Object?> get props => [message];
}

class DebtOperationSuccess extends DebtState {
  final String message;

  const DebtOperationSuccess(this.message);

  @override
  List<Object?> get props => [message];
}
