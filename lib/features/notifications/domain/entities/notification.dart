import 'package:equatable/equatable.dart';

enum NotificationType {
  budgetAlert,
  billReminder,
  savingsMilestone,
  debtPaymentDue,
  expenseAdded,
  goalAchieved,
  customReminder,
}

enum NotificationPriority {
  low,
  medium,
  high,
  urgent,
}

class AppNotification extends Equatable {
  final String id;
  final String title;
  final String body;
  final NotificationType type;
  final NotificationPriority priority;
  final DateTime scheduledTime;
  final DateTime? sentTime;
  final bool isRead;
  final bool isSent;
  final Map<String, dynamic>? payload;
  final String? actionUrl;

  const AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    this.priority = NotificationPriority.medium,
    required this.scheduledTime,
    this.sentTime,
    this.isRead = false,
    this.isSent = false,
    this.payload,
    this.actionUrl,
  });

  bool get isPending => !isSent && scheduledTime.isAfter(DateTime.now());
  bool get isOverdue => !isSent && scheduledTime.isBefore(DateTime.now());

  AppNotification copyWith({
    String? id,
    String? title,
    String? body,
    NotificationType? type,
    NotificationPriority? priority,
    DateTime? scheduledTime,
    DateTime? sentTime,
    bool? isRead,
    bool? isSent,
    Map<String, dynamic>? payload,
    String? actionUrl,
  }) {
    return AppNotification(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      type: type ?? this.type,
      priority: priority ?? this.priority,
      scheduledTime: scheduledTime ?? this.scheduledTime,
      sentTime: sentTime ?? this.sentTime,
      isRead: isRead ?? this.isRead,
      isSent: isSent ?? this.isSent,
      payload: payload ?? this.payload,
      actionUrl: actionUrl ?? this.actionUrl,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        body,
        type,
        priority,
        scheduledTime,
        sentTime,
        isRead,
        isSent,
        payload,
        actionUrl,
      ];
}
