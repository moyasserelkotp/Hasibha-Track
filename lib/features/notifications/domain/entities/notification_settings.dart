import 'package:equatable/equatable.dart';

class NotificationSettings extends Equatable {
  final bool budgetAlertsEnabled;
  final bool billRemindersEnabled;
  final bool savingsMilestonesEnabled;
  final bool debtPaymentsEnabled;
  final bool expenseNotificationsEnabled;
  final int budgetAlertThreshold; // Percentage (e.g., 80 for 80%)
  final int billReminderDaysBefore;
  final bool soundEnabled;
  final bool vibrationEnabled;
  final String? customSound;

  const NotificationSettings({
    this.budgetAlertsEnabled = true,
    this.billRemindersEnabled = true,
    this.savingsMilestonesEnabled = true,
    this.debtPaymentsEnabled = true,
    this.expenseNotificationsEnabled = false,
    this.budgetAlertThreshold = 80,
    this.billReminderDaysBefore = 3,
    this.soundEnabled = true,
    this.vibrationEnabled = true,
    this.customSound,
  });

  NotificationSettings copyWith({
    bool? budgetAlertsEnabled,
    bool? billRemindersEnabled,
    bool? savingsMilestonesEnabled,
    bool? debtPaymentsEnabled,
    bool? expenseNotificationsEnabled,
    int? budgetAlertThreshold,
    int? billReminderDaysBefore,
    bool? soundEnabled,
    bool? vibrationEnabled,
    String? customSound,
  }) {
    return NotificationSettings(
      budgetAlertsEnabled: budgetAlertsEnabled ?? this.budgetAlertsEnabled,
      billRemindersEnabled: billRemindersEnabled ?? this.billRemindersEnabled,
      savingsMilestonesEnabled: savingsMilestonesEnabled ?? this.savingsMilestonesEnabled,
      debtPaymentsEnabled: debtPaymentsEnabled ?? this.debtPaymentsEnabled,
      expenseNotificationsEnabled: expenseNotificationsEnabled ?? this.expenseNotificationsEnabled,
      budgetAlertThreshold: budgetAlertThreshold ?? this.budgetAlertThreshold,
      billReminderDaysBefore: billReminderDaysBefore ?? this.billReminderDaysBefore,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
      customSound: customSound ?? this.customSound,
    );
  }

  @override
  List<Object?> get props => [
        budgetAlertsEnabled,
        billRemindersEnabled,
        savingsMilestonesEnabled,
        debtPaymentsEnabled,
        expenseNotificationsEnabled,
        budgetAlertThreshold,
        billReminderDaysBefore,
        soundEnabled,
        vibrationEnabled,
        customSound,
      ];
}
