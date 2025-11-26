import '../../domain/entities/debt_enums.dart';

class DebtDto {
  final String title;
  final String description;
  final double amount;
  final DebtType type;
  final String? contactName;
  final String? contactPhone;
  final DateTime? dueDate;
  final double? interestRate;
  final PaymentFrequency? paymentFrequency;

  const DebtDto({
    required this.title,
    required this.description,
    required this.amount,
    required this.type,
    this.contactName,
    this.contactPhone,
    this.dueDate,
    this.interestRate,
    this.paymentFrequency,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'amount': amount,
      'type': type.toString().split('.').last,
      if (contactName != null) 'contact_name': contactName,
      if (contactPhone != null) 'contact_phone': contactPhone,
      if (dueDate != null) 'due_date': dueDate!.toIso8601String(),
      if (interestRate != null) 'interest_rate': interestRate,
      if (paymentFrequency != null)
        'payment_frequency': paymentFrequency.toString().split('.').last,
    };
  }
}
