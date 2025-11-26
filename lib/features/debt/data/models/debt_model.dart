import '../../domain/entities/debt.dart';
import '../../domain/entities/debt_enums.dart';
import 'payment_model.dart';

class DebtModel extends Debt {
  const DebtModel({
    required super.id,
    required super.title,
    required super.description,
    required super.amount,
    required super.paidAmount,
    required super.type,
    super.contactName,
    super.contactPhone,
    required super.createdDate,
    super.dueDate,
    required super.status,
    super.interestRate,
    super.paymentFrequency,
    super.payments = const [],
  });

  factory DebtModel.fromJson(Map<String, dynamic> json) {
    return DebtModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      amount: (json['amount'] as num).toDouble(),
      paidAmount: (json['paid_amount'] as num?)?.toDouble() ?? 0.0,
      type: DebtType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
      ),
      contactName: json['contact_name'] as String?,
      contactPhone: json['contact_phone'] as String?,
      createdDate: DateTime.parse(json['created_date'] as String),
      dueDate: json['due_date'] != null
          ? DateTime.parse(json['due_date'] as String)
          : null,
      status: DebtStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
      ),
      interestRate: (json['interest_rate'] as num?)?.toDouble(),
      paymentFrequency: json['payment_frequency'] != null
          ? PaymentFrequency.values.firstWhere(
              (e) => e.toString().split('.').last == json['payment_frequency'],
            )
          : null,
      payments: (json['payments'] as List<dynamic>?)
              ?.map((e) => PaymentModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'amount': amount,
      'paid_amount': paidAmount,
      'type': type.toString().split('.').last,
      if (contactName != null) 'contact_name': contactName,
      if (contactPhone != null) 'contact_phone': contactPhone,
      'created_date': createdDate.toIso8601String(),
      if (dueDate != null) 'due_date': dueDate!.toIso8601String(),
      'status': status.toString().split('.').last,
      if (interestRate != null) 'interest_rate': interestRate,
      if (paymentFrequency != null)
        'payment_frequency': paymentFrequency.toString().split('.').last,
      'payments': payments
          .map((p) => PaymentModel.fromEntity(p).toJson())
          .toList(),
    };
  }

  factory DebtModel.fromEntity(Debt debt) {
    return DebtModel(
      id: debt.id,
      title: debt.title,
      description: debt.description,
      amount: debt.amount,
      paidAmount: debt.paidAmount,
      type: debt.type,
      contactName: debt.contactName,
      contactPhone: debt.contactPhone,
      createdDate: debt.createdDate,
      dueDate: debt.dueDate,
      status: debt.status,
      interestRate: debt.interestRate,
      paymentFrequency: debt.paymentFrequency,
      payments: debt.payments,
    );
  }

  Debt toEntity() => this;
}
