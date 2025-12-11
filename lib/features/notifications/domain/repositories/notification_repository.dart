import 'package:dartz/dartz.dart';
import '../../../../shared/errors/failures.dart';
import '../entities/notification.dart';
import '../entities/notification_settings.dart';

abstract class NotificationRepository {
  Future<Either<Failure, List<AppNotification>>> getNotifications();
  Future<Either<Failure, AppNotification>> markAsRead(String id);
  Future<Either<Failure, void>> markAllAsRead();
  Future<Either<Failure, void>> deleteNotification(String id);
  Future<Either<Failure, NotificationSettings>> getSettings();
  Future<Either<Failure, NotificationSettings>> updateSettings(NotificationSettings settings);
}
