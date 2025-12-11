import 'package:dartz/dartz.dart';
import '../../../../shared/errors/failures.dart';
import '../../domain/entities/notification.dart';
import '../../domain/entities/notification_settings.dart';
import '../../domain/repositories/notification_repository.dart';
import '../datasources/notification_remote_datasource.dart';
import '../dtos/notification_dto.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource remoteDataSource;

  NotificationRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<AppNotification>>> getNotifications() async {
    try {
      final dtos = await remoteDataSource.getNotifications();
      final notifications = dtos.map(_dtoToEntity).toList();
      return Right(notifications);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AppNotification>> markAsRead(String id) async {
    try {
      final dto = await remoteDataSource.markAsRead(id);
      return Right(_dtoToEntity(dto));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> markAllAsRead() async {
    try {
      await remoteDataSource.markAllAsRead();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteNotification(String id) async {
    try {
      await remoteDataSource.deleteNotification(id);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, NotificationSettings>> getSettings() async {
    try {
      final dto = await remoteDataSource.getSettings();
      return Right(_settingsDtoToEntity(dto));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, NotificationSettings>> updateSettings(
    NotificationSettings settings,
  ) async {
    try {
      final dto = _settingsEntityToDto(settings);
      final result = await remoteDataSource.updateSettings(dto);
      return Right(_settingsDtoToEntity(result));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  AppNotification _dtoToEntity(NotificationDto dto) {
    return AppNotification(
      id: dto.id,
      title: dto.title,
      body: dto.body,
      type: _typeFromString(dto.type),
      priority: _priorityFromString(dto.priority),
      scheduledTime: DateTime.parse(dto.scheduledTime),
      sentTime: dto.sentTime != null ? DateTime.parse(dto.sentTime!) : null,
      isRead: dto.isRead,
      isSent: dto.isSent,
      payload: dto.payload,
      actionUrl: dto.actionUrl,
    );
  }

  NotificationSettings _settingsDtoToEntity(NotificationSettingsDto dto) {
    return NotificationSettings(
      budgetAlertsEnabled: dto.budgetAlertsEnabled,
      billRemindersEnabled: dto.billRemindersEnabled,
      savingsMilestonesEnabled: dto.savingsMilestonesEnabled,
      debtPaymentsEnabled: dto.debtPaymentsEnabled,
      expenseNotificationsEnabled: dto.expenseNotificationsEnabled,
      budgetAlertThreshold: dto.budgetAlertThreshold,
      billReminderDaysBefore: dto.billReminderDaysBefore,
      soundEnabled: dto.soundEnabled,
      vibrationEnabled: dto.vibrationEnabled,
      customSound: dto.customSound,
    );
  }

  NotificationSettingsDto _settingsEntityToDto(NotificationSettings entity) {
    return NotificationSettingsDto(
      budgetAlertsEnabled: entity.budgetAlertsEnabled,
      billRemindersEnabled: entity.billRemindersEnabled,
      savingsMilestonesEnabled: entity.savingsMilestonesEnabled,
      debtPaymentsEnabled: entity.debtPaymentsEnabled,
      expenseNotificationsEnabled: entity.expenseNotificationsEnabled,
      budgetAlertThreshold: entity.budgetAlertThreshold,
      billReminderDaysBefore: entity.billReminderDaysBefore,
      soundEnabled: entity.soundEnabled,
      vibrationEnabled: entity.vibrationEnabled,
      customSound: entity.customSound,
    );
  }

  NotificationType _typeFromString(String type) {
    switch (type) {
      case 'budgetAlert':
        return NotificationType.budgetAlert;
      case 'billReminder':
        return NotificationType.billReminder;
      case 'savingsMilestone':
        return NotificationType.savingsMilestone;
      case 'debtPaymentDue':
        return NotificationType.debtPaymentDue;
      case 'expenseAdded':
        return NotificationType.expenseAdded;
      case 'goalAchieved':
        return NotificationType.goalAchieved;
      default:
        return NotificationType.customReminder;
    }
  }

  NotificationPriority _priorityFromString(String priority) {
    switch (priority) {
      case 'low':
        return NotificationPriority.low;
      case 'medium':
        return NotificationPriority.medium;
      case 'high':
        return NotificationPriority.high;
      case 'urgent':
        return NotificationPriority.urgent;
      default:
        return NotificationPriority.medium;
    }
  }
}
