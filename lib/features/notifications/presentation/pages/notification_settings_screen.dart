import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../shared/const/colors.dart';
import '../../../../shared/const/design_tokens.dart';
import '../../../../shared/widgets/snackbars/app_snackbar.dart';
import '../../domain/entities/notification_settings.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  // Mock settings - would come from BLoC in real implementation
  NotificationSettings _settings = const NotificationSettings();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('Notification Settings'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: EdgeInsets.all(DesignTokens.space16),
        children: [
          _buildSectionHeader('Alert Types'),
          _buildSwitchTile(
            'Budget Alerts',
            'Get notified when spending approaches limit',
            Icons.account_balance_wallet,
            _settings.budgetAlertsEnabled,
            (value) => _updateSettings(_settings.copyWith(budgetAlertsEnabled: value)),
          ),
          if (_settings.budgetAlertsEnabled) ...[
            Padding(
              padding: EdgeInsets.only(left: DesignTokens.space16, right: DesignTokens.space16, bottom: DesignTokens.space12),
              child: Row(
                children: [
                  Text(
                    'Alert at ${_settings.budgetAlertThreshold}% of budget',
                    style: TextStyle(fontSize: DesignTokens.textSm),
                  ),
                  const Spacer(),
                  Text(
                    '${_settings.budgetAlertThreshold}%',
                    style: TextStyle(
                      fontSize: DesignTokens.textSm,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
            Slider(
              value: _settings.budgetAlertThreshold.toDouble(),
              min: 50,
              max: 100,
              divisions: 10,
              label: '${_settings.budgetAlertThreshold}%',
              onChanged: (value) => _updateSettings(
                _settings.copyWith(budgetAlertThreshold: value.toInt()),
              ),
            ),
          ],
          _buildSwitchTile(
            'Bill Reminders',
            'Reminders for upcoming bill payments',
            Icons.receipt_long,
            _settings.billRemindersEnabled,
            (value) => _updateSettings(_settings.copyWith(billRemindersEnabled: value)),
          ),
          if (_settings.billRemindersEnabled) ...[
            Padding(
              padding: EdgeInsets.only(left: DesignTokens.space16, right: DesignTokens.space16, bottom: DesignTokens.space12),
              child: Row(
                children: [
                  Text(
                    'Remind me ${_settings.billReminderDaysBefore} days before',
                    style: TextStyle(fontSize: DesignTokens.textSm),
                  ),
                  const Spacer(),
                  Text(
                    '${_settings.billReminderDaysBefore}d',
                    style: TextStyle(
                      fontSize: DesignTokens.textSm,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
            Slider(
              value: _settings.billReminderDaysBefore.toDouble(),
              min: 1,
              max: 7,
              divisions: 6,
              label: '${_settings.billReminderDaysBefore} days',
              onChanged: (value) => _updateSettings(
                _settings.copyWith(billReminderDaysBefore: value.toInt()),
              ),
            ),
          ],
          _buildSwitchTile(
            'Savings Milestones',
            'Celebrate reaching savings goals',
            Icons.savings,
            _settings.savingsMilestonesEnabled,
            (value) => _updateSettings(_settings.copyWith(savingsMilestonesEnabled: value)),
          ),
          _buildSwitchTile(
            'Debt Payment Reminders',
            'Stay on track with debt payments',
            Icons.payment,
            _settings.debtPaymentsEnabled,
            (value) => _updateSettings(_settings.copyWith(debtPaymentsEnabled: value)),
          ),
          _buildSwitchTile(
            'Expense Notifications',
            'Notify when new expenses are added',
            Icons.receipt,
            _settings.expenseNotificationsEnabled,
            (value) => _updateSettings(_settings.copyWith(expenseNotificationsEnabled: value)),
          ),
          
          SizedBox(height: DesignTokens.space24),
          _buildSectionHeader('Sound & Vibration'),
          
          _buildSwitchTile(
            'Sound',
            'Play sound for notifications',
            Icons.volume_up,
            _settings.soundEnabled,
            (value) => _updateSettings(_settings.copyWith(soundEnabled: value)),
          ),
          _buildSwitchTile(
            'Vibration',
            'Vibrate for notifications',
            Icons.vibration,
            _settings.vibrationEnabled,
            (value) => _updateSettings(_settings.copyWith(vibrationEnabled: value)),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(
        top: DesignTokens.space16,
        bottom: DesignTokens.space8,
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: DesignTokens.textBase,
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildSwitchTile(
    String title,
    String subtitle,
    IconData icon,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: DesignTokens.space8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: DesignTokens.borderRadiusMd,
        boxShadow: DesignTokens.shadowSm,
      ),
      child: SwitchListTile(
        secondary: Icon(icon, color: AppColors.primary),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: DesignTokens.textBase,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: DesignTokens.textSm,
            color: AppColors.textSecondary,
          ),
        ),
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.primary,
      ),
    );
  }

  void _updateSettings(NotificationSettings newSettings) {
    setState(() {
      _settings = newSettings;
    });
    AppSnackBar.showSuccess(context, message: 'Settings updated');
  }
}
