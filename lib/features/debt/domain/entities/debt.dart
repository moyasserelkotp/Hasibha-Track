import 'package:equatable/equatable.dart';
import 'debt_enums.dart';
import 'payment.dart';

class Debt extends Equatable {
  final String id;
  final String title;
  final String description;
  final double amount;
  final double paidAmount;
  final DebtType type;
  final String? contactName;
  final String? contactPhone;
  final DateTime createdDate;
  final DateTime? dueDate;
  final DebtStatus status;
  final double? interestRate;
  final PaymentFrequency? paymentFrequency;
  final List<Payment> payments;

  const Debt({
    required this.id,
    required this.title,
    required this.description,
    required this.amount,
    required this.paidAmount,
    required this.type,
    this.contactName,
    this.contactPhone,
    required this.createdDate,
    this.dueDate,
    required this.status,
    this.interestRate,
    this.paymentFrequency,
    this.payments = const [],
  });

  double get remainingAmount => amount - paidAmount;
  double get progressPercentage => amount > 0 ? (paidAmount / amount) * 100 : 0;
  bool get isFullyPaid => paidAmount >= amount;
  bool get isOverdue => dueDate != null && 
      DateTime.now().isAfter(dueDate!) && 
      status != DebtStatus.PAID;

  DebtStatus calculateStatus() {
    if (isFullyPaid) return DebtStatus.PAID;
    if (isOverdue) return DebtStatus.OVERDUE;
    if (paidAmount > 0) return DebtStatus.PARTIALLY_PAID;
    return DebtStatus.ACTIVE;
  }

  Debt copyWith({
    String? id,
    String? title,
    String? description,
    double? amount,
    double? paidAmount,
    DebtType? type,
    String? contactName,
    String? contactPhone,
    DateTime? createdDate,
    DateTime? dueDate,
    DebtStatus? status,
    double? interestRate,
    PaymentFrequency? paymentFrequency,
    List<Payment>? payments,
  }) {
    return Debt(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      paidAmount: paidAmount ?? this.paidAmount,
      type: type ?? this.type,
      contactName: contactName ?? this.contactName,
      contactPhone: contactPhone ?? this.contactPhone,
      createdDate: createdDate ?? this.createdDate,
      dueDate: dueDate ?? this.dueDate,
      status: status ?? this.status,
      interestRate: interestRate ?? this.interestRate,
      paymentFrequency: paymentFrequency ?? this.paymentFrequency,
      payments: payments ?? this.payments,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        amount,
        paidAmount,
        type,
        contactName,
        contactPhone,
        createdDate,
        dueDate,
        status,
        interestRate,
        paymentFrequency,
        payments,
      ];
}
