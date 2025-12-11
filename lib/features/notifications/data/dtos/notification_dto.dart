class NotificationDto {
  final String id;
  final String title;
  final String body;
  final String type;
  final String priority;
  final String scheduledTime;
  final String? sentTime;
  final bool isRead;
  final bool isSent;
  final Map<String, dynamic>? payload;
  final String? actionUrl;

  NotificationDto({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.priority,
    required this.scheduledTime,
    this.sentTime,
    required this.isRead,
    required this.isSent,
    this.payload,
    this.actionUrl,
  });

  factory NotificationDto.fromJson(Map<String, dynamic> json) {
    return NotificationDto(
      id: json['id'] ?? json['_id'] ?? '',
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      type: json['type'] ?? 'customReminder',
      priority: json['priority'] ?? 'medium',
      scheduledTime: json['scheduledTime'] ?? DateTime.now().toIso8601String(),
      sentTime: json['sentTime'],
      isRead: json['isRead'] ?? false,
      isSent: json['isSent'] ?? false,
      payload: json['payload'],
      actionUrl: json['actionUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'type': type,
      'priority': priority,
      'scheduledTime': scheduledTime,
      'sentTime': sentTime,
      'isRead': isRead,
      'isSent': isSent,
      'payload': payload,
      'actionUrl': actionUrl,
    };
  }
}

class NotificationSettingsDto {
  final bool budgetAlertsEnabled;
  final bool billRemindersEnabled;
  final bool savingsMilestonesEnabled;
  final bool debtPaymentsEnabled;
  final bool expenseNotificationsEnabled;
  final int budgetAlertThreshold;
  final int billReminderDaysBefore;
  final bool soundEnabled;
  final bool vibrationEnabled;
  final String? customSound;

  NotificationSettingsDto({
    required this.budgetAlertsEnabled,
    required this.billRemindersEnabled,
    required this.savingsMilestonesEnabled,
    required this.debtPaymentsEnabled,
    required this.expenseNotificationsEnabled,
    required this.budgetAlertThreshold,
    required this.billReminderDaysBefore,
    required this.soundEnabled,
    required this.vibrationEnabled,
    this.customSound,
  });

  factory NotificationSettingsDto.fromJson(Map<String, dynamic> json) {
    return NotificationSettingsDto(
      budgetAlertsEnabled: json['budgetAlertsEnabled'] ?? true,
      billRemindersEnabled: json['billRemindersEnabled'] ?? true,
      savingsMilestonesEnabled: json['savingsMilestonesEnabled'] ?? true,
      debtPaymentsEnabled: json['debtPaymentsEnabled'] ?? true,
      expenseNotificationsEnabled: json['expenseNotificationsEnabled'] ?? false,
      budgetAlertThreshold: json['budgetAlertThreshold'] ?? 80,
      billReminderDaysBefore: json['billReminderDaysBefore'] ?? 3,
      soundEnabled: json['soundEnabled'] ?? true,
      vibrationEnabled: json['vibrationEnabled'] ?? true,
      customSound: json['customSound'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'budgetAlertsEnabled': budgetAlertsEnabled,
      'billRemindersEnabled': billRemindersEnabled,
      'savingsMilestonesEnabled': savingsMilestonesEnabled,
      'debtPaymentsEnabled': debtPaymentsEnabled,
      'expenseNotificationsEnabled': expenseNotificationsEnabled,
      'budgetAlertThreshold': budgetAlertThreshold,
      'billReminderDaysBefore': billReminderDaysBefore,
      'soundEnabled': soundEnabled,
      'vibrationEnabled': vibrationEnabled,
      'customSound': customSound,
    };
  }
}
