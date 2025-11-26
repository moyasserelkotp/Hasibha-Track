enum DebtType {
  OWED_TO_ME,
  OWED_BY_ME,
}

enum DebtStatus {
  ACTIVE,
  PARTIALLY_PAID,
  PAID,
  OVERDUE,
  CANCELLED,
}

enum PaymentFrequency {
  WEEKLY,
  BIWEEKLY,
  MONTHLY,
  QUARTERLY,
  YEARLY,
}

extension DebtTypeExtension on DebtType {
  String get displayName {
    switch (this) {
      case DebtType.OWED_TO_ME:
        return 'Owed To Me';
      case DebtType.OWED_BY_ME:
        return 'Owed By Me';
    }
  }

  bool get isReceivable => this == DebtType.OWED_TO_ME;
  bool get isPayable => this == DebtType.OWED_BY_ME;
}

extension DebtStatusExtension on DebtStatus {
  String get displayName {
    switch (this) {
      case DebtStatus.ACTIVE:
        return 'Active';
      case DebtStatus.PARTIALLY_PAID:
        return 'Partially Paid';
      case DebtStatus.PAID:
        return 'Paid';
      case DebtStatus.OVERDUE:
        return 'Overdue';
      case DebtStatus.CANCELLED:
        return 'Cancelled';
    }
  }

  bool get isActive => this == DebtStatus.ACTIVE;
  bool get isPaid => this == DebtStatus.PAID;
  bool get isOverdue => this == DebtStatus.OVERDUE;
}

extension PaymentFrequencyExtension on PaymentFrequency {
  String get displayName {
    switch (this) {
      case PaymentFrequency.WEEKLY:
        return 'Weekly';
      case PaymentFrequency.BIWEEKLY:
        return 'Bi-weekly';
      case PaymentFrequency.MONTHLY:
        return 'Monthly';
      case PaymentFrequency.QUARTERLY:
        return 'Quarterly';
      case PaymentFrequency.YEARLY:
        return 'Yearly';
    }
  }
}
