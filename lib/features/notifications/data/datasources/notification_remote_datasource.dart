import 'package:dio/dio.dart';
import '../dtos/notification_dto.dart';
import '../../domain/entities/notification.dart';
import '../../domain/entities/notification_settings.dart';

abstract class NotificationRemoteDataSource {
  Future<List<NotificationDto>> getNotifications();
  Future<NotificationDto> markAsRead(String id);
  Future<void> markAllAsRead();
  Future<void> deleteNotification(String id);
  Future<NotificationSettingsDto> getSettings();
  Future<NotificationSettingsDto> updateSettings(NotificationSettingsDto dto);
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final Dio dio;
  static const String baseUrl = '/api/notifications';

  NotificationRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<NotificationDto>> getNotifications() async {
    try {
      final response = await dio.get(baseUrl);
      final List<dynamic> data = response.data['data'] ?? response.data;
      return data.map((json) => NotificationDto.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch notifications: $e');
    }
  }

  @override
  Future<NotificationDto> markAsRead(String id) async {
    try {
      final response = await dio.put('$baseUrl/$id/read');
      return NotificationDto.fromJson(response.data['data'] ?? response.data);
    } catch (e) {
      throw Exception('Failed to mark notification as read: $e');
    }
  }

  @override
  Future<void> markAllAsRead() async {
    try {
      await dio.put('$baseUrl/read-all');
    } catch (e) {
      throw Exception('Failed to mark all as read: $e');
    }
  }

  @override
  Future<void> deleteNotification(String id) async {
    try {
      await dio.delete('$baseUrl/$id');
    } catch (e) {
      throw Exception('Failed to delete notification: $e');
    }
  }

  @override
  Future<NotificationSettingsDto> getSettings() async {
    try {
      final response = await dio.get('$baseUrl/settings');
      return NotificationSettingsDto.fromJson(response.data['data'] ?? response.data);
    } catch (e) {
      throw Exception('Failed to fetch settings: $e');
    }
  }

  @override
  Future<NotificationSettingsDto> updateSettings(NotificationSettingsDto dto) async {
    try {
      final response = await dio.put(
        '$baseUrl/settings',
        data: dto.toJson(),
      );
      return NotificationSettingsDto.fromJson(response.data['data'] ?? response.data);
    } catch (e) {
      throw Exception('Failed to update settings: $e');
    }
  }
}

// Mock implementation
class MockNotificationRemoteDataSource implements NotificationRemoteDataSource {
  final List<NotificationDto> _mockNotifications = [
    NotificationDto(
      id: '1',
      title: 'Budget Alert: Food',
      body: "You've spent 85% of your food budget this month",
      type: 'budgetAlert',
      priority: 'high',
      scheduledTime: DateTime.now().subtract(const Duration(hours: 2)).toIso8601String(),
      sentTime: DateTime.now().subtract(const Duration(hours: 2)).toIso8601String(),
      isRead: false,
      isSent: true,
    ),
    NotificationDto(
      id: '2',
      title: 'Bill Reminder',
      body: 'Electricity bill due in 3 days',
      type: 'billReminder',
      priority: 'medium',
      scheduledTime: DateTime.now().subtract(const Duration(hours: 5)).toIso8601String(),
      sentTime: DateTime.now().subtract(const Duration(hours: 5)).toIso8601String(),
      isRead: true,
      isSent: true,
    ),
    NotificationDto(
      id: '3',
      title: 'Savings Milestone! 🎉',
      body: "You've reached 50% of your vacation fund goal!",
      type: 'savingsMilestone',
      priority: 'medium',
      scheduledTime: DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
      sentTime: DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
      isRead: true,
      isSent: true,
    ),
  ];

  NotificationSettingsDto _mockSettings = NotificationSettingsDto(
    budgetAlertsEnabled: true,
    billRemindersEnabled: true,
    savingsMilestonesEnabled: true,
    debtPaymentsEnabled: true,
    expenseNotificationsEnabled: false,
    budgetAlertThreshold: 80,
    billReminderDaysBefore: 3,
    soundEnabled: true,
    vibrationEnabled: true,
  );

  @override
  Future<List<NotificationDto>> getNotifications() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_mockNotifications);
  }

  @override
  Future<NotificationDto> markAsRead(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final index = _mockNotifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      _mockNotifications[index] = NotificationDto(
        id: _mockNotifications[index].id,
        title: _mockNotifications[index].title,
        body: _mockNotifications[index].body,
        type: _mockNotifications[index].type,
        priority: _mockNotifications[index].priority,
        scheduledTime: _mockNotifications[index].scheduledTime,
        sentTime: _mockNotifications[index].sentTime,
        isRead: true,
        isSent: _mockNotifications[index].isSent,
        payload: _mockNotifications[index].payload,
        actionUrl: _mockNotifications[index].actionUrl,
      );
      return _mockNotifications[index];
    }
    throw Exception('Notification not found');
  }

  @override
  Future<void> markAllAsRead() async {
    await Future.delayed(const Duration(milliseconds: 300));
    for (var i = 0; i < _mockNotifications.length; i++) {
      _mockNotifications[i] = NotificationDto(
        id: _mockNotifications[i].id,
        title: _mockNotifications[i].title,
        body: _mockNotifications[i].body,
        type: _mockNotifications[i].type,
        priority: _mockNotifications[i].priority,
        scheduledTime: _mockNotifications[i].scheduledTime,
        sentTime: _mockNotifications[i].sentTime,
        isRead: true,
        isSent: _mockNotifications[i].isSent,
        payload: _mockNotifications[i].payload,
        actionUrl: _mockNotifications[i].actionUrl,
      );
    }
  }

  @override
  Future<void> deleteNotification(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _mockNotifications.removeWhere((n) => n.id == id);
  }

  @override
  Future<NotificationSettingsDto> getSettings() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _mockSettings;
  }

  @override
  Future<NotificationSettingsDto> updateSettings(NotificationSettingsDto dto) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _mockSettings = dto;
    return _mockSettings;
  }
}
