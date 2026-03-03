class TransactionDto {
  final String type;
  final double amount;
  final String category;
  final String? description;
  final String? date;
  final String? paymentMethod;
  final List<String>? tags;
  final String? notes;

  TransactionDto({
    required this.type,
    required this.amount,
    required this.category,
    this.description,
    this.date,
    this.paymentMethod,
    this.tags,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'amount': amount,
      'category': category,
      if (description != null) 'description': description,
      if (date != null) 'date': date,
      if (paymentMethod != null) 'paymentMethod': paymentMethod,
      if (tags != null) 'tags': tags,
      if (notes != null) 'notes': notes,
    };
  }
}
