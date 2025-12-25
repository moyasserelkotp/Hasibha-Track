import 'dart:async';
import '../../models/debt_model.dart';
import '../../models/payment_model.dart';
import '../../../domain/entities/debt_enums.dart';
import 'debt_remote_datasource.dart';

class MockDebtRemoteDataSource implements DebtRemoteDataSource {
  final List<DebtModel> _debts = [
    DebtModel(
      id: '1',
      title: 'Lunch Money',
      description: 'Borrowed for lunch',
      contactName: 'John Doe',
      amount: 150.0,
      paidAmount: 0.0,
      createdDate: DateTime.now().subtract(const Duration(days: 2)),
      dueDate: DateTime.now().add(const Duration(days: 5)),
      type: DebtType.OWED_TO_ME,
      status: DebtStatus.ACTIVE,
    ),
    DebtModel(
      id: '2',
      title: 'Coffee',
      description: 'Starbucks run',
      contactName: 'Jane Smith',
      amount: 50.0,
      paidAmount: 0.0,
      createdDate: DateTime.now().subtract(const Duration(days: 10)),
      dueDate: DateTime.now().subtract(const Duration(days: 1)),
      type: DebtType.OWED_BY_ME,
      status: DebtStatus.OVERDUE,
    ),
    DebtModel(
      id: '3',
      title: 'Freelance Work',
      description: 'Project payment',
      contactName: 'Mike Ross',
      amount: 1200.0,
      paidAmount: 200.0,
      createdDate: DateTime.now().subtract(const Duration(days: 5)),
      dueDate: DateTime.now().add(const Duration(days: 30)),
      type: DebtType.OWED_TO_ME,
      status: DebtStatus.PARTIALLY_PAID,
    ),
    DebtModel(
      id: '4',
      title: 'Ticket Refund',
      description: 'Concert tickets for John',
      contactName: 'John Doe',
      amount: 85.0,
      paidAmount: 0.0,
      createdDate: DateTime.now().subtract(const Duration(days: 1)),
      dueDate: DateTime.now().add(const Duration(days: 2)),
      type: DebtType.OWED_TO_ME,
      status: DebtStatus.ACTIVE,
    ),
    DebtModel(
      id: '5',
      title: 'Shared Dinner',
      description: 'Dinner at Italian place',
      contactName: 'Sarah Connors',
      amount: 45.50,
      paidAmount: 0.0,
      createdDate: DateTime.now().subtract(const Duration(days: 3)),
      dueDate: DateTime.now().add(const Duration(days: 4)),
      type: DebtType.OWED_BY_ME,
      status: DebtStatus.ACTIVE,
    ),
    DebtModel(
      id: '6',
      title: 'Rent Share',
      description: 'Monthly rent contribution',
      contactName: 'Roommate',
      amount: 600.0,
      paidAmount: 600.0,
      createdDate: DateTime.now().subtract(const Duration(days: 20)),
      dueDate: DateTime.now().subtract(const Duration(days: 5)),
      type: DebtType.OWED_BY_ME,
      status: DebtStatus.PAID,
    ),
  ];

  @override
  Future<List<DebtModel>> getDebts({DebtType? type, DebtStatus? status}) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return _debts.where((debt) {
      if (type != null && debt.type != type) return false;
      if (status != null && debt.status != status) return false;
      return true;
    }).toList();
  }

  @override
  Future<DebtModel> getDebtById(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final debt = _debts.where((d) => d.id == id).toList();
    if (debt.isEmpty) throw Exception('Debt not found');
    return debt.first;
  }

  @override
  Future<DebtModel> createDebt(DebtModel debt) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    final newDebt = DebtModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: debt.title,
      description: debt.description,
      amount: debt.amount,
      paidAmount: debt.paidAmount,
      type: debt.type,
      status: debt.status,
      createdDate: DateTime.now(),
      dueDate: debt.dueDate,
      contactName: debt.contactName,
      contactPhone: debt.contactPhone,
      interestRate: debt.interestRate,
      paymentFrequency: debt.paymentFrequency,
    );
    _debts.add(newDebt);
    return newDebt;
  }

  @override
  Future<DebtModel> updateDebt(DebtModel debt) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    final index = _debts.indexWhere((d) => d.id == debt.id);
    if (index == -1) throw Exception('Debt not found');
    _debts[index] = debt; // Since mock, just replace it. Logic for "updatedAt" update is moot if model doesn't support it.
    return debt;
  }

  @override
  Future<void> deleteDebt(String id) async {
    await Future.delayed(const Duration(milliseconds: 800));
    final index = _debts.indexWhere((d) => d.id == id);
    if (index == -1) throw Exception('Debt not found');
    _debts.removeAt(index);
  }

  @override
  Future<DebtModel> addPayment(String debtId, PaymentModel payment) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    final index = _debts.indexWhere((d) => d.id == debtId);
    if (index == -1) throw Exception('Debt not found');

    final debt = _debts[index];
    final newPaidAmount = (debt.paidAmount) + payment.amount;
    
    // Create new DebtModel with updated values since we don't have copyWith
    final updatedDebt = DebtModel(
      id: debt.id,
      title: debt.title,
      description: debt.description,
      amount: debt.amount,
      paidAmount: newPaidAmount,
      type: debt.type,
      status: newPaidAmount >= debt.amount
          ? DebtStatus.PAID
          : DebtStatus.PARTIALLY_PAID,
      createdDate: debt.createdDate,
      dueDate: debt.dueDate,
      contactName: debt.contactName,
      contactPhone: debt.contactPhone,
      interestRate: debt.interestRate,
      paymentFrequency: debt.paymentFrequency,
      payments: [...debt.payments, payment],
    );

    _debts[index] = updatedDebt;
    return updatedDebt;
  }

  @override
  Future<Map<String, double>> getDebtSummary() async {
    await Future.delayed(const Duration(milliseconds: 500));
    final owedToMe = _debts
        .where((d) => d.type == DebtType.OWED_TO_ME)
        .fold(0.0, (sum, d) => sum + (d.amount - (d.paidAmount ?? 0)));
    final owedByMe = _debts
        .where((d) => d.type == DebtType.OWED_BY_ME)
        .fold(0.0, (sum, d) => sum + (d.amount - (d.paidAmount ?? 0)));

    return {
      'total_owed_to_me': owedToMe,
      'total_owed_by_me': owedByMe,
      'net_balance': owedToMe - owedByMe,
    };
  }
}



