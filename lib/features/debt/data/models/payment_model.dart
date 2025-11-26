import '../../domain/entities/payment.dart';

class PaymentModel extends Payment {
  const PaymentModel({
    required super.id,
    required super.debtId,
    required super.amount,
    required super.paymentDate,
    super.note,
    super.receiptUrl,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['id'] as String,
      debtId: json['debt_id'] as String,
      amount: (json['amount'] as num).toDouble(),
      paymentDate: DateTime.parse(json['payment_date'] as String),
      note: json['note'] as String?,
      receiptUrl: json['receipt_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'debt_id': debtId,
      'amount': amount,
      'payment_date': paymentDate.toIso8601String(),
      if (note != null) 'note': note,
      if (receiptUrl != null) 'receipt_url': receiptUrl,
    };
  }

  factory PaymentModel.fromEntity(Payment payment) {
    return PaymentModel(
      id: payment.id,
      debtId: payment.debtId,
      amount: payment.amount,
      paymentDate: payment.paymentDate,
      note: payment.note,
      receiptUrl: payment.receiptUrl,
    );
  }

  Payment toEntity() => this;
}
