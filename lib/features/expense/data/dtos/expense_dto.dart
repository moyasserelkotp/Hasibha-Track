class ExpenseDto {
  final double amount;
  final String categoryId;
  final String date; // ISO 8601 format
  final String? description;
  final String? note;
  final List<String>? tags;
  final String? attachmentUrl;
  final String? receiptImagePath;
  final String? merchant;
  final bool isRecurring;
  final String? recurringPeriod;

  ExpenseDto({
    required this.amount,
    required this.categoryId,
    required this.date,
    this.description,
    this.note,
    this.tags,
    this.attachmentUrl,
    this.receiptImagePath,
    this.merchant,
    this.isRecurring = false,
    this.recurringPeriod,
  });

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'category_id': categoryId,
      'date': date,
      if (description != null) 'description': description,
      if (note != null) 'note': note,
      if (tags != null && tags!.isNotEmpty) 'tags': tags,
      if (attachmentUrl != null) 'attachment_url': attachmentUrl,
      if (receiptImagePath != null) 'receipt_image_path': receiptImagePath,
      if (merchant != null) 'merchant': merchant,
      'is_recurring': isRecurring,
      if (recurringPeriod != null) 'recurring_period': recurringPeriod,
    };
  }
}
