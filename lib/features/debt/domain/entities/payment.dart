import 'package:equatable/equatable.dart';

class Payment extends Equatable {
  final String id;
  final String debtId;
  final double amount;
  final DateTime paymentDate;
  final String? note;
  final String? receiptUrl;

  const Payment({
    required this.id,
    required this.debtId,
    required this.amount,
    required this.paymentDate,
    this.note,
    this.receiptUrl,
  });

  Payment copyWith({
    String? id,
    String? debtId,
    double? amount,
    DateTime? paymentDate,
    String? note,
    String? receiptUrl,
  }) {
    return Payment(
      id: id ?? this.id,
      debtId: debtId ?? this.debtId,
      amount: amount ?? this.amount,
      paymentDate: paymentDate ?? this.paymentDate,
      note: note ?? this.note,
      receiptUrl: receiptUrl ?? this.receiptUrl,
    );
  }

  @override
  List<Object?> get props => [
        id,
        debtId,
        amount,
        paymentDate,
        note,
        receiptUrl,
      ];
}
