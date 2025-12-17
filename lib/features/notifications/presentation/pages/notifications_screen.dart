import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../../shared/const/colors.dart';
import '../../../../shared/const/design_tokens.dart';
import '../../../../shared/utils/routes.dart';
import '../../../../shared/data/mock_data_provider.dart';
import '../../domain/entities/notification.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  // Load from MockDataProvider
  late List<AppNotification> _notifications;
  
  @override
  void initState() {
    super.initState();
    _notifications = MockDataProvider.getMockNotifications();
  }

  @override
  Widget build(BuildContext context) {
    final unreadCount = _notifications.where((n) => !n.isRead).length;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          if (unreadCount > 0)
            TextButton(
              onPressed: _markAllAsRead,
              child: const Text(
                'Mark all read',
                style: TextStyle(color: Colors.white),
              ),
            ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.push(AppRoutes.notificationSettings),
          ),
        ],
      ),
      body: _notifications.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: EdgeInsets.all(DesignTokens.space16),
              itemCount: _notifications.length,
              itemBuilder: (context, index) {
                return _buildNotificationCard(_notifications[index]);
              },
            ),
    );
  }

  Widget _buildNotificationCard(AppNotification notification) {
    return Container(
      margin: EdgeInsets.only(bottom: DesignTokens.space12),
      decoration: BoxDecoration(
        color: notification.isRead ? Colors.white : AppColors.primary.withValues(alpha: 0.05),
        borderRadius: DesignTokens.borderRadiusMd,
        boxShadow: DesignTokens.shadowSm,
        border: notification.isRead
            ? null
            : Border.all(color: AppColors.primary.withValues(alpha: 0.2), width: 1),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(DesignTokens.space12),
        leading: Container(
          width: 48.w,
          height: 48.w,
          decoration: BoxDecoration(
            color: _getNotificationColor(notification.type).withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            _getNotificationIcon(notification.type),
            color: _getNotificationColor(notification.type),
            size: 24.sp,
          ),
        ),
        title: Text(
          notification.title,
          style: TextStyle(
            fontWeight: notification.isRead ? FontWeight.w500 : FontWeight.bold,
            fontSize: DesignTokens.textBase,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4.h),
            Text(
              notification.body,
              style: TextStyle(
                fontSize: DesignTokens.textSm,
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              timeago.format(notification.sentTime ?? notification.scheduledTime),
              style: TextStyle(
                fontSize: DesignTokens.textXs,
                color: AppColors.textHint,
              ),
            ),
          ],
        ),
        trailing: !notification.isRead
            ? Container(
                width: 8.w,
                height: 8.w,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              )
            : null,
        onTap: () => _handleNotificationTap(notification),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none,
            size: 80.sp,
            color: AppColors.textHint,
          ),
          SizedBox(height: DesignTokens.space16),
          Text(
            'No notifications yet',
            style: TextStyle(
              fontSize: DesignTokens.textLg,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: DesignTokens.space8),
          Text(
            'You\'ll see updates about budgets, bills, and goals here',
            style: TextStyle(
              fontSize: DesignTokens.textSm,
              color: AppColors.textHint,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Color _getNotificationColor(NotificationType type) {
    switch (type) {
      case NotificationType.budgetAlert:
        return AppColors.warning;
      case NotificationType.billReminder:
        return AppColors.info;
      case NotificationType.savingsMilestone:
        return AppColors.success;
      case NotificationType.debtPaymentDue:
        return AppColors.error;
      case NotificationType.goalAchieved:
        return AppColors.success;
      default:
        return AppColors.primary;
    }
  }

  IconData _getNotificationIcon(NotificationType type) {
    switch (type) {
      case NotificationType.budgetAlert:
        return Icons.warning_amber_rounded;
      case NotificationType.billReminder:
        return Icons.receipt;
      case NotificationType.savingsMilestone:
        return Icons.savings;
      case NotificationType.debtPaymentDue:
        return Icons.payment;
      case NotificationType.goalAchieved:
        return Icons.celebration;
      default:
        return Icons.notifications;
    }
  }

  void _handleNotificationTap(AppNotification notification) {
    setState(() {
      final index = _notifications.indexOf(notification);
      _notifications[index] = notification.copyWith(isRead: true);
    });

    // Navigate based on notification type
    if (notification.actionUrl != null) {
      context.push(notification.actionUrl!);
    }
  }

  void _markAllAsRead() {
    setState(() {
      for (var i = 0; i < _notifications.length; i++) {
        _notifications[i] = _notifications[i].copyWith(isRead: true);
      }
    });
  }
}
